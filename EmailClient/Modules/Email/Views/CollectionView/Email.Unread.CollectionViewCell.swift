//
//  Email.Unread.CollectionViewCell.swift
//  EmailClient
//
//  Created by Haider Khan on 7/9/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import UIKit

public final class UnreadCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    
    let containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        
        // We should add a cgimage instead for a shadow in a uicollectionview cell - due to performance
        view.dropShadow()
        
        return view
    }()
    
    let subjectLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = Styles.Fonts.avenirNextMedium.font(with: 16.0)
        view.textColor = Styles.Colors.primaryTextColor.uiColor
        view.textAlignment = .left
        view.numberOfLines = 1
        return view
    }()
    
    let sendersLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = Styles.Fonts.avenirNextRegular.font(with: 14.0)
        view.textColor = Styles.Colors.primaryTextColor.uiColor
        view.textAlignment = .left
        view.numberOfLines = 1
        return view
    }()
    
    let bodyLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = Styles.Fonts.avenirNextRegular.font(with: 14.0)
        view.textColor = Styles.Colors.secondaryTextColor.uiColor
        view.textAlignment = .left
        view.numberOfLines = 2
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = Styles.Fonts.avenirNextRegular.font(with: 14.0)
        view.textColor = .blue
        view.textAlignment = .right
        view.numberOfLines = 1
        return view
    }()
    
    let markAsReadButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Mark as Read", for: .normal)
        return view
    }()
    
    // MARK: - Attributes
    
    var model: EmailModel? {
        didSet {
            guard let model = model else { return }
            guard let oldValue = oldValue else {
                self.update(withModel: model, isInitial: true)
                return
            }
            guard model != oldValue else { return }
            self.update(withModel: model, isInitial: false)
        }
    }
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // Use this for collection view cell views - better performance than constraints
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.contentView.bounds
        
        // Inset container view frame by 20.0
        let containerViewFrame = bounds.insetBy(dx: 4.0, dy: 4.0)
        containerView.frame = containerViewFrame
        
        let (first, bottomFrame) = containerViewFrame.divided(atDistance: 2/3 * bounds.height, from: .minYEdge)
        
        // We want to divide view into thirds
        let (topFrame, middleFrame) = first.divided(atDistance: first.height / 2.0, from: .minYEdge)
        
        // Position subject and senders label in top left / center left and position date label
        // at top right of top frame
        let (leftTopHalf, rightTopHalf) = topFrame.divided(atDistance: 2/3 * topFrame.width, from: .minXEdge)
        let (subjectFrame, sendersFrame) = leftTopHalf.divided(atDistance: leftTopHalf.height / 2.0, from: .minYEdge)
        subjectLabel.frame = subjectFrame.insetBy(dx: 6.0, dy: 0.0).offsetBy(dx: 0.0, dy: 4.0)
        sendersLabel.frame = sendersFrame.insetBy(dx: 6.0, dy: 0.0).offsetBy(dx: 0.0, dy: -2.0)
        
        // Set date label frame
        let (dateFrame, _) = rightTopHalf.divided(atDistance: rightTopHalf.height / 2.0, from: .minYEdge)
        dateLabel.frame = dateFrame.insetBy(dx: 6.0, dy: 0.0).offsetBy(dx: -6.0, dy: 4.0)
        
        // Set body frame
        bodyLabel.frame = middleFrame.insetBy(dx: 6.0, dy: 0.0)
        
        // Set mark as read button frame
        markAsReadButton.frame = bottomFrame.insetBy(dx: bottomFrame.width * 1/5, dy: 4.0)
    }
    
    // MARK: - Update
    
    private func update(withModel model: EmailModel, isInitial: Bool) {
        subjectLabel.text = model.subject
        sendersLabel.text = model.to.joined(separator: ", ")
        bodyLabel.text = model.body
        
        if let date = model.date?.toDate() {
            
            let humanReadableString = date.humanReadableString()
            
            if date.isDateToday() {
                
                // Only show time string
                if let timeString = humanReadableString.components(separatedBy: ",").map({$0.trimmingCharacters(in: .whitespaces)}).last {
                    dateLabel.text = timeString
                }
                
            } else {
                
                // Only show date string
                if let dateString = humanReadableString.components(separatedBy: ",").map({$0.trimmingCharacters(in: .whitespaces)}).first {
                    dateLabel.text = dateString
                    
                }
                
            }
        }
    }
    
    // MARK: - Target
    
    @objc fileprivate func didTapMarkAsRead(_ sender: UIButton) {
        
        // Let our email service know we are marking this as read
        guard let email = model else { return }
        👾.emailStateProvider.dispatch(Email.Events.UpdateEmailEvent(email: email))
    }
    
}

extension UnreadCollectionViewCell {
    
    static var name: String {
        return String(reflecting: UnreadCollectionViewCell.self)
    }
    
    fileprivate func initialize() {
        func addSubviews() {
            self.contentView.addSubview(containerView)
            containerView.addSubview(subjectLabel)
            containerView.addSubview(dateLabel)
            containerView.addSubview(sendersLabel)
            containerView.addSubview(bodyLabel)
            containerView.addSubview(markAsReadButton)
        }
        func prepareViews() {
            markAsReadButton.addTarget(self, action: #selector(didTapMarkAsRead(_:)), for: .touchUpInside)
        }
        addSubviews()
        prepareViews()
    }
    
}
