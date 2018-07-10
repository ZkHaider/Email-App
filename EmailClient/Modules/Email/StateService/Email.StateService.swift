//
//  Email.StateService.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import RealmSwift

public protocol EmailStateProvider: Service {
    var emailSignal: Signal<EmailState> { get }
    var errorSignal: Signal<ErrorModel> { get }
}

public final class EmailStateService: BaseService, EmailStateProvider {
    
    // MARK: - Associations
    
    typealias `Self` = EmailStateService
    
    // MARK: - Attributes
    
    private let environment: Environment
    
    public var emailSignal: Signal<EmailState> = Signal<EmailState>(value: EmailState.emptyState())
    public var errorSignal: Signal<ErrorModel> = Signal<ErrorModel>(value: ErrorModel.emptyError())
    
    private var emailToken: NotificationToken? = nil 
    
    // MARK: - Init
    
    required public init(withEnvironment environment: Environment) {
        self.environment = environment
        super.init()
        
        // Add event listeners
        registerListeners()
        
        // Subcribe to realm notifications
        👾.executionThread.execute { [weak self] in
            guard let this = self else { return }
            let realm = Realm.emailDomain.realm
            this.emailToken = realm.objects(EmailManagedObject.self).observe({ [weak self] change in
                guard let this = self else { return }
                this.observeEmailChanges(change: change)
            })
        }
    }
    
    @available(*, unavailable)
    public required init() {
        fatalError("init() has not been implemented")
    }
    
    private func registerListeners() {
        add(listener: self,
            for: Email.Events.ViewDidLoad.name,
            handler: Self.viewDidLoad)
        add(listener: self,
            for: Email.Events.GetEmailsEvent.name,
            handler: Self.handleGetEmails)
        add(listener: self,
            for: Email.Events.MarkAsReadEvent.name,
            handler: Self.handleMarkAsRead)
        add(listener: self,
            for: Email.Events.MarkAsUnReadEvent.name,
            handler: Self.handleMarkAsUnRead)
    }
    
    // MARK: - Realm Changes
    
    /**
     *  Our cache / database source, updated from true source from API views use this source
     */
    private func observeEmailChanges(change: RealmCollectionChange<Results<EmailManagedObject>>) {
        switch change {
        case let .initial(emails):
            updateState(withModels: emails.map({ $0.struct() }))
        case .update(let emails, _, _, _):
            
            // Here we can use deletions, insertions, and modifications to diff if we want...
            updateState(withModels: emails.map({ $0.struct() }))
            
        case let .error(error):
            errorSignal.value = ErrorModel(error: error, type: .realm)
        }
    }
    
    private func updateState(withModels emailModels: [EmailModel]) {
        
        // Segregate into read and unread models and sort by date
        let unreadEmails: [EmailModel] = emailModels.filter({ $0.unread }).sorted { (lhs, rhs) -> Bool in
            guard
                let lhsDate = lhs.date?.toDate(),
                let rhsDate = rhs.date?.toDate()
                else { return false }
            return lhsDate > rhsDate
        }
        let readEmails: [EmailModel] = emailModels.filter({ !$0.unread }).sorted { (lhs, rhs) -> Bool in
            guard
                let lhsDate = lhs.date?.toDate(),
                let rhsDate = rhs.date?.toDate()
                else { return true }
            return lhsDate > rhsDate
        }
        
        // Update state
        let oldState = emailSignal.value
        let newState = EmailState(unreadEmails: unreadEmails,
                                  readEmails: readEmails)
        
        // Don't update unless state actually changed
        guard oldState != newState else { return }
        
        // Dispatch signal
        emailSignal.value = newState
    }
    
    // MARK: - Event Listeners
    
    private func viewDidLoad(_ event: Email.Events.ViewDidLoad) {
        👾.loggingStateProvider.dispatch(Logging.Events.LogEvent(logRecording: .event(event, CFAbsoluteTimeGetCurrent())))
        👾.emailStateProvider.dispatch(Email.Events.GetEmailsEvent())
    }
    
