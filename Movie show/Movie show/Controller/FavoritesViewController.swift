//
//  FavoritesViewController.swift
//  Movie show
//
//  Created by MACBOOK on 22/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestore


class FavoritesViewController: UIViewController {
    
    
    let client = Service()
    let db = Firestore.firestore()
    
    var favsMoviesIds : [Int] = []
    var movies : [Movie] = []

    var isActiveButton:Bool = false
    
    @IBOutlet weak var uiTableView: UITableView!

    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.favsMoviesIds.removeAll()
//
//
//        fetchFavsFromFireStore()
//
//        uiTableView.delegate = self
//        uiTableView.dataSource = self
//        self.uiTableView.reloadData()
//
//
//        //         Do any additional setup after loading the view.
//
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        favsMoviesIds.removeAll()
        
        
        fetchFavsFromFireStore()
        uiTableView.delegate = self
        uiTableView.dataSource = self
        
        
        

//        self.uiTableView.reloadData()

    }
    
    
    
    
    
    func fetchFavsFromFireStore(){
        if let uid = Auth.auth().currentUser?.uid {
            
           let doc =  db.collection("Favorites").document(uid)
            doc.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                     let favsData = document.data() as? [String : [Int]] ?? [String: [Int]]()
                     self.favsMoviesIds =  favsData["favs"] ?? []
                     print(self.favsMoviesIds)
                    self.fetchMoviesFromApi()
                } else {
                    print("Document does not exist")
                }
            }
        
            
        }
    }
    
    
    func fetchMoviesFromApi(){
        movies = []
//        movies.removeAll()
        for movieID in favsMoviesIds {
            client.movieDetail(movieID: movieID) { (movieRes:Movie) in
                self.movies.append(movieRes)
                print(movieRes)
                DispatchQueue.main.async {
                    self.uiTableView.reloadData()
                }
            }
        }

    }
    
    
    @IBOutlet weak var editMovieDone: UIBarButtonItem!
    @IBAction func editMovies(_ sender: UIButton) {
        
        if isActiveButton {
               isActiveButton = false
            editMovieDone.title = "Edit"

            } else {
                isActiveButton = true
                editMovieDone.title = "Done"
            }
        
        

       
        if uiTableView.isEditing {
            uiTableView.isEditing = false
        } else {
            uiTableView.isEditing = true
        }
        
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

extension FavoritesViewController:UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as! FavoritesTableViewCell

        let movie = movies[indexPath.row]
        cell.movies = movie

        
        

        

        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard movies.count > indexPath.row else { return }
        let movie = movies[indexPath.row]
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "movieDetail") as? DetailViewController else {return}
        detailVC.movie = movie
        detailVC.movieID = movie.id
        self.showDetailViewController(detailVC, sender: self)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")

          self.movies.remove(at: indexPath.row)
        self.favsMoviesIds.remove(at: indexPath.row)
        let favsData = ["favs" : self.favsMoviesIds]
        self.saveFavsToFireStore(favsData: favsData)
        self.uiTableView.deleteRows(at: [indexPath], with: .automatic)
          
      }
    }
    
    
    func saveFavsToFireStore(favsData : [String : Any]) {
        
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("Favorites").document(uid).setData(favsData, merge: true,  completion: { error in
                
                if let error = error {
                    print(error)
                }
                
            })
        }
    }


}

