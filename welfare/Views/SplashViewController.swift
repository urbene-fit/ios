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
        
        //서버통신
        Alamofire.request("https://www.urbene-fit.com/login", method: .post, parameters: parameters)
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
                            
                            print("로그인 성공")
                            print("관심사 입력여부:\(parseResult.Check!)")
                            print("로그인 아이디 : \(parseResult.login_id)")
                            LoginManager.sharedInstance.memberGetSession()
                            
                            moveMain()
                        }else{
                            moveMain()
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
    
    
    func moveMain(){
        print("메인이동")
        //로그인 및 기본정보 입력여부 체크후 메인화면으로 이동
        
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
        print("스플래쉬")
        
        
        //이정표(메인/다른페이지)로 이동
        var check = UserDefaults.standard.string(forKey: "check")
        var platform = UserDefaults.standard.string(forKey: "platform")
        var identifier = UserDefaults.standard.string(forKey: "identifier")
        var fcmToken = UserDefaults.standard.string(forKey: "fcmToken")
        
        
        //로그인을 한 적 없으면
        if(platform == nil){
            print("비로그인 상태")
            
            moveMain()
            LoginManager.sharedInstance.getSession()
            
            //애플로그인인지 다른로그인지에 따라 구분해서 확인한다.
        }else if(platform == "apple"){
            print("ios자동 로그인함")
            
            PARAM = [ "platform":platform!, "identifier":check!, "fcm_token":fcmToken!,"osType": "ios"]
            
            Login(parameters: PARAM)
            // 다른 플랫폼의 경우
        }else{
            // print("다른 플랫폼 자동 로그인함")
            PARAM = ["platform":platform!,"email":check!, "fcm_token":fcmToken!,"osType": "ios"]
            
            Login(parameters: PARAM)
        }
    }
}
