//
//  LuckyImageModel.swift
//  PorscheHW
//
//  Created by Sergio Eduardo Zorilla Arellano on 16/10/23.
//

import Foundation

struct LuckyImageModel: Codable {
    let id: String
    let urls: Urls?
    let views: Int?
    let downloads: Int?
}
