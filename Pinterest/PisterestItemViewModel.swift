//
//  ItemViewModel.swift
//  Pinterest
//
//  Created by Ricardo González Pacheco on 22/05/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

protocol ItemViewDelegate {
    func onShowingImages()
}

class PinterestItemViewModel {
    
    var viewDelegate: ItemViewDelegate?
    var image: UIImage?
    var height: CGFloat
    
    init(imageUrl: URL, height: CGFloat) {

        self.height = height
        
        DispatchQueue.global(qos: .userInteractive).async {
            guard let imageData = try? Data(contentsOf: imageUrl),
                let image = UIImage(data: imageData) else { fatalError() }
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                self.image = image
                self.viewDelegate?.onShowingImages()
            }
        }
    }
}
