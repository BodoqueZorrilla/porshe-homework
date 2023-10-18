//
//  SectionDetailViewController.swift
//  PorscheHW
//
//  Created by Sergio Eduardo Zorilla Arellano on 17/10/23.
//

import UIKit

final class SectionDetailViewController: UIViewController {
    
    var viewModel: SectionDetailViewModel?
    private var isLoading = false
    private var currentPage = 1

    lazy private var myCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await viewModel?.fetchCollectionImages()
            self.myCollectionView.reloadData()
            if self.viewModel?.collectionDetail?.count ?? 0 < 1 {
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
    
    private func loadData() {
        if !self.isLoading {
            self.isLoading = true
            Task {
                await self.viewModel?.addMoreImages(page: currentPage)
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        self.myCollectionView.reloadData()
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    private func setupUI() {
        myCollectionView.register(SectionDetailCollectionViewCell.self, forCellWithReuseIdentifier: "sectionDetailCell")
        myCollectionView.backgroundColor = .white
        view.backgroundColor = .white
        self.title = viewModel?.titleSection
        view.addSubview(myCollectionView)
        
        NSLayoutConstraint.activate([
            myCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            myCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            myCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.contentInsetAdjustmentBehavior = .never
        myCollectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let inset: CGFloat = 3
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1))
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize, subitems: [smallItem])
        
        let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupSize, subitems: [largeItem, nestedGroup, nestedGroup])
        
        let section = NSCollectionLayoutSection(group: outerGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension SectionDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.collectionDetail?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionDetailCell",
                                                        for: indexPath) as? SectionDetailCollectionViewCell
        myCell?.sectionImage = viewModel?.collectionDetail?[indexPath.row]
        return myCell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (viewModel?.collectionDetail?.count ?? 0) - 5 && !self.isLoading {
            loadData()
            currentPage += 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoDetailViewModel = PhotoDetailViewModel(idPhoto: viewModel?.collectionDetail?[indexPath.row].id ?? "")
        let photoDetailVC = PhotoDetailViewController()
        photoDetailVC.photoDetailViewModel = photoDetailViewModel
        self.show(photoDetailVC, sender: nil)
    }
}

