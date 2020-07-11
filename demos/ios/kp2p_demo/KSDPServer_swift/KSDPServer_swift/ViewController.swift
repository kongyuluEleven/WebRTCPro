//
//  ViewController.swift
//  KSDPServer_swift
//
//  Created by kongyulu on 2020/7/11.
//  Copyright © 2020 wondershare. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    private var server:KWebSocketServer?

    override func viewDidLoad() {
        super.viewDidLoad()
        server = try? KWebSocketServer()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startServer(_ sender: Any) {
        guard let server = server else {
            print("没有创建server")
            return
        }
        server.start()
    }
    
}

