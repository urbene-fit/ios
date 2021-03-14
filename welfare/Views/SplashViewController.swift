/*
 루트화면으로 사용될 스플래쉬화면
 
 앱시작시/로딩시/FCM을 통해 들어올떄 사용되는 화면
 */

import UIKit
import Alamofire


class SplashViewController: UIViewController {
    
    
    //로그인 검증시 사용할 파라미터 값
    var PARAM = Parameters()
    
    //로그인 파싱
    struct parse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
        let Message : String
        var Token : String?
        var Check : String?
        var nickName : String?
        var login_id : Int?
    }
    
    
    //다른 기종에서 문제가 발생해서 viewdidappear 에서 구현
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        set()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //로그인
    func Login(parameters: Parameters){
        Alamofire.request("https://www.hyemo.com/login", method: .post, parameters: parameters)
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
                            
                            LoginManager.sharedInstance.loginId = parseResult.login_id!
                            
                            debugPrint("로그인 성공")
                            LoginManager.sharedInstance.memberGetSession()
                            
                            moveMain()
                        }else{
                            moveMain()
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
    
    
    //로그인 및 기본정보 입력여부 체크후 메인화면으로 이동
    func moveMain(){
        debugPrint("메인이동")
        
        let mainTabBar = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        mainTabBar.modalPresentationStyle = .fullScreen
        self.present(mainTabBar, animated: true, completion: nil)
    }
    
    
    func set(){
        self.view.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        
        let logoLabel = UILabel()
        logoLabel.frame = CGRect(x: 0, y: view.bounds.height/2 - 50, width: view.bounds.width, height: 100)
        logoLabel.textAlignment = .center
        logoLabel.textColor = UIColor.white
        logoLabel.text = "UrBene_Fit"
        logoLabel.font = UIFont(name: "Bowhouse-Black", size: 60  *  DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(logoLabel)
        debugPrint("스플래쉬")
        
        
        //이정표(메인/다른페이지)로 이동
        let check = UserDefaults.standard.string(forKey: "check")
        let platform = UserDefaults.standard.string(forKey: "platform")
        let fcmToken = UserDefaults.standard.string(forKey: "fcmToken")
        
        
        switch platform {
        case nil: // 비로그인 상태
            moveMain()
            LoginManager.sharedInstance.getSession()
        case "apple": // ios자동 로그인함
            PARAM = [ "platform":platform!, "identifier":check!, "fcm_token":fcmToken!,"osType": "ios"]
            Login(parameters: PARAM)
        default:// 다른 플랫폼의 경우
            PARAM = ["platform":platform!,"email":check!, "fcm_token":fcmToken!,"osType": "ios"]
            Login(parameters: PARAM)
        }
    }
}
