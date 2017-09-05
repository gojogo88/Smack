//
//  SocketService.swift
//  Smack
//
//  Created by Jonathan Go on 2017/09/05.
//  Copyright © 2017 Appdelight. All rights reserved.
//

//singleton
import UIKit
import SocketIO

class SocketService: NSObject {
    static let instance = SocketService()

    override init() {
        super.init()
    }
    
    var socket : SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!)
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription)  //newChannel, channelName, channelDesription are taken from the API code
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        //socket.on will listen for an event
        socket.on("channelCreated") { (dataArray, ack) in  //we know its an array from API code. order is important
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, channelID: channelId)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
}
