//
//  PhotoDetailModel.swift
//  PorscheHW
//
//  Created by Sergio Eduardo Zorilla Arellano on 18/10/23.
//

import Foundation

struct PhotoDetailModel: Codable {
    let id, description, altDescription: String?
    let createdAt: String?
    let urls: Urls?
    let downloads, likes: Int?

    enum CodingKeys: String, CodingKey {
        case id, description
        case altDescription = "alt_description"
        case createdAt = "created_at"
        case urls
        case downloads, likes
    }
}
