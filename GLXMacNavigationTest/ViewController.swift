//
//  ViewController.swift
//  GLXMacNavigationTest
//
//  Created by Andriy Gordiychuk on 14/06/2017.
//  Copyright © 2017 Glenmax Ltd. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var label:NSTextField!
    
    var hide = (arc4random() % 2) == 0
    
    override var hidesBottomBarWhenPushed:Bool {
        return hide
    }
    
    override var hidesTopBarWhenPushed:Bool {
        return hide
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem?.leftBarButtonItem = GLXMacBarButtonItem(title: String(describing: self.navigationController!.viewControllers.count), target: nil, selector: nil)
        self.navigationItem?.leftBarButtonItem?.tintColor = NSColor.white
        self.navigationItem?.rightBarButtonItem = GLXMacBarButtonItem(image: NSImage(named:"cancelCross")!, target: nil, selector: nil)
        self.navigationItem?.rightBarButtonItem?.tintColor = NSColor.white
        
        //self.setToolbarItems([GLXMacBarButtonItemFlexibleSpace(),GLXMacBarButtonItem(image: NSImage(named:"cancelCross")!, target: nil, selector: nil),GLXMacBarButtonItemFlexibleSpace(),GLXMacBarButtonItem(title: String(describing: self.navigationController!.viewControllers.count), target: nil, selector: nil),GLXMacBarButtonItemFlexibleSpace()], animated: true)
        // Do any additional setup after loading the view.
        label.stringValue = "View controller in the stack\n\n\(String(describing: self.navigationController!.viewControllers.count))"
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func push(_ sender:NSButton) {
        let view = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func pop(_ sender:NSButton) {
        self.navigationController?.popViewController(animated: true)
    }


}

