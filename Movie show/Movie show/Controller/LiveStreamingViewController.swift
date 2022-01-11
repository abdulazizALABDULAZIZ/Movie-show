//
//  LiveStreamingViewController.swift
//  Movie show
//
//  Created by MACBOOK on 23/05/1443 AH.
//

import UIKit
import StreamingKit


class LiveStreamingViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var grayView: UIView!
    
    private let videoPlayer = StreamingVideoPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        setupVidewPlayer()
        playButtonTapped((Any).self)
    }
    
    private func setupVidewPlayer() {
        
        videoPlayer.add(to: grayView)
        
        
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        
        guard let _ = textField.text,
              
        let url = URL(string: "https://dminnvll.cdn.mangomolo.com/dubaione/smil:dubaione.stream.smil/playlist.m3u8") else {
            
            print("Error Parsing URL")
            
            return
        }
        
        videoPlayer.play(url: url)
        
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        
        videoPlayer.pause()
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        
        textField.text = nil
        videoPlayer.pause()
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
