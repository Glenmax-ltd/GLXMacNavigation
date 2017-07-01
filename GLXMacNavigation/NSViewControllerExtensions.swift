//
//  NSViewControllerExtensions.swift
//  GLXMacNavigation
//
//  Created by Andriy Gordiychuk on 07/05/2017.
//  Copyright © 2017 Glenmax Ltd. All rights reserved.
//

import Foundation
import Cocoa

public extension NSViewController {
    
    public var navigationItem:GLXMacNavigationItem? {
        return navigationController?.navigationItem(forController: self)
    }
    
    public var navigationController:GLXMacNavigationController? {
        if let parent = self.parent {
            if let navC = parent as? GLXMacNavigationController {
                return navC
            }
            else {
                return parent.navigationController
            }
        }
        return nil
    }
    
    public func setToolbarItems(_ items:[GLXMacBarButtonItem], animated:Bool) {
        self.navigationController?.setToolbarItems(items, forController: self, animated: animated)
    }
    
    public var hidesBottomBarWhenPushed:Bool {
        return true
    }
    
    public var hidesTopBarWhenPushed:Bool {
        return true
    }
    
}
