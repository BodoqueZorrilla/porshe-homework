//
//  PhotoDetailViewController.swift
//  PorscheHW
//
//  Created by Sergio Eduardo Zorilla Arellano on 18/10/23.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    var photoDetailViewModel: PhotoDetailViewModel?

    lazy private var photoImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()

    lazy private var imageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.italicSystemFont(ofSize: PhotoDetailConstants.fontDescriptionSize)
        return label
    }()

    lazy private var contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis  = .horizontal
        sv.alignment = .center
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    lazy private var likesView: UIStackView = {
        let sv = UIStackView()
        sv.axis  = .vertical
        sv.alignment = .center
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    lazy private var likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: PhotoDetailConstants.fontCountsSize)
        return label
    }()

    lazy private var likesImages: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.tintColor = .black
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()

    lazy private var downloadsView: UIStackView = {
        let sv = UIStackView()
        sv.axis  = .vertical
        sv.alignment = .center
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy private var downloadLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: PhotoDetailConstants.fontCountsSize)
        return label
    }()

    lazy private var downloadImages: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.tintColor = .black
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy private var shareButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .black
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await photoDetailViewModel?.fetchImageData()
            guard let photo =  photoDetailViewModel?.photoData else { return }
            self.title = photo.id ?? ""
            self.imageDescriptionLabel.text = photo.description ?? photo.altDescription ?? ""
            if let imagePath = photo.urls?.small {
                DispatchQueue.main.async {
                    self.photoImageView.loadImageUsingCache(withUrl: imagePath)
                    self.likesLabel.text =  "\(self.photoDetailViewModel?.photoData?.likes ?? 0)"
                    self.downloadLabel.text =  "\(self.photoDetailViewModel?.photoData?.downloads ?? 0)"
                }
            }
            if self.photoDetailViewModel?.photoData?.id?.count ?? 0 < 1 {
                DispatchQueue.main.async {
                    Tools.showAlert(title: "It done",
                                    message: "you reached your limit of 50 requests per hour 😥", titleForTheAction: "Ok",
                                    in: self,
                                    titleForCancelAction: "") {}
                }
            }
        }
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(photoImageView)
        view.addSubview(imageDescriptionLabel)
        view.addSubview(contentStackView)
        
        likesView.addArrangedSubview(likesLabel)
        likesImages.image = UIImage(systemName: "hand.thumbsup",
                                    withConfiguration: photoDetailViewModel?.returnIconSize(size: PhotoDetailConstants.iconsCount))
        likesView.addArrangedSubview(likesImages)

        downloadsView.addArrangedSubview(downloadLabel)
        downloadImages.image = UIImage(systemName: "arrow.down.circle",
                                       withConfiguration: photoDetailViewModel?.returnIconSize(size: PhotoDetailConstants.iconsCount))
        downloadsView.addArrangedSubview(downloadImages)

        contentStackView.addArrangedSubview(likesView)
        contentStackView.addArrangedSubview(downloadsView)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up.circle",
                                     withConfiguration: photoDetailViewModel?.returnIconSize(size: PhotoDetailConstants.buttonHeigth)),
                             for: .normal)
        view.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: PhotoDetailConstants.constraintView),
            photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -PhotoDetailConstants.constraintView),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: PhotoDetailConstants.constraintView),
            photoImageView.heightAnchor.constraint(equalToConstant: view.frame.height / PhotoDetailConstants.contentHeigth),
            imageDescriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: PhotoDetailConstants.constraintView),
            imageDescriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -PhotoDetailConstants.constraintView),
            imageDescriptionLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            
            contentStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: PhotoDetailConstants.constraintView),
            contentStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -PhotoDetailConstants.constraintView),
            contentStackView.topAnchor.constraint(equalTo: imageDescriptionLabel.bottomAnchor),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -PhotoDetailConstants.constraintView)
        ])
        shareButton.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
    }

    @objc private func shareImage() {
        guard let image = photoImageView.image,
              let url = URL(string: photoDetailViewModel?.photoData?.urls?.small ?? "") else { return }
        let sharedVC = UIActivityViewController(activityItems: [image, url], applicationActivities: nil)
        DispatchQueue.main.async {
            self.present(sharedVC, animated: true)
        }
    }
}
