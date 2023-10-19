//
//  Networking.swift
//  PorscheHW
//
//  Created by Sergio Eduardo Zorilla Arellano on 16/10/23.
//

import Foundation

struct ApiCaller {
    private let mainURL = "https://api.unsplash.com"
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    func fetch<T: Decodable>(type: T.Type, from urlString: String, query: String? = "") async -> T? {
        var completeURL = mainURL + urlString
        guard let apiURL = Bundle.infoPlistValue(forKey: "CLIENT_ID") as? String else { return nil}
        completeURL += "?client_id=\(apiURL)"
        if let query = query {
            completeURL += query
        }
        guard let url = URL(string: completeURL) else { return nil }
        do {
            let (data, _) = try await URLSession
                .shared
                .data(from: url)
            return try decoder.decode(type, from: data)
        } catch {
            print("Info could not be decoded: \(error)")
            return nil
        }
    }
}

enum PathsUrl {
    case topics
    case lucky
    case sectionDetail(id: String)
    case photo(id: String)
    
    var pathId: String {
        switch self {
        case .topics:
            return "/topics"
        case .lucky:
            return "/photos/random"
        case .sectionDetail(let id):
            return "/topics/\(id)/photos"
        case .photo(let id):
            return "/photos/\(id)"
        }
    }
}

extension Bundle {
    static func infoPlistValue(forKey key: String) -> Any? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) else {
           return nil
        }
        return value
    }
}
