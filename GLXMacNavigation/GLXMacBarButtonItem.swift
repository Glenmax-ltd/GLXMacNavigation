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
    
    open var isOn = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var isMenuOpeningButton = false {
        didSet {
            if isMenuOpeningButton {
                self.widthAnchor.constraint(equalToConstant: 26).isActive = true
                self.heightAnchor.constraint(equalToConstant: 26).isActive = true
            }
        }
    }
    
    public convenience init(title:String,target:AnyObject?,selector:Selector?) {
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
    
    public convenience init(image:NSImage,target:AnyObject?,selector:Selector?) {
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
    
    override open func draw(_ dirtyRect: NSRect) {
        if !isMenuOpeningButton {
            return
        }
        var color:NSColor
        
        if let tint = tintColor {
            color = tint
        }
        else {
            color = NSColor.white
        }
        
        if self.isOn {
            color = color.withAlphaComponent(0.5)
        }
        
        color.setStroke()
        
        let context = NSGraphicsContext.current()
        context?.shouldAntialias = false
        
        let top = NSBezierPath()
        top.move(to: CGPoint(x:3,y:6.5))
        top.line(to: CGPoint(x:23,y:6.5))
        top.stroke()
        
        let middle = NSBezierPath()
        middle.move(to: CGPoint(x:3,y:12.5))
        middle.line(to: CGPoint(x:23,y:12.5))
        middle.stroke()
        
        let bottom = NSBezierPath()
        bottom.move(to: CGPoint(x:3,y:18.5))
        bottom.line(to: CGPoint(x:23,y:18.5))
        bottom.stroke()
    }
    
    public override func animateColor(_ isOn: Bool) {
        super.animateColor(isOn)
        self.isOn = isOn
    }
}
