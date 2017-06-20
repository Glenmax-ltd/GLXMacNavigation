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

    override func viewDidLoad() {
        super.viewDidLoad()

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

