//
//  NYMTableViewCell.swift
//  NewYorkMagazineAPI
//
//  Created by Sihan Fang on 2019/1/23.
//  Copyright © 2019 Sihan Fang. All rights reserved.
//

import UIKit

class HeadlinesViewCell: UITableViewCell {
    
    static let cellID = "Headlines Cell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    func configure(dataSource delegate: NewsDataSource) {
        self.titleLabel.text = delegate.title
        self.dateLabel.text = delegate.date
        self.newsImageView.image = delegate.image
    }
    
    

}


