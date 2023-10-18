//
//  PhotoDetailViewModel.swift
//  PorscheHW
//
//  Created by Sergio Eduardo Zorilla Arellano on 18/10/23.
//

import Foundation
import UIKit

class PhotoDetailViewModel: NSObject {
    var photoData: PhotoDetailModel?
    private var apiCaller = ApiCaller()
    private var idPhoto: String
    
    init(idPhoto: String) {
        self.idPhoto = idPhoto
    }
    
    func fetchImageData() async {
        photoData = await apiCaller.fetch(type: PhotoDetailModel.self,
                                          from: PathsUrl.photo(id: idPhoto).pathId)
    }

    func returnIconSize(size: Int) ->  UIImage.SymbolConfiguration {
        return UIImage.SymbolConfiguration(pointSize: CGFloat(size))
    }
}

enum PhotoDetailConstants {
    static let fontDescriptionSize: CGFloat = 16.0
    static let fontCountsSize: CGFloat = 45.0
    static let constraintView: CGFloat = 16
    static let buttonHeigth: Int = 60
    static let contentHeigth: CGFloat = 3
    static let iconsCount: Int = 40
}
