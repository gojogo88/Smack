//
//  Channel.swift
//  Smack
//
//  Created by Jonathan Go on 2017/09/05.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import Foundation


struct Channel {
    public private(set) var channeltTitle: String!
    public private(set) var channeltDescription: String!
    public private(set) var channeltID: String!
}

//using decodable, you gotta have the variable names exactly as in the JSON data and should include everything
//struct  Channel : Decodable {
//    public private(set) var name: String!
//    public private(set) var description: String!
//    public private(set) var _id: String!
//    public private(set) var __v: Int?
//}

