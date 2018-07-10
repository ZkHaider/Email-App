//
//  Email.TopBar.View.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import UIKit
import Cartography

public final class TopBarView: BaseView {
    
    // MARK: - Views
    
    // Maybe add a bell or something for notifications here...
    
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Email Client"
        view.textColor = .white
        view.font = Styles.Fonts.avenirNextDemibold.font(with: 24.0)
        view.numberOfLines = 1
        return view
    }()
    
    let notificationBell: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = #imageLiteral(resourceName: "notification_bell")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // MARK: - Initialize
    
    public required init() {
        super.init()
        initialize()
    }
    
    // MARK: - Lifecycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

extension TopBarView {
    
    fileprivate func initialize() {
        func addSubviews() {
            self.addSubview(titleLabel)
            self.addSubview(notificationBell)
        }
        func setupConstraints() {
            constrain(titleLabel) {
                $0.centerY == $0.superview!.centerY
                $0.leading == $0.superview!.leading + 20.0
            }
            constrain(notificationBell) {
                $0.centerY == $0.superview!.centerY
                $0.trailing == $0.superview!.trailing - 20.0
                $0.height == 30.0
                $0.width == 30.0
            }
        }
        func prepareViews() {
            self.backgroundColor = Styles.Colors.primaryColor.uiColor
        }
        addSubviews()
        setupConstraints()
        prepareViews()
    }
    
}
