//
//  ViewController.swift
//  carTestMac
//
//  Created by Andriy Gordiychuk on 25/04/16.
//
//

import Cocoa
import Foundation

fileprivate enum GLXNavigationAction {
    case none
    case pushing
    case popping
}

open class GLXMacNavigationController: NSViewController {
    
    // MARK: Properties
    // MARK:---- Navigation Bar
    /// Returns the navigation bar of the view controller
    open lazy var navigationBar:GLXMacNavigationBar = {
        let view = GLXMacNavigationBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.navBarHeightConstraint = view.heightAnchor.constraint(equalToConstant: self.navigationBarHeight)
        self.navBarHeightConstraint?.isActive = true
        return view
    }()
    
    /// Height constraint for navigation bar
    fileprivate var navBarHeightConstraint: NSLayoutConstraint?
    
    /// Height of the navigation bar
    open var navigationBarHeight:CGFloat = 60.0 {
        didSet {
            self.navBarHeightConstraint?.constant = navigationBarHeight
        }
    }
    
    // MARK:---- Toolbar
    
    open lazy var toolbar:GLXMacToolbar = {
        let view = GLXMacToolbar()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.toolbarHeightConstraint = view.heightAnchor.constraint(equalToConstant: self.toolbarHeight)
        self.toolbarHeightConstraint?.isActive = true
        return view
    }()
    
    fileprivate var toolbarHeightConstraint: NSLayoutConstraint?
    
    open var toolbarHeight:CGFloat = 60.0 {
        didSet {
            self.toolbarHeightConstraint?.constant = toolbarHeight
        }
    }
    
    // MARK:---- View controllers access
    
    open var viewControllers:[NSViewController] = []
    
    open var topViewController:NSViewController? {
        return viewControllers.last
    }
    
    open var rootViewController:NSViewController? {
        return viewControllers.first
    }
    
    // MARK:---- Other properties
    
    fileprivate var currentNavigationAction:GLXNavigationAction = .none
    
    /// Collection of leading constraints for each view controller in the stack
    fileprivate var navigationConstraints:[NSLayoutConstraint] = []
    
    convenience init(rootViewController:NSViewController) {
        self.init()
        self.addViewController(rootViewController)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(navigationBar)
        self.view.addSubview(toolbar)
        navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        toolbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func addViewController(_ viewController:NSViewController) {
        self.addChildViewController(viewController)
        self.view.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        navigationConstraints.append(self.setupConstraintsForChildViewController(viewController))
    }
    
    func setupConstraintsForChildViewController(_ viewController:NSViewController) ->NSLayoutConstraint {
        viewController.view.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: toolbar.topAnchor).isActive = true
        let leading = viewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        leading.isActive = true
        let width = viewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        width.isActive = true
        return leading
    }
    
    func removeViewController(_ viewController:NSViewController) {
        
        if let index = self.viewControllers.index(of: viewController) {
            self.viewControllers.remove(at: index)
        }
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
        
    }
    
    open func pushViewController(_ viewController:NSViewController, animated:Bool) {
        if let currentViewController = self.topViewController {
            self.currentNavigationAction = .pushing
            if !self.childViewControllers.contains(viewController) {
                self.addViewController(viewController)
            }
            let constraints = navigationConstraints.last!
            let previousConstraints = navigationConstraints[navigationConstraints.count-2]
            constraints.constant = self.view.frame.size.width
            previousConstraints.constant = 0
            NSAnimationContext.runAnimationGroup({ (context) in
                if animated {
                    context.duration = 0.25
                }
                else {
                    context.duration = 0
                }
                constraints.animator().constant = 0
                previousConstraints.animator().constant = -self.view.frame.size.width/3
            }, completionHandler: {
                if self.currentNavigationAction == .pushing {
                    currentViewController.removeFromParentViewController()
                    currentViewController.view.removeFromSuperview()
                    self.currentNavigationAction = .none
                }
            })
        }
        else {
            self.addViewController(viewController)
        }
        viewControllers.append(viewController)
    }
    
    open func popViewController(animated:Bool) {
        if viewControllers.count > 1 {
            self.currentNavigationAction = .popping
            let currentViewController = self.topViewController!
            let viewController = self.viewControllers[self.viewControllers.count-2]
            if !self.childViewControllers.contains(viewController) {
                self.insertChildViewController(viewController, at: self.childViewControllers.index(of: currentViewController)!)
                self.view.addSubview(viewController.view, positioned: .below, relativeTo: currentViewController.view)
                navigationConstraints.insert(self.setupConstraintsForChildViewController(viewController), at: navigationConstraints.count-1)
            }
            let constraints = navigationConstraints.last!
            let previousConstraints = navigationConstraints[navigationConstraints.count-2]
            previousConstraints.constant = -self.view.frame.size.width/3
            NSAnimationContext.runAnimationGroup({ (context) in
                if animated {
                    context.duration = 0.25
                }
                else {
                    context.duration = 0
                }
                previousConstraints.animator().constant = 0
                //viewController.view.animator().constant = 0
                constraints.animator().constant = self.view.frame.size.width
            }, completionHandler: {
                if self.currentNavigationAction == .popping {
                    currentViewController.removeFromParentViewController()
                    currentViewController.view.removeFromSuperview()
                    self.currentNavigationAction = .none
                }
            })
            viewControllers.removeLast()
            navigationConstraints.removeLast()
        }
    }

}

