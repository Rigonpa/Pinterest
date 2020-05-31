//
//  PinterestViewController.swift
//  Pinterest
//
//  Created by Ricardo González Pacheco on 22/05/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

class PinterestViewController: UIViewController {
    
    let numberOfColumns: Int = 3
    let sectionInset: CGFloat = 16.0
    let minimumInteritemSpacing: CGFloat = 8.0
    
    lazy var initialFlowLayout: UICollectionViewFlowLayout = {
        let fl = UICollectionViewFlowLayout()
        fl.minimumInteritemSpacing = minimumInteritemSpacing
        fl.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        return fl
    }()
    
    lazy var customLayout: CustomLayout = {
        let cl = CustomLayout()
        cl.customDelegate = self
        return cl
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: initialFlowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.register(PinterestItem.self, forCellWithReuseIdentifier: PinterestItem.itemIdentifier)
        return cv
    }()
    
    lazy var changeLayoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Change layout", for: .normal)
        btn.backgroundColor = .systemPink
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(handleFlowChange), for: .touchUpInside)
        return btn
    }()
    
    let viewModel: PinterestViewModel
    init(viewModel: PinterestViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    var currentLayout: UICollectionViewLayout?
    
    override func viewDidLoad() {
        viewModel.viewWasLoaded()
        
        setupUI()
    }
    
    private func setupUI() {
        
        view.addSubview(collectionView)
        view.addSubview(changeLayoutButton)
        
        currentLayout = initialFlowLayout
//        collectionView.setCollectionViewLayout(initialFlowLayout, animated: true)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            changeLayoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            changeLayoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
        ])
    }
    
    @objc private func handleFlowChange() {
        currentLayout = currentLayout == initialFlowLayout ? customLayout : initialFlowLayout
        collectionView.setCollectionViewLayout(currentLayout!, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PinterestViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: PinterestItem.itemIdentifier, for: indexPath) as? PinterestItem else { fatalError() }
        let itemViewModel = viewModel.viewModel(indexPath: indexPath)
        item.viewModel = itemViewModel
        return item
    }
}

extension PinterestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (UIScreen.main.bounds.width - sectionInset*2 - minimumInteritemSpacing*(CGFloat(numberOfColumns) - 1)) / CGFloat(numberOfColumns)
        let imageCellViewModel = viewModel.viewModel(indexPath: indexPath)
        return CGSize(width: width, height: imageCellViewModel.height)
    }
}

extension PinterestViewController: PinterestViewDelegate {
    func onImagesLoaded() {
        self.collectionView.reloadData()
    }
}

extension PinterestViewController: CollectionCustomDelegate {
    func retrieveItemHeight(collectionView: UICollectionView, at indexPath: IndexPath) -> CGFloat {
        let imageCellViewModel = viewModel.viewModel(indexPath: indexPath)
        return imageCellViewModel.height
    }
}
