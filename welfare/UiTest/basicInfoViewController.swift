//
//  basicInfoViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/11/16.
//  Copyright © 2020 com. All rights reserved.
//

//맞춤알람을 위한 사용자 개인정보를 받는 창
//우선 스크롤 뷰

import UIKit

class basicInfoViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource , UNUserNotificationCenterDelegate {
    

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return values.count }
    
    // Delegate method that returns the value to be displayed in the picker.
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//
//
//        return values[row] }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

           var label = view as! UILabel?
           if label == nil {
               label = UILabel()
               label?.textAlignment = .center
           }
        

               label?.text = values[row]
                label?.font = UIFont(name: "Jalnan", size: 22)
             
               return label!

        
           

       }
    
//    // A method called when the picker is selected.
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print("row: \(row)")
//        print("value: \(values[row])")
//
//    }
    
    
    
    let limitLength = 3

    
    //지역선택에 사용할 피커뷰
    var pickerView = UIPickerView()
    var picker2 = UIPickerView()
    
    private let values: [String] = ["지역선택","서울","경기","강원","인천","제주","부산","경남","대구","경북","울산","대전","충남","충북","광주","전남","전북"]
    let areas: [String] = ["서울","경기","강원","인천","제주","부산","경남","대구","경북","울산","대전","충남","충북","광주","전남","전북"]
    
    let subAreas: [String] = ["예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시","예시"]
    
    //지역 선택버튼들을 담을 배열
    var buttons = [UIButton]()
    //하위개념의 지역선택버튼들을 저장하는 자료구조
    var subBtns = [UIButton]()
    
    
    ///클릭한 번호
    var k : Int = 0
    
    //클릭했던 번호
    var clicked : Int = 0
    
    //로고
    let appLogo = UIImageView()
    //헤더
    let header = UIView()
    let headerLabel = UILabel()
    //최하단 확인 버튼
    let enterBtn = UIButton()
    
    // 메인 세로 스크롤
    let m_Scrollview = UIScrollView()
    
    //성별 선택버튼들을 담을 배열
    var sexBtns = [UIButton]()
    //남녀 이미지와 라벨을 관리하는 배열
    //카테고리 이미지뷰드를 담을 배열
    var sexImgs = [UIImageView]()
    //카테고리 라벨을 담을 배열
    var sexLabels = [UILabel]()
    
    
    //사용자가 나이,성별,지역을 입력하면 저장하는 변수
    var age : String = ""
    var gender : String = ""
    var district : String = ""

    //나이 입력하는 부분
    let myField = PastelessTextField()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let center = UNUserNotificationCenter.current()
        
        center.delegate = self
        
        //화면 스크롤 크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        
        print("테스트")
        print(screenWidth)

        //임시 디바이스 크기별 레이아웃 조정
        if(screenWidth == 375){
        
        
        //상단 라벨 고민
        //맞춤알림을 받기 위한 당신의 정보를 입력해주세요
        //맞춤알림을 받아보세요
        
        let LogoImg = UIImage(named: "appLogo")
        appLogo.image = LogoImg
        appLogo.frame = CGRect(x: 22.1, y: 26.7, width: 106, height: 14.3)
        self.view.addSubview(appLogo)
        //m_Scrollview.addSubview(appLogo)
        
        
        //헤더에 무슨화면인지 설명
        header.frame = CGRect(x: 0, y: Int(67.7), width: screenWidth, height: 66)
        
        //추후 그라데이션 적용
        header.backgroundColor = UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1)
        
        //헤더라벨
        headerLabel.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 66)
        headerLabel.textColor = UIColor.white
        //폰트지정 추가
        
        headerLabel.text = "당신이 놓치고있는 혜택은?"
        headerLabel.numberOfLines = 2
        
        //라벨 줄간격 조절
        let attrString = NSMutableAttributedString(string: headerLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        headerLabel.attributedText = attrString
        headerLabel.textAlignment = .center
        
        
        headerLabel.font = UIFont(name: "Jalnan", size: 22)
        // inquiryLabel.font = UIFont(name: "NanumGothicBold", size: 13.7)
        header.addSubview(headerLabel)
        self.view.addSubview(header)
        
        //나이 입력(숫자만 입력가능)
        //타이틀 라벨
        //            let ageInput = UITextField()
        //            ageInput.frame = CGRect(x: 0, y: 100, width: 200, height: 200)
        //ageInput.keyboardType = .numberPad
        // Set Delegate to itself
        
        //titleLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
        //폰트지정 추가
        
        //정보를 입력하라는 라벨
        let mainLabel = UILabel()
        mainLabel.frame = CGRect(x: 0, y: 160, width: screenWidth, height: 30)
        mainLabel.textAlignment = .center
        //titleLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
        //폰트지정 추가
        
        mainLabel.text = "당신의 나이,성별,거주지역을 입력해주세요"
        mainLabel.font = UIFont(name: "Jalnan", size: 16.7)
        
        self.view.addSubview(mainLabel)
        
        //나이(만) 라벨
        let firstAge = UILabel()
        firstAge.frame = CGRect(x: 122.5, y: 240, width: 30, height: 30)
        //firstAge.frame = CGRect(x: 5, y: 15, width: 30, height: 30)

        firstAge.textAlignment = .left
        //titleLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
        //폰트지정 추가
        
        firstAge.text = "만"
        firstAge.font = UIFont(name: "Jalnan", size: 17)
        

      self.view.addSubview(firstAge)
        //m_Scrollview.addSubview(firstAge)
        
        myField.frame = CGRect(x: 162.5, y: 220, width: 70, height: 70)
        //var myField: UITextField = UITextField (frame:CGRect(x: screenWidth/2 - 60, y: 220, width: 120, height: 60))
        //m_Scrollview.addSubview(myField)
        myField.layer.cornerRadius = 3.3
        myField.layer.borderWidth = 1
         //myField.layer.borderColor =  UIColor(displayP3Red: 72/255.0, green:18/255.0, blue: 165/255.0, alpha: 1).cgColor
        myField.clipsToBounds = true
        myField.keyboardType = .numberPad
        
        //입력위치 설정
     myField.beginFloatingCursor(at: CGPoint(x: 30.0, y: 0))

        //숫자입력 폰트
        myField.font = UIFont(name: "Jalnan", size: 22)

        //입력한 숫자가 텍스트필드의 좌측에 붙지 않게 패딩을 준다.
        myField.addLeftPadding()

        
        
     
        
        //나이(세) 라벨
        let secLabel = UILabel()
        //secLabel.frame = CGRect(x: 60, y: 15, width: 30, height: 30)
        secLabel.frame = CGRect(x: 222.5, y: 240, width: 30, height: 30)

        secLabel.textAlignment = .right
        //폰트지정 추가
        
        secLabel.text = "세"
        //secLabel.textColor = UIColor(displayP3Red: 251/255.0, green: 251/255.0, blue: 251/255.0, alpha: 1)
        secLabel.font = UIFont(name: "Jalnan", size: 17)
        
//        myField.addSubview(firstAge)
//
//        myField.addSubview(secLabel)
        
        self.view.addSubview(secLabel)
        //m_Scrollview.addSubview(secLabel)
        self.myField.delegate = self
             self.view.addSubview(myField)
       //checkMaxLength(textField: myField, maxLength: 4)

        
        // myField.becomeFirstResponder()
        
        
        //성별 선택
        //성별 라벨
        let sexLabel = UILabel()
        sexLabel.frame = CGRect(x: 20, y: 200, width: 30, height: 30)
        sexLabel.textAlignment = .center
        //폰트지정 추가
        
        sexLabel.text = "성별"
        sexLabel.font = UIFont(name: "TTCherryblossomR", size: 17)
        
        //self.view.addSubview(sexLabel)
        //m_Scrollview.addSubview(sexLabel)
        
        //성별 선택 버튼
        
        //남자
        var manBtn = UIButton(type: .system)
        
        //manBtn.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
        manBtn.frame = CGRect(x:25, y: 305, width: Int(150), height: 130)
        //button.setTitle(LabelName[i], for: .normal)
        //이미지 및 라벨 추가
        let manImg = UIImage(named: "man")
        var manImgView = UIImageView()
        
        manImgView.setImage(manImg!)
        manImgView.frame = CGRect(x: 55, y: 38.1, width: 38.8, height: 38.8)
        manImgView.image = manImgView.image?.withRenderingMode(.alwaysOriginal)
        
        
        //라벨
        var manLabel = UILabel()
        
        manLabel.frame = CGRect(x: 40, y: 88, width: 55, height: 18.7)
        manLabel.textAlignment = .center
        
        //폰트지정 추가
        manLabel.text = "남자"
            manLabel.font = UIFont(name: "Jalnan", size: 16.1)
        
        //각 성별을 나타내는 라벨과 이미지뷰를 각각 관리해주는 자료구조에 추가한다.
        sexLabels.append(manLabel)
        sexImgs.append(manImgView)
        
        
        manBtn.addSubview(manImgView)
        manBtn.addSubview(manLabel)
        
        
        manBtn.setTitleColor(UIColor.black, for: .normal)
        manBtn.backgroundColor = .white
        manBtn.layer.cornerRadius = 14
        manBtn.layer.borderWidth = 2.7
        manBtn.layer.borderColor = UIColor.white.cgColor
        
        //성별 선택시 선택한 성별을 저장해주는 메소드
        manBtn.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
        manBtn.tag = 0
        sexBtns.append(manBtn)
        
        self.view.addSubview(manBtn)
        //m_Scrollview.addSubview(manBtn)
        
        //여자
        var womanBtn = UIButton(type: .system)
        
        womanBtn.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
        womanBtn.frame = CGRect(x:200, y: 305, width: Int(150), height: 130)
        //button.setTitle(LabelName[i], for: .normal)
        //이미지 및 라벨 추가
        let womanImg = UIImage(named: "woman")
        var womanImgView = UIImageView()
        
        womanImgView.setImage(womanImg!)
        womanImgView.frame = CGRect(x: 50, y: 34.7, width: 35.3, height: 35.3)
        womanImgView.image = womanImgView.image?.withRenderingMode(.alwaysOriginal)
        
        
        //라벨
        var womanLabel = UILabel()
        
        womanLabel.frame = CGRect(x: 40, y: 80, width: 50, height: 17)
        womanLabel.textAlignment = .center
        
        //폰트지정 추가
        womanLabel.text = "여자"
        womanLabel.font = UIFont(name: "Jalnan", size: 14.7)
        
        
        //각 성별을 나타내는 라벨과 이미지뷰를 각각 관리해주는 자료구조에 추가한다.
        sexLabels.append(womanLabel)
        sexImgs.append(womanImgView)
        
        womanBtn.addSubview(womanImgView)
        womanBtn.addSubview(womanLabel)
        
        
        womanBtn.setTitleColor(UIColor.black, for: .normal)
        womanBtn.backgroundColor = .white
        womanBtn.layer.cornerRadius = 14
        womanBtn.layer.borderWidth = 2.7
        womanBtn.layer.borderColor = UIColor.white.cgColor
        womanBtn.tag = 1
        sexBtns.append(womanBtn)
        //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
        //womanBtn.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
        
        
        self.view.addSubview(womanBtn)
        // m_Scrollview.addSubview(womanBtn)
        
        
        //지역선택
        //시,도,구.군,동,읍,면 구분
        var areaLabel = UILabel()
        
        areaLabel.frame = CGRect(x: 0, y: 370, width: Double(screenWidth), height: 20)
        areaLabel.textAlignment = .left
        
        //폰트지정 추가
        areaLabel.text = "지역선택"
        areaLabel.font = UIFont(name: "Jalnan", size: 14.7)
        //self.view.addSubview(areaLabel)
        // m_Scrollview.addSubview(areaLabel)
        
        
        //상위지역 선택버튼 추가하는 부분
        //        for i in 0..<10 {
        //            var button = UIButton(type: .system)
        //
        //            //홀수번호
        //            if(i%2==0){
        //                buttons.append(button)
        //
        //                button.tag = i
        //                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
        //                button.frame = CGRect(x:20, y:380 + Double(Int(50) * i/2), width: 161.3, height: 50)
        //                button.setTitle(areas[i], for: .normal)
        //                button.setTitleColor(UIColor.black, for: .normal)
        //                button.backgroundColor = .white
        //                button.layer.cornerRadius = 14
        //                button.layer.borderWidth = 2.7
        //                button.layer.borderColor = UIColor.white.cgColor
        //                m_Scrollview.addSubview(button)
        //
        //                //짝수번호
        //            }else if(i != 0 && i%2==1){
        //                buttons.append(button)
        //
        //                button.tag = i
        //                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
        //                button.frame = CGRect(x:193.7, y:380 + Double(Int(50) * (i - 1)/2), width: 161.3, height: 50)
        //                button.setTitle(areas[i], for: .normal)
        //                button.setTitleColor(UIColor.black, for: .normal)
        //                button.backgroundColor = .white
        //                button.layer.cornerRadius = 14
        //                button.layer.borderWidth = 2.7
        //                button.layer.borderColor = UIColor.white.cgColor
        //                m_Scrollview.addSubview(button)
        //
        //            }
        //
        //
        //
        //
        //        }
        
        
        //스피너 추가
        let label: UILabel = UILabel.init(frame: CGRect(x: 20, y: 0, width: 50, height: 30))
        label.text = "시/도"
        label.textAlignment = .center
        //pickerView.addSubview(label)
        // Specify the size.
        pickerView.frame = CGRect(x: 50, y: 445, width: screenWidth - 100, height: Int(100.0))
        // Set the backgroundColor.
        
        pickerView.layer.borderWidth = 2.3
        pickerView.layer.cornerRadius = 14

        pickerView.layer.borderColor =  UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1).cgColor

        pickerView.backgroundColor = .white
        
       
        
        // Set the delegate.
        pickerView.delegate = self
        // Set the dataSource.
        pickerView.dataSource = self
        
        // m_Scrollview.addSubview(self.pickerView)
        self.view.addSubview(pickerView)
        
        //최종확인 버튼
        
        
        
        
        enterBtn.setTitle("확인", for: .normal)
        enterBtn.frame = CGRect(x: 20, y: screenHeight - 60, width: 335, height: Int(53.7))
        
        enterBtn.titleLabel!.font = UIFont(name: "Jalnan", size:17)
        enterBtn.layer.cornerRadius = 4.3
        enterBtn.layer.borderWidth = 1.3
        enterBtn.backgroundColor = UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1)
        enterBtn.layer.borderColor =  UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1).cgColor
        //선택결과 페이지로 이동하는 메소드
        enterBtn.addTarget(self, action: #selector(self.move), for: .touchUpInside)
        
        self.view.addSubview(enterBtn)
        
        
        //메인 스크롤뷰를 기본뷰에 추가해준다.
        //        m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        //        m_Scrollview.contentSize = CGSize(width:screenWidth, height: 1747)
        //        self.view.addSubview(m_Scrollview)
        //
        
            
            //임시 실제디바이스 크기별 레이아웃 조정
        }else{
         
            
            //상단 라벨 고민
            //맞춤알림을 받기 위한 당신의 정보를 입력해주세요
            //맞춤알림을 받아보세요
            
            let LogoImg = UIImage(named: "appLogo")
            appLogo.image = LogoImg
            appLogo.frame = CGRect(x: 25, y: 45, width: 116.6, height: 16)
            self.view.addSubview(appLogo)
            //m_Scrollview.addSubview(appLogo)
            
            
            //헤더에 무슨화면인지 설명
            header.frame = CGRect(x: 0, y: Int(80), width: screenWidth, height: Int(100))
            
            //추후 그라데이션 적용
            header.backgroundColor = UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1)
            
            //헤더라벨
            headerLabel.frame = CGRect(x: 0, y: 0, width: screenWidth, height: Int(100))
            headerLabel.textColor = UIColor.white
            //폰트지정 추가
            
            headerLabel.text = "당신이 놓치고있는 혜택은?"
            headerLabel.numberOfLines = 2
            
            //라벨 줄간격 조절
            let attrString = NSMutableAttributedString(string: headerLabel.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            headerLabel.attributedText = attrString
            headerLabel.textAlignment = .center
            
            
            headerLabel.font = UIFont(name: "Jalnan", size: 28)
            // inquiryLabel.font = UIFont(name: "NanumGothicBold", size: 13.7)
            header.addSubview(headerLabel)
            self.view.addSubview(header)
            
            //나이 입력(숫자만 입력가능)
            //타이틀 라벨
            //            let ageInput = UITextField()
            //            ageInput.frame = CGRect(x: 0, y: 100, width: 200, height: 200)
            //ageInput.keyboardType = .numberPad
            // Set Delegate to itself
            
            //titleLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
            //폰트지정 추가
            
            //정보를 입력하라는 라벨
            let mainLabel = UILabel()
            mainLabel.frame = CGRect(x: 0, y: 191, width: screenWidth, height: 40)
            mainLabel.textAlignment = .center
            //titleLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
            //폰트지정 추가
            
            mainLabel.text = "당신의 나이,성별,거주지역을 입력해주세요"
            mainLabel.font = UIFont(name: "Jalnan", size: 19)
            
            self.view.addSubview(mainLabel)
            
            //나이(만) 라벨
            let firstAge = UILabel()
            firstAge.frame = CGRect(x: 142.7, y: 270, width: 33, height: 33)
            //firstAge.frame = CGRect(x: 5, y: 15, width: 30, height: 30)

            firstAge.textAlignment = .left
            //titleLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
            //폰트지정 추가
            
            firstAge.text = "만"
            firstAge.font = UIFont(name: "Jalnan", size: 19)
            

          self.view.addSubview(firstAge)
            //m_Scrollview.addSubview(firstAge)
            
            myField.frame = CGRect(x: 171.5, y: 252, width: 71, height: 71)
            //var myField: UITextField = UITextField (frame:CGRect(x: screenWidth/2 - 60, y: 220, width: 120, height: 60))
            //m_Scrollview.addSubview(myField)
            myField.layer.cornerRadius = 3.3
            myField.layer.borderWidth = 1
             //myField.layer.borderColor =  UIColor(displayP3Red: 72/255.0, green:18/255.0, blue: 165/255.0, alpha: 1).cgColor
            myField.clipsToBounds = true
            myField.keyboardType = .numberPad
            
            //입력위치 설정
         myField.beginFloatingCursor(at: CGPoint(x: 33.0, y: 0))

            //숫자입력 폰트
            myField.font = UIFont(name: "Jalnan", size: 25)

            //입력한 숫자가 텍스트필드의 좌측에 붙지 않게 패딩을 준다.
            myField.addLeftPadding()

            
            
         
            
            //나이(세) 라벨
            let secLabel = UILabel()
            //secLabel.frame = CGRect(x: 60, y: 15, width: 30, height: 30)
            secLabel.frame = CGRect(x: 237.7, y: 270, width: 33, height: 33)

            secLabel.textAlignment = .right
            //폰트지정 추가
            
            secLabel.text = "세"
            //secLabel.textColor = UIColor(displayP3Red: 251/255.0, green: 251/255.0, blue: 251/255.0, alpha: 1)
            secLabel.font = UIFont(name: "Jalnan", size: 19)
            
    //        myField.addSubview(firstAge)
    //
    //        myField.addSubview(secLabel)
            
            self.view.addSubview(secLabel)
            //m_Scrollview.addSubview(secLabel)
            self.myField.delegate = self
                 self.view.addSubview(myField)
           //checkMaxLength(textField: myField, maxLength: 4)

            
            // myField.becomeFirstResponder()
            
            
            //성별 선택
            //성별 라벨
            let sexLabel = UILabel()
            sexLabel.frame = CGRect(x: 22, y: 220, width: 33, height: 33)
            sexLabel.textAlignment = .center
            //폰트지정 추가
            
            sexLabel.text = "성별"
            sexLabel.font = UIFont(name: "TTCherryblossomR", size: 18.7)
            
            //self.view.addSubview(sexLabel)
            //m_Scrollview.addSubview(sexLabel)
            
            //성별 선택 버튼
            
            //남자
            var manBtn = UIButton(type: .system)
            
            //manBtn.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
            manBtn.frame = CGRect(x:20, y: 350, width: Int(161), height: 187)
            //button.setTitle(LabelName[i], for: .normal)
            //이미지 및 라벨 추가
            let manImg = UIImage(named: "man")
            var manImgView = UIImageView()
            
            manImgView.setImage(manImg!)
            manImgView.frame = CGRect(x: 25, y: 25, width: 111, height: 136)
            manImgView.image = manImgView.image?.withRenderingMode(.alwaysOriginal)
            
            
            //라벨
            var manLabel = UILabel()
            
            manLabel.frame = CGRect(x: 13, y: 161, width: 136, height: 25)
            manLabel.textAlignment = .center
            
            //폰트지정 추가
            manLabel.text = "남자"
            manLabel.font = UIFont(name: "Jalnan", size: 16.1)
            
            //각 성별을 나타내는 라벨과 이미지뷰를 각각 관리해주는 자료구조에 추가한다.
            sexLabels.append(manLabel)
            sexImgs.append(manImgView)
            
            
            manBtn.addSubview(manImgView)
            manBtn.addSubview(manLabel)
            
            
            manBtn.setTitleColor(UIColor.black, for: .normal)
            manBtn.backgroundColor = .white
            manBtn.layer.cornerRadius = 14
            manBtn.layer.borderWidth = 2.7
            manBtn.layer.borderColor = UIColor.white.cgColor
            
            //성별 선택시 선택한 성별을 저장해주는 메소드
            manBtn.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
            manBtn.tag = 0
            sexBtns.append(manBtn)
            
            self.view.addSubview(manBtn)
            //m_Scrollview.addSubview(manBtn)
            
            //여자
            var womanBtn = UIButton(type: .system)
            
            womanBtn.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
            womanBtn.frame = CGRect(x:220,  y: 350, width: Int(161), height: 187)
            //button.setTitle(LabelName[i], for: .normal)
            //이미지 및 라벨 추가
            let womanImg = UIImage(named: "woman")
            var womanImgView = UIImageView()
            
            womanImgView.setImage(womanImg!)
            womanImgView.frame = CGRect(x: 25, y: 25, width: 111, height: 136)

            
            womanImgView.image = womanImgView.image?.withRenderingMode(.alwaysOriginal)
            
            
            //라벨
            var womanLabel = UILabel()
            
            womanLabel.frame = CGRect(x: 13, y: 161, width: 136, height: 25)
            womanLabel.textAlignment = .center
            
            //폰트지정 추가
            womanLabel.text = "여자"
            womanLabel.font = UIFont(name: "Jalnan", size: 16.1)
            
            
            //각 성별을 나타내는 라벨과 이미지뷰를 각각 관리해주는 자료구조에 추가한다.
            sexLabels.append(womanLabel)
            sexImgs.append(womanImgView)
            
            womanBtn.addSubview(womanImgView)
            womanBtn.addSubview(womanLabel)
            
            
            womanBtn.setTitleColor(UIColor.black, for: .normal)
            womanBtn.backgroundColor = .white
            womanBtn.layer.cornerRadius = 14
            womanBtn.layer.borderWidth = 2.7
            womanBtn.layer.borderColor = UIColor.white.cgColor
            womanBtn.tag = 1
            sexBtns.append(womanBtn)
            //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
            //womanBtn.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
            
            
            self.view.addSubview(womanBtn)
            // m_Scrollview.addSubview(womanBtn)
            
            
            //지역선택
            //시,도,구.군,동,읍,면 구분
            var areaLabel = UILabel()
            
            areaLabel.frame = CGRect(x: 0, y: 407, width: Double(screenWidth), height: 22)
            areaLabel.textAlignment = .left
            
            //폰트지정 추가
            areaLabel.text = "지역선택"
            areaLabel.font = UIFont(name: "Jalnan", size: 17.7)
            //self.view.addSubview(areaLabel)
            // m_Scrollview.addSubview(areaLabel)
            
            
            
            //스피너 추가
            let label: UILabel = UILabel.init(frame: CGRect(x: 22, y: 0, width: 55, height: 33))
            label.text = "시/도"
            label.textAlignment = .center
            //pickerView.addSubview(label)
            // Specify the size.
            pickerView.frame = CGRect(x: 50, y: 580, width: screenWidth - 100, height: Int(150.0))
            // Set the backgroundColor.
            
            pickerView.layer.borderWidth = 2.3
            pickerView.layer.cornerRadius = 14

            pickerView.layer.borderColor =  UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1).cgColor

            pickerView.backgroundColor = .white
            
           
            
            // Set the delegate.
            pickerView.delegate = self
            // Set the dataSource.
            pickerView.dataSource = self
            
            // m_Scrollview.addSubview(self.pickerView)
            self.view.addSubview(pickerView)
            
            //최종확인 버튼
            
            
            
            
            enterBtn.setTitle("확인", for: .normal)
            enterBtn.frame = CGRect(x: 22, y: screenHeight - 100, width: screenWidth - 44, height: Int(66))
            
            enterBtn.titleLabel!.font = UIFont(name: "Jalnan", size:16.1)
            enterBtn.layer.cornerRadius = 4.3
            enterBtn.layer.borderWidth = 1.3
            enterBtn.backgroundColor = UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1)
            enterBtn.layer.borderColor =  UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1).cgColor
            //선택결과 페이지로 이동하는 메소드
            enterBtn.addTarget(self, action: #selector(self.move), for: .touchUpInside)
            
            self.view.addSubview(enterBtn)
            
            
            
            
            
        }
            
            
        
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //텍스트 필드 포커스 받을시 키보드 나오는 메소드
    
    
    
    
    //키보드 delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField.isEqual(self.myField)){ //titleField에서 리턴키를 눌렀다면
            self.myField.becomeFirstResponder()//컨텐츠필드로 포커스 이동
        }
        return true
    }
    
    func endEdit(){
        self.myField.resignFirstResponder()//키보드 숨기기
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //성별선택시
    @objc func selected(_ sender: UIButton) {
        
        //다른 부분 터치시 키보드를 화면에서 안보이게 한다.
        self.myField.resignFirstResponder()//키보드 숨기기
        
        var remove : Int
        //다른 성별을 해제하기 위해 반대되는 성별의 태그값을 저장한다.
        if(sender.tag == 0){
         remove = 1
        }else{
        remove = 0
        }
        
        //선택 해제하는 경우
        if(self.sexBtns[sender.tag].backgroundColor == UIColor(displayP3Red: 72/255.0, green:18/255.0, blue: 165/255.0, alpha: 1)){
            
            gender = ""

            sexImgs[sender.tag].image = sexImgs[sender.tag].image?.withRenderingMode(.alwaysOriginal)
            
            sexLabels[sender.tag].textColor = UIColor.black
            sexBtns[sender.tag].backgroundColor = UIColor.white
            sexBtns[sender.tag].setTitleColor(UIColor.black, for: .normal)
            sexBtns[sender.tag].layer.borderColor = UIColor.white.cgColor
            
            
            
            
            //선택하는 경우
        }else if(self.sexBtns[sender.tag].backgroundColor == UIColor.white){
            
            //성별 저장
            gender = sexLabels[sender.tag].text!
            sexImgs[sender.tag].tintColor = UIColor.white
            sexImgs[sender.tag].image = sexImgs[sender.tag].image?.withRenderingMode(.alwaysTemplate)
            
            sexLabels[sender.tag].textColor = UIColor.white
            sexBtns[sender.tag].backgroundColor = UIColor(displayP3Red: 72/255.0, green:18/255.0, blue: 165/255.0, alpha: 1)
            sexBtns[sender.tag].layer.borderColor = UIColor(displayP3Red: 72/255.0, green:18/255.0, blue: 165/255.0, alpha: 1).cgColor
            
            //다른 성별을 선택해제한다.
            sexImgs[remove].image = sexImgs[remove].image?.withRenderingMode(.alwaysOriginal)
                 
                 sexLabels[remove].textColor = UIColor.black
                 sexBtns[remove].backgroundColor = UIColor.white
                 sexBtns[remove].setTitleColor(UIColor.black, for: .normal)
                 sexBtns[remove].layer.borderColor = UIColor.white.cgColor
            
            
            
        }
        
        
    }
    
    
    //확인시 질문지 선택페이지로 이동하는 메소드
    @objc func move(_ sender: UIButton) {
        print("질문지 페이지로 이동하는 버튼 클릭")
        
        //다른 부분 터치시 키보드를 화면에서 안보이게 한다.
        self.myField.resignFirstResponder()//키보드 숨기기

        
        
        //정보입력 확인 버튼을 누르면 필요한 정보들이 다 입력되었는지 체크
        age = self.myField.text!
        

        
        
        //정보를 다 입력했을 경우
        if(age != "" && gender != "" && district != "" ){
            
            
            //상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "interestViewController") as? interestViewController         else{
                
                return
                
            }
            
            RVC.modalPresentationStyle = .fullScreen
            
            // 관심사 선택 페이지로 이동
           // self.present(RVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(RVC, animated: true)

            
            
            //모든 정보를 입력하지 않은 경우
        }else{
            let alert = UIAlertController(title: "기본 정보", message: "기본정보를 다 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            alert.addAction(okAction)
            
            present(alert, animated: false, completion: nil)
            
            
        }
        
    }
    
    //선택한 거주지역을 저장
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //다른 부분 터치시 키보드를 화면에서 안보이게 한다.
        self.myField.resignFirstResponder()//키보드 숨기기
        
        print("row: \(row)")
        print("value: \(values[row])")
        
        if(values[row] != "지역선택"){
            district = values[row]
        }
        
    }
    
    
    //광역시 지역을 클릭했을때
    //광역시 관활의 시/군/구를 보여주는 메소드
    
    //한 줄에 2개의 광역시 지역이 있으며,
    //예를 들어 첫번째 줄에 서울, 경기가 있고 이 지역들을 자료구조에서 0,1번의 번호로 관리한다.
    //서울을 클릭하면 0번을 클릭한거지만 서울의 시/군/구는 첫번째 줄과 두번째 줄 사이에 추가 되기때문에
    //두번째 줄에 위치한 광역시 지역(예를 들어 강원,제주) 강원,제주부터 추가될 시/군/구를 고려하여 다시 배치해준다.
    
    //예를 들어 세번째 줄에 제주와 부산이 있는데, 첫번째 줄에 속한 서울을 누른 후
    //제주와 부산을 다시 누르면 서울을 누르면서 1)그 아래라인에 추가되었던 시/군/구를 삭제 해준다.
    //2)그리고 2번째 줄에 위치한
    
    
    //    @objc func selected(_ sender: UIButton) {
    //        print("버튼 클릭")
    //        //기준점
    //        if(sender.tag%2==0){
    //            k = sender.tag+1
    //        }else{
    //            k = sender.tag
    //
    //        }
    //
    //        //지역선택버튼이 처음 클릭되는건지 2번째 선택되는지도 구분
    //
    //
    //        //만약 이전에 상위지역버튼을 클릭했었으면
    //        //다시 재배치해준다.
    //        if(clicked>0){
    //
    //            //선택된 버튼된 하단의 버튼들을 삭제해주고 재추가 해준다.
    //            for subview in m_Scrollview.subviews {
    //
    //
    //
    //                if subview is UIButton && subview.tag > clicked { subview.removeFromSuperview()
    //                }
    //
    //
    //
    //            }
    //
    //            //하단에 다시 상위지역 선택버튼 추가하는 부분
    //
    //            clicked += 1
    //            for i in clicked..<k {
    //                var button = UIButton(type: .system)
    //
    //                //홀수번호
    //                if(i%2==0){
    //                    buttons.append(button)
    //
    //                    button.tag = i
    //                    button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
    //                    button.frame = CGRect(x:20, y:380 + Double(Int(50) * i/2), width: 161.3, height: 50)
    //                    button.setTitle(areas[i], for: .normal)
    //                    button.setTitleColor(UIColor.black, for: .normal)
    //                    button.backgroundColor = .white
    //                    button.layer.cornerRadius = 14
    //                    button.layer.borderWidth = 2.7
    //                    button.layer.borderColor = UIColor.white.cgColor
    //                    m_Scrollview.addSubview(button)
    //
    //                    //짝수번호
    //                }else if(i != 0 && i%2==1){
    //                    buttons.append(button)
    //
    //                    button.tag = i
    //                    button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
    //                    button.frame = CGRect(x:193.7, y:380 + Double(Int(50) * (i - 1)/2), width: 161.3, height: 50)
    //                    button.setTitle(areas[i], for: .normal)
    //                    button.setTitleColor(UIColor.black, for: .normal)
    //                    button.backgroundColor = .white
    //                    button.layer.cornerRadius = 14
    //                    button.layer.borderWidth = 2.7
    //                    button.layer.borderColor = UIColor.white.cgColor
    //                    m_Scrollview.addSubview(button)
    //
    //                }
    //
    //
    //
    //                clicked+=1
    //            }
    //
    //
    //            //k += 1
    //            //print(k)
    //            for i in k..<10 {
    //                var button = UIButton(type: .system)
    //
    //                //홀수번호
    //                if(i%2==0){
    //                    buttons.append(button)
    //
    //                    button.tag = i
    //                    button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
    //                    button.frame = CGRect(x:20, y:580 + Double(Int(50) * i/2), width: 161.3, height: 50)
    //                    button.setTitle(areas[k], for: .normal)
    //                    button.setTitleColor(UIColor.black, for: .normal)
    //                    button.backgroundColor = .white
    //                    button.layer.cornerRadius = 14
    //                    button.layer.borderWidth = 2.7
    //                    button.layer.borderColor = UIColor.white.cgColor
    //                    m_Scrollview.addSubview(button)
    //
    //                    //짝수번호
    //                }else if(i != 0 && i%2==1){
    //                    buttons.append(button)
    //
    //                    button.tag = i
    //                    button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
    //                    button.frame = CGRect(x:193.7, y:580 + Double(Int(50) * (i - 1)/2), width: 161.3, height: 50)
    //                    button.setTitle(areas[k], for: .normal)
    //                    button.setTitleColor(UIColor.black, for: .normal)
    //                    button.backgroundColor = .white
    //                    button.layer.cornerRadius = 14
    //                    button.layer.borderWidth = 2.7
    //                    button.layer.borderColor = UIColor.white.cgColor
    //                    m_Scrollview.addSubview(button)
    //
    //                }
    //
    //
    //
    //                k+=1
    //            }
    //
    //
    //
    //        }else{
    //
    //            //선택된 버튼된 하단의 버튼들을 삭제해주고 재추가 해준다.
    //            for subview in m_Scrollview.subviews {
    //
    //
    //
    //                if subview is UIButton && subview.tag > k { subview.removeFromSuperview()
    //                }
    //
    //
    //
    //            }
    //
    //
    //            //하단에 다시 상위지역 선택버튼 추가하는 부분
    //            k += 1
    //            //print(k)
    //            for i in k..<10 {
    //                var button = UIButton(type: .system)
    //
    //                //홀수번호
    //                if(i%2==0){
    //                    buttons.append(button)
    //
    //                    button.tag = i
    //                    button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
    //                    button.frame = CGRect(x:20, y:580 + Double(Int(50) * i/2), width: 161.3, height: 50)
    //                    button.setTitle(areas[k], for: .normal)
    //                    button.setTitleColor(UIColor.black, for: .normal)
    //                    button.backgroundColor = .white
    //                    button.layer.cornerRadius = 14
    //                    button.layer.borderWidth = 2.7
    //                    button.layer.borderColor = UIColor.white.cgColor
    //                    m_Scrollview.addSubview(button)
    //
    //                    //짝수번호
    //                }else if(i != 0 && i%2==1){
    //                    buttons.append(button)
    //
    //                    button.tag = i
    //                    button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
    //                    button.frame = CGRect(x:193.7, y:580 + Double(Int(50) * (i - 1)/2), width: 161.3, height: 50)
    //                    button.setTitle(areas[k], for: .normal)
    //                    button.setTitleColor(UIColor.black, for: .normal)
    //                    button.backgroundColor = .white
    //                    button.layer.cornerRadius = 14
    //                    button.layer.borderWidth = 2.7
    //                    button.layer.borderColor = UIColor.white.cgColor
    //                    m_Scrollview.addSubview(button)
    //
    //                }
    //
    //
    //
    //                k+=1
    //            }
    //
    //        }
    //
    //        //다른 상위지역버튼이 클릭되면 이전 하위지역을 삭제해주고 재배치후 다시 추가해준다.
    //        for subview in m_Scrollview.subviews {
    //
    //
    //
    //            if subview is UIButton && subview.tag > 20 && subview.tag < 30  { subview.removeFromSuperview()
    //            }
    //
    //
    //
    //        }
    //
    //
    //        var subY : Int =  420 + (50 * sender.tag/2)
    //
    //
    //        //클릭한 버튼아래에 지역명을 추가해준다.
    //        for i in 0..<10 {
    //            var button = UIButton(type: .system)
    //            //하위 지역버튼들이 보여줄 뷰의 높이를 계산해준다.
    //
    //
    //
    //            //홀수번호
    //            if(i%2==0){
    //                subBtns.append(button)
    //
    //                button.tag = i+20
    //                //button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
    //                button.frame = CGRect(x:20, y:Double(subY) + Double(Int(20) * i/2), width: 161.3, height: 20)
    //                button.setTitle(subAreas[i], for: .normal)
    //                button.setTitleColor(UIColor.black, for: .normal)
    //                button.backgroundColor = .gray
    //                //                       button.layer.cornerRadius = 14
    //                //                       button.layer.borderWidth = 2.7
    //                button.layer.borderColor = UIColor.white.cgColor
    //                m_Scrollview.addSubview(button)
    //
    //                //짝수번호
    //            }else if(i != 0 && i%2==1){
    //                subBtns.append(button)
    //
    //                button.tag = i+20
    //                //button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
    //                button.frame = CGRect(x:193.7, y:Double(subY) + Double(Int(20) * (i - 1)/2), width: 161.3, height: 20)
    //                button.setTitle(subAreas[i], for: .normal)
    //                button.setTitleColor(UIColor.black, for: .normal)
    //                button.backgroundColor = .gray
    //                //                       button.layer.cornerRadius = 14
    //                //                       button.layer.borderWidth = 2.7
    //                button.layer.borderColor = UIColor.white.cgColor
    //                m_Scrollview.addSubview(button)
    //
    //            }
    //
    //
    //
    //
    //        }
    //
    //        if(sender.tag%2==0){
    //            clicked =
    //                sender.tag+1
    //        }else{
    //            clicked =
    //                sender.tag
    //
    //        }
    //
    //
    //    }
    //
    //
    
    
