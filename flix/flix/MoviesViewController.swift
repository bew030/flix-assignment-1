//
//  MoviesViewController.swift
//  flix
//
//  Created by Bernard Wong on 1/23/20.
//  Copyright © 2020 Bernard Wong. All rights reserved.
//

import UIKit


// this function runs immediately when a screen comes up
// added UITableViewDataSource and UITableViewDelegate so that viewcontroller can work with table view
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    // step 1: add in necessary items so viewcontroller can work with table view
    // step 2: input number of rows (tableView func1) and row information (tableView func2)
    // step 3: set the right references for tableview dataSource and tableview.delegate
    @IBOutlet weak var tableView: UITableView!
    
    // asking the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // getting value from movies, don't need to reference self.movies
        return movies.count
    }
    
    // for "this particular row" give me the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // dequeueReusuableCell ensures that you dont run out of memory by reusing cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! movieCell
        // !/? is a swift optional, meant to deal with values that aren't the proper type or are missing
        
        // getting value from movies, don't need to reference self.movies
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        cell.titleLabel?.text = "\(title)"
        cell.synopsisLabel?.text = "\(synopsis)"
        
        return cell
    }
    
    // creating an array of dictionaries
    // Syntax for dictionary - type of the key: type of the value
    // parentheses indicates that movies will be created
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // THIS IS STEP 3
        tableView.dataSource = self
        tableView.delegate = self
        
        // the url of the API
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        
        // sends a request to the server
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        // UNSURE: spend some time googling it
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        // UNSURE
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
            
            // dataDictionary is the json with all the data, this is trying to convert the data into strings
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

            // typecasts the array of dictionaries
            // FIGURE OUT WHAT THE ! following the as does (is it "not")
            self.movies = dataDictionary["results"] as! [[String:Any]]
            
            // YOU NEED TO HAVE THIS: tableView is loaded right when the viewcontroller loads up, so it won't update unless you tell it to update again
            self.tableView.reloadData()
            print(self.movies[0])
           }
        }
        task.resume()
    }
    

}
