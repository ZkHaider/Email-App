//
//  Email.View.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import Cartography

extension EmailView {
    static let _topBarHeight: CGFloat = 80.0
    static let _backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.00)
}

public final class EmailView: BaseView {
    
    // MARK: - Views
    
    let topBarView: TopBarView = {
        let view = TopBarView()
        return view
    }()
    
    let unreadView: UnreadView = {
        let view = UnreadView()
        return view
    }()
    
    let readView: ReadView = {
        let view = ReadView()
        return view
    }()
    
    let bottomBar: BottomBarView = {
        let view = BottomBarView()
        return view
    }()
    
    // MARK: - Initialization
    
    public required init() {
        super.init()
        initialize()
    }
    
    // MARK: - Lifecycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

extension EmailView {
    
    fileprivate func initialize() {
        func addSubviews() {
            self.addSubview(topBarView)
            self.addSubview(unreadView)
            self.addSubview(readView)
            self.addSubview(bottomBar)
        }
        func setupConstraints() {
            constrain(topBarView, unreadView) {
                $0.leading == $0.superview!.leading
                $0.top == $0.superview!.topMargin
                $0.trailing == $0.superview!.trailing
                $0.height == EmailView._topBarHeight
                $1.top == $0.bottom + 20.0
                $1.leading == $1.superview!.leading
                $1.trailing == $1.superview!.trailing
                $1.height == (3/7) * UIScreen.main.bounds.height - EmailView._topBarHeight
            }
            constrain(unreadView, readView, bottomBar) {
                $2.leading == $2.superview!.leading
                $2.trailing == $2.superview!.trailing
                $2.bottom == $2.superview!.bottom
                $2.height == 80.0
                $1.top == $0.bottom + 10.0
                $1.leading == $1.superview!.leading
                $1.trailing == $1.superview!.trailing
                $1.bottom == $2.top
            }
        }
        func prepareViews() {
            self.backgroundColor = EmailView._backgroundColor
        }
        addSubviews()
        setupConstraints()
        prepareViews()
    }
    
}
