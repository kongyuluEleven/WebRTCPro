//
//  KWebSocketClient.swift
//  KSDPServer_swift
//
//  Created by kongyulu on 2020/7/11.
//  Copyright © 2020 wondershare. All rights reserved.
//

import Cocoa
import Network

//继承哈希协议, 才能放进去set集

class KWebSocketClient: Hashable, Equatable {
    let id:String
    let connection: NWConnection
    
    init(connection:NWConnection) {
        self.connection = connection
        id = UUID().uuidString
    }
    
    static func == (lhs: KWebSocketClient, rhs: KWebSocketClient) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
