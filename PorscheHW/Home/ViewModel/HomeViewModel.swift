//
//  HomeViewModel.swift
//  PorscheHW
//
//  Created by Sergio Eduardo Zorilla Arellano on 16/10/23.
//

import Foundation

class HomeViewModel: NSObject {
    var topics: [TopicsModel]?
    private var apiCaller = ApiCaller()
    var lucky: LuckyImageModel?

    func fetchMainImages() async {
        topics = await apiCaller.fetch(type: [TopicsModel].self, from: PathsUrl.topics.rawValue)
    }
    
    func loadLuckyImage() async {
        lucky = await apiCaller.fetch(type: LuckyImageModel.self, from: PathsUrl.lucky.rawValue, query: "porsche")
    }
}

