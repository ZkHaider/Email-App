//
//  Logging.View.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import UIKit

public final class LoggingView: BaseView {
    
    // MARK: - Views
    
    let textView: UITextView = {
        let view = UITextView(frame: .zero)
        view.backgroundColor = .black
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 14.0)
        return view
    }()
    
    let dismissButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Dismiss", for: .normal)
        return view
    }()
    
    let clearButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Clear", for: .normal)
        return view
    }()
    
    // MARK: - Initialization
    
    public required init() {
        super.init()
        initialize()
    }
    
    // MARK: - Lifecycle
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let (topFrame, _) = bounds.divided(atDistance: 40.0, from: .minYEdge)
        textView.frame = bounds
        let (leftButtonFrame, dismissFrame) = topFrame.divided(atDistance: bounds.width - 80.0, from: .minXEdge)
        dismissButton.frame = dismissFrame
        clearButton.frame = leftButtonFrame.divided(atDistance: leftButtonFrame.width - 80.0, from: .minXEdge).remainder
    }
    
}

extension LoggingView {
    
    fileprivate func initialize() {
        func addSubviews() {
            addSubview(textView)
            addSubview(dismissButton)
            addSubview(clearButton)
        }
        func prepareViews() {
            backgroundColor = .clear
            textView.contentInset = UIEdgeInsetsMake(40.0, 0.0, 0.0, 0.0)
        }
        addSubviews()
        prepareViews()
    }
    
}
