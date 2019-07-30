//
//  TopHeadlinesCollectionViewCell.swift
//  NewYorkMagazineAPI
//
//  Created by Sihan Fang on 2019/2/21.
//  Copyright © 2019 Sihan Fang. All rights reserved.
//

import UIKit

class TopHeadlinesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topHeadlinesImageView: UIImageView! {
        didSet {
            topHeadlinesImageView.layer.cornerRadius = 10
            topHeadlinesImageView.clipsToBounds = true

        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gradientView: GradientView! {
        didSet {
            gradientView.layer.cornerRadius = 10
            gradientView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    func set(_ title: String?, _ image: UIImage? = nil) {
        self.topHeadlinesImageView.image = image
        self.titleLabel.text = title
        self.titleLabel.textColor = .white
    }
    
}
