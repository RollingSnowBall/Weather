//
//  ErrorMsg.swift
//  Weather
//
//  Created by JUNO on 2022/04/30.
//

import Foundation

struct ErrorMsg : Codable {
    let msg: String
    
    enum CodingKeys: String, CodingKey {
        case msg = "message"
    }
}
