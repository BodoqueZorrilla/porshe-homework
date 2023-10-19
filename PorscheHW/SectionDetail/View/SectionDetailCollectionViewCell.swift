//
//  SectionDetailCollectionViewCell.swift
//  PorscheHW
//
//  Created by Sergio Eduardo Zorilla Arellano on 18/10/23.
//

import UIKit

final class SectionDetailCollectionViewCell: UICollectionViewCell {
    private let sectionImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 5
        img.layer.masksToBounds = true
        return img
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sectionImageView)
        addViews()
    }

    private func addViews(){
        NSLayoutConstraint.activate([
            sectionImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            sectionImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            sectionImageView.heightAnchor.constraint(equalToConstant: 90),
            sectionImageView.widthAnchor.constraint(equalToConstant: 90)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var sectionImage: CollectionModel? {
        didSet {
            guard let sectionImage = sectionImage else { return }
            if let imagePath = sectionImage.urls?.small {
                DispatchQueue.global().async { [weak self] in
                    DispatchQueue.main.async {
                        self?.sectionImageView.loadImageUsingCache(withUrl: imagePath)
                    }
                }
            }
        }
    }
}
