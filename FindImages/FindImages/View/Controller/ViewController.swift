//
//  ViewController.swift
//  FindImages
//
//  Created by admin on 07/05/22.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var searchTextField: UISearchBar!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var minColumns: UILabel!
    @IBOutlet weak var maxColumns: UILabel!
    @IBOutlet weak var columnSlider: UISlider!
    
    //MARK: variables
    var columnsRange = 2...5
    var columnCount = 2 {
        didSet {
            let spacing = ((10 * (columnCount - 1)) + 21)
            self.size = (UIScreen.main.bounds.width - CGFloat(spacing)) / CGFloat(columnCount)
            self.imagesCollectionView.reloadData()
        }
    }
    var size: CGFloat = 0.0
    var photos : [Photos] = []
    var page = 0
    var isNextAvailable = true
    
    //MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    func setUI() {
        self.columnCount = 2// default set
        self.searchTextField.delegate = self
        self.minColumns.text = "\(columnsRange.lowerBound)"
        self.maxColumns.text = "\(columnsRange.upperBound)"
        self.columnSlider.minimumValue = Float(columnsRange.lowerBound)
        self.columnSlider.maximumValue = Float(columnsRange.upperBound)
        self.columnSlider.setValue(Float(columnCount), animated: true)
        self.columnSlider.addTarget(self, action: #selector(self.didChangeSliderValue), for: .valueChanged)
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
        self.imagesCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.imagesCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }
    
    func getImages() {
        self.page += 1
        let searchText = (searchTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if searchText != "" {
            ImagesViewModel.shared.getImagesApiCall(page: page,search: searchText,completion: { data in
                if self.page == 1 {
                    self.photos = data?.photos ?? []
                    if data?.photos?.count == 0 {
                        self.noDataAlert()
                    }
                } else {
                    self.photos.append(contentsOf: data?.photos ?? [])
                }
                RealmManager.shared.savePhotoList(terms: searchText, results: self.photos, lastPage: self.page)
                self.isNextAvailable = !(data?.photos?.count == 0)
                self.imagesCollectionView.reloadData()
            })
        } else {
            self.photos = []
            RealmManager.shared.savePhotoList(terms: searchText, results: self.photos, lastPage: self.page)
            self.imagesCollectionView.reloadData()
        }
    }
    
    @objc func didChangeSliderValue() {
        let newValue = (self.columnSlider.value / Float(1)).rounded() * Float(1)
        self.columnSlider.setValue(newValue, animated: false)
        self.columnCount = Int(Double(self.columnSlider.value))
    }
    
    func noDataAlert() {
        let alert = UIAlertController(title: "No Data Found.", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
}

//MARK: CollectionView Delegate and DataSource Methods
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let data = self.photos[indexPath.row]
        cell.configureCell(data)
        cell.photoHeight.constant = size
        cell.photoWidth.constant = size
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == self.photos.count - 1) && self.isNextAvailable {
            self.getImages()
        }
    }
}

//MARK: CollectionView Flow layout Delegate Methods
extension ViewController:  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: size, height: size)
    }
}

//MARK: SearchBar Delegate Methods
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchImage()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchImage()
    }
    
    func searchImage() {
        let searchText = (searchTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        self.photos = RealmManager.shared.getPhotoList(terms: searchText)
        self.imagesCollectionView.reloadData()
        self.searchTextField.resignFirstResponder()
        if NetworkManager.isConnectedToNetwork() {
            self.page = 0
        } else {
            self.page = RealmManager.shared.getLastPage(terms: searchText)
        }
        self.isNextAvailable = false
        self.getImages()
    }
}
