//
//  GifCollectionViewCell.swift
//  AR-Demo
//
//  Created by xinhao.song on 2021/11/15.
//

import UIKit
import Gifu

class GifCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gifImageView: GIFImageView!
    
    static let identifier = "GifCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // lzy test556
    }
    
    public func configure(with gifName: String){
        
        gifImageView.animate(withGIFNamed: gifName)
        gifImageView.layer.cornerRadius = 12
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gifImageView.frame = contentView.bounds
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "GifCollectionViewCell", bundle: nil)
    }

}