//    func checkMaxLength(textField: UITextField!, maxLength: Int) {
//      if (textField.text!.count > maxLength) {
//              textField.deleteBackward()
//          }
//      }
    
    //나이가 3자리가 안넘어가기 때문에 숫자입력길이제한을 최대 3자로 둔다.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
         guard let text = textField.text else { return true }
         let newLength = text.count + string.count - range.length
         return newLength <= 3
     }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Print message ID.
        
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        print("bajic 메시지 수신")
        //viewcontrol 이동
        let userInfo2 = response.notification.request.content.userInfo
        let title = response.notification.request.content.title
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SecondTypeNotification"),
                                        object: title, userInfo: userInfo2)
        
        
        //상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "interestViewController") as? interestViewController         else{
            
            return
            
        }
        
        //뷰 이동
        RVC.modalPresentationStyle = .fullScreen
        
        // B 컨트롤러 뷰로 넘어간다.
        self.present(RVC, animated: true, completion: nil)
        
        
        completionHandler()
        
    }
    
    
}

//숫자외의 입력을 방지하기 위해 복붙이 안되게 설정한다.
class PastelessTextField : UITextField {
  override func canPerformAction (
      _ action : Selector, withSender sender : Any?)-> Bool {
        return super.canPerformAction (action, withSender : sender)
        && (action == #selector ( UIResponderStandardEditActions.cut )
        || action == #selector ( UIResponderStandardEditActions.copy ))
    }
}

extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
    
 
    
  }
  
    

    
}
