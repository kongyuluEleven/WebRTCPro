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

    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet var textView: NSTextView!
    
    @IBOutlet weak var btnStart: NSButton!
    private var bStarted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        server = try? KWebSocketServer()
        server?.delegate = self
        btnStart.title = "启动"
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
        if bStarted {
            server.stop()
            btnStart.title = "启动"
        } else {
            server.start()
            btnStart.title = "停止"
        }

        bStarted = !bStarted
    }
}

extension ViewController:KWebSocketServerMsgDelegate {
    func didReceive(msg: String) {
        DispatchQueue.main.async {
            let message = self.textView.string + "\n" + "\(Date()):\(msg)"
            self.textView.string = message
        }
    }
}

