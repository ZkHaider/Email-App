//
//  Logging.ViewController.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import UIKit

public final class LoggingViewController: BaseViewController {
    
    // MARK: - Views
    
    public var _view: LoggingView {
        return view as! LoggingView
    }
    
    // MARK: - Initialization
    
    public required init() {
        super.init()
        👾.loggingStateProvider.stateSignal.add(target: self,
                                                  action: LoggingViewController.handleLoggingState)
    }
    
    // MARK: - Lifecycle
    
    override public func loadView() {
        self.view = LoggingView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        _view.dismissButton.addTarget(self, action: #selector(dismissTapped(_:)), for: .touchUpInside)
        _view.clearButton.addTarget(self, action: #selector(clearTapped(_:)), for: .touchUpInside)
        
        // Get state and set
        let state = 👾.loggingStateProvider.stateSignal.value
        _view.textView.text = state.loggingText
    }
    
    // MARK: - Targets
    
    @objc private func dismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func clearTapped(_ sender: UIButton) {
        _view.textView.text = ""
        👾.loggingStateProvider.dispatch(Logging.Events.ClearLoggingEvent())
    }
    
    // MARK: - State
    
    private func handleLoggingState(_ state: LoggingState) {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this._view.textView.text = state.loggingText
        }
    }
    
}
