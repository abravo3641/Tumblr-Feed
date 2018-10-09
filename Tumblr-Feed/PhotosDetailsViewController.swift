//
//  PhotosDetailsViewController.swift
//  Tumblr-Feed
//
//  Created by Anthony Bravo on 10/5/18.
//  Copyright © 2018 Anthony Bravo. All rights reserved.
//

import UIKit

class PhotosDetailsViewController: UIViewController {

    var url:String?
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = self.url {
            let urlLink = URL(string: url)!
            imgView.af_setImage(withURL: urlLink)
        }
    }

}
