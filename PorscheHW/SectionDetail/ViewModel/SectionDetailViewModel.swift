//
//  SectionDetailViewModel.swift
//  PorscheHW
//
//  Created by Sergio Eduardo Zorilla Arellano on 17/10/23.
//

import Foundation

final class SectionDetailViewModel: NSObject {
    var collectionDetail: [CollectionModel]?
    private var apiCaller = ApiCaller()
    var titleSection: String
    private var idCollection: String

    init(title: String, idCollection: String) {
        self.titleSection = title
        self.idCollection = idCollection
    }

    func fetchCollectionImages() async {
        collectionDetail = await apiCaller.fetch(type: [CollectionModel].self,
                                                 from: PathsUrl.sectionDetail(id: idCollection).pathId)
    }

    func addMoreImages(page: Int) async {
        let newImages = await apiCaller.fetch(type: [CollectionModel].self,
                                                     from: PathsUrl.sectionDetail(id: idCollection).pathId,
                                                     query: "&page=\(page)")
        guard let newImages = newImages else { return }
        for myCollection in newImages {
            self.collectionDetail?.append(myCollection)
        }
    }
}
