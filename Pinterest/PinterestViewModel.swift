//
//  PinterestViewModel.swift
//  Pinterest
//
//  Created by Ricardo González Pacheco on 22/05/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

protocol PinterestViewDelegate {
    func onImagesLoaded()
}

class PinterestViewModel {
    
    var pinterestItemViewModels: [PinterestItemViewModel] = []
    var viewDelegate: PinterestViewDelegate?
    
    func viewWasLoaded() {
        
        for imageIndex in stride(from: 1, to: 86, by: 1) {
            let randomHeight = (50 ..< 200).randomElement() ?? 100
            guard let url = URL(string: "https://picsum.photos/id/\(imageIndex)/100/\(randomHeight)") else { continue }
            pinterestItemViewModels.append(PinterestItemViewModel(imageUrl: url, height: CGFloat(randomHeight)))
        }
        self.viewDelegate?.onImagesLoaded()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems() -> Int {
        return pinterestItemViewModels.count
    }
    
    func viewModel(indexPath: IndexPath) -> PinterestItemViewModel {
        return pinterestItemViewModels[indexPath.row]
    }
}
