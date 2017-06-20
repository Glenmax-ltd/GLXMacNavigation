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
    
    public var hidesBottomBarWhenPushed: Bool {
        return true
    }
    
    public var toolbarItems:[GLXMacBarButtonItem]? {
        return nil
    }
    
    
    public var navigationItem:GLXMacNavigationItem? {
        return nil
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
    
}
