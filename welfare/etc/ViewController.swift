//
//  ViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/07/29.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
//영상재생관련 module
import AVKit
import Foundation
import Alamofire
import SwiftyJSON


class ViewController: UIViewController,GIDSignInDelegate {
    
    
    
    lazy var activityIndicator: UIActivityIndicatorView = {
            // Create an indicator.
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.center = self.view.center
            activityIndicator.color = UIColor.red
            // Also show the indicator even when the animation is stopped.
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.white
            // Start animation.
        activityIndicator.startAnimating()

           // activityIndicator.stopAnimating()
            return activityIndicator }()



  
    //json 키
    struct Token: Decodable {
        var retCode : String
        var errMsg : String
        var retBody : String
        var token : String

        
    }
    
    
    //영상관련 변수 선언
    public var videoPlayer:AVQueuePlayer?
    public var videoPlayerLayer:AVPlayerLayer?
    var playerLooper: NSObject?
    var queuePlayer: AVQueuePlayer?
    
    
   

    @IBOutlet weak var GoogleBtn: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("메인열림")

                        
        
//                       FirebaseApp.configure()
//        
//                       GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        //자동로그인
        
        //비디오뷰를 먼저 뷰에 배치하고 sns로그인버튼들을 추후에 그위에 배치
        
        //비디오 파일명을 사용하여 비디오가 저장된 앱 내부의 파일 경로를 받아온다.
//                      let filePath:String? = Bundle.main.path(forResource: "main", ofType: "mp4")
//
//
//                       //앱내부의 파일명을 nsurl형식으로 변경한다.
//               let url = NSURL(fileURLWithPath: filePath!)
//
//
//
//              let playerItem = AVPlayerItem(url: url as URL)
//
//                       videoPlayer = AVQueuePlayer(items: [playerItem])
//                       playerLooper = AVPlayerLooper(player: videoPlayer!, templateItem: playerItem)
//
//                       videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
//                       videoPlayerLayer!.frame = self.view.bounds
//                       videoPlayerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
//
//                       self.view.layer.addSublayer(videoPlayerLayer!)
//
//                       videoPlayer?.play()
        
        //색상부분
        self.view.backgroundColor = UIColor(red: 0.6, green: 0.3, blue: 0.5, alpha: 0.3)


        
        //앱 라벨추가
        let frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 100)
        let label = UILabel(frame: frame)
        label.text="정책왕"
        label.textAlignment = NSTextAlignment.center

        
        label.font = UIFont(name: "System", size: 100)
        label.font = label.font.withSize(100)

        
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)


