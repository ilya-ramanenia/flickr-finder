//
//  ResultsDisplayVC.swift
//  FlickrFinder
//
//  Created by ilya Ramanenia on 17.07.21.
//

import UIKit

/// Displays image results in collection view with Waterfall layout

final class ResultsDisplayVC: UIViewController {
    
    // MARK: - Private
    
    private enum Const {
        static let searchVCSegueIdentifier = "searchVCSegueIdentifier"
        static let noImageSize: CGSize = .init(width: 100, height: 100)
    }
    
    private var presenter: ResultsDisplayPresenter = ResultsDisplayPresenterImpl()
    private var cachedImageSizes: [IndexPath: CGSize] = [:]
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    @IBOutlet weak var nothingFoundLabel: UILabel!
    
    
    // MARK: - Main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsCollectionView.collectionViewLayout = CollectionViewWaterfallLayout()
        
        presenter.loadedViewDelegate(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchVC {
            searchVC.presenter.setSearchDelegate(presenter)
            presenter.setPaginationDelegate(searchVC.presenter)
        }
    }
    
    
    // MARK: - Actions
    @IBAction func resultsAreaDidTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(false)
    }
}


extension ResultsDisplayVC: ResultsDisplayViewDelegate {
    
    func searchResultsUpdated(resetExisting: Bool) {
        nothingFoundLabel.isHidden = presenter.searchResultsCount() != 0
        
        resultsCollectionView.reloadSections([0])
        if resetExisting {
            cachedImageSizes = [:]
        }
    }
}


import CollectionViewWaterfallLayout
extension ResultsDisplayVC: CollectionViewWaterfallLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        cachedImageSizes[indexPath as IndexPath] ??
            .init(width: collectionView.frame.size.width / 2,
                  height: collectionView.frame.size.height)
    }
}


extension ResultsDisplayVC: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int { presenter.searchResultsCount() }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ResultsDisplayCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
            // To prevent async load wrong images in dequeued cells
            cell.loadedForIndexPath = indexPath
            
            presenter.imageForSearchResult(index: indexPath.row) { [weak self] image in
                guard indexPath == cell.loadedForIndexPath else { return }
                
                cell.imageView.image = image
                cell.noImageLabel.isHidden = image != nil
                let imageSize = image?.size ?? Const.noImageSize
                
                if self?.cachedImageSizes[indexPath] != imageSize {
                    self?.cachedImageSizes[indexPath] = imageSize
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                        collectionView.collectionViewLayout.invalidateLayout()
                    }
                }
            }
        
        return cell
    }
}