    private func handleGetEmails(_ event: Email.Events.GetEmailsEvent) {
        👾.loggingStateProvider.dispatch(Logging.Events.LogEvent(logRecording: .event(event, CFAbsoluteTimeGetCurrent())))
        
        let networkStateProvider: NetworkStateProvider = 👾.networkStateProvider
        networkStateProvider.emailProvider.request(.emails) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let response):
                
                let data = response.data
                
                do {
                    
                    let emailResponse = try networkStateProvider.jsonDecoder.decode(EmailResponse.self, from: data)
                    
                    // Update our realm domain with emails
                    let realm = Realm.emailDomain.realm
                    realm.work({
                        realm.add(emailResponse.emails.map({ $0.managedObject() }), update: true)
                    })
                    
                } catch let error as NSError {
                    this.errorSignal.value = ErrorModel(error: error, type: .other)
                }
                
                break
                
            case .failure(let error):
                this.errorSignal.value = ErrorModel(error: error, type: .network)
                break
            }
        }
    }
    
    private func handleMarkAsRead(_ event: Email.Events.MarkAsReadEvent) {
        👾.loggingStateProvider.dispatch(Logging.Events.LogEvent(logRecording: .event(event, CFAbsoluteTimeGetCurrent())))
        
        // Immediate update UI
        let email = event.email
        let updatedEmail = EmailModel(id: email.id,
                                      subject: email.subject,
                                      from: email.from,
                                      body: email.body,
                                      date: email.date,
                                      unread: false,
                                      to: email.to)
        
        let realm = Realm.emailDomain.realm
        realm.work({
            realm.add(updatedEmail.managedObject(), update: true)
        })
        
        let networkStateProvider: NetworkStateProvider = 👾.networkStateProvider
        networkStateProvider.emailProvider.request(.updateEmail(id: String(describing: email.id))) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let response):
                
                let data = response.data
                do {
                    
                    let remoteEmail = try networkStateProvider.jsonDecoder.decode(EmailModel.self, from: data)
                    
                    // Update our realm domain with emails
                    realm.work({
                        realm.add(remoteEmail.managedObject(), update: true)
                    })
                    
                } catch let error as NSError {
                    this.errorSignal.value = ErrorModel(error: error, type: .other)
                }
                
            case .failure(let error):
                this.errorSignal.value = ErrorModel(error: error, type: .network)
            }
        }
    }
    
    private func handleMarkAsUnRead(_ event: Email.Events.MarkAsUnReadEvent) {
        👾.loggingStateProvider.dispatch(Logging.Events.LogEvent(logRecording: .event(event, CFAbsoluteTimeGetCurrent())))
        
        // Immediate update UI
        let email = event.email
        let updatedEmail = EmailModel(id: email.id,
                                      subject: email.subject,
                                      from: email.from,
                                      body: email.body,
                                      date: email.date,
                                      unread: true,
                                      to: email.to)
        
        let realm = Realm.emailDomain.realm
        realm.work({
            realm.add(updatedEmail.managedObject(), update: true)
        })
        
        let networkStateProvider: NetworkStateProvider = 👾.networkStateProvider
        networkStateProvider.emailProvider.request(.updateEmail(id: String(describing: email.id))) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let response):
                
                let data = response.data
                do {
                    
                    let remoteEmail = try networkStateProvider.jsonDecoder.decode(EmailModel.self, from: data)
                    
                    // Update our realm domain with emails
                    realm.work({
                        realm.add(remoteEmail.managedObject(), update: true)
                    })
                    
                } catch let error as NSError {
                    this.errorSignal.value = ErrorModel(error: error, type: .other)
                }
                
            case .failure(let error):
                this.errorSignal.value = ErrorModel(error: error, type: .network)
            }
        }
    }
    
    deinit {
        emailSignal.removeAllListeners()
        emailToken = nil
    }
    
}

public extension ServiceCenter {
    
    public var emailStateProvider: EmailStateProvider {
        guard let provider = 👾.service(for: EmailStateService.defaultIdentifier) as? EmailStateProvider else {
            let provider: EmailStateProvider = EmailStateService(withEnvironment: Environment.currentEnvironment())
            return provider
        }
        return provider
    }
    
}
