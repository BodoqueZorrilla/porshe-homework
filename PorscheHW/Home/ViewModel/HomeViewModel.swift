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
        topics = await apiCaller.fetch(type: [TopicsModel].self, from: PathsUrl.topics.pathId)
    }
    
    func loadLuckyImage() async {
        lucky = await apiCaller.fetch(type: LuckyImageModel.self, from: PathsUrl.lucky.pathId, query: "&query=porsche")
    }
}

enum HomeConstants {
    static let mainImageHeigth: CGFloat = 3
    static let randomImageHeight: CGFloat = 4
    static let constraintView: CGFloat = 16
    static let buttonHeigth: CGFloat = 60.0
}
