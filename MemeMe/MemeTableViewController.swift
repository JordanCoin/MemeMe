//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Jordan Jackson on 10/24/17.
//  Copyright © 2017 Jordan Jackson. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]!

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    @IBAction func newMeme(_ sender: Any) {
        let newMemeViewController = storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        present(newMemeViewController, animated: true, completion: nil)
    }
    
    @IBAction func unwindMemeEditor(segue: UIStoryboardSegue) {
        tableView!.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MemeCollection.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTable", for: indexPath) as! MemeTableViewCell
        let meme = MemeCollection.totalMemes[indexPath.row]
        cell.memeImageView.image = meme.memeImage
        cell.memeTextLabel.text = "\(meme.topText)...\(meme.bottomText)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.selectedMeme = MemeCollection.totalMemes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }

}
