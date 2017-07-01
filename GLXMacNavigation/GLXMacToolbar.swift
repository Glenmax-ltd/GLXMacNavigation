//
//  GLXMacToolbar.swift
//  GLXMacNavigation
//
//  Created by Andriy Gordiychuk on 07/05/2017.
//  Copyright © 2017 Glenmax Ltd. All rights reserved.
//

import Foundation
import Cocoa

open class GLXMacToolbar:NSBox {
    
    open var toolbarItems:[GLXMacBarButtonItem] = []
    
    func setItems(_ items:[GLXMacBarButtonItem], animated:Bool) {
        var previousView:NSView = self
        var flexSpaceViews:[GLXMacBarButtonItemFlexibleSpace] = []
        for item in items {
            item.alphaValue = 0
            self.addSubview(item)
            if previousView == self {
                item.leadingAnchor.constraint(equalTo: previousView.leadingAnchor, constant:15).isActive = true
            }
            else {
                item.leadingAnchor.constraint(equalTo: previousView.trailingAnchor, constant:15).isActive = true
            }
            item.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            if let flex = item as? GLXMacBarButtonItemFlexibleSpace {
                flex.setContentHuggingPriority(NSLayoutPriorityDefaultLow, for: .horizontal)
                flex.translatesAutoresizingMaskIntoConstraints = false
                if let last = flexSpaceViews.last {
                    last.widthAnchor.constraint(equalTo: flex.widthAnchor).isActive = true
                }
                flexSpaceViews.append(flex)
                flex.heightAnchor.constraint(equalToConstant: 10.0).isActive = true
            }
            else {
                item.setContentHuggingPriority(NSLayoutPriorityRequired, for: .horizontal)
            }
            previousView = item
        }
        
        if let last = items.last {
            last.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        }
        
        NSAnimationContext.runAnimationGroup({ (context) in
            if animated {
                context.duration = 0.5
            }
            else {
                context.duration = 0
            }
            for item in items {
                if let flex = item as? GLXMacBarButtonItemFlexibleSpace {
                    
                }
                else {
                    item.animator().alphaValue = 1.0
                }
            }
            for item in self.toolbarItems {
                item.animator().alphaValue = 0.0
            }
        }, completionHandler: {
            for item in self.toolbarItems {
                item.removeFromSuperview()
            }
            self.toolbarItems = items
        })
    }
    
}
