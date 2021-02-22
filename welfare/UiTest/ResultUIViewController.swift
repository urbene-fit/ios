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
    
    
//
//    struct item {
//        var name: String
//        var sd = Array<String>()
//
//    }
//
//    var items: [item] = []
    
    //카테고리명

    
//    var categoryItems: [String] = ["전체"]
//
//    struct categoryItems {
//
//        var welf_name : String
//        var welf_local : String
//        var parent_category : String
//        var welf_category : String
//        var tag : String
//
//    }
//
//
//    struct item {
//
//        var welf_name : String
//        var welf_local : String
//        var parent_category : String
//        var welf_category : String
//        var tag : String
//
//    }
//
//    var items: [item] = []
    
    
    
        struct item {
                    var welf_name : String
                    var welf_local : String
                    var parent_category : String
                    var welf_category : String
                    var tag : [String]
        }
        
    
    
    
    
        var items: [item] = []
    var categoryItems: [String] = ["전체"]
    
    
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
    
    var itemCount : Int = 0
    var selected : String = "전체"
    
    //카테고리 선택버튼들을 담을 배열
    var buttons = [UIButton]()
    
    var filtered : [item] = []
    
    //    //카테고리 선택 라벨들
    //    let LabelName: [String] = ["전체","학생 청년","주거","육아","창업"]
    //
    //    let Items: [String] = ["행복주택 공급","긴급 주거지원","영구임대주택 공급","국민임대주택 공급","맞춤형 기초생활보장제도","긴급복지 지원제도","가족역량강화 지원"]
    
    
    //가로스크롤뷰
    //유튜브
    var rst_scroll = UIScrollView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("테스트 시작 ")

        itemCount = items.count
        
        //화면 스크롤 크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        
