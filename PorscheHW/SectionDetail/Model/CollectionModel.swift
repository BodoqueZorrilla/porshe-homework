//
//  CollectionModel.swift
//  PorscheHW
//
//  Created by Sergio Eduardo Zorilla Arellano on 17/10/23.
//

import Foundation

struct CollectionModel: Codable {
    let id, slug, description: String?
    let createdAt: String?
    let urls: Urls?

    enum CodingKeys: String, CodingKey {
        case id, slug, description
        case createdAt = "created_at"
        case urls
    }
}
