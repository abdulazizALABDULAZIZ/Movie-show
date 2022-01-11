//
//  UpComingRow.swift
//  Movie show
//
//  Created by MACBOOK on 20/05/1443 AH.
//

import UIKit

class UpcomingRow: UITableViewCell {

    
    let client = Service()
    var movies: [Movie] = []
    var cancelRequest: Bool = false
    var movie: Movie!
    var timer :Timer?
    var currentCellIndex = 0
    
    @IBOutlet weak var upcomingCollectionView: UICollectionView!

    
    override func awakeFromNib() {
        loadUpcomingData()
        startTimer()

    }
    //
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 3, target: self , selector: #selector(moveToNextItem) , userInfo: nil, repeats: true)

    }

    @objc func moveToNextItem(){



        let lastItem = upcomingCollectionView.indexPathsForVisibleItems.last
        let currentItem = IndexPath(item: lastItem?.item ?? movies.count, section: 0)
        upcomingCollectionView.scrollToItem(at: currentItem, at: .right, animated: true)
        var nextItem = currentItem.item + 1

        if nextItem == movies.count
        {

            nextItem = 0
        }
        let nextIndexPath = IndexPath(item: nextItem, section: 0)
        upcomingCollectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)




//        upcomingCollectionView.scrollToItem(at: IndexPath(item: movies.count, section:0), at: .centeredHorizontally, animated: true)


    }

    
    
    
    private func loadUpcomingData(onPage page: Int = 1) {
        
        guard !cancelRequest else { return }
        
        let _ = client.taskForGETMethod(Methods.UPCOMING, parameters: [ParameterKeys.PAGE: page as AnyObject, ParameterKeys.REGION: "US" as AnyObject]) { (data, error) in
            if error == nil, let jsonData = data {
                
                let result = MovieResults.decode(jsonData: jsonData)
                
                if let movieResults = result?.results {
                    self.movies += movieResults
                    
                    DispatchQueue.main.async {
                        self.upcomingCollectionView.reloadData()
                    }
                }
                if let totalPages = result?.total_pages, page < totalPages {
                    guard !self.cancelRequest else {
                        print("Cancel Request Failed")
                        return
                        
                    }
                    self.loadUpcomingData(onPage: page + 1)
                }
            } else if let error = error, let retry = error.userInfo["Retry-After"] as? Int {
                print("Retry after: \(retry) seconds")
                DispatchQueue.main.async {
                    self.loadUpcomingData(onPage: page)
                }
            } else {
                print("Error code: \(String(describing: error?.code))")
                print("There was an error: \(String(describing: error?.userInfo))")
            }
        }
    }
}

extension UpcomingRow: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Tapped Cell for Upcoming")
        if let mainViewController = parentViewController as? HomeViewController {
            guard movies.count > indexPath.row else { return }
            let movie = movies[indexPath.row]
            guard let detailVC = mainViewController.storyboard?.instantiateViewController(withIdentifier: "movieDetail") as? DetailViewController else { return }
            detailVC.movie = movie
            detailVC.movieID = movie.id
            mainViewController.show(detailVC, sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCell", for: indexPath) as! UpcomingCell
        
        let movie = movies[indexPath.row]
    
        
        cell.releaseDate.text = ("Release Date: " + (movie.release_date?.convertDateString())!)
        cell.movieTitle.text = movie.title!
        
        //MARK: TO DO - Get Genres
       // cell.genre.text = "\(list)"

        // set poster image
        if let posterPath = movie.backdrop_path {
            let _ = client.taskForGETImage(ImageKeys.PosterSizes.BACK_DROP, filePath: posterPath, completionHandlerForImage: { (imageData, error) in
                if let image = UIImage(data: imageData!) {
                    
                    DispatchQueue.main.async {
                        cell.activityIndicator.alpha = 0.0
                        cell.activityIndicator.stopAnimating()
                        cell.imageView.image = image
                    }
                }
            })
        } else {
            cell.activityIndicator.alpha = 0.0
            cell.activityIndicator.stopAnimating()
        }
        return cell
    }
    
    
    
    
    

}
