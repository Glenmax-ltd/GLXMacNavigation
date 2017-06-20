//
//  AppDelegate.swift
//  GLXMacNavigationTest
//
//  Created by Andriy Gordiychuk on 14/06/2017.
//  Copyright © 2017 Glenmax Ltd. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let nav = NSApplication.shared().keyWindow?.contentViewController as? GLXMacNavigationController {
            nav.pushViewController(NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "ViewController") as! ViewController, animated: false)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

