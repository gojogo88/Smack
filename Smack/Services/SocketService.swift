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
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    
    //this func listens for a new message at the server and if we get it, we get a dataArray which we have to parse through
    func getChatMessage(completion: @escaping CompletionHandler) {
        socket.on("messageCreated") { (dataArray, ack) in
            guard let msgBody = dataArray[0] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let userName = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            
            //check if the incoming message is part of the channel we chose
            if channelId == MessageService.instance.selectedChannel?.channelID && AuthService.instance.isLoggedIn {
                let newMessage = Message(message: msgBody, username: userName, channelID: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                MessageService.instance.messages.append(newMessage)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
