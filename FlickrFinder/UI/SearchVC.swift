//
//  SearchVC.swift
//  FlickrFinder
//
//  Created by ilya Ramanenia on 24.07.21.
//

import UIKit

/// Provides search input and history

final class SearchVC: UIViewController {
    
    var presenter: SearchPresenter = SearchPresenterImpl()
    
    
    // MARK: - Private
    
    private var isSearchInputEnabled: Bool = true
    
    
    // MARK: - Outlets
    
    @IBOutlet private weak var searchTextField: UITextField!
    // TODO: Use predictive keyboard input option
    @IBOutlet private weak var historyStackView: UIStackView!
    @IBOutlet private weak var searchContainerView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.loadedViewDelegate(self)
    }
    
    private func resetHistoryViews(results: [String]) {
        UIView.animate(withDuration: 0.3) { [self] in
            historyStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            for result in results {
                let historyLabel = UILabel()
                historyLabel.text = result
                historyLabel.font = .systemFont(ofSize: 14)
                historyLabel.textAlignment = .center
                historyLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(historyResultTapped(sender:)))
                historyLabel.addGestureRecognizer(tapRecognizer)
                historyLabel.isUserInteractionEnabled = true
                historyLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
                
                historyStackView.addArrangedSubview(historyLabel)
            }
        }
    }
    
    
    // MARK: - Actions
    
    @objc private func historyResultTapped(sender: UITapGestureRecognizer) {
        guard let tappedLabel = sender.view as? UILabel,
              let tappedHistoryString = tappedLabel.text else { return }
        
        searchTextField.text = tappedHistoryString
        presenter.queryChanged(tappedHistoryString)
    }
}


extension SearchVC: SearchPresenterViewDelegate {
    
    func searchStarted() {
        searchContainerView.alpha = 0
        activityIndicator.startAnimating()
        isSearchInputEnabled = false
    }
    
    func searchFinished() {
        UIView.animate(withDuration: 0.3) { [self] in
            searchContainerView.alpha = 1
        }
        activityIndicator.stopAnimating()
        isSearchInputEnabled = true
    }
    
    func historyUpdated(results: [String]) {
        resetHistoryViews(results: results)
    }
}


extension SearchVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard isSearchInputEnabled else { return false }
        
        let text = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        
        presenter.queryChanged(resultString)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.queryChangeEnded()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(false)
        return true
    }
}
