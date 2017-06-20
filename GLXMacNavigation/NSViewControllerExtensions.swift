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
    
    var hidesBottomBarWhenPushed: Bool {
        return true
    }
    
    var toolbarItems:[GLXMacBarButtonItem]? {
        return nil
    }
    
    var navigationItem:GLXMacNavigationItem? {
        return nil
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
    
}
