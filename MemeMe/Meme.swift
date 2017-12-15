//
//  Meme.swift
//  MemeMe
//
//  Created by Jordan Jackson on 10/14/17.
//  Copyright © 2017 Jordan Jackson. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText = ""
    var bottomText = ""
    var orignialImage: UIImage!
    var memeImage: UIImage!
}

struct MemeCollection {
    
    static var totalMemes: [Meme] {
        return storage().memes
    }
    
    static func update(atIndex index: Int, withMeme meme: Meme) {
        storage().memes[index] = meme
    }
    
    static func add(meme: Meme) {
        storage().memes.append(meme)
    }
    
    static func count() -> Int {
        return storage().memes.count
    }
    
    static func storage() -> AppDelegate {
        let object = UIApplication.shared.delegate
        return object as! AppDelegate
    }
    
}


