//
//  VideoPlayer.swift
//  StreamingKit
//
//  Created by MACBOOK on 23/05/1443 AH.
//

import Foundation
import AVKit
import AVFoundation

public class StreamingVideoPlayer {
    
    private let playerViewController = AVPlayerViewController()
    
    private let avPlayer = AVPlayer()
    
    private lazy var playerView: UIView = {
        
        let view = playerViewController.view!
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public init() {}
    
    // Mark - Public interface
    
   public func add(to view : UIView) {
        view.addSubview(playerView)
        NSLayoutConstraint.activate([
        
            playerView.topAnchor.constraint(equalTo: view.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor), 

        
        ])
        
    }
    
   public func play(url: URL) {
        
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        avPlayer.replaceCurrentItem(with: playerItem)
       playerViewController.player = avPlayer
       playerViewController.player?.play()
       
       
    }
    
   public func pause() {
       
       avPlayer.pause()
        
        
    }
    
}
