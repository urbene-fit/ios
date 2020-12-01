//
//  interestViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/11/17.
//  Copyright © 2020 com. All rights reserved.
//

// 사용자가 맞춤알림을 받기 위해 기본정보를 입력한 다음
// 기본정보에 따라 선택지를 제공해주는 화면


import UIKit
import Alamofire

class interestViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    
    //로고
    let appLogo = UIImageView()
    //헤더
    let header = UIView()
    let headerLabel = UILabel()
    //최하단 확인 버튼
    let enterBtn = UIButton()
    
    
    //선택지를 보여주는 테이블 뷰
    private var selectTbView: UITableView!
    
    //선택지를 저장하고 있는 아이템
    //let items: [String] = ["어려운 형편으로 걱정되는 교육비 해결해보시겠어요?","몸이 불편해서 곤란하신가요?","취업 관련 교육비를 지원받는건 어떠신가요?"]
    
    
    
    var keyword_1 = String()
    var keyword_2 = String()
    
    
    
    struct item {
        var content: String
        var keyWord = Array<String>()
        
    }
    
    var items: [item] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //더미
        items.append(item.init(content: "어려운 형편으로 걱정되는 교육비해결해보시겠어요?", keyWord: ["저소득", "교육"]))
        items.append(item.init(content: "몸이 불편해서 곤란하신가요?", keyWord: ["장애인", "지원"]))
        items.append(item.init(content: "취업 관련 교육비를 지원받는건 어떠신가요?", keyWord: ["청년", "지원"]))
        items.append(item.init(content: "대학교 등록금이 걱정이신가요?", keyWord: ["청년", "지원"]))
        items.append(item.init(content: "저소득층을 위한 교육비 지원 정책이 궁금하신가요?", keyWord: ["청년", "지원"]))
        items.append(item.init(content: "문화활동으로 평소 쌓인 스트레스를 해소하는 건 어떠신가요?", keyWord: ["청년", "지원"]))
        items.append(item.init(content: "청소년 대상의 예방접종 찾고 계신가요?", keyWord: ["청년", "지원"]))
        items.append(item.init(content: "임신·출산 관련 문제로 고민중이신가요?", keyWord: ["청년", "지원"]))
        items.append(item.init(content: "하교 후, 혼자 있는 아이가 걱정되시나요?", keyWord: ["청년", "지원"]))
        items.append(item.init(content: "경제적 어려움을 겪고 계신가요?", keyWord: ["청년", "지원"]))
        
        
        
        //화면 스크롤 크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        
        
        //임시 디바이스 크기별 레이아웃 조정
        if(screenWidth == 375){
        
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
        
        
        
        //화면을 설명하는 라벨
        let mainLabel = UILabel()
        mainLabel.frame = CGRect(x: 0, y: 162, width: screenWidth, height: 28)
        mainLabel.textAlignment = .center
        //titleLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
        //폰트지정 추가
        //당신의 관심사를 선택해주세요
        //당신에게
        
        mainLabel.text = "당신의 관심사를 선택해주세요"
        mainLabel.font = UIFont(name: "Jalnan", size: 16.7)
        
        self.view.addSubview(mainLabel)
        
        //테이블뷰를 통해 질문지를 보여준다.
        selectTbView = UITableView(frame: CGRect(x: 0, y: Int(221.7), width: screenWidth, height: screenHeight - Int(285.4)))
        
        //테이블뷰 레이아웃을 설정하기 위해서  Constraints을 풀어놓는다.
        selectTbView.translatesAutoresizingMaskIntoConstraints = false
        
        //테이블 셀간의 줄 없애기
        selectTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //커스텀 테이블뷰를 등록
        //myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        
        selectTbView.register(SelectTableViewCell.self, forCellReuseIdentifier: SelectTableViewCell.identifier)
        
        selectTbView.dataSource = self
        selectTbView.delegate = self
        
        selectTbView.rowHeight = 100
        //myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.view.addSubview(selectTbView)
        
        
        //테이블 뷰 Constraints설정
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            selectTbView.topAnchor.constraint(equalTo: guide.topAnchor),
            selectTbView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            selectTbView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            selectTbView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
        
        //테이블뷰 레이아웃을 설정하기 위해서  Constraints을 다시 고정
        selectTbView.translatesAutoresizingMaskIntoConstraints = true
        
        
        
        enterBtn.setTitle("확인", for: .normal)
        enterBtn.frame = CGRect(x: 20, y: screenHeight - 60, width: 335, height: Int(53.7))
        
        enterBtn.titleLabel!.font = UIFont(name: "Jalnan", size:14.7)
        enterBtn.layer.cornerRadius = 4.3
        enterBtn.layer.borderWidth = 1.3
        enterBtn.backgroundColor = UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1)
        enterBtn.layer.borderColor =  UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1).cgColor
        //선택결과 페이지로 이동하는 메소드
        enterBtn.addTarget(self, action: #selector(self.move), for: .touchUpInside)
        
        self.view.addSubview(enterBtn)
        
            
            
            //임시 실제디바이스 크기별 레이아웃 조정
        }else{
            
            
            
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
            headerLabel.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 100)
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
            
            
            
            //화면을 설명하는 라벨
            let mainLabel = UILabel()
            mainLabel.frame = CGRect(x: 0, y: 187, width: screenWidth, height: 38)
            mainLabel.textAlignment = .center
            //titleLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
            //폰트지정 추가
            //당신의 관심사를 선택해주세요
            //당신에게
            
            mainLabel.text = "당신의 관심사를 선택해주세요"
            mainLabel.font = UIFont(name: "Jalnan", size: 19)
            
            self.view.addSubview(mainLabel)
            
            //테이블뷰를 통해 질문지를 보여준다.
            selectTbView = UITableView(frame: CGRect(x: 0, y: 225, width: screenWidth, height: screenHeight - 300))
            
            //테이블뷰 레이아웃을 설정하기 위해서  Constraints을 풀어놓는다.
            selectTbView.translatesAutoresizingMaskIntoConstraints = false
            
            //테이블 셀간의 줄 없애기
            selectTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
            //커스텀 테이블뷰를 등록
            //myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
            
            
            selectTbView.register(SelectTableViewCell.self, forCellReuseIdentifier: SelectTableViewCell.identifier)
            
            selectTbView.dataSource = self
            selectTbView.delegate = self
            
            selectTbView.rowHeight = 130
            //myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            
            self.view.addSubview(selectTbView)
            
            
            //테이블 뷰 Constraints설정
            
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                selectTbView.topAnchor.constraint(equalTo: guide.topAnchor),
                selectTbView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                selectTbView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                selectTbView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            ])
            
            //테이블뷰 레이아웃을 설정하기 위해서  Constraints을 다시 고정
            selectTbView.translatesAutoresizingMaskIntoConstraints = true
            
            
            
            enterBtn.setTitle("확인", for: .normal)
            enterBtn.frame = CGRect(x: 22, y: screenHeight - 75, width: screenWidth - 44, height: Int(70))
            
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
    
    
    //확인시 질문지 선택페이지로 이동하는 메소드
    @objc func move(_ sender: UIButton) {
        print("질문지 선택 후 다른 페이지로 이동")
        
        //선택여부 체크
        if(keyword_1 != "" && keyword_2 != ""){
            
            
            var userEmail = UserDefaults.standard.string(forKey: "email")
            let parameters = ["email": userEmail!,"keyword_1": keyword_1,"keyword_2": keyword_2]
            
            Alamofire.request("http://3.34.4.196/backend/php/common/benefit_info_register.php", method: .post, parameters: parameters)
                .validate()
                .responseString()
                    //.responseJSON
                    { response in
                        
                        switch response.result {
                        case .success(let value):
                            
                            
                            let alert = UIAlertController(title: "알림", message: "관심항목이 등록되었습니다.", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                
                                //상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
                                guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "UiTestController") as? UiTestController         else{
                                    
                                    return
                                    
                                }
                                RVC.modalPresentationStyle = .fullScreen
                                
                               // self.present(RVC, animated: true, completion: nil)
                                
                                ///메인으로 다시 이동 
                                self.navigationController?.pushViewController(RVC, animated: true)

                                
                            }
                            alert.addAction(okAction)
                            
                            self.present(alert, animated: false, completion: nil)
                            
                            
                            
                        case .failure(let error):
                            print(error)
                        }
            }
            
            //관심사를 선택하지 않은경우
        }else{
            
            let alert = UIAlertController(title: "관심사", message: "관심사를 선택해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            alert.addAction(okAction)
            
            present(alert, animated: false, completion: nil)
            
            
        }
        
    }
    
    
    //테이블뷰 총 섹션 숫자
    func numberOfSections(in tableView: UITableView) -> Int { return items.count }
    
    //셀 클릭이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("관심사 선택")
        
        
        //사용자 이메일와 함께 입력한 개인정보를 서버로 보낸다.
        //               var userEmail = UserDefaults.standard.string(forKey: "email")
        //              let parameters = ["email": userEmail!,"keyword_1": self.items[indexPath.row].keyWord[0],"keyword_2": self.items[indexPath.row].keyWord[1]]
        //
        
        keyword_1 = self.items[indexPath.row].keyWord[0]
        keyword_2 = self.items[indexPath.row].keyWord[1]
        
        
        //
        //        //사용자 이메일와 함께 입력한 개인정보를 서버로 보낸다.
        //         var userEmail = UserDefaults.standard.string(forKey: "email")
        //
        //        //상세페이지로 이동한다.
        //        //print("\(items[indexPath.section].content[indexPath.row])")
        //
        //        //안내 문구를 띄어준다.
        //          let alert = UIAlertController(title: "관심사 추가", message: "'\(items[indexPath.row].content)'에 대해 관심이 있으신가요", preferredStyle: UIAlertController.Style.alert)
        //
        //
        //        //확인을 누르면 서버로 보낸다
        //        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
        //
        //            let parameters = ["email": userEmail!,"keyword_1": self.items[indexPath.row].keyWord[0],"keyword_2": self.items[indexPath.row].keyWord[1]]
        //
        //
        //                 Alamofire.request("http://3.34.4.196/backend/php/common/benefit_info_register.php", method: .post, parameters: parameters)
        //                            .validate()
        //                            .responseJSON { response in
        //
        //                                switch response.result {
        //                                case .success(let value):
        //
        //                                    //상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
        //                                    guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultUIViewController") as? ResultUIViewController         else{
        //
        //                                        return
        //
        //                                    }
        //
        //
        //                                case .failure(let error):
        //                                    print(error)
        //                                }
        //                 }
        //
        //        }
        //        //취소
        //        let cancleAction = UIAlertAction(title: "취소", style: .default) { (action) in
        //
        //              }
        //        alert.addAction(okAction)
        //        alert.addAction(cancleAction)
        //
        //
        //        present(alert, animated: false, completion: nil)
        //
        //
        ////         if(userEmail != nil){
        //      print("자동로그인 이메일 주소:\(userEmail!)")
        //        print("키1:\(items[indexPath.row].keyWord[0])")
        //        print("키2:\(items[indexPath.row].keyWord[1])")
        //
        //
        
        
        //
        //        }
        
        //        for i in 0..<2 {
        //
        //            firKey = items[indexPath.row].keyWord.joined(separator: ",")
        //            secKey = items[indexPath.row].keyWord.joined(separator: ",")
        //
        //            }
        
        //        let string = items[indexPath.row].keyWord[0]
        //        print("키워드:\(string)")
        
        
        
        
        
        
        
        
        
        //        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "DuViewController") as? DuViewController         else{
        //
        //            return
        //
        //        }
        //        //RVC.selectedPolicy = "\(items[indexPath.section].sd[indexPath.row])"
        //        //뷰 이동
        //        RVC.modalPresentationStyle = .fullScreen
        
        // B 컨트롤러 뷰로 넘어간다.
        //self.present(RVC, animated: true, completion: nil)
        
        
    }
    
    //섹션별 로우 숫자
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        //firstItems.count
        
        
        
        
    }
    
    //테이블뷰의 셀을 만드는 메소드
    //테이블뷰의 셀이 어떤 커스텀셀을 참조하는지 지정해준다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectTableViewCell.identifier, for: indexPath) as! SelectTableViewCell
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 1.0).cgColor
        cell.layer.borderWidth = 1.3
        cell.layer.cornerRadius = 17
        cell.clipsToBounds = true
        //cell.textLabel?.text = "\(firstItems[indexPath.row])"
        //cell.policyLank.text = String(indexPath.row)
        
        //띄어쓰기 후 내용
        var content : String = items[indexPath.row].content
        if(content.count>18){
            let index = content.index(content.startIndex, offsetBy: 17)
            content.insert("\n", at: index)
            
            
        }
        
        //내용간격 띄우기
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 9
        let attributes = [NSAttributedString.Key.paragraphStyle: style]
        cell.questionLabel.attributedText = NSAttributedString(string: "\(content)", attributes: attributes)
        cell.questionLabel.font = UIFont(name: "Jalnan", size: 20)
        cell.questionLabel.sizeToFit()
        
        //cell.questionLabel.textAlignment = .center
        //            cell.questionLabel.text = "\(content)"
        //            cell.questionLabel.font = UIFont(name: "Jalnan", size: 14.7)
        return cell }
}
