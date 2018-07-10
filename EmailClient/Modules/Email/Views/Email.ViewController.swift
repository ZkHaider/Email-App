//
//  Email.ViewController.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import UIKit

public final class EmailViewController: BaseViewController {
    
    // MARK: - Associations
    
    typealias `Self` = EmailViewController
    
    // MARK: - Views
    
    var _view: EmailView {
        return view as! EmailView
    }
    
    // MARK: - Attributes
    
    var hasAnimatedIn: Bool = false
    
    // MARK: - Init
    
    public required init() {
        super.init()
        initialize()
        
        // Add listener to signal
        👾.emailStateProvider.emailSignal.add(target: self, action: Self.handleStateChange)
        👾.emailStateProvider.errorSignal.add(target: self, action: Self.handleError)
    }
    
    // MARK: - Lifecycle
    
    override public func loadView() {
        self.view = EmailView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial alphas for views before initial animation
        _view.topBarView.alpha = 0.0
        _view.readView.alpha = 0.0
        _view.unreadView.alpha = 0.0
        
        // Execute on background thread
        👾.serviceQueue.async { [weak self] in
            guard self != nil else { return }
            👾.emailStateProvider.dispatch(Email.Events.ViewDidLoad())
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Event Listeners
    
    private func handleStateChange(_ state: EmailState) {
        👾.loggingStateProvider.dispatch(Logging.Events.LogEvent(logRecording: .any(state, CFAbsoluteTimeGetCurrent())))
        
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            
            // Check if our state is empty if so then just show a loading bar
            guard !state.isEmpty() else {
                
                // Show a loading bar or something
                return
            }
            
            // Update collection views 
            this._view.unreadView.unreadEmails = state.unreadEmails
            this._view.readView.readEmails = state.readEmails
            
            // Update bottom bar count
            this._view.bottomBar.unreadCountLabel.text = "Unread count: \(state.unreadEmails.count)"
            
            this.animateInViews()
        }
    }
    
    private func handleError(_ error: ErrorModel) {
        switch error.type {
        case .realm:
            
            // We had a realm error show a message
            
            break
        case .network:
            
            // Network error let the user know
            
            break
            
        case .other:
            
            // Some other weird error occurred handle it
            
            break
        }
    }
    
    private func animateInViews() {
        
        if (!hasAnimatedIn) {
            hasAnimatedIn = true
            
            // Set initial transforms for views
            _view.topBarView.transform = CGAffineTransform(translationX: 0.0, y: -(_view.topBarView.frame.height))
            _view.readView.transform = CGAffineTransform(translationX: _view.readView.frame.width, y: 0.0)
            _view.unreadView.transform = CGAffineTransform(translationX: 0.0, y: _view.unreadView.frame.height)
            
            UIView.animate(withDuration: 0.6,
                           delay: 0.3,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0.8,
                           options: .curveEaseIn,
                           animations: {
                                self._view.topBarView.alpha = 1.0
                                self._view.unreadView.alpha = 1.0
                                self._view.readView.alpha = 1.0
                                self._view.topBarView.transform = .identity
                                self._view.readView.transform = .identity
                                self._view.unreadView.transform = .identity
                           },
                           completion: nil
            )
        }
    }
    
}

extension EmailViewController {
    
    fileprivate func initialize() {
        func setupViews() {
        }
        setupViews()
    }
    
}
