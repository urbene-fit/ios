//
//  TestViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/07/29.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import AVKit
import Foundation



class TestViewController: UIViewController {

//        var video: String?
//      // @IBOutlet weak var vView: UIView!
//
//       var player: AVPlayer!
//       var playerLayer: AVPlayerLayer!
//
    
    
    //nsobject란 객체의 생명주기에 따라 명령할 수 있게 해주는 클래스 
    
    public var videoPlayer:AVQueuePlayer?
    public var videoPlayerLayer:AVPlayerLayer?
    var playerLooper: NSObject?
    var queuePlayer: AVQueuePlayer?
    
    
//    var playerLooper: NSObject?
//    var playerLayer:AVPlayerLayer!
//    var queuePlayer: AVQueuePlayer?
       
       override func viewDidLoad() {
           super.viewDidLoad()
        
        print("뷰 로드")
        
         //비디오 파일명을 사용하여 비디오가 저장된 앱 내부의 파일 경로를 받아온다.
               let filePath:String? = Bundle.main.path(forResource: "main", ofType: "mp4")

        
                //앱내부의 파일명을 nsurl형식으로 변경한다.
        let url = NSURL(fileURLWithPath: filePath!)



//        var player = AVPlayer(url: url as URL)
//           let playerLayer = AVPlayerLayer(player: player)
//           playerLayer.frame = self.view.bounds
//           self.view.layer.addSublayer(playerLayer)
//           player.play()

        
        
       let playerItem = AVPlayerItem(url: url as URL)

                videoPlayer = AVQueuePlayer(items: [playerItem])
                playerLooper = AVPlayerLooper(player: videoPlayer!, templateItem: playerItem)

                videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
                videoPlayerLayer!.frame = self.view.bounds
                videoPlayerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill

                self.view.layer.addSublayer(videoPlayerLayer!)

                videoPlayer?.play()
    

}
    
    func remove() {
        videoPlayerLayer?.removeFromSuperlayer()

    }
}
