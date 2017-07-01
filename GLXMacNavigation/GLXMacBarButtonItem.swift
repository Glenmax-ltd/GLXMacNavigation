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

open class GLXMacBarButtonItem:NSButton {
    
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
        alignment = .center
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
        alignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        self.updateTint()
    }
    
    func updateTint() {
        if let image = self.image {
            self.image = image.tinted(color: tintColor)
        }
        if let textColor = tintColor
        {
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            
            let attributes =
                [
                    NSForegroundColorAttributeName: textColor,
                    NSFontAttributeName: NSFont.systemFont(ofSize: 17.0),
                    NSParagraphStyleAttributeName: style
                    ] as [String : Any]
            
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            self.attributedTitle = attributedTitle
        }
    }
}
