//
//  PhotosViewController.swift
//  Tumblr-Feed
//
//  Created by Anthony Bravo on 9/29/18.
//  Copyright © 2018 Anthony Bravo. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var posts: [[String: Any]] = [] //Holds dictionary of photos

    
    override func viewDidLoad() {
        activityIndicator.startAnimating() //Display middle spinning circle
        super.viewDidLoad()
        
        //Creating refresh control: top spining circle when pulled down
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PhotosViewController.pulledRefresh(_:)), for: .valueChanged)
        //Notifies the view controlller when pulled down and calls pulledRefresh method to tell it what to do
        //Note that withing the pulled refresh method the object refresh control gets passed in
        tableView.insertSubview(refreshControl, at: 0)
        //Puts the spinning circle at the top of the screen, row 0
        
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = 255 //Adjust the height of each cell
        fetchPosts()

    }
    
    @objc func pulledRefresh(_ refreshControl:UIRefreshControl) {
        fetchPosts() //Get movie data
        refreshControl.endRefreshing()
        //After data is obtained, stop top spinning circle
    }
    
    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                self.tableView.reloadData()
                
                self.activityIndicator.stopAnimating()
            }
        }
        task.resume()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        let post = posts[indexPath.row] //A single dictionary at index indexPath.row from the array dictionary
        
        //Checking that photos is not nil
        if let photos = post["photos"] as? [[String:Any]] {
            //Photos is not nil, we are safe to use it
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String:Any]
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString)!
            cell.postImage.af_setImage(withURL: url)
        }
        
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DetailsVC = segue.destination as! PhotosDetailsViewController
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let post = posts[indexPath.row]
        
        
        if let photos = post["photos"] as? [[String:Any]] {
            //Photos is not nil, we are safe to use it
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String:Any]
            let urlString = originalSize["url"] as! String
            DetailsVC.url = urlString
        }
        
    }
    
    
    //Removes gray region of selected cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
