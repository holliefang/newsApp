//
//  SearchResultTableViewCell.swift
//  NewYorkMagazineAPI
//
//  Created by Sihan Fang on 2019/2/12.
//  Copyright © 2019 Sihan Fang. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var searchImage: UIImageView!
    
    func set(title: String, author: String, date: String, image: UIImage) {
        
        titleLabel.text = title
        authorLabel.text = author
        timeLabel.text = date
        searchImage.image = image
    }
}
