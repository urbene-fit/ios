//
//  newInfoViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/12/29.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Alamofire

class newInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {
   
    
    
    
    private let genderValues: [String] = ["남자","여자"]
    private let areaValues: [String] = ["지역선택","서울","경기","강원","인천","제주","부산","경남","대구","경북","울산","대전","충남","충북","광주","전남","전북"]
    
    var alert = UIAlertController()

    
    // 메인 세로 스크롤
    let m_Scrollview = UIScrollView()
    let nickNameField = UITextField()
    let ageField = UITextField()
    let genderView = UIView()
    let areaView = UIView()
    
    //선택한 성별
    var selectedGender : String = ""
    //선택한 지역
    var selectedArea : String = ""

    //터치이벤트 인식변수
    var singleTapGestureRecognizer = UITapGestureRecognizer()
    
    //기본정보 입력후 서버로부터 받는 키워드들을 파싱하는 구조체
    struct parse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
        let Message : [keyWordList]
    }
    
    struct keyWordList: Decodable {
       let interest : String
       
        
    }
    
    
    //성별 버튼 이미지를 관리하는 배열
    //키워드 버튼의 배열
    var buttons = [UIButton]()
    //키워드 버튼의 이미지 배열
    var imgViews = [UIImageView]()
    
    //네비게이션 컨트롤러 변경 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        DuViewController의 view가 사라짐
        //        ReViewViewController의 view가 화면에 나타남
        setBarButton()
    }

    //백버튼 감지(전페이지로 돌아가는거 감지)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            print("백버튼 감지")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //네비게이션 스택관리
        navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
            if vc.isKind(of: newInfoViewController.self) || vc.isKind(of: NewMainViewController.self) || vc.isKind(of: privateViewController.self) {
                return false
            } else {
                return true
            }
        })
        
        
        //상단 라벨
        let topLabel = UILabel()
        topLabel.frame = CGRect(x: 20 * DeviceManager.sharedInstance.widthRatio, y: 100 * DeviceManager.sharedInstance.heightRatio, width: 300 * DeviceManager.sharedInstance.widthRatio, height: 60 *  DeviceManager.sharedInstance.heightRatio)
        topLabel.backgroundColor = UIColor.clear
        topLabel.text = "맞춤혜택을 위한\n정보를 입력해주세요"
        topLabel.font = UIFont(name: "NanumBarunGothicBold", size: 26 * DeviceManager.sharedInstance.heightRatio)
        topLabel.numberOfLines  = 2
        self.view.addSubview(topLabel)

        //닉네임
        let nickNameLabel = UILabel()
        nickNameLabel.frame = CGRect(x: 20 * DeviceManager.sharedInstance.widthRatio, y: 220 * DeviceManager.sharedInstance.heightRatio, width: 180 * DeviceManager.sharedInstance.widthRatio, height: 20 *  DeviceManager.sharedInstance.heightRatio)
        nickNameLabel.backgroundColor = UIColor.clear
        nickNameLabel.text = "닉네임"
        nickNameLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        nickNameLabel.font = UIFont(name: "NanumGothicBold", size: 15 * DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(nickNameLabel)
        self.view.addSubview(nickNameLabel)
        
        //닉네임 입력 필드

        nickNameField.frame = CGRect(x: 20 * DeviceManager.sharedInstance.widthRatio, y: 255 * DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 40 * DeviceManager.sharedInstance.widthRatio, height: 30 * DeviceManager.sharedInstance.heightRatio)
        
        //밑줄용 추가레이어

        nickNameField.layer.addBorder(.bottom, color: UIColor.black, width: 1.0)
        
        //입력위치 설정
     //myField.beginFloatingCursor(at: CGPoint(x: 33.0 * DeviceManager.sharedInstance.widthRatio, y: 0))

        // 폰트
        nickNameField.font = UIFont(name: "Jalnan", size: 16 * DeviceManager.sharedInstance.heightRatio)

        
        //커스텀 키보드 설정
        nickNameField.delegate = self
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.doneBtnClicked))
        
        //toolBarKeyboard.items.rightBarButtonItem = btnDoneBar
        toolBarKeyboard.items = [btnDoneBar]
        toolBarKeyboard.tintColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)

        nickNameField.inputAccessoryView = toolBarKeyboard

        
        //입력한 숫자가 텍스트필드의 좌측에 붙지 않게 패딩을 준다.
        //myField.addLeftPadding()
        
        m_Scrollview.addSubview(nickNameField)
        self.view.addSubview(nickNameField)

        
        //나이
        let ageLabel = UILabel()
        ageLabel.frame = CGRect(x: 20 * DeviceManager.sharedInstance.widthRatio, y: 315 * DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - (40 * DeviceManager.sharedInstance.widthRatio), height: 20 *  DeviceManager.sharedInstance.heightRatio)
        ageLabel.backgroundColor = UIColor.clear
        ageLabel.text = "나이"
        ageLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        ageLabel.font = UIFont(name: "NanumGothicBold", size: 15 * DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(ageLabel)
        self.view.addSubview(ageLabel)
        
        //나이 입력 필드

        ageField.frame = CGRect(x: 20 * DeviceManager.sharedInstance.widthRatio, y: 350 * DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - (40 * DeviceManager.sharedInstance.widthRatio), height: 30 * DeviceManager.sharedInstance.heightRatio)
        
        
        //숫자 설정
        ageField.keyboardType = .numberPad
        ageField.inputAccessoryView = toolBarKeyboard


        //입력위치 설정
     //myField.beginFloatingCursor(at: CGPoint(x: 33.0 * DeviceManager.sharedInstance.widthRatio, y: 0))

        // 폰트
        ageField.font = UIFont(name: "Jalnan", size: 16 * DeviceManager.sharedInstance.heightRatio)
        ageField.layer.addBorder(.bottom, color: UIColor.black, width: 1.0)
        //입력한 숫자가 텍스트필드의 좌측에 붙지 않게 패딩을 준다.
        //myField.addLeftPadding()
        m_Scrollview.addSubview(ageField)
        self.view.addSubview(ageField)
     
        
        
        //성별
        let genderLabel = UILabel()
        genderLabel.frame = CGRect(x: 20 * DeviceManager.sharedInstance.widthRatio, y: 410 * DeviceManager.sharedInstance.heightRatio, width: 220 * DeviceManager.sharedInstance.widthRatio, height: 20 *  DeviceManager.sharedInstance.heightRatio)
        genderLabel.backgroundColor = UIColor.clear
        genderLabel.text = "성별"
        genderLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        genderLabel.font = UIFont(name: "NanumGothicBold", size: 15 * DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(genderLabel)
        self.view.addSubview(genderLabel)
        
        
        
        for i in 0..<2 {

        var button = UIButton(type: .system)
        var imgView = UIImageView()
        button.tag = i
        
        //
        buttons.append(button)
        imgViews.append(imgView)
            
            
            button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
            // button.frame = CGRect(x:22, y:Double(Int(175.2) * i/2) + 679.4, width: 177.4, height: 158.4)
            button.frame = CGRect(x:20 * DeviceManager.sharedInstance.widthRatio + (200 * CGFloat((i))) * DeviceManager.sharedInstance.widthRatio, y:450 * DeviceManager.sharedInstance.heightRatio, width: 200 * DeviceManager.sharedInstance.widthRatio, height: 31 * DeviceManager.sharedInstance.heightRatio)
            
            
            
            //이미지 및 라벨 추가
            let img = UIImage(named: "check")
            imgView.setImage(img!)
            imgView.frame = CGRect(x: 0, y: 0, width: 31 * DeviceManager.sharedInstance.widthRatio, height: 31 * DeviceManager.sharedInstance.heightRatio)
            //imgView.image = imgView.image?.withRenderingMode(.alwaysOriginal)
            
            imgView.layer.cornerRadius = imgView.frame.height/2
            imgView.layer.borderWidth = 1
            imgView.layer.borderColor = UIColor.clear.cgColor
            imgView.clipsToBounds = true
            
            
            button.addSubview(imgView)
            
            
            let gender = UILabel()
            gender.frame = CGRect(x: 51 * DeviceManager.sharedInstance.widthRatio, y: 0, width: 149 * DeviceManager.sharedInstance.widthRatio, height: 31 *  DeviceManager.sharedInstance.heightRatio)
            gender.backgroundColor = UIColor.clear
            gender.text = genderValues[i]
            //ageLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            gender.font = UIFont(name: "NanumGothicBold", size: 15 * DeviceManager.sharedInstance.heightRatio)
            
            button.addSubview(gender)

            
//            button.setTitleColor(UIColor.black, for: .normal)
//            button.backgroundColor = .white
            
           
            
            //카테고리에 사용되는 뷰들을 리스트로 관리해서 선택됫을경우 선탟된 카테고리의 뷰들
            //에 대해 변형해준다.
            
            
            self.view.addSubview(button)

        }
        
        
//        genderView.frame = CGRect(x: 20 * DeviceManager.sharedInstance.widthRatio, y: 455 * DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 40 * DeviceManager.sharedInstance.widthRatio, height: 30 * DeviceManager.sharedInstance.heightRatio)
//
//
//        //genderView.layer.borderWidth = 1
//        genderView.layer.addBorder(.bottom, color: UIColor.black, width: 1.0)
//
//        //성별 클릭시 성별을 선택할 수 있는 picker가 나오게 한다.
//
//
//        singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.genderPick))
//
//
//        singleTapGestureRecognizer.numberOfTapsRequired = 1
//
//        singleTapGestureRecognizer.isEnabled = true
//
//        singleTapGestureRecognizer.cancelsTouchesInView = false
//
//
//
//        genderView.addGestureRecognizer(singleTapGestureRecognizer)
//
//        m_Scrollview.addSubview(genderView)
//        self.view.addSubview(genderView)
        
        
        
        //지역선택
        let areaLabel = UILabel()
        areaLabel.frame = CGRect(x: 20 * DeviceManager.sharedInstance.widthRatio, y: 510 * DeviceManager.sharedInstance.heightRatio, width: 220 * DeviceManager.sharedInstance.widthRatio, height: 20 *  DeviceManager.sharedInstance.heightRatio)
        areaLabel.backgroundColor = UIColor.clear
        areaLabel.text = "지역"
        areaLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        areaLabel.font = UIFont(name: "NanumGothicBold", size: 15 * DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(areaLabel)
        self.view.addSubview(areaLabel)
        
        
        areaView.frame = CGRect(x: 20 * DeviceManager.sharedInstance.widthRatio, y: 545 * DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - (40 * DeviceManager.sharedInstance.widthRatio), height: 30 * DeviceManager.sharedInstance.heightRatio)
        
        
        //genderView.layer.borderWidth = 1
        areaView.layer.addBorder(.bottom, color: UIColor.black, width: 1.0)

        //성별 클릭시 성별을 선택할 수 있는 picker가 나오게 한다.
        
        
        singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.areaPick))
        

        singleTapGestureRecognizer.numberOfTapsRequired = 1

        singleTapGestureRecognizer.isEnabled = true

        singleTapGestureRecognizer.cancelsTouchesInView = false

        
        
        areaView.addGestureRecognizer(singleTapGestureRecognizer)
        
        m_Scrollview.addSubview(areaView)
        self.view.addSubview(areaView)
        
        
        
        
       
        
    }
    

   
    
    //네비게이션 바 세팅
    private func setBarButton() {
        print("ReViewViewController의 setBarButton")
        
       
//        self.navigationController?.navigationBar.topItem?.titleView = nil
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        
        
        let registerBtn = UIBarButtonItem(title: "등록", style: .done, target: self, action: #selector(completed))
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = registerBtn
        
        
    }
    
    
   
    
    //다른 부분 터치 입력 키보드 내리기
    func endEdit(){
        self.nickNameField.resignFirstResponder()//키보드 숨기기
        self.ageField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("다른 부분 터치")

        self.view.endEditing(true)
    }
    
    //성별
    @objc func genderPick(sender: UITapGestureRecognizer) {
        print("성별 선택")
    
        let pickerView = UIPickerView()
        pickerView.frame = CGRect(x: 15 * DeviceManager.sharedInstance.widthRatio, y: 90 * DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - (30 * DeviceManager.sharedInstance.widthRatio) , height: 130  * DeviceManager.sharedInstance.heightRatio)
        pickerView.tag = 1

        

        
            pickerView.backgroundColor = .white

            // Set the delegate.
            pickerView.delegate = self
            // Set the dataSource.
            pickerView.dataSource = self
   

           alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        

        let confirmBtn = UIButton(type: .system)
        confirmBtn.frame =  CGRect(x: 300 * DeviceManager.sharedInstance.widthRatio, y: 0, width: 100 * DeviceManager.sharedInstance.widthRatio , height: 50  * DeviceManager.sharedInstance.heightRatio)

        confirmBtn.setTitle("확인", for: .normal)
        confirmBtn.titleLabel!.font = UIFont(name: "Jalnan", size:14 * DeviceManager.sharedInstance.heightRatio)
        confirmBtn.setTitleColor(UIColor.black, for: .normal)
        confirmBtn.addTarget(self, action: #selector(self.dismissAlert), for: .touchUpInside)
        confirmBtn.tag = 1
        let customView = UIView()
        
        customView.addSubview(confirmBtn)

        customView.addSubview(pickerView)

        alert.view.addSubview(customView)
        
        
        

        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 0).isActive = true
        customView.rightAnchor.constraint(equalTo: alert.view.rightAnchor, constant: 0).isActive = true
        customView.leftAnchor.constraint(equalTo: alert.view.leftAnchor, constant:0).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 250 * DeviceManager.sharedInstance.heightRatio).isActive = true
        
     
        
        alert.view.translatesAutoresizingMaskIntoConstraints = false
        alert.view.widthAnchor.constraint(equalToConstant: DeviceManager.sharedInstance.width).isActive = true
        //alert.view.backgroundColor =  #colorLiteral(red: 0.9017364597, green: 0.9017364597, blue: 0.9017364597, alpha: 1)
        alert.view.heightAnchor.constraint(equalToConstant: 250 * DeviceManager.sharedInstance.heightRatio).isActive = true
        
        //customView.backgroundColor =  #colorLiteral(red: 0.9017364597, green: 0.9017364597, blue: 0.9017364597, alpha: 1)
        self.present(alert, animated: false, completion: nil)

        
    }
    
    //지역선택
    @objc func areaPick(sender: UITapGestureRecognizer) {
        let pickerView = UIPickerView()
        pickerView.frame = CGRect(x: 15 * DeviceManager.sharedInstance.widthRatio, y: 90 * DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - (30 * DeviceManager.sharedInstance.widthRatio) , height: 130  * DeviceManager.sharedInstance.heightRatio)
        pickerView.tag = 2

        

        
            pickerView.backgroundColor = .white

            // Set the delegate.
            pickerView.delegate = self
            // Set the dataSource.
            pickerView.dataSource = self
   

           alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        

        let confirmBtn = UIButton(type: .system)
        confirmBtn.frame =  CGRect(x: 300 * DeviceManager.sharedInstance.widthRatio, y: 0, width: 100 * DeviceManager.sharedInstance.widthRatio, height: 50  * DeviceManager.sharedInstance.heightRatio)

        confirmBtn.setTitle("확인", for: .normal)
        confirmBtn.titleLabel!.font = UIFont(name: "Jalnan", size:14 * DeviceManager.sharedInstance.heightRatio)
        confirmBtn.setTitleColor(UIColor.black, for: .normal)
        confirmBtn.addTarget(self, action: #selector(self.dismissAlert), for: .touchUpInside)
        confirmBtn.tag = 2
        let customView = UIView()
        
        customView.addSubview(confirmBtn)

        customView.addSubview(pickerView)

        alert.view.addSubview(customView)
        
        
        

        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 0).isActive = true
        customView.rightAnchor.constraint(equalTo: alert.view.rightAnchor, constant: 0).isActive = true
        customView.leftAnchor.constraint(equalTo: alert.view.leftAnchor, constant:0).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 250 * DeviceManager.sharedInstance.heightRatio).isActive = true
        
     
        
        alert.view.translatesAutoresizingMaskIntoConstraints = false
        alert.view.widthAnchor.constraint(equalToConstant: DeviceManager.sharedInstance.width).isActive = true
        //alert.view.backgroundColor =  #colorLiteral(red: 0.9017364597, green: 0.9017364597, blue: 0.9017364597, alpha: 1)
        alert.view.heightAnchor.constraint(equalToConstant: 250 * DeviceManager.sharedInstance.heightRatio).isActive = true
        
        //customView.backgroundColor =  #colorLiteral(red: 0.9017364597, green: 0.9017364597, blue: 0.9017364597, alpha: 1)
        self.present(alert, animated: false, completion: nil)
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 1:
            
            return genderValues.count
            break
            //지역선택인 경우
        case 2:
            return areaValues.count
            break
            
        default:
         
              
              
                return 0
            break
            
        }
           

        
        
         }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        
        //성별 선택일 경우
        switch pickerView.tag {
        case 1:
            
            var label = view as! UILabel?
            if label == nil {
                label = UILabel()
                label?.textAlignment = .center
            }
         

                label?.text = genderValues[row]
                 label?.font = UIFont(name: "Jalnan", size: 22 * DeviceManager.sharedInstance.heightRatio)
              
                return label!
            break
            //지역선택인 경우
        case 2:
            var label = view as! UILabel?
            if label == nil {
                label = UILabel()
                label?.textAlignment = .center
            }
         

                label?.text = areaValues[row]
                 label?.font = UIFont(name: "Jalnan", size: 22 * DeviceManager.sharedInstance.heightRatio)
              
                return label!
            
            break
            
        default:
            var label = view as! UILabel?
            if label == nil {
                label = UILabel()
                label?.textAlignment = .center
            }
         

              
              
                return label!
            break
            
        }
           

        
           

       }
    
    //선택한 성별을 저장
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //다른 부분 터치시 키보드를 화면에서 안보이게 한다.
       // self.myField.resignFirstResponder()//키보드 숨기기
        
        
        //성별선택괴 지역선택을 구분하기 위해 태그를 사용
