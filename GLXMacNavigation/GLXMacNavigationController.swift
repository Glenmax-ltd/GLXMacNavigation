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
        view.titlePosition = .noTitle
        view.boxType = .custom
        view.borderType = .noBorder
        view.cornerRadius = 0.0
        view.borderWidth = 0.0
        view.fillColor = NSColor.red
        view.title = ""
        view.contentViewMargins = NSMakeSize(0,0)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.navBarHeightConstraint = view.heightAnchor.constraint(equalToConstant: self.navigationBarHeight)
        self.navBarHeightConstraint?.isActive = true
        self.navBarHeightConstraint?.priority = 1000
        return view
    }()
    
    /// Height constraint for navigation bar
    fileprivate var navBarHeightConstraint: NSLayoutConstraint?
    fileprivate lazy var navBarLeadingConstraint: NSLayoutConstraint = {
        return self.navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
    }()
    
    /// Height of the navigation bar
    open var navigationBarHeight:CGFloat = 44.0 {
        didSet {
            if let contr = self.topViewController {
                if !contr.hidesTopBarWhenPushed  {
                    self.navBarHeightConstraint?.constant = navigationBarHeight
                }
                
            }
        }
    }
    
    // MARK:---- Toolbar
    
    open lazy var toolbar:GLXMacToolbar = {
        let view = GLXMacToolbar()
        view.titlePosition = .noTitle
        view.boxType = .custom
        view.borderType = .noBorder
        view.cornerRadius = 0.0
        view.borderWidth = 0.0
        view.fillColor = NSColor.red
        view.title = ""
        view.contentViewMargins = NSMakeSize(0,0)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.toolbarHeightConstraint = view.heightAnchor.constraint(equalToConstant: self.toolbarHeight)
        self.toolbarHeightConstraint?.isActive = true
        return view
    }()
    
    open var toolbarItems:[[GLXMacBarButtonItem]] = []
    
    fileprivate var toolbarHeightConstraint: NSLayoutConstraint?
    fileprivate lazy var toolbarLeadingConstraint: NSLayoutConstraint = {
        return self.toolbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
    }()
    
    open var toolbarHeight:CGFloat = 44.0 {
        didSet {
            if let contr = self.topViewController {
                if !contr.hidesBottomBarWhenPushed  {
                    self.toolbarHeightConstraint?.constant = navigationBarHeight
                }
                
            }
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
        navBarLeadingConstraint.isActive = true
        toolbarLeadingConstraint.isActive = true
        navigationBar.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        toolbar.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func addViewController(_ viewController:NSViewController) {
        let item = GLXMacNavigationItem(navController: self)
        self.navigationBar.pushItem(item, animated: true)
        self.toolbarItems.append([])
        viewControllers.append(viewController)
        self.addChildViewController(viewController)
        self.view.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        navigationConstraints.append(self.setupConstraintsForChildViewController(viewController))
    }
    
    func setupConstraintsForChildViewController(_ viewController:NSViewController) ->NSLayoutConstraint {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        let topC = viewController.view.topAnchor.constraint(equalTo: self.view.topAnchor)
        if !viewController.hidesTopBarWhenPushed {
            topC.constant = navigationBarHeight
        }
        topC.isActive = true
        
        let bottomC = viewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        if !viewController.hidesBottomBarWhenPushed {
            bottomC.constant = -toolbarHeight
        }
        bottomC.isActive = true
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
            let shouldAnimateNavBar = viewController.hidesTopBarWhenPushed != currentViewController.hidesTopBarWhenPushed
            if shouldAnimateNavBar {
                if viewController.hidesTopBarWhenPushed {
                    
                }
                else {
                    self.navBarHeightConstraint?.constant = navigationBarHeight
                    self.navBarLeadingConstraint.constant = self.view.frame.size.width
                }
            }
            let shouldAnimateToolbar = viewController.hidesBottomBarWhenPushed != currentViewController.hidesBottomBarWhenPushed
            if shouldAnimateToolbar {
                if viewController.hidesBottomBarWhenPushed {
                    
                }
                else {
                    self.toolbarHeightConstraint?.constant = toolbarHeight
                    self.toolbarLeadingConstraint.constant = self.view.frame.size.width
                }
            }
            if !self.childViewControllers.contains(viewController) {
                self.addViewController(viewController)
            }
            let constraints = navigationConstraints.last!
            let previousConstraints = navigationConstraints[navigationConstraints.count-2]
            constraints.constant = self.view.frame.size.width
            previousConstraints.constant = 0
            NSAnimationContext.runAnimationGroup({ (context) in
                if animated {
                    context.duration = 0.5
                }
                else {
                    context.duration = 0
                }
                if shouldAnimateNavBar {
                    if viewController.hidesTopBarWhenPushed {
                        self.navBarLeadingConstraint.animator().constant = -self.view.frame.size.width
                    }
                    else {
                        self.navBarLeadingConstraint.animator().constant = 0
                    }
                }
                if shouldAnimateToolbar {
                    if viewController.hidesBottomBarWhenPushed {
                        self.toolbarLeadingConstraint.animator().constant = -self.view.frame.size.width
                    }
                    else {
                        self.toolbarLeadingConstraint.animator().constant = 0
                    }
                }
                constraints.animator().constant = 0
                previousConstraints.animator().constant = -self.view.frame.size.width/3
            }, completionHandler: {
                if self.currentNavigationAction == .pushing {
                    currentViewController.removeFromParentViewController()
                    currentViewController.view.removeFromSuperview()
                    self.currentNavigationAction = .none
                    if viewController.hidesTopBarWhenPushed {
                        self.navBarLeadingConstraint.constant = 0
                        self.navBarHeightConstraint?.constant = 0
                    }
                    if viewController.hidesBottomBarWhenPushed {
                        self.toolbarLeadingConstraint.constant = 0
                        self.toolbarHeightConstraint?.constant = 0
                    }
                }
            })
        }
        else {
            self.addViewController(viewController)
            self.navBarLeadingConstraint.constant = 0
            if viewController.hidesTopBarWhenPushed {
                self.navBarHeightConstraint?.constant = 0
                
            }
            else {
                self.navBarHeightConstraint?.constant = navigationBarHeight
            }
            self.toolbarLeadingConstraint.constant = 0
            if viewController.hidesBottomBarWhenPushed {
                self.toolbarHeightConstraint?.constant = 0
                
            }
            else {
                self.toolbarHeightConstraint?.constant = toolbarHeight
            }
        }
    }
    
    open func popViewController(animated:Bool) {
        if viewControllers.count > 1 {
            self.currentNavigationAction = .popping
            let currentViewController = self.topViewController!
            let viewController = self.viewControllers[self.viewControllers.count-2]
            let shouldAnimateNavBar = viewController.hidesTopBarWhenPushed != currentViewController.hidesTopBarWhenPushed
            if shouldAnimateNavBar {
                if viewController.hidesTopBarWhenPushed {
                    
                }
                else {
                    self.navBarHeightConstraint?.constant = navigationBarHeight
                    self.navBarLeadingConstraint.constant = -self.view.frame.size.width
                }
            }
            let shouldAnimateToolbar = viewController.hidesBottomBarWhenPushed != currentViewController.hidesBottomBarWhenPushed
            if shouldAnimateToolbar {
                if viewController.hidesBottomBarWhenPushed {
                    
                }
                else {
                    self.toolbarHeightConstraint?.constant = toolbarHeight
                    self.toolbarLeadingConstraint.constant = -self.view.frame.size.width
                }
            }
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
                    context.duration = 0.5
                }
                else {
                    context.duration = 0
                }
                if shouldAnimateNavBar {
                    if viewController.hidesTopBarWhenPushed {
                        self.navBarLeadingConstraint.animator().constant = self.view.frame.size.width
                    }
                    else {
                        self.navBarLeadingConstraint.animator().constant = 0
                    }
                }
                if shouldAnimateToolbar {
                    if viewController.hidesBottomBarWhenPushed {
                        self.toolbarLeadingConstraint.animator().constant = self.view.frame.size.width
                    }
                    else {
                        self.toolbarLeadingConstraint.animator().constant = 0
                    }
                }
                previousConstraints.animator().constant = 0
                //viewController.view.animator().constant = 0
                constraints.animator().constant = self.view.frame.size.width
            }, completionHandler: {
                if self.currentNavigationAction == .popping {
                    currentViewController.removeFromParentViewController()
                    currentViewController.view.removeFromSuperview()
                    self.currentNavigationAction = .none
                    if viewController.hidesTopBarWhenPushed {
                        self.navBarLeadingConstraint.constant = 0
                        self.navBarHeightConstraint?.constant = 0
                    }
                    if viewController.hidesBottomBarWhenPushed {
                        self.toolbarLeadingConstraint.constant = 0
                        self.toolbarHeightConstraint?.constant = 0
                    }
                }
            })
            viewControllers.removeLast()
            navigationConstraints.removeLast()
            self.toolbarItems.removeLast()
            self.navigationBar.popItem(self.navigationBar.topItem!, animated: true)
        }
    }
    
    func navigationItem(forController controller:NSViewController) ->GLXMacNavigationItem? {
        if let index = viewControllers.index(of: controller) {
            return self.navigationBar.items[index]
        }
        return nil
    }
    
    func setToolbarItems(_ items:[GLXMacBarButtonItem], forController controller:NSViewController, animated:Bool) {
        if let index = viewControllers.index(of: controller) {
            self.toolbarItems[index] = items
            if index == viewControllers.count - 1 {
                self.toolbar.setItems(items, animated: animated)
            }
        }
    }

}

