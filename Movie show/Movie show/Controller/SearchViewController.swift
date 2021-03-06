//
//  SearchViewController.swift
//  Movie show
//
//  Created by MACBOOK on 20/05/1443 AH.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchController: UISearchBar!
    
    // MARK: - Properties
    var movies: [Movie] = []
    let client = Service()
    var cancelRequest: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.movies.removeAll()
        searchController.delegate = self
        
        self.setupToHideKeyboardOnTapOnView()

        
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
//    / Searches movies after selecting Search on bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text ?? ""
        
        Service.fetchMovie(with: searchTerm) { (movies) in
            guard let fetchedMovies = movies else { return }
            self.movies = fetchedMovies
            DispatchQueue.main.async {
                
                self.searchTableView.reloadData()
                searchBar.text = nil
            }
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as!SearchResultsCell
        let movie = movies[indexPath.row]
        cell.movie = movie
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard movies.count > indexPath.row else { return }
        let movie = movies[indexPath.row]
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "movieDetail") as? DetailViewController else { return }
        detailVC.movie = movie
        detailVC.movieID = movie.id
        self.showDetailViewController(detailVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }

    
    

   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// dismiss Keyboard for search Bar

extension UIViewController {
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboards() {
        view.endEditing(true)
    }
}

