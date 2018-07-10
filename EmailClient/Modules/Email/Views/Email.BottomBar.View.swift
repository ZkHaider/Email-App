//
//  Email.BottomBar.View.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import UIKit

public final class BottomBarView: BaseView {
    
    // MARK: - Views
    
    let unreadCountLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Unread count: 0"
        view.font = UIFont.boldSystemFont(ofSize: 14.0)
        view.textAlignment = .center
        view.textColor = .white
        return view
    }()
    
    // MARK: - Init
    
    public required init() {
        super.init()
        initialize()
    }
    
    // MARK: - Lifecycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Get the bounds for this view and calculate the position for the unread count label
        let insetBounds = bounds.insetBy(dx: 20.0, dy: 20.0)
        self.unreadCountLabel.frame = insetBounds
    }
    
}

extension BottomBarView {
    
    fileprivate func initialize() {
        func addSubviews() {
            self.addSubview(unreadCountLabel)
        }
        func setupConstraints() {
            
        }
        func prepareViews() {
            self.backgroundColor = Styles.Colors.darkPrimaryColor.uiColor
        }
        addSubviews()
        setupConstraints()
        prepareViews()
    }
    
}
