//
//  GLXMacNavigationBar.swift
//  GLXMacNavigation
//
//  Created by Andriy Gordiychuk on 07/05/2017.
//  Copyright © 2017 Glenmax Ltd. All rights reserved.
//

import Foundation
import Cocoa

open class GLXMacNavigationBar:NSBox {
    
    var leftBarButtonItem:GLXMacBarButtonItem?
    var rightBarButtonItem:GLXMacBarButtonItem?
    var navBarTitle:NSTextField?
    
    open var tintColor:NSColor? {
        didSet {
            for item in self.items {
                item.leftBarButtonItem?.updateTint()
                item.rightBarButtonItem?.updateTint()
                item.titleLabel.textColor = tintColor
            }
        }
    }
    
    open var items:[GLXMacNavigationItem] = []
    
    open var topItem:GLXMacNavigationItem? {
        return items.last
    }
    
    open var backItem:GLXMacNavigationItem? {
        if items.count > 1 {
            return items[items.count - 2]
        }
        return nil
    }
    
    open func pushItem(_ item:GLXMacNavigationItem, animated: Bool) {
        if topItem != item {
            items.append(item)
        }
        if let left = topItem?.leftBarButtonItem {
            left.alphaValue = 0.0
            self.addSubview(left)
            left.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            left.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        }
        
        if let right = topItem?.rightBarButtonItem {
            right.alphaValue = 0.0
            self.addSubview(right)
            right.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            right.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        }
        let top = self.topItem
        let back = self.backItem
        NSAnimationContext.runAnimationGroup({ (context) in
            if animated {
                context.duration = 0.5
            }
            else {
                context.duration = 0
            }
            top?.leftBarButtonItem?.animator().alphaValue = 1
            top?.rightBarButtonItem?.animator().alphaValue = 1
            top?.titleLabel.animator().alphaValue = 1
            back?.leftBarButtonItem?.animator().alphaValue = 0
            back?.rightBarButtonItem?.animator().alphaValue = 0
            back?.titleLabel.animator().alphaValue = 0
        }, completionHandler: {
            back?.leftBarButtonItem?.removeFromSuperview()
            back?.rightBarButtonItem?.removeFromSuperview()
            back?.titleLabel.removeFromSuperview()
        })
    }
    
    open func popItem(_ item:GLXMacNavigationItem, animated: Bool) {
        if let left = backItem?.leftBarButtonItem {
            left.alphaValue = 0.0
            self.addSubview(left)
            left.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            left.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        }
        
        if let right = backItem?.rightBarButtonItem {
            right.alphaValue = 0.0
            self.addSubview(right)
            right.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            right.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        }
        let top = self.topItem
        let back = self.backItem
        NSAnimationContext.runAnimationGroup({ (context) in
            if animated {
                context.duration = 0.5
            }
            else {
                context.duration = 0
            }
            top?.leftBarButtonItem?.animator().alphaValue = 0
            top?.rightBarButtonItem?.animator().alphaValue = 0
            top?.titleLabel.animator().alphaValue = 0
            back?.leftBarButtonItem?.animator().alphaValue = 1
            back?.rightBarButtonItem?.animator().alphaValue = 1
            back?.titleLabel.animator().alphaValue = 1
        }, completionHandler: {
            top?.leftBarButtonItem?.removeFromSuperview()
            top?.rightBarButtonItem?.removeFromSuperview()
            top?.titleLabel.removeFromSuperview()
        })
        self.items.removeLast()
    }

    func updateLeftItem(forItem item:GLXMacNavigationItem) {
        if item == self.topItem {
            leftBarButtonItem?.removeFromSuperview()
            if let left = item.leftBarButtonItem {
                self.addSubview(left)
                left.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                left.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
            }
            leftBarButtonItem = item.leftBarButtonItem
        }
    }
    
    func updateRightItem(forItem item:GLXMacNavigationItem) {
        if item == self.topItem {
            rightBarButtonItem?.removeFromSuperview()
            if let right = item.rightBarButtonItem {
                self.addSubview(right)
                right.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                right.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
            }
            rightBarButtonItem = item.rightBarButtonItem
        }
    }
    
    func updateTitle(forItem item:GLXMacNavigationItem) {
        if item == self.topItem {
            navBarTitle?.removeFromSuperview()
            self.addSubview(item.titleLabel)
            item.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            item.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            navBarTitle = item.titleLabel
        }
    }
    
    /*func updateSubviews() {
        while self.subviews.count > 0 {
            self.subviews.remove(at: 0)
        }
     
    }*/
}
