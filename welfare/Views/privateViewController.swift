/*
 회원 개인정보 및 설정을 할 수 있는 뷰
 화면구성 ;
 네비 바 (네비 바 타이틀)
 
 계정 프로필
 계정 이름
 사용 SNs계정
 --- 이상 정보들을 수정할 수 있는 버튼
 줄
 계정설정 라벨 및   버튼
 푸쉬알림 설정 라벨 및  버튼
 혜택 유형 라벨 및  버튼
 위치기반 서비스 이용약관 라벨 및 버튼
 개인정보처리방침 라벨 및 버튼
 버전정보 라벨 및 버전정보표시
 */


import UIKit
import Alamofire
import UserNotifications
import FirebaseMessaging



class privateViewController: UIViewController, MessagingDelegate {
    
    //푸쉬허용여부를 저장하는 불린변수
    var is_push : Bool = false
    
    let pushSwicth = UISwitch()
    
    private var observer: NSObjectProtocol?
    
    //푸쉬알림을 설정하러 갔는지를 체크
    var pushSet : Bool = false
    
    //푸쉬설정 결과 알림
    var pushResultAlert = UIAlertController()
    
    //세팅하러가는거 묻는 다이얼로그
    var setAlert = UIAlertController()
    
    
    //푸쉬허용 여부를 보여주는 스위치버튼
    var pushBtn = UIButton()
    
    
    //사용자 정보 라벨
    var snsLabel = UILabel()
    var profileLabel = UILabel()
    
    
    //사용자 정보를 저장하는 변수
    var platform = String()
    var nickName = String()
    
    
    // viewDidAppear: 뷰가 화면에 나타난 직후에 실행, 화면에 적용될 애니메이션을 그려줌, 네비게이션 컨트롤러 변경
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("개인정보 화면 - viewDidAppear")
        
        // 네비게이션 UI 생성
        setBarButton()
        
        //옵저버 등록
        setOb()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("개인정보 화면 - viewWillAppear")
        
        
        if(LoginManager.sharedInstance.token != ""){
            debugPrint("로그인 상태")
            
            setBasic()
            setLogoutBtn()
            setUserInfo()
        }else{
            //로그인을 한상태면 개인정보를 표시해준다.
            debugPrint("비 로그인 상태")
            
            setNonMember()
            setLoginBtn()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("개인정보 페이지")
        
        //네비바 백버튼 설정
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    
    @objc func goAgreement() {
        
        //이용약관으로 이동
        debugPrint("이용약관 버튼 클릭")
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "clauseViewController") as? clauseViewController else{
            return
        }
        
        // 개인정보처리방침화면으로 이동
        // 뷰 이동
        RVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(RVC, animated: true)
    }
    
    
    //개인정보처리방침 또는 이용약관으로 이동
    @objc func alert(_ sender: UIButton) {
        
        //이용약관으로 이동
        if(sender.tag == 1){
            debugPrint("이용약관 버튼 클릭")
            
            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "clauseViewController") as? clauseViewController else{
                return
            }
            
            //뷰 이동
            RVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(RVC, animated: true)
        }else{
            //개인정보처리방침화면으로 이동
            debugPrint("개인정보처리방침화면으로 버튼 클릭")
            
            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicyViewController") as? privacyPolicyViewController else{
                return
            }
            
