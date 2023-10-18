//
//  HomeViewController.swift
//  PorscheHW
//
//  Created by Sergio Eduardo Zorilla Arellano on 16/10/23.
//

import UIKit

final class HomeViewController: UIViewController {
    
    lazy private var mainImagesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        return collectionView
    }()

    lazy private var luckyiImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        return img
    }()

    lazy private var luckyiBack: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        return img
    }()

    lazy private var randomImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Luck", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private var viewModel = HomeViewModel()
    private var showingBack = false
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        Task {
            await viewModel.fetchMainImages()
            self.mainImagesCollectionView.reloadData()
            if viewModel.topics?.count ?? 0 < 1 {
                DispatchQueue.main.async {
                    Tools.showAlert(title: "It done",
                                    message: "you reached your limit of 50 requests per hour 😥", titleForTheAction: "Ok",
                                    in: self,
                                    titleForCancelAction: "") {}
                }
            }
        }
        self.view.backgroundColor = .white
        taskGetRandomImege()
        mainImagesCollectionView.dataSource = self
        mainImagesCollectionView.delegate = self
    }

    private func taskGetRandomImege() {
        Task {
            if showingBack {
                await viewModel.loadLuckyImage()
                if let imagePath = self.viewModel.lucky?.urls?.small {
                    self.luckyiImageView.loadImageUsingCache(withUrl: imagePath)
                }
            } else {
                await viewModel.loadLuckyImage()
                if let imagePath = viewModel.lucky?.urls?.small {
                    self.luckyiBack.loadImageUsingCache(withUrl: imagePath)
                }
            }
            if self.viewModel.lucky?.urls?.small.count ?? 0 < 1 {
                DispatchQueue.main.async {
                    Tools.showAlert(title: "It done",
                                    message: "you reached your limit of 50 requests per hour 😥", titleForTheAction: "Ok",
                                    in: self,
                                    titleForCancelAction: "") {}
                }
            }
        }
    }

    private func setupUI() {
        mainImagesCollectionView.backgroundColor = .white
        mainImagesCollectionView.register(HomeImagesCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        mainImagesCollectionView.register(ContentCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "cellHeader")
        mainImagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainImagesCollectionView)
        view.addSubview(randomImageButton)
        randomImageButton.addTarget(self, action: #selector(getLuck), for: .touchUpInside)
        cardView.addSubview(luckyiBack)
        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            mainImagesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainImagesCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mainImagesCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            mainImagesCollectionView.heightAnchor.constraint(equalToConstant: view.frame.height / HomeConstants.mainImageHeigth),
            randomImageButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: HomeConstants.constraintView),
            randomImageButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -HomeConstants.constraintView),
            randomImageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -HomeConstants.constraintView),
            randomImageButton.heightAnchor.constraint(equalToConstant: HomeConstants.buttonHeigth)
        ])
        mainImagesCollectionView.contentInset.bottom = view.safeAreaInsets.bottom
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        mainImagesCollectionView.collectionViewLayout = layout()
        addLuckyImage()
        
    }

    private func layout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionNumber, environment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            return self.createBasicTypeSection()
        }
    }

    private func createBasicTypeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.90))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }

    private func addLuckyImage() {
        if showingBack {
            NSLayoutConstraint.activate([
                luckyiImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
                luckyiImageView.leftAnchor.constraint(equalTo: cardView.leftAnchor),
                luckyiImageView.rightAnchor.constraint(equalTo: cardView.rightAnchor),
                luckyiImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                luckyiBack.topAnchor.constraint(equalTo: cardView.topAnchor),
                luckyiBack.leftAnchor.constraint(equalTo: cardView.leftAnchor),
                luckyiBack.rightAnchor.constraint(equalTo: cardView.rightAnchor),
                luckyiBack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
            ])
        }
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: mainImagesCollectionView.bottomAnchor, constant: HomeConstants.constraintView),
            cardView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: HomeConstants.constraintView),
            cardView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -HomeConstants.constraintView),
            cardView.heightAnchor.constraint(equalToConstant: view.frame.height / HomeConstants.randomImageHeight)
        ])
    }

    @objc private func getLuck() {
        var showingSide = luckyiBack
        var hiddenSide = luckyiImageView
        if showingBack {
            (showingSide, hiddenSide) = (luckyiImageView, luckyiBack)
        }
        
        UIView.transition(from: showingSide,
                          to: hiddenSide,
                          duration: 0.7,
                          options: UIView.AnimationOptions.transitionFlipFromRight) { _ in
            self.taskGetRandomImege()
            self.addLuckyImage()
        }
        showingBack = !showingBack
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.topics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell",
                                                        for: indexPath) as? HomeImagesCollectionViewCell
        myCell?.sectionImage = viewModel.topics?[indexPath.row]
        return myCell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionDetailViewModel = SectionDetailViewModel(title: viewModel.topics?[indexPath.row].title ?? "",
                                                            idCollection: viewModel.topics?[indexPath.row].slug ?? "")
        let sectionDetailVC = SectionDetailViewController()
        sectionDetailVC.viewModel = sectionDetailViewModel
        self.show(sectionDetailVC, sender: nil)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "cellHeader",
                                                                             for: indexPath) as? ContentCollectionViewHeader
            headerView?.sectionNameLabel.text = "Collections"
            return headerView ?? UICollectionViewCell()
        }
        return UICollectionReusableView()
    }
}

