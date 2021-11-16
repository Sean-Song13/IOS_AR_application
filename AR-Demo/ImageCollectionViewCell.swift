//
//  ImageCollectionViewCell.swift
//  AR-Demo
//
//  Created by xinhao.song on 2021/11/15.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = "ImageCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with image: UIImage){
        
        imageView.image = image
        imageView.layer.cornerRadius = 12
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    static func nib() -> UINib{
        return UINib(nibName: "ImageCollectionViewCell", bundle: nil)
    }

}
