//
//  ResultUIViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/10/19.
//  Copyright © 2020 com. All rights reserved.
//

//메인화면 구성도(스크롤뷰)
//1.너의 혜택은(로고 - 이미지뷰). 2.몇개 결과 검색 알림 (텍스트뷰).  3.혜택 종류별 카테고리(버튼) 및 가로 스크롤뷰  4.혜택 검색결과 (테이블 뷰)
//5.하단 (텍스트 및 로고 )


import UIKit

class ResultUIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    struct item {
        var name: String
        var sd = Array<String>()
        
    }
    
    var items: [item] = []
    
    
    //    //메인을 구성하는 이미지 및 라벨 뷰
    let appLogo = UIImageView()
    let resultLabel = UILabel()
    //정책검색결과를 보여주는 테이블 뷰
    private var resultTbView: UITableView!
    
    
    // 카테고리를 선택하게하는 가로 스크롤뷰
    let categoryScrlview = UIScrollView()
    let message : String = "복지 혜택 결과가 '100'개가\n검색되었습니다."
    
    
    var count : Int = 0
    let footer = UIView()
    
    
    //    //카테고리 선택 라벨들
    //    let LabelName: [String] = ["전체","학생 청년","주거","육아","창업"]
    //
    //    let Items: [String] = ["행복주택 공급","긴급 주거지원","영구임대주택 공급","국민임대주택 공급","맞춤형 기초생활보장제도","긴급복지 지원제도","가족역량강화 지원"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("테스트 시작 ")
        for i in 0..<items.count {
            count += items[i].sd.count
        }
        
        //화면 스크롤 크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        
        //메인 좌측상단 로고 추가
        let LogoImg = UIImage(named: "appLogo")
        appLogo.image = LogoImg
        appLogo.frame = CGRect(x: 22.1, y: 26.7, width: 106, height: 14.3)
        self.view.addSubview(appLogo)
        
        
        //복지혜택 검색결과
        resultLabel.frame = CGRect(x: 31.3, y: 116, width: 312.7, height: 62.3)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 2
        
        
        let shu : String = String(count)
        //resultLabel.text = "복지 혜택 결과가 +'100'+개가\n검색되었습니다."
        resultLabel.text = "복지 혜택 결과가 \(shu) 개가\n검색되었습니다."
        
        
        let attributedStr = NSMutableAttributedString(string: resultLabel.text!)
        
        // let regex = try? NSRegularExpression(pattern: "'[0-9]'+", options: .caseInsensitive)
        
        //attributedStr.addAttribute(.foregroundColor, value: UIColor.blue, range: (resultLabel.text! as NSString).range(of: "[0-9]"))
        attributedStr.addAttribute(.foregroundColor, value: UIColor(red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1.0), range: (resultLabel.text! as NSString).range(of: shu))
        
        
        
        
        resultLabel.attributedText = attributedStr
        
        resultLabel.font = UIFont(name: "Jalnan", size: 24.3)
        
        
        self.view.addSubview(resultLabel)
        
        
        //카테고리 선택버튼들
        for i in 0..<items.count {
            
            let button = UIButton(type: .system)
            button.frame = CGRect(x:Double(20 + (Int(119) * i)), y:0, width: 111.7, height: 46)
            
            //button.setTitle(LabelName[i], for: .normal)
            
            
            
            //
            //            //라벨
            //            let label = UILabel()
            //            label.frame = CGRect(x: 48.7, y: 14, width: 126, height: 18)
            //            label.textAlignment = .left
            //
            //            //폰트지정 추가
            //            label.text = LabelName[i]
            //            //label.textColor = .white
            //            label.font = UIFont(name: "NanumGothic", size: 15.7)
            //
            
            
            //button.addSubview(label)
            button.setTitle(items[i].name, for: .normal)
            button.titleLabel?.font = UIFont(name: "NanumGothic", size: 15.7)!
            
            button.setTitleColor(UIColor.black, for: .normal)
            button.layer.cornerRadius = 20
            
            button.layer.borderWidth = 1.3
            //button.layer.borderColor = UIColor(displayP3Red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 1) as! CGColor
            
            categoryScrlview.addSubview(button)
            
        }
        
        //가로 카테고리 스크롤뷰 추가
        categoryScrlview.frame = CGRect(x: 0, y: Int(211.7), width: screenWidth, height: 46)
        categoryScrlview.contentSize = CGSize(width:1000, height: 46)
        //categoryScrlview.showsVerticalScrollIndicator = false
        //categoryScrlview.showHori
        categoryScrlview.showsHorizontalScrollIndicator = false
        self.view.addSubview(categoryScrlview)
        
        
        resultTbView = UITableView(frame: CGRect(x: 0, y: Int(311.7), width: screenWidth, height: screenHeight - Int(311.7)))
        
        
        
        
        
        //푸터 설정resultTbView.tableFooterView = footer
        
        //검색결과(필터링된) 정책들을 보여주는 테이블 뷰
        //        resultTbView = UITableView(frame: CGRect(x: 0, y: 150, width: 375, height: 400))
        
        
        //테이블뷰 레이아웃을 설정하기 위해서  Constraints을 풀어놓는다.
        resultTbView.translatesAutoresizingMaskIntoConstraints = false
        
        //테이블 셀간의 줄 없애기
        resultTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //커스텀 테이블뷰를 등록
        //myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        
        resultTbView.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.identifier)
        
        resultTbView.dataSource = self
        resultTbView.delegate = self
        
        resultTbView.rowHeight = 186
        //myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.view.addSubview(resultTbView)
        
        
        //테이블 뷰 Constraints설정
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            resultTbView.topAnchor.constraint(equalTo: guide.topAnchor),
            resultTbView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            resultTbView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            resultTbView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
        
        //테이블뷰 레이아웃을 설정하기 위해서  Constraints을 다시 고정
        resultTbView.translatesAutoresizingMaskIntoConstraints = true
        
        
    }
    
    
    //테이블뷰 총 섹션 숫자
    func numberOfSections(in tableView: UITableView) -> Int { return items.count }
    
    //셀 클릭이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("정책 선택")
        
        //상세페이지로 이동한다.
        print("\(items[indexPath.section].sd[indexPath.row])")
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "DuViewController") as? DuViewController         else{
            
            return
            
        }
        RVC.selectedPolicy = "\(items[indexPath.section].sd[indexPath.row])"
        RVC.modalPresentationStyle = .fullScreen

        //혜택 상세보기 페이지로 이동
        //self.present(RVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(RVC, animated: true)
        
        
        //        tableView.deselectRow(at: indexPath, animated: false)
        //       // print(indexPath)
        //        let p = tableView.cellForRow(at: indexPath) as! ResultTableViewCell
        //        //let cell = tableView.cellForRow(at: indexPath) as! ResultTableViewCell
        //
        ////
        ////        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as! ResultTableViewCell
        ////
        ////                    cell.policyName.textColor = UIColor.white
        //
        //
        //     //  if(p.policyName.text == "\(items[indexPath.section].sd[indexPath.row])"){
        //      if (p.backgroundColor == UIColor(red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1.0)){
        ////        //클릭여부 판단
        //     //   if (){
        //            //let cell = tableView.cellForRow(at: indexPath) as! ResultTableViewCell
        //
        //            p.backgroundColor = UIColor.white
        //               p.policyName.textColor = UIColor.black
        //               p.plusImg.tintColor = UIColor.black
        //               p.plusImg.image = p.plusImg.image?.withRenderingMode(.alwaysTemplate)
        //
        //       }else{
        //            //let cell = tableView.cellForRow(at: indexPath) as! ResultTableViewCell
        //
        //            p.backgroundColor = UIColor(red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1.0)
        //               p.policyName.textColor = UIColor.white
        //               p.plusImg.tintColor = UIColor.white
        //               p.plusImg.image = p.plusImg.image?.withRenderingMode(.alwaysTemplate)
        //        }
        
        
        //
        //   NSLog("You selected cell number: \(indexPath.row)!")
        
        
        //var (testName) = tasks[indexPath.row]
        //cell.textLabel?.text=testName
        
    }
    
    //섹션별 로우 숫자
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for i in 0..<items.count {
            
            return items[i].sd.count
            //firstItems.count
            
        }
        return 0
        
        //    } else if section == 1 {
        //        return 0
        
        //} else { return 0 }
        
    }
    
    //테이블뷰의 셀을 만드는 메소드
    //테이블뷰의 셀이 어떤 커스텀셀을 참조하는지 지정해준다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier, for: indexPath) as! ResultTableViewCell
        
        //셀 테두리 설정
        //        if indexPath.section == 0 {
        //            cell.backgroundColor = UIColor.white
        //            cell.layer.borderColor = UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 1.0).cgColor
        //            cell.layer.borderWidth = 1.3
        //            cell.layer.cornerRadius = 34
        //            cell.clipsToBounds = true
        //            //cell.textLabel?.text = "\(firstItems[indexPath.row])"
        //            //cell.policyLank.text = String(indexPath.row)
        //            cell.policyName.text = "\(items[indexPath.row])"
        //            //cell.policyTag.text = "#현금 #지역주민 #교육"
        //
        //            //} else if indexPath.section == 1 {
        //            //  cell.textLabel?.text = "\(secItems[indexPath.row])"
        //
        //        } else { return UITableViewCell() }
        
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 1.0).cgColor
        cell.layer.borderWidth = 1.3
        cell.layer.cornerRadius = 34
        cell.clipsToBounds = true
        //cell.textLabel?.text = "\(firstItems[indexPath.row])"
        //cell.policyLank.text = String(indexPath.row)
        cell.policyName.text = "\(items[indexPath.section].sd[indexPath.row])"
        return cell }
    
    
    
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
    //        //테이블뷰 푸터추가
    //              //하단 뷰 너의 혜택은 이미지 뷰
    //                   //이미지 및 라벨 추가
    //                   let bottomImg = UIImage(named: "bottomImg")
    //                   let bottomImgView = UIImageView(image: bottomImg)
    //                   bottomImgView.frame = CGRect(x: 20.7, y: 31.7, width: 96.7, height: 17)
    //                   footerView.addSubview(bottomImgView)
    //
    //                   //하단 설명 라벨
    //                   let bottomLabel = UILabel()
    //                   //bottomLabel.frame = CGRect(x: 20.7, y: 58.3, width: 238.7, height: 12.7)
    //                   bottomLabel.frame = CGRect(x: 20.7, y: 58.3, width: 300, height: 12.7)
    //                   bottomLabel.textAlignment = .left
    //                   bottomLabel.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
    //
    //                   bottomLabel.text = "사용자에게 알 맞는 복지 지원과 혜택을 알려드립니다"
    //                   bottomLabel.font = UIFont(name: "NanumGothic", size: 11)
    //                   footerView.addSubview(bottomLabel)
    //
    //
    //
    //                   //2번째 라벨
    //                   let bottomSecLabel = UILabel()
    //                   //bottomLabel.frame = CGRect(x: 20.7, y: 58.3, width: 238.7, height: 12.7)
    //                   bottomSecLabel.frame = CGRect(x: 20.7, y: 108.3, width: 300, height: 15)
    //                   bottomSecLabel.textAlignment = .left
    //                   bottomSecLabel.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
    //
    //                   bottomSecLabel.text = "Copyright © All rights reserved"
    //                   bottomSecLabel.font = UIFont(name: "OpenSans-Bold", size: 11)
    //                   footerView.addSubview(bottomSecLabel)
    //
    //                   //하단 페이스북 버튼
    //                   let bottomFbBtn = UIButton(type: .system)
    //                   bottomFbBtn.frame = CGRect(x:20.7, y:143.3, width: 35.3, height: 35.3)
    //                   bottomFbBtn.backgroundColor = UIColor(displayP3Red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
    //                   bottomFbBtn.layer.cornerRadius = 100
    //
    //                   bottomFbBtn.layer.cornerRadius = bottomFbBtn.frame.height/2
    //                   bottomFbBtn.layer.borderWidth = 1
    //                   bottomFbBtn.layer.borderColor = UIColor.clear.cgColor
    //                   // 뷰의 경계에 맞춰준다
    //                   bottomFbBtn.clipsToBounds = true
    //
    //
    //                   //페이스북 로고이미지 추가
    //                   let fbImg = UIImage(named:"fbImg")
    //                   let fbImgView = UIImageView(image: fbImg)
    //                   fbImgView.frame = CGRect(x: 14.4, y: 10.5, width: 6.9, height: 13.8)
    //
    //                   //각 상위뷰에 추가
    //                   bottomFbBtn.addSubview(fbImgView)
    //                   footerView.addSubview(bottomFbBtn)
    //
    //
    //                   //하단 구글 버튼
    //                   let bottomGgBtn = UIButton(type: .system)
    //                   bottomGgBtn.frame = CGRect(x:64, y:143.3, width: 35.3, height: 35.3)
    //                   bottomGgBtn.backgroundColor = UIColor(displayP3Red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
    //                   bottomGgBtn.layer.cornerRadius = 100
    //
    //                   bottomGgBtn.layer.cornerRadius = bottomFbBtn.frame.height/2
    //                   bottomGgBtn.layer.borderWidth = 1
    //                   bottomGgBtn.layer.borderColor = UIColor.clear.cgColor
    //                   // 뷰의 경계에 맞춰준다
    //                   bottomGgBtn.clipsToBounds = true
    //
    //
    //                   //페이스북 로고이미지 추가
    //                   let GgImg = UIImage(named:"GgImg")
    //                   let GgImgView = UIImageView(image: GgImg)
    //                   GgImgView.frame = CGRect(x: 10.8, y: 10.5, width: 9.3, height: 13.8)
    //
    //                   //각 상위뷰에 추가
    //                   bottomGgBtn.addSubview(GgImgView)
    //                   footerView.addSubview(bottomGgBtn)
    //
    //                   //앱스토어 추가
    //                   //애플
    //                   //로고
    //                   let appleImg = UIImage(named:"appleImg")
    //                   let appleImgView = UIImageView(image: appleImg)
    //                   appleImgView.frame = CGRect(x: 129, y: 153.7, width: 14.3, height: 17.3)
    //
    //                   footerView.addSubview(appleImgView)
    //
    //                   //버튼
    //                   let appleBtn = UIButton(type: .system)
    //                   appleBtn.frame = CGRect(x:150.7, y:151.7, width: 70.3, height: 20.7)
    //                   appleBtn.backgroundColor = .clear
    //                   appleBtn.setTitle("App Store", for: .normal)
    //                   appleBtn.setTitleColor(UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1), for: .normal)
    //                   appleBtn.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size:14.3)
    //                   footerView.addSubview(appleBtn)
    //
    //
    //
    //                   //구글
    //                   //로고
    //                   let googleImg = UIImage(named:"googleImg")
    //                   let googleImgView = UIImageView(image: googleImg)
    //                   googleImgView.frame = CGRect(x: 235, y: 153.3, width: 16.7, height: 18)
    //
    //                   footerView.addSubview(googleImgView)
    //
    //                   //버튼
    //                   let googleBtn = UIButton(type: .system)
    //                   googleBtn.frame = CGRect(x:258.7, y:151.3, width: 87.7, height: 20.7)
    //                   googleBtn.backgroundColor = .clear
    //                   googleBtn.setTitle("Google play", for: .normal)
    //                   googleBtn.setTitleColor(UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1), for: .normal)
    //                   googleBtn.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size:14.3)
    //                   footerView.addSubview(googleBtn)
    //        return footerView
    //    }
    //
    //    // set height for footer
    //       func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //           return 208.7
    //       }
    
}
