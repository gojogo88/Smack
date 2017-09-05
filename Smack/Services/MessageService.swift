//
//  MessageService.swift
//  Smack
//
//  Created by Jonathan Go on 2017/09/05.
//  Copyright © 2017 Appdelight. All rights reserved.
//

//responsible for storing our messages, channels and functions that will retrieve messages and channels. This will be a singleton too. This is a swift file

import Foundation
import Alamofire
import SwiftyJSON

class MessgeService {
    
    static let instance = MessgeService()
    
    var channels = [Channel]()
    
    func findAllChannel(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                if let json = JSON(data: data).array {
                    for item in json {
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(channeltTitle: name, channeltDescription: channelDescription, channeltID: id)
                        self.channels.append(channel)
                    }
                    print(self.channels[0].channeltTitle)
                    completion(true)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
                //using the decodable option for parsing
//                do {
//                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
//                } catch let error {
//                    debugPrint(error as Any)
//                }
//                print(self.channels)

        }
    }
}
