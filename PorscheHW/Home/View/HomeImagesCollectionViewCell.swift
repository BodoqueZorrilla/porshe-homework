//
//  HomeImagesCollectionViewCell.swift
//  PorscheHW
//
//  Created by Sergio Eduardo Zorilla Arellano on 16/10/23.
//

import UIKit

final class HomeImagesCollectionViewCell: UICollectionViewCell {
    lazy private var sectionImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        return img
    }()

    lazy private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .black.withAlphaComponent(0.5)
        return label
    }()

    lazy private var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis  = .vertical
        sv.alignment = .center
        sv.distribution = .fillProportionally
        sv.spacing = 5
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.layer.cornerRadius = 5
        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }

    private func addViews(){
        addSubview(stackView)
        
        stackView.addArrangedSubview(sectionImageView)
        stackView.addArrangedSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            sectionImageView.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 5),
            sectionImageView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -5),
            sectionImageView.heightAnchor.constraint(equalToConstant: 120),
            sectionImageView.widthAnchor.constraint(equalToConstant: 120),
            nameLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 5),
            nameLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -5),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var sectionImage: TopicsModel? {
        didSet {
            guard let sectionImage = sectionImage else {return}
            if let title = sectionImage.title {
                nameLabel.text = title
            }
            if let imagePath = sectionImage.coverPhoto.urls?.raw {
                DispatchQueue.global().async { [weak self] in
                    DispatchQueue.main.async {
                        self?.sectionImageView.loadImageUsingCache(withUrl: imagePath)
                    }
                }
            }
        }
    }
}


final class ContentCollectionViewHeader: UICollectionReusableView {
    let sectionNameLabel = UILabel()
        
    override func layoutSubviews() {
        super.layoutSubviews()
        sectionNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        sectionNameLabel.textColor = .black
        sectionNameLabel.sizeToFit()
        sectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sectionNameLabel)
        
        NSLayoutConstraint.activate([
            sectionNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            sectionNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
}
