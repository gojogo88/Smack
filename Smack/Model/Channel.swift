//
//  Channel.swift
//  Smack
//
//  Created by Jonathan Go on 2017/09/05.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import Foundation


struct Channel {
    public private(set) var channelTitle: String!
    public private(set) var channelDescription: String!
    public private(set) var channelID: String!
}

//using decodable, you gotta have the variable names exactly as in the JSON data and should include everything
//struct  Channel : Decodable {
//    public private(set) var name: String!
//    public private(set) var description: String!
//    public private(set) var _id: String!
//    public private(set) var __v: Int?
//}

