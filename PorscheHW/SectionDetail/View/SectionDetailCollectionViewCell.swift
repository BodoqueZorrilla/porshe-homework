//
//  SectionDetailCollectionViewCell.swift
//  PorscheHW
//
//  Created by Sergio Eduardo Zorilla Arellano on 18/10/23.
//

import UIKit

final class SectionDetailCollectionViewCell: UICollectionViewCell {
    
    let sectionImageView: UIImageView = {
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

    func addViews(){
        NSLayoutConstraint.activate([
            sectionImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            sectionImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            sectionImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            sectionImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            sectionImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height),
            sectionImageView.widthAnchor.constraint(equalToConstant: contentView.frame.width)
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
