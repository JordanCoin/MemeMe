//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Jordan Jackson on 10/24/17.
//  Copyright © 2017 Jordan Jackson. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var selectedMeme: Meme!

    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memeImageView.image = selectedMeme.memeImage
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(unwindController))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func unwindController() {
       navigationController?.popToRootViewController(animated: true)
    }
    
}