//        let naviLabel = UILabel()
//        naviLabel.textAlignment = .right
//        
//        naviLabel.text = "혜택"
//        naviLabel.font = UIFont(name: "Jalnan", size: 18.1)
//        
//        self.navigationController?.navigationBar.topItem?.titleView = naviLabel
//        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        //복지혜택 검색결과
        resultLabel.frame = CGRect(x: 0, y: 116 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(screenWidth),  height: 62.3 *  DeviceManager.sharedInstance.heightRatio)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 2
        
        
        let shu : String = String(items.count)
        //resultLabel.text = "복지 혜택 결과가 +'100'+개가\n검색되었습니다."
        resultLabel.text = "복지 혜택 결과가 \(shu) 개가\n검색되었습니다."
        
        
        let attributedStr = NSMutableAttributedString(string: resultLabel.text!)
        
        // let regex = try? NSRegularExpression(pattern: "'[0-9]'+", options: .caseInsensitive)
        
        //attributedStr.addAttribute(.foregroundColor, value: UIColor.blue, range: (resultLabel.text! as NSString).range(of: "[0-9]"))
        attributedStr.addAttribute(.foregroundColor, value: UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), range: (resultLabel.text! as NSString).range(of: shu))
        
        
        
        
        resultLabel.attributedText = attributedStr
        
        resultLabel.font = UIFont(name: "Jalnan", size: 24.3 *  DeviceManager.sharedInstance.heightRatio)
        
        
        self.view.addSubview(resultLabel)
        
        
        //카테고리 선택버튼들
        for i in 0..<categoryItems.count {
            
            let button = UIButton(type: .system)
            button.frame = CGRect(x:CGFloat(20 + (Int(200) * i)) *  DeviceManager.sharedInstance.widthRatio, y:0, width: 190 *  DeviceManager.sharedInstance.widthRatio, height: 52 *  DeviceManager.sharedInstance.heightRatio)
            
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
            button.setTitle(categoryItems[i], for: .normal)
            button.titleLabel?.font = UIFont(name: "NanumGothicBold", size: 16 *  DeviceManager.sharedInstance.heightRatio)!
            
            button.setTitleColor(UIColor.black, for: .normal)
            button.layer.cornerRadius = 20 *  DeviceManager.sharedInstance.heightRatio
            
            button.layer.borderWidth = 1.3
            button.tag = i
            //카테고리 선택시 카테고리에 해당하는 데이터만 보여주는 메소드
            button.addTarget(self, action: #selector(self.selectCategory), for: .touchUpInside)
            buttons.append(button)
            //button.layer.borderColor = UIColor(displayP3Red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 1) as! CGColor
            
            categoryScrlview.addSubview(button)
            
        }
        
        //가로 카테고리 스크롤뷰 추가
        categoryScrlview.frame = CGRect(x: 0, y: 211.7 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(screenWidth), height: 55 *  DeviceManager.sharedInstance.heightRatio)
        categoryScrlview.contentSize = CGSize(width:220 * categoryItems.count *  Int(DeviceManager.sharedInstance.widthRatio), height: 55)
        //categoryScrlview.showsVerticalScrollIndicator = false
        //categoryScrlview.showHori
        categoryScrlview.showsHorizontalScrollIndicator = false
        self.view.addSubview(categoryScrlview)
        
        
        resultTbView = UITableView(frame: CGRect(x: 0, y: Int(311.7 *  DeviceManager.sharedInstance.heightRatio), width: screenWidth, height: screenHeight - Int(311.7 *  DeviceManager.sharedInstance.heightRatio)))
        
        
        
        
        
        //푸터 설정resultTbView.tableFooterView = footer
        
        //검색결과(필터링된) 정책들을 보여주는 테이블 뷰
        //        resultTbView = UITableView(frame: CGRect(x: 0, y: 150, width: 375, height: 400))
        
        
        //테이블뷰 레이아웃을 설정하기 위해서  Constraints을 풀어놓는다.
                      //        resultTbView.translatesAutoresizingMaskIntoConstraints = false
        
        //테이블 셀간의 줄 없애기
        resultTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //커스텀 테이블뷰를 등록
        //myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        
        resultTbView.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.identifier)
        
        resultTbView.dataSource = self
        resultTbView.delegate = self
        
        resultTbView.rowHeight = 186 *  DeviceManager.sharedInstance.heightRatio
        //myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
        
        
        
        
        
        
        
        //self.view.addSubview(resultTbView)
        
        
        //검색결과 아이템
        for i in 0..<items.count {

            

            let imageView = UIImageView()
           
            imageView.frame = CGRect(x: 10, y: 150,
                                     width: 180,
                                     height: 150 *  DeviceManager.sharedInstance.heightRatio)
            
            imageView.setImage(UIImage(named: "cash")!)
            
            imageView.backgroundColor = UIColor.clear
            
            
            let listVeiw = UIView()
            listVeiw.backgroundColor = #colorLiteral(red: 0.1389008292, green: 0.00778250823, blue: 0.4471565673, alpha: 1)
//            listVeiw.text = items[0].welf_name
//            listVeiw.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//            listVeiw.font = UIFont(name: "NanumGothicBold", size: 15)
//
            
            let xPosition = (220 * CGFloat(i) + 20) * DeviceManager.sharedInstance.widthRatio
            
            listVeiw.frame = CGRect(x: xPosition, y: 30, width: 200, height: 300 *  DeviceManager.sharedInstance.heightRatio)
            
            listVeiw.layer.cornerRadius = 23 *  DeviceManager.sharedInstance.heightRatio
            listVeiw.layer.borderWidth = 0.1

            
            listVeiw.layer.borderColor = #colorLiteral(red: 0.1389008292, green: 0.00778250823, blue: 0.4471565673, alpha: 1).cgColor

            listVeiw.layer.shadowColor = #colorLiteral(red: 0.1264403451, green: 0.007084356744, blue: 0.4070431472, alpha: 1).cgColor
            listVeiw.layer.shadowOffset = CGSize(width: 0, height: 5) // 반경에 대해서 너무 적용이 되어서 4point 정도 ㅐ림.
            
            listVeiw.layer.shadowOpacity = 1
            listVeiw.layer.shadowRadius = 1 // 반경?
            
            listVeiw.layer.shadowOpacity = 0.5 // alpha값입니다.
            
        
           let nameLabel = UILabel()
            nameLabel.backgroundColor = UIColor.clear
            
            
            nameLabel.text = items[i].welf_name
            nameLabel.textColor = UIColor.white
            nameLabel.font = UIFont(name: "NanumGothicBold", size: 12)
            nameLabel.frame = CGRect(x: 20, y: 20,
                                     width: 200,
                                     height: 30 *  DeviceManager.sharedInstance.heightRatio)
            
            nameLabel.numberOfLines = 3
            
            listVeiw.addSubview(nameLabel)

            listVeiw.addSubview(imageView)

            rst_scroll.addSubview(listVeiw)
            
            
        }
        
        
        
        rst_scroll.frame = CGRect(x: 0, y: 320, width: self.view.frame.width, height: 390 *  DeviceManager.sharedInstance.heightRatio)
        rst_scroll.contentSize.width =
            self.view.frame.width * CGFloat(3) *  DeviceManager.sharedInstance.widthRatio
        rst_scroll.isPagingEnabled = true
        rst_scroll.showsHorizontalScrollIndicator = false
        
        self.view.addSubview(rst_scroll)
        
        
        
        
        
        //테이블 뷰 Constraints설정
        
