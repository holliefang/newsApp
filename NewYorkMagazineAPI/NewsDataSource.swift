//
//  NewsDataSource.swift
//  NewYorkMagazineAPI
//
//  Created by Hollie Fang on 2019/10/3.
//  Copyright © 2019 Sihan Fang. All rights reserved.
//

import UIKit

protocol NewsDataSource {
    var title: String {get}
    var date: String {get}
    var author: String {get}
    var image: UIImage {get}
    func onNewsTapped(navigationController: UINavigationController?)
}
