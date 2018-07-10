//
//  UIViewController+Extensions.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import UIKit

open class BaseViewController: UIViewController {
    
    public required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName: bundle:) has not been implemented")
    }
    
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func animateIn(from viewController: UIViewController, completion: ((Bool) -> ())?) {
        if let completion = completion {
            completion(true)
        }
    }
    
    open func animateOut(to viewController: UIViewController, completion: ((Bool) -> ())?) {
        if let completion = completion {
            completion(true)
        }
    }
    
    override open func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        super.motionBegan(motion, with: event)
        switch motion {
        case .motionShake:
            guard Environment.currentEnvironment() != .production else { return }
            guard let logging = self as? LoggingViewController else {
                self.present(LoggingViewController(), animated: true, completion: nil)
                return
            }
            logging.dismiss(animated: true, completion: nil)
        default: break
        }
    }
    
}

extension UIViewController {
    
    public func getCurrentViewController(_ vc: UIViewController) -> UIViewController? {
        if let pvc = vc.presentedViewController {
            return getCurrentViewController(pvc)
        }
        else if let svc = vc as? UISplitViewController, svc.viewControllers.count > 0 {
            return getCurrentViewController(svc.viewControllers.last!)
        }
        else if let nc = vc as? UINavigationController, nc.viewControllers.count > 0 {
            return getCurrentViewController(nc.topViewController!)
        }
        else if let tbc = vc as? UITabBarController {
            if let svc = tbc.selectedViewController {
                return getCurrentViewController(svc)
            }
        }
        return vc
    }
    
    /*
     Adds childController to the controller hierarchy and at the same time adds, and optionally animates, the child view
     @param animation: Closure to execute some animation. It receives the container view, the child view and a completion closure to call when animation is completed
     */
    public func addAndShowChildViewController(_ childController: UIViewController, container: UIView?, animation: ((UIView, UIView, @escaping (Bool) -> ()) ->())?) {
        addChildViewController(childController)
        childController.view.frame = view.bounds
        view.addSubview(childController.view)
        let containerView: UIView = container ?? view
        if animation != nil {
            animation?(containerView, childController.view, { (finished: Bool) in
                childController.didMove(toParentViewController: self)
            })
        } else {
            childController.didMove(toParentViewController: self)
        }
    }
    
    public func addAndFadeInChildViewController(_ childController: UIViewController, container: UIView?) {
        addAndShowChildViewController(childController, container: container) { (container: UIView, childView: UIView, completion: @escaping (Bool)->()) in
            // Fade in
            childView.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                childView.alpha = 1.0
            }, completion: completion)
        }
    }
    
    public func dismissAndRemoveChildViewController(_ childController: UIViewController, animation: ((UIView, @escaping (Bool) -> ()) ->())?) {
        childController.willMove(toParentViewController: nil)
        if animation != nil {
            animation?(childController.view, { (finished: Bool) in
                childController.view.removeFromSuperview()
                childController.removeFromParentViewController()
            })
        } else {
            childController.view.removeFromSuperview()
            childController.removeFromParentViewController()
        }
    }
    
    public func fadeOutAndRemoveChildViewController(_ childController: UIViewController) {
        dismissAndRemoveChildViewController(childController) { (childView: UIView, completion: @escaping (Bool)->()) in
            // Fade out
            UIView.animate(withDuration: 0.3, animations: {
                childView.alpha = 0.0
            }, completion: completion)
        }
    }
}