//
//        if(pickerView.tag == 1){
//        print("row: \(row)")
//       // print("value: \(genderValues[row])")
//
//            if( genderValues[row] == "성별선택"){
//                selectedGender = ""
//            }else{
//
//
//            selectedGender = genderValues[row]
//        print("value: \(selectedGender)")
//            }
//            //지역선택인 경우
//        }else{
            
            if( areaValues[row] == "지역선택"){
                selectedArea = ""
            }else{

                
                selectedArea = areaValues[row]
            print("value: \(selectedArea)")
            }
            
            
       // }
        
    }
    
    
    
    @objc func dismissAlert(_ sender: UIButton) {

        //액션시트를 없애주고
        alert.dismiss(animated: false, completion: nil)
        
        //성별 선택일 경우
//        if (sender.tag == 1 ){
//
//            print("선택 성별 : \(selectedGender)")
//        //선택한 성별을 반영해주고 저장한다.
//        let genderLabel = UILabel()
//        genderLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
//        genderLabel.text = selectedGender
//            genderLabel.font = UIFont(name: "NanumGothicBold", size: 25 * DeviceManager.sharedInstance.heightRatio)
//
//
//            //이전에 선택한 내용이 있으면 삭제
//        for view in genderView.subviews{
//            view.removeFromSuperview()
//        }
//        genderView.addSubview(genderLabel)
//
//            //지역선택 일 경우
//        }else {
            //선택한 지역 반영
            let areaLabel = UILabel()
            areaLabel.frame = CGRect(x: 0, y: 0, width: 200 * DeviceManager.sharedInstance.widthRatio, height: 30 * DeviceManager.sharedInstance.heightRatio)
            areaLabel.text = selectedArea
            areaLabel.font = UIFont(name: "Jalnan", size: 16 * DeviceManager.sharedInstance.heightRatio)

            //이전에 선택한 내용이 있으면 삭제
            for view in areaView.subviews{
                view.removeFromSuperview()
            }
            areaView.addSubview(areaLabel)
            
            
        //}
    }
    
    
    
    @IBAction func doneBtnClicked (sender: Any) {
            //click action...
            self.view.endEditing(true)
        }

    
    
    
    //확인시 질문지 선택페이지로 이동하는 메소드
    @objc func completed(){
        print("질문지 페이지로 이동하는 버튼 클릭")
        
        //다른 부분 터치시 키보드를 화면에서 안보이게 한다.
        self.nickNameField.resignFirstResponder()//키보드 숨기기
        self.ageField.resignFirstResponder()
        
        
        //정보입력 확인 버튼을 누르면 필요한 정보들이 다 입력되었는지 체크
        var age = self.ageField.text!
        var nick = self.nickNameField.text!
        //나이를 애초에 입력하지 않은 경우 널값이 떠버림
        //나이를
//        guard let ageRange : Int = Int(age) else{
//            return
//        }
        
        //정보를 다 입력했을 경우 && 나이를 터무니 없는 숫자를 입력하지 않았을 경우&& ageRange < 120
        if(age != "" && selectedGender != "" && selectedArea != "" && nick != ""){
            
            print("나이:\(age), 지역:\(selectedArea), 성별:\(selectedGender)")
            

            
            let ageRange : Int = Int(age)!
            if(ageRange < 100){
            print("정보를 제대로 다 입력")
                //닉네임 임시저장
                UserDefaults.standard.set(nick, forKey:"nickName")


            //서버로 입력한 개인정보를 전송
                let parameters = ["login_token": LoginManager.sharedInstance.token, "nickName":nick,"age" : age, "gender" : selectedGender, "city" : selectedArea]

                
                
                Alamofire.request("https://www.urbene-fit.com/user", method: .post, parameters: parameters)
                    .validate()
                    .responseJSON { response in
                        
                        switch response.result {
                        case .success(let value):
                            
                            
                            
                            
                            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "tagSelectViewController") as? tagSelectViewController         else{

                                return

                            }
                            
                            print(value)
                            do {
                                let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                                let parseResult = try JSONDecoder().decode(parse.self, from: data)

                                print(parseResult.Message[0].interest)

                                let interestArr = parseResult.Message[0].interest.components(separatedBy: ",")

                                for i in 0..<interestArr.count {

                                    RVC.interst.append(interestArr[i])
                                    print(interestArr[i])

                                }
                                // 관심사 선택 페이지로 이동
                                            self.navigationController?.pushViewController(RVC, animated: true)
//

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
//



                           
                        case .failure(let error):
                            print(error)
                        }
                    }
                
                
//            //상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
//            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "interestViewController") as? interestViewController         else{
//
//                return
//
//            }
//
//            RVC.modalPresentationStyle = .fullScreen
//
//            // 관심사 선택 페이지로 이동
//           // self.present(RVC, animated: true, completion: nil)
//            self.navigationController?.pushViewController(RVC, animated: true)
                
                
                //나이를 장난으로 많이 입력한 경우
            }else{
                                let alert = UIAlertController(title: "기본 정보", message: "나이를 제대로 입력해주세요", preferredStyle: UIAlertController.Style.alert)
                                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
                                }
                                alert.addAction(okAction)
                
                                present(alert, animated: false, completion: nil)
            }
            
            //모든 정보를 입력하지 않은 경우
    
            
            
        }else if(age == "" ){
                let alert = UIAlertController(title: "기본 정보", message: "나이를  입력해주세요", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                alert.addAction(okAction)
                
                present(alert, animated: false, completion: nil)
            }else if(selectedGender == "" ){
                let alert = UIAlertController(title: "기본 정보", message: "성별을 선택해주세요", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                alert.addAction(okAction)
                
                present(alert, animated: false, completion: nil)
            }else if(selectedArea == "" ){
                let alert = UIAlertController(title: "기본 정보", message: "지역을 선택해주세요", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                alert.addAction(okAction)
                
                present(alert, animated: false, completion: nil)
            
            }else{
                let alert = UIAlertController(title: "기본 정보", message: "닉네임을 입력해주세요", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                alert.addAction(okAction)
                
                present(alert, animated: false, completion: nil)
            }
                //else if(ageRange > 120 ){
//                let alert = UIAlertController(title: "기본 정보", message: "나이를 제대로 입력해주세요", preferredStyle: UIAlertController.Style.alert)
//                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
//
//                }
//                alert.addAction(okAction)
//
//                present(alert, animated: false, completion: nil)
//            }
 
          
            
        
        
    }
    
    
    //성별선택
    @objc func selected(_ sender: UIButton) {

        
        
        
        //선택 해제하는 경우
        if(self.imgViews[sender.tag].layer.borderColor != UIColor.clear.cgColor){
            //선택해제
            self.imgViews[sender.tag].layer.borderColor = UIColor.clear.cgColor
            
            //선택한 성별에서 삭제
            selectedGender = ""

            
            let img = UIImage(named: "check")
            self.imgViews[sender.tag].setImage(img!)
            
        }else{
            //선택표시
            self.imgViews[sender.tag].layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
            let img = UIImage(named: "checked")
            self.imgViews[sender.tag].setImage(img!)
            //선택한 성별을 저장
            selectedGender = genderValues[sender.tag]

            
            //다른 성별 선택해제
            var tag = Int()
            if (sender.tag == 0){
                tag = 1
            }else{
                tag = 0

            }
            
            self.imgViews[tag].layer.borderColor = UIColor.clear.cgColor
            let secImg = UIImage(named: "check")
            self.imgViews[tag].setImage(secImg!)
            
        }
        
    }

    

}
extension CALayer {
    func addBorder(_ edge: UIRectEdge, color: UIColor, width: CGFloat) {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor;
            self.addSublayer(border)
        
    }
    
    
    


    
    func makePick(){
        
        
        
    }
    
}

