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
    
    var navigationItem:GLXMacNavigationItem? {
        return navigationController?.navigationItem(forController: self)
    }
    
    var navigationController:GLXMacNavigationController? {
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
    
    func setToolbarItems(_ items:[GLXMacBarButtonItem], animated:Bool) {
        self.navigationController?.setToolbarItems(items, forController: self, animated: animated)
    }
    
    var hidesBottomBarWhenPushed:Bool {
        return true
    }
    
    open var hidesTopBarWhenPushed:Bool {
        return true
    }
    
}
