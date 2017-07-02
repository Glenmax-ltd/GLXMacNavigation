//
//  NSViewControllerExtensions.swift
//  GLXMacNavigation
//
//  Created by Andriy Gordiychuk on 07/05/2017.
//  Copyright © 2017 Glenmax Ltd. All rights reserved.
//

import Foundation
import Cocoa

extension NSViewController {
    
    open var navigationItem:GLXMacNavigationItem? {
        return navigationController?.navigationItem(forController: self)
    }
    
    open var navigationController:GLXMacNavigationController? {
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
    
    open func setToolbarItems(_ items:[GLXMacBarButtonItem], animated:Bool) {
        self.navigationController?.setToolbarItems(items, forController: self, animated: animated)
    }
    
    open var hidesBottomBarWhenPushed:Bool {
        return true
    }
    
    open var hidesTopBarWhenPushed:Bool {
        return true
    }
    
}
