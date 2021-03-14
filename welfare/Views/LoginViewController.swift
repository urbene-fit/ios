//sns로그인을 하는 화면
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
    
    
    // 로그 보낼떄 화면을 알려주는 변수
    var type : String = "login"
    
    // 메인화면으로 이동하는 경우와 키워드입력화면으로 이동하는 경우가 있는데 이를 처리해주기 위한 변수
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
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.red
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.white
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    //스택뷰
    var appleLoginStackView = UIStackView()
    
    
    //푸터
    let footer = UIView()
    
    
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
        debugPrint("가로비율:\(DeviceManager.sharedInstance.widthRatio)")
        debugPrint("세로비율:\(DeviceManager.sharedInstance.heightRatio)")
        
        
        //카톡 로그인 버튼
        let ktBtn = UIButton()
        ktBtn.setTitle("카카오로 시작하기", for: .normal)
        ktBtn.titleLabel!.font = UIFont(name: "Jalnan", size:16.1 *  DeviceManager.sharedInstance.heightRatio)
        ktBtn.layer.cornerRadius = 13 *  DeviceManager.sharedInstance.heightRatio
        ktBtn.layer.borderWidth = 1.3
        ktBtn.layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
        ktBtn.backgroundColor =  UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        ktBtn.tintColor =  UIColor.white
        ktBtn.addTarget(self, action: #selector(touchUpLoginButton(_:)), for: .touchUpInside)
        ktBtn.frame = CGRect(x: 40 * DeviceManager.sharedInstance.heightRatio, y: 500 * DeviceManager.sharedInstance.heightRatio, width: CGFloat(screenWidth) - 80 * DeviceManager.sharedInstance.heightRatio, height: 60 *  DeviceManager.sharedInstance.heightRatio)
        
        
        //카톡버튼은 커스텀 안됨.
        self.view.addSubview(ktBtn)
        
        
        //애플 로그인 버튼
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        authorizationButton.frame = CGRect(x: 40 * DeviceManager.sharedInstance.heightRatio, y: 580 * DeviceManager.sharedInstance.heightRatio , width: CGFloat(screenWidth) - 80 *  DeviceManager.sharedInstance.heightRatio, height: 60 *  DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(authorizationButton)
        
        
        let logoLabel = UILabel()
        logoLabel.frame = CGRect(x: 0, y: 200 * DeviceManager.sharedInstance.heightRatio, width: view.bounds.width, height: 100 * DeviceManager.sharedInstance.heightRatio)
        logoLabel.textAlignment = .center
        logoLabel.textColor =  UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        logoLabel.text = "UrBene_Fit"
        logoLabel.font = UIFont(name: "Bowhouse-Black", size: 60  *  DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(logoLabel)
        
        
        //다른 계정 로그인 버튼
        footer.frame = CGRect(x: 0, y: 710 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(screenWidth), height: 150 *  DeviceManager.sharedInstance.heightRatio)
        footer.backgroundColor = UIColor(displayP3Red: 251/255.0, green: 251/255.0, blue: 251/255.0, alpha: 1)
        
        
        //다른 sns 로그인 안내 라벨
        let inquiryBtnLabel = UILabel()
        inquiryBtnLabel.frame = CGRect(x: 0, y: 10 *  DeviceManager.sharedInstance.heightRatio , width: CGFloat(screenWidth), height: 17 *  DeviceManager.sharedInstance.heightRatio)
        inquiryBtnLabel.textAlignment = .center
        inquiryBtnLabel.text = "다른 계정으로 시작하기"
        inquiryBtnLabel.font = UIFont(name: "Jalnan", size: 16 *  DeviceManager.sharedInstance.heightRatio )
        footer.addSubview(inquiryBtnLabel)
        
        
        //페이스북 로고이미지 추가
        let fbImg = UIImage(named:"fbImg")
        let fbImgView = UIImageView(image: fbImg)
        fbImgView.frame = CGRect(x: 14.4 *  DeviceManager.sharedInstance.heightRatio, y: 10.5 *  DeviceManager.sharedInstance.heightRatio, width: 6.9 *  DeviceManager.sharedInstance.heightRatio, height: 13.8 *  DeviceManager.sharedInstance.heightRatio)
        
        
        // 각 상위뷰에 추가, 하단 페이스북 버튼
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
    }
    
    
    @objc private func touchUpLoginButton(_ sender: UIButton) {
        if KOSession.shared()!.isOpen() { KOSession.shared()!.close() }
        KOSession.shared()!.presentingViewController = self
        var userToken = UserDefaults.standard.string(forKey: "fcmToken")!
        
        
        func profile(_ error: Error?, user: KOUserMe?) {
            guard let user = user,
                  error == nil else { return }
            
            if let gender = user.account?.gender {
                if gender == KOUserGender.male {
                    debugPrint("male")
                } else if gender == KOUserGender.female {
                    debugPrint("female")
                }
            }
            
            let email = user.account?.email ?? ""

            
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
            Alamofire.request("https://www.hyemo.com/login", method: .post, parameters: PARAM)
                .validate()
                .responseJSON { response in
                    
                    //메인화면으로 이동한다
                    switch response.result {
                    case .success(let value):
                        do {
                            let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let parseResult = try JSONDecoder().decode(parse.self, from: data)
                            if(parseResult.Status == "200"){
                                LoginManager.sharedInstance.token = parseResult.Token!
                                LoginManager.sharedInstance.checkInfo = Bool(parseResult.Check!)!
                                
                                //로그인 성공
                                debugPrint("카카오 로그인 성공")
                                
                                //토큰을 저장
                                UserDefaults.standard.set(value, forKey:"idToken")
                                
                                //화면이동
                                if(!LoginManager.sharedInstance.checkInfo){
                                    debugPrint("기본정보 입력안되어있음")
                                    
                                    DeviceManager.sharedInstance.sendLog(content: "기본정보 입력페이지로 이동", type: self.type)
                                    
                                    guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "newInterestViewController") as? newInterestViewController else{
                                        return
                                    }
                                    
                                    RVC.modalPresentationStyle = .fullScreen
                                    
                                    //혜택 상세보기 페이지로 이동
                                    //self.present(RVC, animated: true, completion: nil)
                                    self.navigationController?.pushViewController(RVC, animated: true)
                                }else{
                                    debugPrint("기본정보 입력되어있음 메인페이지로 이동")
                                    let nickName : String = parseResult.nickName!
                                    
                                    if(nickName != ""){
                                        debugPrint("닉네임 저장: \(nickName)")
                                        UserDefaults.standard.set(nickName, forKey:"nickName")
                                    }
                                    
                                    DeviceManager.sharedInstance.sendLog(content: "메인페이지로 이동", type: self.type)
                                    self.dismiss(animated: true) {
                                    }
                                }
                            }
                        }
                        catch let DecodingError.dataCorrupted(context) {
                            debugPrint(context)
                        } catch let DecodingError.keyNotFound(key, context) {
                            debugPrint("Key '\(key)' not found:", context.debugDescription)
                            debugPrint("codingPath:", context.codingPath)
                        } catch let DecodingError.valueNotFound(value, context) {
                            debugPrint("Value '\(value)' not found:", context.debugDescription)
                            debugPrint("codingPath:", context.codingPath)
                        } catch let DecodingError.typeMismatch(type, context)  {
                            debugPrint("Type '\(type)' mismatch:", context.debugDescription)
                            debugPrint("codingPath:", context.codingPath)
                        } catch {
                            debugPrint("error: ", error)
                        }
                    case .failure(let error):
                        debugPrint(error)
                    }
                }//resoponse 종료괄호
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
            })
        })
    }
    
    
    @objc func GoogleLoginAction() {
        
        //브라우저로 카카오톡을 연다, 토큰받은경우와 에러가 난경우를
        debugPrint("구글로그인 버튼클릭")
        self.view.addSubview(self.activityIndicator)
    }
    
    
    //url여는 메소드
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
        debugPrint("url여는 메소드")
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        debugPrint("url여는 메소드")
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    //프로토콜
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            debugPrint("뷰 컨트롤: 구글로그인 에러", error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        debugPrint("뷰컨트롤:구글로그인 성공")
        
        
        //로그인에 성공하면 사용자 정보를 이용해 firebase에
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                debugPrint("유저정보들고오기 실패", error)
                return
            }
            
            
            //구글로그인정보를 이용해서 파이어베이스에 인증하고
            let user = Auth.auth().currentUser
            if let user = user {
                let email:String? = user.email
                debugPrint("뷰 컨트롤: 유저정보들고오기 성공")
                                
                // 파이어베이스에서 받아온 정보를 almofire를 이용해서 서버로 전송한다.
                
                //로그인 성공알림
                
                //로그인 절차가 진행되는 동안 로딩바를 띄어준다.
                
                //로딩바를 종료해준다.
                self.activityIndicator.stopAnimating()
                
                guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "mapTestViewController")  else{return}
                uvc.modalPresentationStyle = .fullScreen
                self.present(uvc, animated: true, completion: nil)
                UserDefaults.standard.set(email!, forKey:"email")
            }//user 언랩핑
        }//파이어베이스 인증괄호
    }//프로토콜 메소드 종료
    
    
    //애플 로그인 메소드
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
            print("handleAuthorizationAppleIDButtonPress")
        }
    }
    
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        debugPrint("authorizationController")
        let userToken = UserDefaults.standard.string(forKey: "fcmToken")!
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let userEmail = appleIDCredential.email
            
            //보안상의 문제로 이름과 이메일 모두 첫 로그인시만 받아올 수 잇다..
            switch authorization.credential {
            
            case let appleIdCredential as ASAuthorizationAppleIDCredential:
                if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
                    debugPrint("첫 로그인")
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
                    Alamofire.request("https://www.hyemo.com/login", method: .post, parameters: PARAM)
                        .validate()
                        .responseJSON { [self] response in
                            
                            //메인화면으로 이동한다
                            switch response.result {
                            case .success(let value):
                                do {
                                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                                    let parseResult = try JSONDecoder().decode(parse.self, from: data)
                                    if(parseResult.Status == "200"){
                                        LoginManager.sharedInstance.token = parseResult.Token!
                                        LoginManager.sharedInstance.checkInfo = Bool(parseResult.Check!)!
                                        //로그인 성공
                                        debugPrint("애플 로그인 성공")
                                        
                                        //토큰을 저장
                                        UserDefaults.standard.set(value, forKey:"idToken")
                                        
                                        //화면이동
                                        if(!LoginManager.sharedInstance.checkInfo){
                                            DeviceManager.sharedInstance.sendLog(content: "기본정보 입력페이지로 이동",type: self.type)
                                            debugPrint("기본정보 입력페이지로 이동")
                                            
                                            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "newInterestViewController") as? newInterestViewController else{
                                                return
                                            }
                                            
                                            RVC.modalPresentationStyle = .fullScreen
                                            
                                            self.navigationController?.pushViewController(RVC, animated: true)
                                        }else{
                                            debugPrint("메인페이지로 이동")
                                            
                                            let nickName : String = parseResult.nickName!
                                            
                                            if(nickName != ""){
                                                debugPrint("닉네임 저장: \(nickName)")
                                                UserDefaults.standard.set(nickName, forKey:"nickName")
                                            }
                                            
                                            DeviceManager.sharedInstance.sendLog(content: "메인페이지로 이동", type: self.type)
                                            self.dismiss(animated: true) {
                                            }
                                        }
                                    }
                                }
                                catch let DecodingError.dataCorrupted(context) {
                                    debugPrint(context)
                                } catch let DecodingError.keyNotFound(key, context) {
                                    debugPrint("Key '\(key)' not found:", context.debugDescription)
                                    debugPrint("codingPath:", context.codingPath)
                                } catch let DecodingError.valueNotFound(value, context) {
                                    debugPrint("Value '\(value)' not found:", context.debugDescription)
                                    debugPrint("codingPath:", context.codingPath)
                                } catch let DecodingError.typeMismatch(type, context)  {
                                    debugPrint("Type '\(type)' mismatch:", context.debugDescription)
                                    debugPrint("codingPath:", context.codingPath)
                                } catch {
                                    debugPrint("error: ", error)
                                }
                            case .failure(let error):
                                debugPrint(error)
                            }
                        }
                } else {
                    debugPrint("로그인 했었음")
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
                    Alamofire.request("https://www.hyemo.com/login", method: .post, parameters: PARAM)
                        .validate()
                        .responseJSON { response in
                            
                            //메인화면으로 이동한다
                            switch response.result {
                            case .success(let value):
                                do {
                                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                                    let parseResult = try JSONDecoder().decode(parse.self, from: data)
                                    if(parseResult.Status == "200"){
                                        LoginManager.sharedInstance.token = parseResult.Token!
                                        LoginManager.sharedInstance.checkInfo = Bool(parseResult.Check!)!
                                        
                                        //로그인 성공
                                        debugPrint("애플 로그인 성공")
                                        //토큰을 저장
                                        UserDefaults.standard.set(value, forKey:"idToken")
                                        
                                        //화면이동
                                        if(!LoginManager.sharedInstance.checkInfo){
                                            DeviceManager.sharedInstance.sendLog(content: "기본정보 입력페이지로 이동", type: self.type)
                                            debugPrint("기본정보 입력페이지로 이동")
                                            
                                            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "newInterestViewController") as? newInterestViewController else{
                                                return
                                            }
                                            
                                            RVC.modalPresentationStyle = .fullScreen
                                            
                                            //혜택 상세보기 페이지로 이동
                                            //self.present(RVC, animated: true, completion: nil)
                                            self.navigationController?.pushViewController(RVC, animated: true)
                                        }else{
                                            var nickName : String = parseResult.nickName!
                                            debugPrint("닉네임 정보: \(nickName)")
                                            
                                            if(nickName != ""){
                                                debugPrint("닉네임 저장: \(nickName)")
                                                UserDefaults.standard.set(nickName, forKey:"nickName")
                                            }
                                            
                                            debugPrint("메인페이지로 이동")
                                            
                                            DeviceManager.sharedInstance.sendLog(content: "메인페이지로 이동", type: self.type)
                                            self.dismiss(animated: true) {
                                            }
                                        }
                                    }
                                }
                                catch let DecodingError.dataCorrupted(context) {
                                    debugPrint(context)
                                } catch let DecodingError.keyNotFound(key, context) {
                                    debugPrint("Key '\(key)' not found:", context.debugDescription)
                                    debugPrint("codingPath:", context.codingPath)
                                } catch let DecodingError.valueNotFound(value, context) {
                                    debugPrint("Value '\(value)' not found:", context.debugDescription)
                                    debugPrint("codingPath:", context.codingPath)
                                } catch let DecodingError.typeMismatch(type, context)  {
                                    debugPrint("Type '\(type)' mismatch:", context.debugDescription)
                                    debugPrint("codingPath:", context.codingPath)
                                } catch {
                                    debugPrint("error: ", error)
                                }
                            case .failure(let error):
                                debugPrint(error)
                            }
                        }
                }
            default:
                break
            }
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
//            let username = passwordCredential.user
//            let password = passwordCredential.password
        }
    }
}
