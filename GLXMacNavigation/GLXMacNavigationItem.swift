//
//  GLXMacNavigationItem.swift
//  GLXMacNavigation
//
//  Created by Andriy Gordiychuk on 07/05/2017.
//  Copyright © 2017 Glenmax Ltd. All rights reserved.
//

import Foundation
import Cocoa

open class GLXMacNavigationItem:NSObject {
    
    weak var navigationController:GLXMacNavigationController?
    
    open var leftBarButtonItem:GLXMacBarButtonItem? {
        didSet {
            navigationController?.navigationBar.updateLeftItem(forItem: self)
        }
    }
    
    open var rightBarButtonItem:GLXMacBarButtonItem? {
        didSet {
            navigationController?.navigationBar.updateRightItem(forItem: self)
        }
    }
    
    init(navController:GLXMacNavigationController) {
        navigationController = navController
        super.init()
    }
    
}
