//
//  LoginViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/12/01.
//  Copyright © 2020 com. All rights reserved.

//sns로그인을 하는 화면
//


//화면 구성
//메인 이미지
//라벨
//카카오로 시작하기
//다른 sns 로그인 (구분선 포함)

import UIKit
import AuthenticationServices
import Alamofire
import GoogleSignIn
import FirebaseAuth
import Firebase


class LoginViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding , GIDSignInDelegate {
    
    
    //로그 보낼떄 화면을 알려주는 변수
    var type : String = "login"
    
    //메인화면으로 이동하는 경우와 키워드입력화면으로 이동하는 경우가 있는데
    //이를 처리해주기 위한 변수
    var moveView = String()
    
    
    //로그인 파싱
    struct parse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
        let Message : String
        var Token : String?
        var Check : String?
        var nickName : String?

        
        
    }
    
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
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    //스택뷰
    var appleLoginStackView = UIStackView()
    
    
    //푸터
    let footer = UIView()
    
    
    
    //카카오 로그인 버튼
    //    private let loginButton: KOLoginButton = {
    //      let button = KOLoginButton()
    //      button.addTarget(self, action: #selector(touchUpLoginButton(_:)), for: .touchUpInside)
    //      button.translatesAutoresizingMaskIntoConstraints = false
    //      return button
    //    }()
    
    //애플 로그인 버튼
    let authorizationButton = ASAuthorizationAppleIDButton()
    
    
    static let base: CGFloat = 414
    
    var adjusted: CGFloat =  UIScreen.main.bounds.width / base
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //구글관련 대리자 설정
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        //화면 스크롤 크기 414 896
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        let withBase: CGFloat = 414
        let heightBase: CGFloat = 896
        
        
        
        
        let widthRatio : CGFloat = UIScreen.main.bounds.width / withBase
        let heightRatio : CGFloat = UIScreen.main.bounds.height / heightBase
        
        //
        //        print(screenWidth)
        //        print(widthRatio)
        
        print("가로비율:\(DeviceManager.sharedInstance.widthRatio)")
        print("세로비율:\(DeviceManager.sharedInstance.heightRatio)")
        
        
        
        //카톡 로그인 버튼
        
        //let ktBtn = KOLoginButton()
        
        let ktBtn = UIButton()
        ktBtn.setTitle("카카오로 시작하기", for: .normal)
        ktBtn.titleLabel!.font = UIFont(name: "Jalnan", size:16.1 *  DeviceManager.sharedInstance.heightRatio)
        ktBtn.layer.cornerRadius = 13 *  DeviceManager.sharedInstance.heightRatio
        ktBtn.layer.borderWidth = 1.3
        ktBtn.layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
        
        ktBtn.backgroundColor =  UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        ktBtn.tintColor =  UIColor.white
        
        ktBtn.addTarget(self, action: #selector(touchUpLoginButton(_:)), for: .touchUpInside)
        //  ktBtn.frame = CGRect(x: 0, y: 0, width: screenWidth - 80, height: 60)
        ktBtn.frame = CGRect(x: 40 * DeviceManager.sharedInstance.heightRatio, y: 500 * DeviceManager.sharedInstance.heightRatio, width: CGFloat(screenWidth) - 80 * DeviceManager.sharedInstance.heightRatio, height: 60 *  DeviceManager.sharedInstance.heightRatio)
        //appleLoginStackView.frame = CGRect(x: 40, y: 500, width: screenWidth - 80, height: 60)
        // appleLoginStackView.addSubview(ktBtn)
        
        //카톡버튼은 커스텀 안됨.
        
        
        self.view.addSubview(ktBtn)
        
        
        //애플 로그인 버튼
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        
        authorizationButton.frame = CGRect(x: 40 * DeviceManager.sharedInstance.heightRatio, y: 580 * DeviceManager.sharedInstance.heightRatio , width: CGFloat(screenWidth) - 80 *  DeviceManager.sharedInstance.heightRatio, height: 60 *  DeviceManager.sharedInstance.heightRatio)
        
        self.view.addSubview(authorizationButton)
        
        
        // Do any additional setup after loading the view.
        //        let MainImgView = UIImageView()
        //        let MainImg = UIImage(named: "MainImg")
        //        MainImgView.image = MainImg
        //        MainImgView.frame = CGRect(x: 40 * DeviceManager.sharedInstance.widthRatio, y: 120  *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(screenWidth) - 80  *  DeviceManager.sharedInstance.widthRatio, height: 210  *  DeviceManager.sharedInstance.heightRatio)
        //
        //        self.view.addSubview(MainImgView)
        
        let logoLabel = UILabel()
        logoLabel.frame = CGRect(x: 0, y: 200 * DeviceManager.sharedInstance.heightRatio, width: view.bounds.width, height: 100 * DeviceManager.sharedInstance.heightRatio)
        logoLabel.textAlignment = .center
        logoLabel.textColor =  UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        
        logoLabel.text = "UrBene_Fit"
        logoLabel.font = UIFont(name: "Bowhouse-Black", size: 60  *  DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(logoLabel)
        
        //
        //        let mainLabel = UILabel()
        //        mainLabel.font = UIFont(name: "Jalnan", size: 22 *  DeviceManager.sharedInstance.heightRatio)
        //        mainLabel.numberOfLines = 2
        //        mainLabel.text = "당신이 놓치고 있는 혜택\n찾아가세요"
        //        mainLabel.frame = CGRect(x: 0, y: 370 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(screenWidth), height: 44 *  DeviceManager.sharedInstance.heightRatio)
        //        mainLabel.textAlignment = .center
        //
        //
        //        self.view.addSubview(mainLabel)
        
        
        //다른 계정 로그인 버튼
        footer.frame = CGRect(x: 0, y: 710 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(screenWidth), height: 150 *  DeviceManager.sharedInstance.heightRatio)
        footer.backgroundColor = UIColor(displayP3Red: 251/255.0, green: 251/255.0, blue: 251/255.0, alpha: 1)
        
        //다른 sns 로그인 안내 라벨
        let inquiryBtnLabel = UILabel()
        inquiryBtnLabel.frame = CGRect(x: 0, y: 10 *  DeviceManager.sharedInstance.heightRatio , width: CGFloat(screenWidth), height: 17 *  DeviceManager.sharedInstance.heightRatio)
        inquiryBtnLabel.textAlignment = .center
        //inquiryBtnLabel.textColor = UIColor(displayP3Red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        
        inquiryBtnLabel.text = "다른 계정으로 시작하기"
        inquiryBtnLabel.font = UIFont(name: "Jalnan", size: 16 *  DeviceManager.sharedInstance.heightRatio )
        
        footer.addSubview(inquiryBtnLabel)
        
        
        //페이스북 로고이미지 추가
        let fbImg = UIImage(named:"fbImg")
        let fbImgView = UIImageView(image: fbImg)
        fbImgView.frame = CGRect(x: 14.4 *  DeviceManager.sharedInstance.heightRatio, y: 10.5 *  DeviceManager.sharedInstance.heightRatio, width: 6.9 *  DeviceManager.sharedInstance.heightRatio, height: 13.8 *  DeviceManager.sharedInstance.heightRatio)
        
        //각 상위뷰에 추가
        //하단 페이스북 버튼
        let bottomFbBtn = UIButton(type: .system)
        bottomFbBtn.frame = CGRect(x:160 *  DeviceManager.sharedInstance.heightRatio, y:55 *  DeviceManager.sharedInstance.heightRatio, width: 35.3 *  DeviceManager.sharedInstance.heightRatio, height: 35.3 *  DeviceManager.sharedInstance.heightRatio)
        bottomFbBtn.backgroundColor = UIColor(displayP3Red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
        
        bottomFbBtn.layer.cornerRadius = bottomFbBtn.frame.height/2
        bottomFbBtn.layer.borderWidth = 1
        bottomFbBtn.layer.borderColor = UIColor.clear.cgColor
        // 뷰의 경계에 맞춰준다
        bottomFbBtn.clipsToBounds = true
        bottomFbBtn.addSubview(fbImgView)
        footer.addSubview(bottomFbBtn)
        
        
        //하단 구글 버튼
        let bottomGgBtn = UIButton(type: .system)
        bottomGgBtn.frame = CGRect(x:210 *  DeviceManager.sharedInstance.heightRatio, y:55 *  DeviceManager.sharedInstance.heightRatio, width: 35.3 *  DeviceManager.sharedInstance.heightRatio, height: 35.3 *  DeviceManager.sharedInstance.heightRatio)
        bottomGgBtn.backgroundColor = UIColor(displayP3Red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
        
        bottomGgBtn.layer.cornerRadius = bottomFbBtn.frame.height/2
        bottomGgBtn.layer.borderWidth = 1
        bottomGgBtn.layer.borderColor = UIColor.clear.cgColor
        // 뷰의 경계에 맞춰준다
        bottomGgBtn.clipsToBounds = true
        
        
        //페이스북 로고이미지 추가
        let GgImg = UIImage(named:"GgImg")
        let GgImgView = UIImageView(image: GgImg)
        GgImgView.frame = CGRect(x: 12 *  DeviceManager.sharedInstance.heightRatio, y: 10.5 *  DeviceManager.sharedInstance.heightRatio, width: 9.3 *  DeviceManager.sharedInstance.heightRatio, height: 13.8 *  DeviceManager.sharedInstance.heightRatio)
        
        //각 상위뷰에 추가
        bottomGgBtn.addSubview(GgImgView)
        bottomGgBtn.addTarget(self, action: #selector(GoogleLoginAction), for: .touchUpInside)
        footer.addSubview(bottomGgBtn)
        
        //self.view.addSubview(footer)
    }
    
    
    @objc private func touchUpLoginButton(_ sender: UIButton) {
        
        if KOSession.shared()!.isOpen() { KOSession.shared()!.close() }
        KOSession.shared()!.presentingViewController = self
        var userToken = UserDefaults.standard.string(forKey: "fcmToken")!
        print(userToken)
        func profile(_ error: Error?, user: KOUserMe?) {
            guard let user = user,
                  error == nil else { return }
            
            guard let token = user.id else { return }
            let name = user.nickname ?? ""
            
            if let gender = user.account?.gender {
                if gender == KOUserGender.male {
                    print("male")
                } else if gender == KOUserGender.female {
                    print("female")
                }
            }
            
            let email = user.account?.email ?? ""
            let profile = user.profileImageURL?.absoluteString ?? ""
            let thumbnail = user.thumbnailImageURL?.absoluteString ?? ""
            
            print(token)
            print(name)
            print(email)
            print(profile)
            print(thumbnail)
            //sns로그인을 통해 받아온 정보를 저장한다.
            UserDefaults.standard.set(email, forKey:"check")
            UserDefaults.standard.set("kakao", forKey:"platform")
            
            let PARAM:Parameters = [
                "platform":"kakao",
                "email":email,
                "fcm_token":userToken,
                "osType": "ios"
            ]
            
            //서버통신
            Alamofire.request("https://www.urbene-fit.com/login", method: .post, parameters: PARAM)
                .validate()
                .responseJSON { response in
                    print("서버통신")
                    //메인화면으로 이동한다
                    
                    switch response.result {
                    case .success(let value): //
                        do {
                            let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let parseResult = try JSONDecoder().decode(parse.self, from: data)
                            if(parseResult.Status == "200"){
                                
                                //                            print("로그인 성공")
                                //                            print("관심사 입력여부:\(parseResult.Check)")
                                
                                LoginManager.sharedInstance.token = parseResult.Token!
                                LoginManager.sharedInstance.checkInfo = Bool(parseResult.Check!)!
                                //로그인 성공
                                print("카카오 로그인 성공")
                                //토큰을 저장
                                UserDefaults.standard.set(value, forKey:"idToken")
                                
                                //화면이동
                                if(!LoginManager.sharedInstance.checkInfo){
                                    print("기본정보 입력안되어있음")

                                    DeviceManager.sharedInstance.sendLog(content: "기본정보 입력페이지로 이동", type: self.type)
                                    
                                    guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "newInfoViewController") as? newInfoViewController         else{
                                        
                                        return
                                        
                                    }
                                    
                                    RVC.modalPresentationStyle = .fullScreen
                                    
                                    //혜택 상세보기 페이지로 이동
                                    //self.present(RVC, animated: true, completion: nil)
                                    self.navigationController?.pushViewController(RVC, animated: true)
                                    //로그인 페이지를 없애고 다른 페이지로 이동
//                                    self.dismiss(animated: true) {
//                                        RVC.navigationController?.pushViewController(RVC, animated: true)
//                                    }
                                    
                                    
                                    
                                }else{
                                    print("기본정보 입력되어있음 메인페이지로 이동")
                                    var nickName : String = parseResult.nickName!
                                    print("닉네임 정보: \(nickName)")
                                    if(nickName != ""){
                                        print("닉네임 저장: \(nickName)")

                                            UserDefaults.standard.set(nickName, forKey:"nickName")

                                            }

                                    
                                    DeviceManager.sharedInstance.sendLog(content: "메인페이지로 이동", type: self.type)
//
//                                    guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewMainViewController") as? NewMainViewController         else{
//
//                                        return
//
//                                    }
//
//                                    RVC.modalPresentationStyle = .fullScreen
//
//                                    self.navigationController?.popViewController(animated: true)
                                    
                                    self.dismiss(animated: true) {
                                        
                                    }
                                    
                                }
                                
                                
                                
                            }
                        }
                        catch let DecodingError.dataCorrupted(context) {
                            print(context)
                        } catch let DecodingError.keyNotFound(key, context) {
                            print("Key '\(key)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch let DecodingError.valueNotFound(value, context) {
                            print("Value '\(value)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch let DecodingError.typeMismatch(type, context)  {
                            print("Type '\(type)' mismatch:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch {
                            print("error: ", error)
                        }
                        
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                }//resoponse 종료괄호
            //화면이동
            //                                    if(self.moveView == "keyword"){
            //                                        DeviceManager.sharedInstance.sendLog(content: "기본정보 입력페이지로 이동")
            //
            //                                        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "newInfoViewController") as? newInfoViewController         else{
            //
            //                                            return
            //
            //                                        }
            //
            //                                        RVC.modalPresentationStyle = .fullScreen
            //
            //                                        //혜택 상세보기 페이지로 이동
            //                                        //self.present(RVC, animated: true, completion: nil)
            //                                        self.navigationController?.pushViewController(RVC, animated: true)
            //                                    }else{
            //
            //
            //                                        DeviceManager.sharedInstance.sendLog(content: "메인페이지로 이동")
            //
            //                                        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewMainViewController") as? NewMainViewController         else{
            //
            //                                            return
            //
            //                                        }
            //
            //                                        RVC.modalPresentationStyle = .fullScreen
            //
            //                                        //혜택 상세보기 페이지로 이동
            //                                        //self.present(RVC, animated: true, completion: nil)
            //                                        self.navigationController?.pushViewController(RVC, animated: true)
            //
            //                                    }
            
            
            
            
        }
        
        KOSession.shared()!.open(completionHandler: { (error) in
            if error != nil || !KOSession.shared()!.isOpen() { return }
            KOSessionTask.userMeTask(completion: { (error, user) in
                if let account = user?.account {
                    var updateScopes = [String]()
                    if account.needsScopeAccountEmail() {
                        updateScopes.append("account_email")
                    }
                    
                    if account.needsScopeGender() {
                        updateScopes.append("gender")
                    }
                    
                    if account.needsScopeGender() {
                        updateScopes.append("birthday")
                    }
                    KOSession.shared()?.updateScopes(updateScopes, completionHandler: { (error) in
                        guard error == nil else {
                            return
                        }
                        KOSessionTask.userMeTask(completion: { (error, user) in
                            profile(error, user: user)
                        })
                    })
                } else {
                    profile(error, user: user)
                }
                //화면이동
                //                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //                let initialViewController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! tabBarController
                //                initialViewController.modalPresentationStyle = .fullScreen
                //
                //                self.present(initialViewController, animated: true, completion: nil)
                
                //print("KOSession.shared()!.open")
                
                
            })
            // print("KOSession.shared()!.open2")
            
        })
        //  print("KOSession.shared()!.open3")
        
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
                
                
                
                
            }//user 언랩핑
            
        }//파이어베이스 인증괄호
        
        
    }//프로토콜 메소드 종료
    
    
    //애플 로그인 메소드
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        
        var userToken = UserDefaults.standard.string(forKey: "fcmToken")!
        
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
            print("handleAuthorizationAppleIDButtonPress")
            
        } else {
            // 구버젼 아이폰 유저들에게..
        }
        
        //    //애플로그인 버튼을 누르면 이름과 이메일을 요청할 객체를 만든다.
        //      let appleIDProvider = ASAuthorizationAppleIDProvider()
        //      let request = appleIDProvider.createRequest()
        //      request.requestedScopes = [.fullName, .email]
        //
        //      //요청을 하고 대리자를 선언한다.
        //      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        //      authorizationController.delegate = self
        //      authorizationController.presentationContextProvider = self
        //      authorizationController.performRequests()
    }
    
    
    
    //        guard let session = KOSession.shared() else {
    //            return
    //        }
    //
    //        if session.isOpen() {
    //            session.close()
    //        }
    //
    //        session.open(completionHandler: { (error) -> Void in
    //
    //            if !session.isOpen() {
    //                if let error = error as NSError? {
    //                    switch error.code {
    //                    case Int(KOErrorCancelled.rawValue):
    //                        break
    //                    default:
    //                        print("오류")
    //                    }
    //                }
    //            } else {
    //                //코세션테스크가 실행이 안됨.
    //                KOSessionTask.userMeTask{(error, user) in
    //                    guard let user = user,
    //                        let email = user.account?.email,
    //                        let name = user.account?.profile?.nickname,
    //                        let id = user.id else {return}
    //                    print("로그인 성공")
    //                    let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapTestViewController")
    //                    self.present(mvc, animated: true)
    //
    //                }
    //
    //               // print("로그인 성공")
    //
    //            }
    //        })
    
    //
    //
    
    
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("authorizationController")
        var userToken = UserDefaults.standard.string(forKey: "fcmToken")!
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName
            let userLastName = appleIDCredential.fullName?.familyName
            let userEmail = appleIDCredential.email
            let jwt = appleIDCredential.identityToken
            
            //보안상의 문제로 이름과 이메일 모두 첫 로그인시만 받아올 수 잇다..
            print(userIdentifier)
            print(userFirstName)
            print(userLastName)
            print(userEmail)
            print(jwt?.base64EncodedString())
            
            switch authorization.credential {
            
            case let appleIdCredential as ASAuthorizationAppleIDCredential:
                if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
                    print("첫 로그인")
                    let email = userEmail
                    let identifier = userIdentifier
                    
                    //UserDefaults.standard.set(email, forKey:"email")
                    UserDefaults.standard.set(identifier, forKey:"check")
                    UserDefaults.standard.set("apple", forKey:"platform")
                    
                    
                    let PARAM:Parameters = [
                        "platform":"apple",
                        "email":email,
                        "identifier":identifier,
                        "fcm_token":userToken,
                        "osType": "ios"
                    ]
                    
                    //서버통신
                    Alamofire.request("https://www.urbene-fit.com/login", method: .post, parameters: PARAM)
                        .validate()
                        .responseJSON { [self] response in
                            
                            //메인화면으로 이동한다
                            
                            switch response.result {
                            case .success(let value): //
                                do {
                                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                                    let parseResult = try JSONDecoder().decode(parse.self, from: data)
                                    if(parseResult.Status == "200"){
                                        
                                        //                            print("로그인 성공")
                                        //                            print("관심사 입력여부:\(parseResult.Check)")
                                        
                                        LoginManager.sharedInstance.token = parseResult.Token!
                                        LoginManager.sharedInstance.checkInfo = Bool(parseResult.Check!)!
                                        //로그인 성공
                                        print("애플 로그인 성공")
                                        //토큰을 저장
                                        UserDefaults.standard.set(value, forKey:"idToken")
                                        
                                        //화면이동
                                        if(!LoginManager.sharedInstance.checkInfo){
                                            DeviceManager.sharedInstance.sendLog(content: "기본정보 입력페이지로 이동",type: self.type)
                                            print("기본정보 입력페이지로 이동")

                                            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "newInfoViewController") as? newInfoViewController         else{
                                                
                                                return
                                                
                                            }
                                            
                                            RVC.modalPresentationStyle = .fullScreen
                                            
                                            self.navigationController?.pushViewController(RVC, animated: true)
                                         

                                            
                                            //로그인 페이지를 없애고 다른 페이지로 이동
        //                                    self.dismiss(animated: true) {
        //                                        RVC.navigationController?.pushViewController(RVC, animated: true)
        //                                    }
                                            
                                            
                                            
                                        }else{
                                            print("메인페이지로 이동")

                                            var nickName : String = parseResult.nickName!
                                            print("닉네임 정보: \(nickName)")
                                            if(nickName != ""){
                                                print("닉네임 저장: \(nickName)")

                                            UserDefaults.standard.set(nickName, forKey:"nickName")

                                            }
                                                               DeviceManager.sharedInstance.sendLog(content: "메인페이지로 이동", type: self.type)
        //
        //                                    guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewMainViewController") as? NewMainViewController         else{
        //
        //                                        return
        //
        //                                    }
        //
        //                                    RVC.modalPresentationStyle = .fullScreen
        //
        //                                    self.navigationController?.popViewController(animated: true)
                                            
                                            self.dismiss(animated: true) {
                                                
                                            }
                                            
                                        }
                                        
                                        
                                        
                                    }
                                }
                                catch let DecodingError.dataCorrupted(context) {
                                    print(context)
                                } catch let DecodingError.keyNotFound(key, context) {
                                    print("Key '\(key)' not found:", context.debugDescription)
                                    print("codingPath:", context.codingPath)
                                } catch let DecodingError.valueNotFound(value, context) {
                                    print("Value '\(value)' not found:", context.debugDescription)
                                    print("codingPath:", context.codingPath)
                                } catch let DecodingError.typeMismatch(type, context)  {
                                    print("Type '\(type)' mismatch:", context.debugDescription)
                                    print("codingPath:", context.codingPath)
                                } catch {
                                    print("error: ", error)
                                }
                                
                
                            
                            
                            case .failure(let error):
                                print(error)
                            }
                            
                        }//resoponse 종료괄호
                    
                    
                } else {
                    print("로그인 했었음")
                    let identifier = userIdentifier
                    UserDefaults.standard.set(identifier, forKey:"check")
                    UserDefaults.standard.set("apple", forKey:"platform")
                    
                    
                    
                    let PARAM:Parameters = [
                        "platform":"apple",
                        "identifier":identifier,
                        "fcm_token":userToken,
                        "osType": "ios"
                    ]
                    
                    
                    //서버통신
                    Alamofire.request("https://www.urbene-fit.com/login", method: .post, parameters: PARAM)
                        .validate()
                        .responseJSON { response in
                            
                            //메인화면으로 이동한다
                            
                            switch response.result {
                            case .success(let value): //
                                do {
                                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                                    let parseResult = try JSONDecoder().decode(parse.self, from: data)
                                    if(parseResult.Status == "200"){
                                        
                                        //                            print("로그인 성공")
                                        //                            print("관심사 입력여부:\(parseResult.Check)")
                                        
                                        LoginManager.sharedInstance.token = parseResult.Token!
                                        LoginManager.sharedInstance.checkInfo = Bool(parseResult.Check!)!
                                        //로그인 성공
                                        print("애플 로그인 성공")
                                        //토큰을 저장
                                        UserDefaults.standard.set(value, forKey:"idToken")
                                        
                                        //화면이동
                                        if(!LoginManager.sharedInstance.checkInfo){
                                               DeviceManager.sharedInstance.sendLog(content: "기본정보 입력페이지로 이동", type: self.type)
                                            print("기본정보 입력페이지로 이동")

                                            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "newInfoViewController") as? newInfoViewController         else{
                                                
                                                return
                                                
                                            }
                                            
                                            RVC.modalPresentationStyle = .fullScreen
                                            
                                            //혜택 상세보기 페이지로 이동
                                            //self.present(RVC, animated: true, completion: nil)
                                         self.navigationController?.pushViewController(RVC, animated: true)
                                         
                                            //로그인 페이지를 없애고 다른 페이지로 이동
        //                                    self.dismiss(animated: true) {
        //                                        RVC.navigationController?.pushViewController(RVC, animated: true)
        //                                    }
                                            
                                            
                                            
                                        }else{
                                            var nickName : String = parseResult.nickName!
                                            print("닉네임 정보: \(nickName)")
                                            if(nickName != ""){
                                                print("닉네임 저장: \(nickName)")

                                            UserDefaults.standard.set(nickName, forKey:"nickName")

                                            }
                                            print("메인페이지로 이동")

                                            
                                                          DeviceManager.sharedInstance.sendLog(content: "메인페이지로 이동", type: self.type)
        //
        //                                    guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewMainViewController") as? NewMainViewController         else{
        //
        //                                        return
        //
        //                                    }
        //
        //                                    RVC.modalPresentationStyle = .fullScreen
        //
        //                                    self.navigationController?.popViewController(animated: true)
                                            
                                            self.dismiss(animated: true) {
                                                
                                            }
                                            
                                        }
                                        
                                        
                                        
                                    }
                                }
                                catch let DecodingError.dataCorrupted(context) {
                                    print(context)
                                } catch let DecodingError.keyNotFound(key, context) {
                                    print("Key '\(key)' not found:", context.debugDescription)
                                    print("codingPath:", context.codingPath)
                                } catch let DecodingError.valueNotFound(value, context) {
                                    print("Value '\(value)' not found:", context.debugDescription)
                                    print("codingPath:", context.codingPath)
                                } catch let DecodingError.typeMismatch(type, context)  {
                                    print("Type '\(type)' mismatch:", context.debugDescription)
                                    print("codingPath:", context.codingPath)
                                } catch {
                                    print("error: ", error)
                                }
                                
                
                            
                            
                            case .failure(let error):
                                print(error)
                            }
                            
                        }//resoponse 종료괄호
                }
                
            default:
                break
            }
            
            
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print(username)
            print(password)
            //Navigate to other view controller
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // handle Error.
    }
    
    
}

//extension ViewController: ASAuthorizationControllerDelegate {
//    @available(iOS 13.0, *)
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        print("authorizationController")
//    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//        // Create an account in your system.
//        let userIdentifier = appleIDCredential.user
//        let userFirstName = appleIDCredential.fullName?.givenName
//        let userLastName = appleIDCredential.fullName?.familyName
//        let userEmail = appleIDCredential.email
//        let jwt = appleIDCredential.identityToken
//        
//        
//        print(userIdentifier)
//        print(userFirstName)
//        print(userLastName)
//        print(userEmail)
//        print(jwt?.base64EncodedString())
// 
//        // 아이디 결과를 통해 원하는 뷰컨트롤러로 이동하시면 됩니다.
//        
//        
//    } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
//        // Sign in using an existing iCloud Keychain credential.
//        let username = passwordCredential.user
//        let password = passwordCredential.password
//        
//        print(username)
//        print(password)
//        //Navigate to other view controller
//    }
//  }
//  
//    @available(iOS 13.0, *)
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//    // handle Error.
//  }
//}



