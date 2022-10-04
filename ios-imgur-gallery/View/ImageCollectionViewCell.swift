//
//  ImageCollectionViewCell.swift
//  ios-imgur-gallery
//
//  Created by Gustavo Ziger on 01/10/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageCollectionViewCell"
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func loadFrom(_ url: String) {
        Task {
            let loadedData = await NetworkManager.shared.fetchImageDataFromUrl(url)
            if let loadedImage = UIImage(data: loadedData) {
                self.imageView.image = loadedImage
            }
        }
    }
}
