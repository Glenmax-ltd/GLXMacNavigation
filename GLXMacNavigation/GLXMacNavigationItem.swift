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
    
    open lazy var titleLabel:NSTextField = {
        let title = NSTextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = NSColor.clear
        title.textColor = self.leftBarButtonItem?.tintColor
        title.font = NSFont.systemFont(ofSize: 20)
        title.isBordered = false
        title.isEditable = false
        return title
    }()
    
    open var rightBarButtonItem:GLXMacBarButtonItem? {
        didSet {
            navigationController?.navigationBar.updateRightItem(forItem: self)
        }
    }
    
    open var title = "" {
        didSet {
            titleLabel.stringValue = title
            navigationController?.navigationBar.updateTitle(forItem: self)
        }
    }
    
    init(navController:GLXMacNavigationController) {
        navigationController = navController
        super.init()
    }
    
}
