//  tagSelectViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/12/21.
//  Copyright © 2020 com. All rights reserved.


import UIKit
import Alamofire

class tagSelectViewController: UIViewController {
    
    //키워드 버튼의 배열
    var buttons = [UIButton]()
    //키워드 버튼의 이미지 배열
    var imgViews = [UIImageView]()
    
    var interst = [String]()
    
    // 메인 세로 스크롤
    let m_Scrollview = UIScrollView()
    
    //선택 및 해제한 키워드 관리하는 배열
    var keyWorlds = Array<String>()
    
    //받아온 키워드 갯수에 따라 UI를 조정하기 위한 변수
    var count : Int = 0
    
    
    struct parse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
        let Message : String
    }
    
    
    //네비게이션 컨트롤러 변경
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 네비게이션 UI 수정
        setBarButton()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        //화면크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 20, y: 0, width: screenWidth - 40, height: 70)
        titleLabel.textAlignment = .left
        
        
        //폰트지정 추가
        titleLabel.text = "당신과 관련있는 \n키워드들을 선택해주세요"
        titleLabel.font = UIFont(name: "NanumBarunGothicBold", size: 26)
        titleLabel.numberOfLines = 3
        m_Scrollview.addSubview(titleLabel)
        
        
        //키워드 선택 버튼
        count = interst.count
        for i in 0..<count {
            var button = UIButton(type: .system)
            var imgView = UIImageView()
            button.tag = i
            
            buttons.append(button)
            imgViews.append(imgView)
            
            
            // 홀짝을 구분
            if(i%2==0){
                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                button.frame = CGRect(x:22 * DeviceManager.sharedInstance.widthRatio, y:CGFloat((80 * i/2 + 120)) * DeviceManager.sharedInstance.heightRatio, width: 180 * DeviceManager.sharedInstance.widthRatio, height: 31 * DeviceManager.sharedInstance.heightRatio)
                button.setTitle(interst[i], for: .normal)
                
                
                //이미지 및 라벨 추가
                let img = UIImage(named: "check")
                imgView.setImage(img!)
                imgView.frame = CGRect(x: 0, y: 0, width: 31 * DeviceManager.sharedInstance.widthRatio, height: 31 * DeviceManager.sharedInstance.heightRatio)
                imgView.layer.cornerRadius = imgView.frame.height/2
                imgView.layer.borderWidth = 1
                imgView.layer.borderColor = UIColor.clear.cgColor
                imgView.clipsToBounds = true
                
                
                button.addSubview(imgView)
                button.setTitleColor(UIColor.black, for: .normal)
                button.backgroundColor = .white
                
                //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                
                
                //카테고리에 사용되는 뷰들을 리스트로 관리해서 선택됫을경우 선탟된 카테고리의 뷰들에 대해 변형해준다.
                m_Scrollview.addSubview(button)
                
                
                //짝수
            }else if(i != 0 && i%2==1){
                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                button.frame = CGRect(x:213 * DeviceManager.sharedInstance.widthRatio, y:CGFloat((80 * (i - 1)/2 + 120)) * DeviceManager.sharedInstance.heightRatio, width: 180 * DeviceManager.sharedInstance.widthRatio, height: 31 * DeviceManager.sharedInstance.heightRatio)
                
                button.setTitle(interst[i], for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
                
                
                //이미지 및 라벨 추가
                let img = UIImage(named: "check")
                imgView.setImage(img!)
                imgView.frame = CGRect(x: 0, y: 0, width: 31, height: 31)
                imgView.layer.cornerRadius = imgView.frame.height/2
                imgView.layer.borderWidth = 1
                imgView.layer.borderColor = UIColor.clear.cgColor
                imgView.clipsToBounds = true
                
                button.addSubview(imgView)
                
                
                //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                
                m_Scrollview.addSubview(button)
            }
        }
        
        //메인스크롤 뷰 추가
        m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        //태그숫자에 따라 스크롤뷰 길이 변동되게 추후 수정
        m_Scrollview.contentSize = CGSize(width:screenWidth, height: (Int(ceil(Double(count/2))) * 80) + 180)
        self.view.addSubview(m_Scrollview)
    }
    
    
    // 키워드 선택시
    @objc func selected(_ sender: UIButton) {
        
        //선택 해제하는 경우
        if(self.imgViews[sender.tag].layer.borderColor != UIColor.clear.cgColor){
            //선택해제
            self.imgViews[sender.tag].layer.borderColor = UIColor.clear.cgColor
            
            //키워드 리스트에서 삭제
            keyWorlds = keyWorlds.filter(){$0 != buttons[sender.tag].currentTitle}
            
            
            let img = UIImage(named: "check")
            self.imgViews[sender.tag].setImage(img!)
        }else{
            //선택표시
            self.imgViews[sender.tag].layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
            let img = UIImage(named: "checked")
            self.imgViews[sender.tag].setImage(img!)
            //선택한 키워드를 리스트에 추가
            keyWorlds.append(buttons[sender.tag].currentTitle!)
        }
    }
    
    
    //최종확인 버튼
    @objc func move(_ sender: UIButton) {
        debugPrint("확인 버튼")
        
        //키워드를 선택했을 경우
        if(keyWorlds.count > 0){
            
            //선택한 카테고리를 전송할 데이터로 파싱하여 옮긴다.
            let string = keyWorlds.joined(separator: "|")
            
            
            let parameters = ["login_token": LoginManager.sharedInstance.token,"type":"interest", "interest":string]
            Alamofire.request("https://www.urbene-fit.com/user", method: .put, parameters: parameters)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        do {
                            let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let result = try JSONDecoder().decode(parse.self, from: data)
                            
                            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewMainViewController") as? NewMainViewController         else{
                                return
                            }
                            
                            
                            if(result.Status == "200"){
                                
                                //키워드입력이 성공적으로 끝나면 메인에 반영해주기 위해 키워드입력이 됬다고 디바이스에 저장해준디.
                                LoginManager.sharedInstance.checkInfo = true
                                
                                //뷰 이동
                                RVC.modalPresentationStyle = .fullScreen

                                // 메인 뷰로 이동
                                self.dismiss(animated: true) {
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
        }else{
            let alert = UIAlertController(title: "알림", message: "하나이상의 키워드를 선택해주세요", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "확인", style: .cancel){
                (action : UIAlertAction) -> Void in
                alert.dismiss(animated: false)
            }
            
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //네비게이션 바 세팅
    private func setBarButton() {
        debugPrint("ReViewViewController의 setBarButton")
        
        
        //네비바 백버튼 설정
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.navigationController?.navigationBar.shadowImage = nil
        
        let registerBtn = UIBarButtonItem(title: "등록", style: .done, target: self, action: #selector(move))
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = registerBtn
    }
}
