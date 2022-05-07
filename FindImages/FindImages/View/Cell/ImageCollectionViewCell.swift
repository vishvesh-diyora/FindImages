//
//  ImageCollectionViewCell.swift
//  FindImages
//
//  Created by admin on 07/05/22.
//

import UIKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoHeight: NSLayoutConstraint!
    @IBOutlet weak var photoWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Below line solved my problem
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func configureCell(_ photo: Photos) {
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        photoImageView.sd_setImage(with: URL(string: photo.src?.medium ?? ""))
    }
}
