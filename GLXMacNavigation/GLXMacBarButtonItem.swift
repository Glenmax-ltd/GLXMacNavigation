//
//  GLXMacBarButtonItem.swift
//  GLXMacNavigation
//
//  Created by Andriy Gordiychuk on 07/05/2017.
//  Copyright © 2017 Glenmax Ltd. All rights reserved.
//

import Foundation
import Cocoa

extension NSImage {
    func tinted(color:NSColor?) -> NSImage {
        if let tint = color {
            let size        = self.size
            let imageBounds = NSMakeRect(0, 0, size.width, size.height)
            let copiedImage = self.copy() as! NSImage
            
            copiedImage.lockFocus()
            tint.set()
            NSRectFillUsingOperation(imageBounds, .sourceAtop)
            copiedImage.unlockFocus()
            
            return copiedImage
        }
        return self
    }
}

open class GLXMacBarButtonItemFlexibleSpace:GLXMacBarButtonItem {
}

open class GLXMacBarButtonItem:FlatButton {
    
    open var tintColor:NSColor? {
        didSet {
            self.updateTint()
        }
    }
    
    convenience init(title:String,target:AnyObject?,selector:Selector?) {
        self.init(frame: NSRect.zero)
        self.target = target
        self.action = selector
        self.title = title
        isBordered = false
        font = NSFont.systemFont(ofSize: 17.0)
        //alignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        self.updateTint()
    }
    
    convenience init(image:NSImage,target:AnyObject?,selector:Selector?) {
        self.init(frame: NSRect.zero)
        self.target = target
        self.action = selector
        self.image = image
        self.title = ""
        isBordered = false
        font = NSFont.systemFont(ofSize: 17.0)
        //alignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        self.updateTint()
    }
    
    func updateTint() {
        buttonColor = NSColor.clear
        momentary = true
        activeButtonColor = NSColor.clear
        borderColor = NSColor.clear
        activeBorderColor = NSColor.clear
        
        if let textColor = tintColor
        {
            self.iconColor = textColor
            self.textColor = textColor
            
            self.activeIconColor = textColor.withAlphaComponent(0.5)
            self.activeTextColor = textColor.withAlphaComponent(0.5)
        }
    }
}
