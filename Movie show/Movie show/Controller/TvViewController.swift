//
//  TvViewController.swift
//  Movie show
//
//  Created by MACBOOK on 20/05/1443 AH.
//

import UIKit

class TvViewController: UIViewController {

    
    var shows: [Movie] = []
    let client = Service()
    var cancelRequest: Bool = false
    var gradient: CAGradientLayer!
    private var timer:Timer?
    
    @IBOutlet weak var onAirCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onAirCollectionView.reloadData()
        loadLatestTvData()
        startTimers()
    }
    
    private func startTimers(){
        timer = Timer.scheduledTimer(timeInterval: 3, target: self , selector: #selector(moveToNextItems) , userInfo: nil, repeats: true)

    }

     @objc func moveToNextItems(){



        let lastItem = onAirCollectionView.indexPathsForVisibleItems.last
        let currentItems = IndexPath(item: lastItem?.item ?? shows.count, section: 0)
        onAirCollectionView.scrollToItem(at: currentItems, at: .right, animated: true)
        var nextItems = currentItems.item + 1

        if nextItems == shows.count
        {

            nextItems = 0
        }
        let nextIndexPath = IndexPath(item: nextItems, section: 0)
        onAirCollectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)



    }
//////
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    private func loadLatestTvData(onPage page: Int = 1) {
        guard !cancelRequest else { return }
        let _ = client.taskForGETMethod(Methods.TRENDING_TV, parameters: [ParameterKeys.TOTAL_RESULTS: page as AnyObject]) { (data, error) in
            if error == nil, let jsonData = data {
                
                let result = MovieResults.decode(jsonData: jsonData)
                if let movieResults = result?.results {
                    self.shows += movieResults
                    DispatchQueue.main.async {
                        self.onAirCollectionView.reloadData()
                    }
                }
                if let totalPages = result?.total_pages, totalPages < 10 {
                    guard !self.cancelRequest else {
                        print("Cancel Request Failed")
                        return
                        
                    }
                    self.loadLatestTvData(onPage: page + 1)
                }
            } else if let error = error, let retry = error.userInfo["Retry-After"] as? Int {
                print("Retry after: \(retry) seconds")
                DispatchQueue.main.async {
                    Timer.scheduledTimer(withTimeInterval: Double(retry), repeats: false, block: { (_) in
                        print("Retrying...")
                        guard !self.cancelRequest else { return }
                        self.loadLatestTvData(onPage: page)
                        return
                    })
                }
            } else {
                print("Error code: \(String(describing: error?.code))")
                print("There was an error: \(String(describing: error?.userInfo))")
            }
        }
    }

}

extension TvViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let onAirCell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularTv", for: indexPath) as! OnAirCell
        
        let tv = shows[indexPath.row]
        
        onAirCell.nameLabel.text = tv.name
        onAirCell.firstAirDate.text = ("Original Air Date: " + (tv.first_air_date?.convertDateString())!)
        
        if let posterPath = tv.poster_path {
            let _ = client.taskForGETImage(ImageKeys.PosterSizes.ORIGINAL_POSTER, filePath: posterPath, completionHandlerForImage: { (imageData, error) in
                if let image = UIImage(data: imageData!) {
                    
                    DispatchQueue.main.async {
                        onAirCell.activityIndicator.alpha = 0.0
                        onAirCell.activityIndicator.stopAnimating()
                        onAirCell.onAirImage.image = image
                    }
                }
            })
        } else {
            onAirCell.activityIndicator.alpha = 0.0
            onAirCell.activityIndicator.stopAnimating()
        }
        return onAirCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard shows.count > indexPath.row else { return }
        let tv = shows[indexPath.row]
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "tvDetail") as? TvDetailViewController else { return }
        detailVC.shows = tv
        detailVC.tvID = tv.id
        
        self.showDetailViewController(detailVC, sender: self)
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
    
    

}
