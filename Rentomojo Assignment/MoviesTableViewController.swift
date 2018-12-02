//
//  MoviesTableViewController.swift
//  Rentomojo Assignment
//
//  Created by Hament on 01/12/18.
//  Copyright © 2018 Hament. All rights reserved.
//

import UIKit

let baseURL = "https://api.themoviedb.org/3/";
let apiKey = "185872b49c5309a58e341e37c882a614";

class MoviesTableViewController: UITableViewController {
    var movies:MovieModel?
    var genreDict:[Int:String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 135
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        
        if ((UserDefaults.standard.object(forKey: "GenreDict")) != nil) {
            
            let data = UserDefaults.standard.object(forKey: "GenreDict") as! Data
            genreDict = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [Int:String]
            self.fetchMovieData()
            
        }else{
            self.fetchGenre()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.movies?.results?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        guard let movieDetails = movies?.results?[indexPath.row] else {
            return movieTableViewCell;
        }
        movieTableViewCell.setData(movieDetails: movieDetails, genreDict: genreDict)
        return movieTableViewCell
    }
    
    //MARK: - API Calls and Parsing
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetails = movies?.results?[indexPath.row];
        movieDetails!.isExpended = !(movieDetails!.isExpended ?? false)
        self.tableView.reloadRows(at: [indexPath], with: .automatic);
    }
    
    func parseGenreDict(genreDict: [String:Any]) {
        guard let genreArr = genreDict["genres"] as? Array<[String:Any]> else {
            return;
        }
        var genreDict = Dictionary<Int, String>()
        
        for dict in genreArr {
            genreDict[dict["id"] as! Int] = dict["name"] as? String;
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: genreDict)
        UserDefaults.standard.set(data, forKey:"GenreDict")
        self.genreDict = genreDict;
        
        self.fetchMovieData()
    }
    
    func fetchGenre() {
        
        URLSession.shared.dataTask(with: URL(string: String(format:"%@genre/movie/list?api_key=%@", baseURL, apiKey))!) { (data, response, error) in
            if (error != nil) {
                return;
            }
            do{
                guard let genreDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] else{
                    return;
                }
                self.parseGenreDict(genreDict: genreDict);
            }
            catch {
                print("json error: \(error)")
            }
            }.resume()
    }
    
    func fetchMovieData() {
        
        URLSession.shared.dataTask(with: URL(string: String(format:"%@movie/popular?api_key=%@", baseURL, apiKey))!)
        { (data, response, error) in
            if (error != nil) {
                
                return;
            }
            do{
                let decoder = JSONDecoder()
                let movies = try decoder.decode(MovieModel.self, from: data!)
                self.movies = movies;
                DispatchQueue.main.async {
                    self.tableView.reloadData();
                }
            }
            catch {
                print("json error: \(error)")
            }
            }.resume()
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

