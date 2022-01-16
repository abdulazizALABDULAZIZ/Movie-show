//
//  FavoritesTableViewCell.swift
//  Movie show
//
//  Created by MACBOOK on 02/06/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestore


class FavoritesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    
    let client = Service()
    let db = Firestore.firestore()
    
    var favsMoviesIds:[Int] = []

    var movies: Movie? {
        didSet {
        updateViews()
        }
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        guard let movie = movies else { return }
        DispatchQueue.main.async {
            self.movieTitle.text = movie.title
//            movie.release_date?.convertDateString()
        }
        // set poster image
        if let posterPath = movies?.poster_path {
            let _ = client.taskForGETImage(ImageKeys.PosterSizes.DETAIL_POSTER, filePath: posterPath, completionHandlerForImage: { (imageData, error) in
                if let image = UIImage(data: imageData!) {
                    print(image)
                    
                    DispatchQueue.main.async {
                        self.movieImage.image = image
                        
                    }
                }
            })
        } else {
            print("Unable to load search results.")
        }
    }

}
