//
//  ResultsDisplayCollectionViewCell.swift
//  FlickrFinder
//
//  Created by ilya Ramanenia on 24.07.21.
//

import UIKit
import Reusable

class ResultsDisplayCollectionViewCell: UICollectionViewCell, Reusable {
    
    var loadedForIndexPath: IndexPath?
    
    
    // MARK: - Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var noImageLabel: UILabel!
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