            //뷰 이동
            RVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(RVC, animated: true)
        }
    }
    
    
    //푸쉬허용을 변경했을 경우
    @objc func push() {
        debugPrint("푸쉬 스위치 변동")
        
        
        if let appSettings = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
            if UIApplication.shared.canOpenURL(appSettings) {
                self.pushSet = true
                debugPrint("푸쉬셋 \(pushSet)")
                UIApplication.shared.open(appSettings)
            }
        }
    }
    
    
    private func setBarButton() {
        debugPrint("ReViewViewController의 setBarButton")
        
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        
        let naviLabel = UILabel()
        naviLabel.frame = CGRect(x: 63.8, y: 235.4, width: 118, height: 17.3)
        naviLabel.textAlignment = .center
        naviLabel.textColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        naviLabel.text = "UrBene_Fit"
        naviLabel.font = UIFont(name: "Bowhouse-Black", size: 30  *  DeviceManager.sharedInstance.heightRatio)
        self.navigationController?.navigationBar.topItem?.titleView = naviLabel
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        debugPrint("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"),
                                        object: nil, userInfo: dataDict)
        //fcm 토큰을 디바이스에 저장
        UserDefaults.standard.set(fcmToken, forKey:"fcmToken")
    }
    
    
    func makePsubAlert(resultText : String) {
        pushResultAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "Jalnan", size: 18 *  DeviceManager.sharedInstance.heightRatio)!, NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 69/255, green: 65/255, blue: 65/255, alpha: 1)]
        // let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "Jalnan", size: 22)!]
        let titleString = NSAttributedString(string: "알림수신 설정 안내", attributes: titleAttributes)
        
        pushResultAlert.setValue(titleString, forKey: "attributedTitle")
        
        let customView = UIView()
        
        var dateLabel = UILabel()
        dateLabel.frame = CGRect(x: 15 *  DeviceManager.sharedInstance.widthRatio, y: 15 *  DeviceManager.sharedInstance.heightRatio, width: 50 *  DeviceManager.sharedInstance.widthRatio, height: 25 *  DeviceManager.sharedInstance.heightRatio)
        
        //폰트지정 추가
        dateLabel.text = "일시:"
        dateLabel.font = UIFont(name: "Jalnan", size: 14 *  DeviceManager.sharedInstance.heightRatio)
        dateLabel.textColor =  #colorLiteral(red: 0.2880122675, green: 0.3258484275, blue: 0.5296835343, alpha: 1)
        customView.addSubview(dateLabel)
        
        //현재날짜
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        var current_date_string = formatter.string(from: Date())
        
        var currentDate = UILabel()
        currentDate.frame = CGRect(x: 95 *  DeviceManager.sharedInstance.widthRatio, y: 15 *  DeviceManager.sharedInstance.heightRatio, width: 150 *  DeviceManager.sharedInstance.widthRatio, height: 25 *  DeviceManager.sharedInstance.heightRatio)
        currentDate.text = current_date_string
        currentDate.font = UIFont(name: "Jalnan", size: 14 *  DeviceManager.sharedInstance.heightRatio)
        customView.addSubview(currentDate)
        
        
        var sendLabel = UILabel()
        sendLabel.frame = CGRect(x: 15 *  DeviceManager.sharedInstance.widthRatio, y: 45 *  DeviceManager.sharedInstance.heightRatio, width: 50 *  DeviceManager.sharedInstance.widthRatio, height: 25 *  DeviceManager.sharedInstance.heightRatio)
        
        //폰트지정 추가
        sendLabel.text = "전송자:"
        sendLabel.font = UIFont(name: "Jalnan", size: 14 *  DeviceManager.sharedInstance.heightRatio)
        sendLabel.textColor =  #colorLiteral(red: 0.2880122675, green: 0.3258484275, blue: 0.5296835343, alpha: 1)
        customView.addSubview(sendLabel)
        
        var sendName = UILabel()
        sendName.frame = CGRect(x: 95 *  DeviceManager.sharedInstance.widthRatio, y: 45 *  DeviceManager.sharedInstance.heightRatio, width: 150 *  DeviceManager.sharedInstance.widthRatio, height: 25 *  DeviceManager.sharedInstance.heightRatio)
        
        //폰트지정 추가
        sendName.text = "너의혜택은 컴퍼니"
        sendName.font = UIFont(name: "Jalnan", size: 14 *  DeviceManager.sharedInstance.heightRatio)
        customView.addSubview(sendName)
        
        var result = UILabel()
        result.frame = CGRect(x: 30 *  DeviceManager.sharedInstance.widthRatio, y: 75 *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        
        //폰트지정 추가
        result.text = resultText
        result.font = UIFont(name: "Jalnan", size: 12 *  DeviceManager.sharedInstance.heightRatio)
        customView.addSubview(result)
        
        //커스텀 버튼 추가
        let customBtn = UIButton()
        
        pushResultAlert.view.addSubview(customView)
        pushResultAlert.view.addSubview(customBtn)
        
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: pushResultAlert.view.topAnchor, constant: 50 *  DeviceManager.sharedInstance.heightRatio).isActive = true
        customView.rightAnchor.constraint(equalTo: pushResultAlert.view.rightAnchor, constant: -10 *  DeviceManager.sharedInstance.widthRatio).isActive = true
        customView.leftAnchor.constraint(equalTo: pushResultAlert.view.leftAnchor, constant: 10 *  DeviceManager.sharedInstance.widthRatio).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 120 *  DeviceManager.sharedInstance.heightRatio).isActive = true
        
        customView.layer.cornerRadius = 13
        
        customBtn.translatesAutoresizingMaskIntoConstraints = false
        customBtn.topAnchor.constraint(equalTo: pushResultAlert.view.topAnchor, constant: 180 *  DeviceManager.sharedInstance.heightRatio).isActive = true
        customBtn.rightAnchor.constraint(equalTo: pushResultAlert.view.rightAnchor, constant: -20 *  DeviceManager.sharedInstance.widthRatio).isActive = true
        customBtn.leftAnchor.constraint(equalTo: pushResultAlert.view.leftAnchor, constant: 20 *  DeviceManager.sharedInstance.widthRatio).isActive = true
        customBtn.heightAnchor.constraint(equalToConstant: 50 *  DeviceManager.sharedInstance.heightRatio).isActive = true
        customBtn.layer.cornerRadius = 13
        customBtn.backgroundColor = #colorLiteral(red: 0.3109882898, green: 0.3137511945, blue: 0.4918305838, alpha: 1)
        
        customBtn.setTitle("확인", for: .normal)
        customBtn.titleLabel!.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        customBtn.setTitleColor(UIColor.white, for: .normal)
        customBtn.addTarget(self, action: #selector(self.dismissAlert), for: .touchUpInside)
        
        
        pushResultAlert.view.translatesAutoresizingMaskIntoConstraints = false
        pushResultAlert.view.heightAnchor.constraint(equalToConstant: 250 *  DeviceManager.sharedInstance.heightRatio).isActive = true
        
        customView.backgroundColor =  #colorLiteral(red: 0.9017364597, green: 0.9017364597, blue: 0.9017364597, alpha: 1)
        present(pushResultAlert, animated: false, completion: nil)
    }
    
    
    @objc func dismissAlert() {
        pushResultAlert.dismiss(animated: false, completion: nil)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("개인정보페이지의 view가 사라지기 전")
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint("개인정보페이지의 view가 사라짐")
        
        //다른 페이지로 이동시 알람 다이얼로그를 보여주지 않기 위해 백그라운드 포어그라운드 감지를 없앤다.
        NotificationCenter.default.removeObserver(observer)
    }
    
    
    func setSwitch() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                debugPrint("결정해주셈")
                
                DispatchQueue.main.async {
                    let image = UIImage(named: "switch_off")
                    let swicthiImg = UIImageView()
                    swicthiImg.setImage(image!)
                    swicthiImg.image = swicthiImg.image?.withRenderingMode(.alwaysTemplate)
                    swicthiImg.tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
                    swicthiImg.frame =  CGRect(x: 10 *  DeviceManager.sharedInstance.widthRatio, y: 0 , width: 60 *  DeviceManager.sharedInstance.widthRatio, height: 50 *  DeviceManager.sharedInstance.heightRatio)
                    self.pushBtn.subviews.forEach { $0.removeFromSuperview() }
                    self.pushBtn.addSubview(swicthiImg)
                }
            } else if settings.authorizationStatus == .denied {
                debugPrint("거절")
                
                DispatchQueue.main.async {
                    let image = UIImage(named: "switch_off")
                    let swicthiImg = UIImageView()
                    swicthiImg.setImage(image!)
                    swicthiImg.image = swicthiImg.image?.withRenderingMode(.alwaysTemplate)
                    swicthiImg.tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
                    swicthiImg.frame =  CGRect(x: 10 *  DeviceManager.sharedInstance.widthRatio, y: 0 , width: 60 *  DeviceManager.sharedInstance.widthRatio, height: 50 *  DeviceManager.sharedInstance.heightRatio)
                    self.pushBtn.subviews.forEach { $0.removeFromSuperview() }
                    self.pushBtn.addSubview(swicthiImg)
                }
            } else if settings.authorizationStatus == .authorized {
                debugPrint("허용")
                
                DispatchQueue.main.async {
                    let image = UIImage(named: "switch_on")
                    let swicthiImg = UIImageView()
                    swicthiImg.setImage(image!)
                    swicthiImg.image = swicthiImg.image?.withRenderingMode(.alwaysTemplate)
                    swicthiImg.tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
                    swicthiImg.frame =  CGRect(x: 10 *  DeviceManager.sharedInstance.widthRatio, y: 0 , width: 60 *  DeviceManager.sharedInstance.widthRatio, height: 50 *  DeviceManager.sharedInstance.heightRatio)
                    
                    
                    self.pushBtn.subviews.forEach { $0.removeFromSuperview() }
                    self.pushBtn.addSubview(swicthiImg)
                }
            }
        })
    }
    
    
    //로그인을 하지 않은 경우 로그인 페이지로 이동할 수 있는 버튼을 추가 한다.
    func setLoginBtn(){
        let loginBtn = UIButton()
        loginBtn.setTitle("로그인하러 가기", for: .normal)
        loginBtn.titleLabel!.font = UIFont(name: "Jalnan", size:16.1 *  DeviceManager.sharedInstance.heightRatio)
        loginBtn.layer.cornerRadius = 13 *  DeviceManager.sharedInstance.heightRatio
        loginBtn.layer.borderWidth = 1.3
        loginBtn.layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
        loginBtn.backgroundColor =  UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        loginBtn.tintColor =  UIColor.white
        loginBtn.addTarget(self, action: #selector(self.goLogin), for: .touchUpInside)
        loginBtn.frame = CGRect(x: 40 * DeviceManager.sharedInstance.widthRatio, y: 300 *  DeviceManager.sharedInstance.heightRatio , width: CGFloat(DeviceManager.sharedInstance.width) - 80 * DeviceManager.sharedInstance.widthRatio, height: 60 *  DeviceManager.sharedInstance.heightRatio)
        
        
        //카톡버튼은 커스텀 안됨.
        self.view.addSubview(loginBtn)
    }
    
    
    //로그아웃 버튼 추가
    func setLogoutBtn(){
        debugPrint("로그인 한상태")
        
        let LogOutBtn = UIButton()
        LogOutBtn.setTitle("로그아웃", for: .normal)
        LogOutBtn.titleLabel!.font = UIFont(name: "Jalnan", size:16.1 *  DeviceManager.sharedInstance.heightRatio)
        LogOutBtn.layer.cornerRadius = 13 *  DeviceManager.sharedInstance.heightRatio
        LogOutBtn.layer.borderWidth = 1.3
        LogOutBtn.layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
        LogOutBtn.backgroundColor =  UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        LogOutBtn.tintColor =  UIColor.white
        LogOutBtn.addTarget(self, action: #selector(self.LogOut), for: .touchUpInside)
        LogOutBtn.frame = CGRect(x: 40 * DeviceManager.sharedInstance.widthRatio, y: CGFloat(DeviceManager.sharedInstance.height) - (200 * DeviceManager.sharedInstance.heightRatio), width: CGFloat(DeviceManager.sharedInstance.width) - 80 * DeviceManager.sharedInstance.widthRatio, height: 60 *  DeviceManager.sharedInstance.heightRatio)
        
        
        //카톡버튼은 커스텀 안됨.
        self.view.addSubview(LogOutBtn)
    }
    
    
    //로그인한 경우 개인정보 화면의 유저의 정보를 보여준다.
    func setUserInfo(){
        debugPrint("유저정보 세팅")
        
        //디바이스에 저장된 로그인 플랫폼 정보를 이용하여 뷰에 반영해준다.
        var platform = UserDefaults.standard.string(forKey: "platform")
        if(platform == "apple"){
            platform = "애플 계정"
            snsLabel.text = platform!
        }else if(platform == "kakao"){
            platform = "카카오 계정"
            snsLabel.text = platform!
        }else{
            platform = "구글 계정"
            snsLabel.text = platform!
        }
        
        
        let nickName = UserDefaults.standard.string(forKey: "nickName")
        if (nickName != nil){
            profileLabel.text = nickName
        }
    }
    
    
    @objc func goLogin(_ sender: UIButton) {
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else{
            return
        }
        
        RVC.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(RVC, animated: true)
    }
    
    
    @objc func LogOut(_ sender: UIButton) {
        
        //디바이스에 저장된 로그인 정보를 모두 삭제한다
        UserDefaults.standard.removeObject(forKey: "platform")
        UserDefaults.standard.removeObject(forKey: "check")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "nickName")
        
        
        //싱글턴에 저장된 로그인정보도 삭제
        LoginManager.sharedInstance.nickName = ""
        LoginManager.sharedInstance.checkInfo = false
        LoginManager.sharedInstance.token = ""
        
        
        //첫화면으로 돌아간다.
        self.dismiss(animated: true) {
        }
    }
    
    
    //로그인상태일때 뷰
    func setBasic(){
        //상단 프로필 사진 및 프로필
        let profileimg = UIImageView(image:UIImage(named:"infoIcon"))
        profileimg.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 120 *  DeviceManager.sharedInstance.heightRatio, width: 80 *  DeviceManager.sharedInstance.widthRatio, height: 80 *  DeviceManager.sharedInstance.heightRatio)
        profileimg.layer.cornerRadius = profileimg.frame.height/2
        self.view.addSubview(profileimg)
        
        
        //프로필 라벨
        profileLabel.frame = CGRect(x: 120 *  DeviceManager.sharedInstance.widthRatio, y: 120 *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        profileLabel.font = UIFont(name: "Jalnan", size: 19 *  DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(profileLabel)
        
        
        //사용자 이용sns라벨
        snsLabel.frame = CGRect(x: 120 *  DeviceManager.sharedInstance.widthRatio, y: 140 *  DeviceManager.sharedInstance.heightRatio, width: 100 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        snsLabel.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
        snsLabel.font = UIFont(name: "Jalnan", size: 13 *  DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(snsLabel)
        
        //구분선
        let border = UIView()
        border.layer.borderColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1).cgColor
        border.layer.borderWidth = 10
        border.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 220 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(DeviceManager.sharedInstance.width - (40 *  DeviceManager.sharedInstance.widthRatio)), height: 1)
        self.view.addSubview(border)
        
        
        //계정설정
        let settingLabel = UILabel()
        settingLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 240  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        settingLabel.text = "개인정보 수정"
        settingLabel.font = UIFont(name: "Jalnan", size:19 *  DeviceManager.sharedInstance.heightRatio)
        
        
        let settingBtn = UIButton(type: .system)
        settingBtn.frame = CGRect(x: DeviceManager.sharedInstance.width - (70 * DeviceManager.sharedInstance.widthRatio), y: 240 *  DeviceManager.sharedInstance.heightRatio, width: 100 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(settingBtn)
        
        
        //푸쉬 알림 설정
        let pushLabel =  UIButton(type: .system)
        pushLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 240  *  DeviceManager.sharedInstance.heightRatio, width: 200 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        pushLabel.setTitle("푸쉬알림 설정", for: .normal)
        pushLabel.setTitleColor(UIColor.black, for: .normal)
        pushLabel.titleLabel?.font =  UIFont(name: "Jalnan", size: 19 *  DeviceManager.sharedInstance.heightRatio)
        pushLabel.contentHorizontalAlignment = .left
        pushLabel.addTarget(self, action: #selector(self.push), for: .touchUpInside)
        self.view.addSubview(pushLabel)
        
        
        pushBtn  = UIButton(type: .system)
        pushBtn.frame = CGRect(x: DeviceManager.sharedInstance.width - (80 * DeviceManager.sharedInstance.widthRatio), y: 230 *  DeviceManager.sharedInstance.heightRatio, width: 40 *  DeviceManager.sharedInstance.widthRatio, height: 50 *  DeviceManager.sharedInstance.heightRatio)
        
        
        //푸쉬 알림 스위치
        pushBtn.addTarget(self, action: #selector(self.push), for: .touchUpInside)
        
        
        //스위치버튼이미지 설정
        setSwitch()
        self.view.addSubview(pushBtn)
        
        
        //이용약관(위치)
        let locAgreementLabel = UIButton(type: .system)
        locAgreementLabel.frame   = CGRect(x: 20 * DeviceManager.sharedInstance.widthRatio, y: 310 *  DeviceManager.sharedInstance.heightRatio, width: 200  * DeviceManager.sharedInstance.widthRatio, height: 30  * DeviceManager.sharedInstance.heightRatio)
        locAgreementLabel.setTitle("이용약관", for: .normal)
        locAgreementLabel.setTitleColor(UIColor.black, for: .normal)
        locAgreementLabel.titleLabel?.font =  UIFont(name: "Jalnan", size: 19 *  DeviceManager.sharedInstance.heightRatio)
        locAgreementLabel.contentHorizontalAlignment = .left
        locAgreementLabel.tag = 1
        locAgreementLabel.addTarget(self, action: #selector(self.alert), for: .touchUpInside)
        self.view.addSubview(locAgreementLabel)
        
        
        let locBtn = UIButton(type: .system)
        locBtn.frame = CGRect(x: DeviceManager.sharedInstance.width - (70 * DeviceManager.sharedInstance.widthRatio), y: 310 *  DeviceManager.sharedInstance.heightRatio, width: 100 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        
        var locNextImg = UIImageView(image: UIImage(named: "next")!)
        locNextImg.frame =  CGRect(x: 10 *  DeviceManager.sharedInstance.widthRatio, y: 0 , width: 30 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        locBtn.addSubview(locNextImg)
        locBtn.tag = 1
        locBtn.addTarget(self, action: #selector(self.alert), for: .touchUpInside)
        self.view.addSubview(locBtn)
        
        
        //(개인정보)
        let policyLabel = UIButton(type: .system)
        policyLabel.frame  = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 380 *  DeviceManager.sharedInstance.heightRatio, width: 200 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        policyLabel.contentHorizontalAlignment = .left
        policyLabel.setTitle("개인정보처리방침", for: .normal)
        policyLabel.setTitleColor(UIColor.black, for: .normal)
        policyLabel.titleLabel?.font =  UIFont(name: "Jalnan", size: 19 *  DeviceManager.sharedInstance.heightRatio)
        policyLabel.tag = 2
        policyLabel.addTarget(self, action: #selector(self.alert), for: .touchUpInside)
        self.view.addSubview(policyLabel)
        
        let policyBtn = UIButton(type: .system)
        policyBtn.frame = CGRect(x: DeviceManager.sharedInstance.width - (70 * DeviceManager.sharedInstance.widthRatio), y: 380 *  DeviceManager.sharedInstance.heightRatio, width: 100 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        
        var policyNextImg = UIImageView(image: UIImage(named: "next")!)
        policyNextImg.frame =  CGRect(x: 10 *  DeviceManager.sharedInstance.widthRatio, y: 0 , width: 30 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        policyBtn.addSubview(policyNextImg)
        policyBtn.addTarget(self, action: #selector(self.alert), for: .touchUpInside)
        policyBtn.tag = 2
        self.view.addSubview(policyBtn)
        
        //버전정보
        let versionLabel = UILabel()
        versionLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 450 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        versionLabel.text = "버전정보                                            1.0.0"
        versionLabel.font = UIFont(name: "Jalnan", size: 19 *  DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(versionLabel)
    }
    
    
    //비회원 화면 세팅
    func setNonMember() {
        
        //푸쉬 알림 설정
        let pushLabel =  UIButton(type: .system)
        pushLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 120  *  DeviceManager.sharedInstance.heightRatio, width: 120 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        pushLabel.setTitle("푸쉬알림 설정", for: .normal)
        pushLabel.setTitleColor(UIColor.black, for: .normal)
        pushLabel.titleLabel?.font =  UIFont(name: "Jalnan", size: 19 *  DeviceManager.sharedInstance.heightRatio)
        pushLabel.addTarget(self, action: #selector(self.push), for: .touchUpInside)
        pushLabel.contentHorizontalAlignment = .left
        self.view.addSubview(pushLabel)
        
        pushBtn  = UIButton(type: .system)
        pushBtn.frame = CGRect(x: DeviceManager.sharedInstance.width - (80 * DeviceManager.sharedInstance.widthRatio), y: 110 *  DeviceManager.sharedInstance.heightRatio, width: 40 *  DeviceManager.sharedInstance.widthRatio, height: 50 *  DeviceManager.sharedInstance.heightRatio)
        
        
        //푸쉬 알림 스위치
        pushBtn.addTarget(self, action: #selector(self.push), for: .touchUpInside)
        
        
        //스위치버튼이미지 설정
        setSwitch()
        self.view.addSubview(pushBtn)
        
        
        //버전정보
        let versionLabel = UILabel()
        versionLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 190 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        versionLabel.text = "버전정보                                            1.0.0"
        versionLabel.font = UIFont(name: "Jalnan", size: 19 *  DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(versionLabel)
    }
    
    
    //알람설정후 개인정보설정화면으로 돌아올경우를 감지하기 위해
    func setOb(){
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) {
            [unowned self] notification in
            // background에서 foreground로 돌아오는 경우 실행 될 코드
            debugPrint("privateViewController - 개인정보 foreground로 돌아오는 경우 ")
            
            
            if(pushSet){
                pushSet = false
                
                //푸쉬허용변경여부를 서버에 보낸다.
                var parameters = Parameters()
                //대리자 선언
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (result, Error) in
                    debugPrint(result)
                    
                    
                    let current = UNUserNotificationCenter.current()
                    current.getNotificationSettings(completionHandler: { (settings) in
                        if settings.authorizationStatus == .notDetermined {
                            debugPrint("결정해주셈")
                            DispatchQueue.main.async {
                                makePsubAlert(resultText: "앱 푸쉬알림 수신을 거절했습니다.")
                                setSwitch()
                            }
                        } else if settings.authorizationStatus == .denied {
                            debugPrint("거절")
                            DispatchQueue.main.async {
                                setSwitch()
                                makePsubAlert(resultText: "앱 푸쉬알림 수신을 거절했습니다.")
                            }
                        } else if settings.authorizationStatus == .authorized {
                            debugPrint("허용")
                            DispatchQueue.main.async {
                                setSwitch()
                                makePsubAlert(resultText: "앱 푸쉬알림 수신을 허용했습니다.")
                            }
                        }
                    })
                }
                
                
                //로그인 되어있을 경우에만
                if(LoginManager.sharedInstance.token != ""){
                    if(pushSwicth.isOn){
                        //허용일경우
                        parameters = ["login_token": LoginManager.sharedInstance.token,"is_push" : "true"]
                    }else{
                        //아닐경우
                        parameters = ["login_token": LoginManager.sharedInstance.token,"is_push" : "false"]
                    }
                    
                    Alamofire.request("https://www.urbene-fit.com/user", method: .put, parameters: parameters)
                        .validate()
                        .responseJSON { [self] response in
                            switch response.result {
                            case .success(let value):
                                
                                if let json = value as? [String: Any] {
                                    for (key, value) in json {
                                        debugPrint("key:",key,", value:",value)
                                        if(key == "is_push"){
                                            debugPrint("푸쉬변경: \(value)")
                                        }
                                    }
                                }
                            case .failure(let error):
                                debugPrint("Error: \(error)")
                                break
                            }
                        }
                }
            }else if(LoginManager.sharedInstance.push){
                debugPrint("푸쉬알람으로 진입")
                LoginManager.sharedInstance.push = false
                
                self.dismiss(animated: true) {
                }
            }
        }
    }
}
