//
//  KWebSocketServer.swift
//  KSDPServer_swift
//
//  Created by kongyulu on 2020/7/11.
//  Copyright © 2020 wondershare. All rights reserved.
//

import Cocoa
import Network

class KWebSocketServer {
    
    private let queue = DispatchQueue.global()
    private let port : NWEndpoint.Port = 8080
    private let listener: NWListener
    
    /// 保存建立连接 的客户端
    private var connectedClients = Set<KWebSocketClient>()
    
    init() throws {
        //设置连接属性
        let webSocketOptions = NWProtocolWebSocket.Options()
        //设置自动回复ping包
        webSocketOptions.autoReplyPing = true
        //使用TCP连接
        let param = NWParameters.tcp
        //设置默认协议栈
        param.defaultProtocolStack.applicationProtocols.append(webSocketOptions)
        //创建监听器
        listener = try NWListener(using: param, on: port)
    }
    
    //启动服务
    func start() {
        //设置接收到消息的代理回调
        listener.newConnectionHandler = newConnectionHandler(_:)
        //开启服务器后台监听
        listener.start(queue: queue)
        print("启动成功信令服务器，端口：\(port)")
    }

}

// MARK: - 连接代理
fileprivate extension KWebSocketServer {
    func send(msg: Data, to client:KWebSocketClient) {
        //设置元数据为二进制数据
        let metadata =  NWProtocolWebSocket.Metadata(opcode: .binary)
        //创建一个连接上下文
        let context = NWConnection.ContentContext(identifier: "kyl_server_context", expiration: 120, priority: 1.0, isFinal: true, antecedent: nil, metadata: [metadata])
        client.connection.send(content: msg, contentContext: context, isComplete: true, completion: .contentProcessed({ (err) in
            print("contentProcessed, err=\(String(describing: err))")
        }))
    }
    
    func broadcast(msg: Data, to clients: Set<KWebSocketClient>) -> Bool {
        guard clients.count > 0 else {
            return  false
        }
        clients.forEach{ [weak self] in
            self?.send(msg: msg, to: $0)
        }
        return true
    }
}

// MARK: - 连接代理
fileprivate extension KWebSocketServer {
    
    func newConnectionHandler(_ connection: NWConnection) {
        let client = KWebSocketClient(connection: connection)
        connectedClients.insert(client)
        //新建连接
        client.connection.start(queue: queue)
        //设置连接回调
        client.connection.receiveMessage { [weak self] (data, context, isFinished, err) in
            print("收到消息：data=\(String(describing: data)),context=\(String(describing: context)),isFinished=\(isFinished),err=\(String(describing: err))")
            self?.didReceivedMsg(from: client, data: data, context: context, error: err)
        }
    }
    
    func didReceivedMsg(from client: KWebSocketClient,
                        data: Data?,
                        context: NWConnection.ContentContext?,
                        error: NWError?) {
        if let context =  context, context.isFinal {
            //如果是收到终止连接消息
            //取消连接
            client.connection.cancel()
            //通知上层，有连接断开
            didDisconnected(client: client)
            return
        }
        //如果有收到数据，则发送给其他客户端
        if let data = data {
            let others = connectedClients.filter{ $0 != client }
            //发送广播给这些客户端
            _ = broadcast(msg: data, to: others)
            if let msg = String(data: data, encoding: .utf8) {
                print("****收到消息：\(msg) \n")
            }
        }
        
        //继续接受其他消息
        client.connection.receiveMessage { [weak self] (data, context, isFinished, error) in
            print("收到消息：data=\(String(describing: data)),context=\(String(describing: context)),isFinished=\(isFinished),err=\(String(describing: error))")
            self?.didReceivedMsg(from: client, data: data, context: context, error: error)
        }
    }
    
    func didDisconnected(client: KWebSocketClient) {
        connectedClients.remove(client)
        print("收到客户端端口连接，当前总连接数量：\(connectedClients.count)")
    }
}