//        let guide = view.safeAreaLayoutGuide
//        NSLayoutConstraint.activate([
//            resultTbView.topAnchor.constraint(equalTo: guide.topAnchor),
//            resultTbView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
//            resultTbView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
//            resultTbView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
//        ])
//        
//        //테이블뷰 레이아웃을 설정하기 위해서  Constraints을 다시 고정
//        resultTbView.translatesAutoresizingMaskIntoConstraints = true
//        
        
    }
    
    
    //테이블뷰 총 섹션 숫자
    //func numberOfSections(in tableView: UITableView) -> Int { return items.count }
    
    //셀 클릭이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("정책 선택")
        
        //상세페이지로 이동한다.
        //print("\(items[indexPath.section].sd[indexPath.row])")
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "DuViewController") as? DuViewController         else{
            
            return
            
        }
        
        
        if(selected == "전체"){
        RVC.selectedPolicy = "\(items[indexPath.row].welf_name)"
            RVC.selectedLocal = "\(items[indexPath.row].welf_local)"

        }else{
            RVC.selectedPolicy = "\(filtered[indexPath.row].welf_name)"
            RVC.selectedLocal = "\(filtered[indexPath.row].welf_local)"
        }
        RVC.modalPresentationStyle = .fullScreen

        //혜택 상세보기 페이지로 이동
        //self.present(RVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(RVC, animated: true)
        
        
        
        
    }
    
    //섹션별 행 숫자
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        
            print("행 숫자: \(itemCount)")
        
        switch selected {

        case ("전체"):
            return itemCount

            
        case (let value) where value != "전체":
            return filtered.count

        default:

            return itemCount

        
        }

    }
    
    //테이블뷰의 셀을 만드는 메소드
    //테이블뷰의 셀이 어떤 커스텀셀을 참조하는지 지정해준다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier, for: indexPath) as! ResultTableViewCell
        
   
        
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1.3
        cell.layer.cornerRadius = 34 *  DeviceManager.sharedInstance.heightRatio
        cell.clipsToBounds = true
        print(selected)
        //cell.textLabel?.text = "\(firstItems[indexPath.row])"
        //cell.policyLank.text = String(indexPath.row)
        
        if(selected == "전체"){
            print(items[indexPath.row].welf_category)
        cell.policyName.text = "\(items[indexPath.row].welf_name)" //"\(items[indexPath.row].welf_name)\n(\(items[indexPath.row].parent_category))"
        }else {
                     cell.policyName.text = "\(filtered[indexPath.row].welf_name)"

        }
//
        
        return cell }
    
    
    
    @objc func selectCategory(_ sender: UIButton) {
        
     //   print(buttons[sender.tag].title(for: .normal)!)
        
        for i in 0..<buttons.count {
            
            //선택한 버튼임을 표시해준다.

            if(buttons[i].tag == sender.tag){
                buttons[i].layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
                buttons[i].setTitleColor(UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), for: .normal)

                
            }else{
                
                buttons[i].layer.borderColor = UIColor.black.cgColor
                
                buttons[i].setTitleColor(.black, for: .normal)

            }
            
            
        }

        
        
    selected =     buttons[sender.tag].title(for: .normal)!
    
        //해당 카테고리의 아이템 숫자를 센다.
        if(selected != "전체"){
            
//        itemCount = items.filter { $0.welf_category == selected
//        }.count
            
            filtered = items.filter{ $0.tag.contains(selected)
            }

            
            

            
        }else{
            itemCount = items.count
        }
        self.resultTbView.reloadData()
//        resultTbView.dataSource = self
//        resultTbView.delegate = self
//

    }
    
}