//        //내가 적용하고싶은 폰트 사이즈
//
//        let fontSize = UIFont.boldSystemFont(ofSize: 30)
//
//
//
//        //label에 있는 Text를 NSMutableAttributedString으로 만들어준다.
//        let text = "복지왕"
//        let attributedStr = NSMutableAttributedString(string: "복지왕")
//
//
//
//        //위에서 만든 attributedStr에 addAttribute메소드를 통해 Attribute를 적용. kCTFontAttributeName은 value로 폰트크기와 폰트를 받을 수 있음.
//
//        attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String), value: fontSize, range: NSMakeRange(0, 2))
//
//        
//
//        //최종적으로 내 label에 속성을 적용
//
//        label.attributedText = attributedStr



        
        view.addSubview(label)
        
        
        //앱 설명 라벨추가
              let subFrame = CGRect(x: 0, y: 200, width: view.frame.width, height: 20)
              let subLabel = UILabel(frame: subFrame)
              subLabel.text="나에게 딱 맞는 혜택정책 쉽게 알아가세요."
              subLabel.textAlignment = NSTextAlignment.center
              subLabel.font = UIFont(name: "System", size: 20)
              subLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)


              view.addSubview(subLabel)
        
        
        
        
        
        
        //구글커스텀 버튼 추가
          let btnGoogleSignIn = GIDSignInButton()

                btnGoogleSignIn.style = GIDSignInButtonStyle.wide
                //버튼 내용 바꾸는거 추가
                
        
                btnGoogleSignIn.addTarget(self, action: #selector(GoogleLoginAction), for: .touchUpInside)


                let width = view.frame.width - 20

        btnGoogleSignIn.frame = CGRect(x: 10, y: view.frame.height-100, width: width, height: 48)

                

        self.view.addSubview(btnGoogleSignIn)



    }


    
    
        @objc
        func GoogleLoginAction() {
           
            //브라우저로 카카오톡을 연다
            //토큰받은경우와 에러가 난경우를
            print("구글로그인 버튼클릭")
          self.view.addSubview(self.activityIndicator)
            
    
            
            
        
      
    }

    
    
    //url여는 메소드
        
    
        @available(iOS 9.0, *)
        func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
          -> Bool {
            print("url여는 메소드")
    
          return GIDSignIn.sharedInstance().handle(url)
        }
    
    
        //
        func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
            print("url여는 메소드")

            return GIDSignIn.sharedInstance().handle(url)
        }
    
    //프로토콜
        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
          // ...
          if let error = error {
            // ...
            print(error)
            print("뷰 컨트롤: 구글로그인 에러")
            return
          }

          guard let authentication = user.authentication else { return }
          let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                            accessToken: authentication.accessToken)
          // ...
            print("뷰컨트롤:구글로그인 성공")
            print(credential)
            //로그인에 성공하면 사용자 정보를 이용해 firebase에
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
             print("유저정보들고오기 실패")

              return
            }
            // User is signed in
            // ...


            //구글로그인정보를 이용해서 파이어베이스에 인증하고
            let user = Auth.auth().currentUser
            if let user = user {
              // The user's ID, unique to the Firebase project.
              // Do NOT use this value to authenticate with your backend server,
              // if you have one. Use getTokenWithCompletion:completion: instead.
              let uid:String? = user.uid
                let email:String? = user.email
                let name:String? = user.displayName
             //let photoURL:String? = user.photoURL


              // 파이어베이스에서 받아온 정보를 almofire를 이용해서 서버로 전송한다.
                print("뷰 컨트롤: 유저정보들고오기 성공")
                //로그인 성공알림
               
            
                //로그인 절차가 진행되는 동안 로딩바를 띄어준다.

                //로딩바를 종료해준다.
                self.activityIndicator.stopAnimating()
                
                guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "mapTestViewController")  else{return}
                                        uvc.modalPresentationStyle = .fullScreen
                                      self.present(uvc, animated: true, completion: nil)
                                        UserDefaults.standard.set(email!, forKey:"email")

            //let parameters = ["username":"test"]

            let PARAM:Parameters = [
                "userPlatform":"google",
                "userEmail":email!,
                "userName": name!,
                "userToken": uid!,
                "osType": "ios"
            ]



            //서버통신
//            Alamofire.request("http://3.34.4.196/backend/ios/sns_login.php", method: .post, parameters: PARAM)
//                .validate()
//                .responseJSON { response in
//
//                    //메인화면으로 이동한다
//
//                    switch response.result {
//                    case .success(let value): //
//                    print("성공")
//            //        print(value)
//
//                        if let json = value as? [String: Any] {
//                    //print(json)
//                    for (key, value) in json {
//                        //암호화된 토큰값을 받아서
//
//                        if(key == "token"){
//
//                            var data = value
//
//                            UserDefaults.standard.set(email!, forKey:"email")
//                           // UserDefaults.standard.set(data, forKey:"token")
//                            UserDefaults.standard.set(value, forKey:"token")
//                            var loadedData = UserDefaults.standard.value(forKey: "token") as! String
//                            print(loadedData)
//
//                            //로딩바를 종료해준다.
//                            self.activityIndicator.stopAnimating()
//
//
//
//                            guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")  else{return}
//                                                    uvc.modalPresentationStyle = .fullScreen
//                                                  self.present(uvc, animated: true, completion: nil)
//
//
//
//                                                   }
//
//
//
//               }
//            }
////                        do {
////                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
////                            let policies = try JSONDecoder().decode(Token.self, from: data)
////                            print(policies.token)
////               } catch let error as NSError {
////                                                 debugPrint("Error: \(error.description)")
////                                                 }
////                           guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")  else{
////                                                                                                    return
////                                                                                                }
////
////
////                                           uvc.modalPresentationStyle = .fullScreen
////
////
////                                          self.present(uvc, animated: true, completion: nil)
//
//
//
//
//
//
//                        case .failure(let error):
//                            print(error)
//                        }
//
//                }//resoponse 종료괄호
                
   


             }//user 언랩핑

          }//파이어베이스 인증괄호


        }//프로토콜 메소드 종료
        
        
    
}

