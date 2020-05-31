//
//  PinterestItem.swift
//  Pinterest
//
//  Created by Ricardo González Pacheco on 22/05/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

class PinterestItem: UICollectionViewCell {
    static var itemIdentifier: String = String(describing: PinterestItem.self)
    
    lazy var myImageView: UIImageView = {
        let iv = UIImageView(frame: .zero)
//        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var viewModel: PinterestItemViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            myImageView.image = viewModel.image
            viewModel.viewDelegate = self
            
            contentView.backgroundColor = .black
            contentView.layer.cornerRadius = 8
            contentView.layer.masksToBounds = true
            
            contentView.addSubview(myImageView)
            
            NSLayoutConstraint.activate([
                myImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                myImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                myImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                myImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
    }
}

extension PinterestItem: ItemViewDelegate {
    func onShowingImages() {
        guard let viewModel = viewModel else { return }
        myImageView.image = viewModel.image
        setNeedsLayout()
    }
}
