//
//  NewResultView.swift
//  welfare
//
//  Created by 김동현 on 2020/12/31.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class NewResultView: UIViewController , UITableViewDelegate, UITableViewDataSource{

    
    struct item {
                var welf_name : String
                var welf_local : String
                var parent_category : String
                var welf_category : [String]
                var tag : String

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
    
    //아이템 이미지 불러올때 사용할 자료구조
    var imgDic : [String : String] = ["일자리지원":"job", "공간지원":"house","교육지원":"traning","현금지원":"cash","사업화지원":"business","카드지원":"giftCard","취업지원":"job","활동지원":"activity","보험지원":"insurance","상담지원":"counseling","진료지원":"treat","임대지원":"rent","창업지원":"business","재활지원":"recover","인력지원":"support","물품지원":"goods","현물지원":"goods","숙식지원":"bedBoard","정보지원":"information","멘토링지원":"mentor","감면지원":"tax","대출지원":"loan","치료지원":"care","서비스지원":"service","홍보지원":"service","세탁서비스지원":"service","컨설팅지원":"Consulting"]



    
    //네비게이션 컨트롤러 변경
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        DuViewController의 view가 사라짐
        //        ReViewViewController의 view가 화면에 나타남
        setBarButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("검색결과화면 viewDidLoad")

        
        itemCount = items.count

        
        //복지혜택 검색결과
        resultLabel.frame = CGRect(x: 0, y: 116 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(DeviceManager.sharedInstance.width),  height: 62.3 *  DeviceManager.sharedInstance.heightRatio)
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
        
        
        //self.view.addSubview(resultLabel)
        
        
        //카테고리 선택버튼들
        for i in 0..<categoryItems.count {
            
            let button = UIButton(type: .system)
            button.frame = CGRect(x:CGFloat(20 + (Int(100) * i)) *  DeviceManager.sharedInstance.widthRatio, y:0, width: 80 *  DeviceManager.sharedInstance.widthRatio, height: 52 *  DeviceManager.sharedInstance.heightRatio)
            
            button.setTitle(categoryItems[i], for: .normal)
            button.titleLabel?.font = UIFont(name: "NanumGothicBold", size: 16 *  DeviceManager.sharedInstance.heightRatio)!
            
            button.setTitleColor(UIColor.black, for: .normal)
            button.layer.addCategoryBtnBorder([.bottom], color:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 1.0)

            
            
            let label = UILabel()
            label.text = categoryItems[i]
            label.font = UIFont(name: "NanumGothicBold", size: 16 *  DeviceManager.sharedInstance.heightRatio)!
            label.textColor = UIColor.black
            
//            button.layer.cornerRadius = 23 *  DeviceManager.sharedInstance.heightRatio

           // button.layer.borderWidth = 1.3
            button.tag = i
            //카테고리 선택시 카테고리에 해당하는 데이터만 보여주는 메소드
            button.addTarget(self, action: #selector(self.selectCategory), for: .touchUpInside)
            buttons.append(button)
            //button.layer.borderColor = UIColor(displayP3Red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 1) as! CGColor
            
//            button.layer.shadowColor = UIColor.black.cgColor
//            button.layer.shadowOffset = CGSize(width: 5, height: 5) // 반경에 대해서 너무 적용이 되어서 4point 정도 ㅐ림.
//
//            button.layer.shadowOpacity = 1
//            button.layer.shadowRadius = 1 // 반경?
//
//            button.layer.shadowOpacity = 0.5 // alpha값입니다.
            
            categoryScrlview.addSubview(button)
            
        }
        
        //전체버튼 기본 선택상태
  
        buttons[0].layer.addCategoryBtnBorder([.bottom], color:UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), width: 1.0)

        buttons[0].setTitleColor(UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), for: .normal)
        //buttons[0].backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        
        //가로 카테고리 스크롤뷰 추가
        categoryScrlview.frame = CGRect(x: 0, y: 120 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(DeviceManager.sharedInstance.width), height: 52 *  DeviceManager.sharedInstance.heightRatio)
        categoryScrlview.contentSize = CGSize(width:(CGFloat(100 * categoryItems.count) *  DeviceManager.sharedInstance.widthRatio)+20, height: 0)
        //categoryScrlview.showsVerticalScrollIndicator = false
        //categoryScrlview.showHori
        categoryScrlview.showsHorizontalScrollIndicator = false
        self.view.addSubview(categoryScrlview)
        
        
        resultTbView = UITableView(frame: CGRect(x: 0, y: Int(220 *  DeviceManager.sharedInstance.heightRatio), width: Int(DeviceManager.sharedInstance.width), height: Int(DeviceManager.sharedInstance.height) - Int(311.7 *  DeviceManager.sharedInstance.heightRatio)))
        
        
        //테이블 셀간의 줄 없애기
        resultTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //커스텀 테이블뷰를 등록
    
        
        
        resultTbView.register(NewResultCell.self, forCellReuseIdentifier: NewResultCell.identifier)
        
        resultTbView.dataSource = self
        resultTbView.delegate = self
        
        resultTbView.rowHeight = 220 *  DeviceManager.sharedInstance.heightRatio
        //myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.view.addSubview(resultTbView)
        

        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("정책 선택")
        
        //상세페이지로 이동한다.
        //print("\(items[indexPath.section].sd[indexPath.row])")
        
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewDetailView") as? NewDetailView         else{
            
            return
            
        }
        
        
        if(selected == "전체"){
        RVC.selectedPolicy = "\(items[indexPath.row].welf_name)"
            RVC.selectedLocal = "\(items[indexPath.row].welf_local)"
            var imgName = items[indexPath.row].welf_category[0]
            
            RVC.selectedImg = imgDic[imgName]!
            print("선택한 정책명 : \(items[indexPath.row].welf_name)")
            print("선택한 정책의 지역 : \(items[indexPath.row].welf_local)")
            print("선택한 정책의 카테고리 : \(items[indexPath.row].welf_category[0])")


        }else{
            RVC.selectedPolicy = "\(filtered[indexPath.row].welf_name)"
            RVC.selectedLocal = "\(filtered[indexPath.row].welf_local)"
            
            var imgName = filtered[indexPath.row].welf_category[0]
            print("선택한 정책명 : \(filtered[indexPath.row].welf_name)")
            print("선택한 정책의 지역 : \(filtered[indexPath.row].welf_local)")


            RVC.selectedImg = imgDic[imgName]!
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
        let cell = tableView.dequeueReusableCell(withIdentifier: NewResultCell.identifier, for: indexPath) as! NewResultCell
        
   
        //아이템의 제목을 받아 바꿔준다
      
        
        cell.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 1.3
        cell.layer.cornerRadius = 34 *  DeviceManager.sharedInstance.heightRatio
        cell.clipsToBounds = true
        print(selected)
        //cell.textLabel?.text = "\(firstItems[indexPath.row])"
        //cell.policyLank.text = String(indexPath.row)
        
        if(selected == "전체"){
            print(items[indexPath.row].welf_category)
            var title = items[indexPath.row].welf_name.replacingOccurrences(of: " ", with: "\n")
        cell.policyName.text = "\(title)"
            cell.localName.text = "#\(items[indexPath.row].welf_local)"
        var imgName = items[indexPath.row].welf_category[0]
            print("이미지 : \(imgName)")
            if(imgDic[imgName] != nil){
            cell.categoryImg.setImage(UIImage(named: imgDic[imgName]!)!)
            }else{
                cell.categoryImg.setImage(UIImage(named: "AppIcon")!)

            }
        }else {
            var title = filtered[indexPath.row].welf_name.replacingOccurrences(of: " ", with: "\n")
                     cell.policyName.text = "\(title)"
            cell.localName.text = "#\(items[indexPath.row].welf_local)"

        var imgName = filtered[indexPath.row].welf_category[0]
            print("이미지 : \(imgName)")
            if(imgDic[imgName] != nil){
            cell.categoryImg.setImage(UIImage(named: imgDic[imgName]!)!)
            }else{
              cell.categoryImg.setImage(UIImage(named: "AppIcon")!)

            }
            
        }
        
        
        cell.categoryImg.backgroundColor = UIColor.clear
        
        //음영
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 5, height: 5) // 반경에 대해서 너무 적용이 되어서 4point 정도 ㅐ림.
        
        cell.layer.shadowOpacity = 1
        cell.layer.shadowRadius = 1 // 반경?
        
        cell.layer.shadowOpacity = 0.5 // alpha값입니다.

        //셀 선택시 회색으로 변하지 않게 하기
        cell.selectionStyle = .none

        
//
        
        return cell }
    
    
    
    @objc func selectCategory(_ sender: UIButton) {
        
     //   print(buttons[sender.tag].title(for: .normal)!)
        
        for i in 0..<buttons.count {
            
            //선택한 버튼임을 표시해준다.

            if(buttons[i].tag == sender.tag){
//                buttons[i].layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
                buttons[i].setTitleColor(UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), for: .normal)
              //  buttons[i].backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
                buttons[sender.tag].layer.addCategoryBtnBorder([.bottom], color:UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), width: 1.0)
                
            }else{
                
                buttons[i].layer.addCategoryBtnBorder([.bottom], color:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 1.0)

                //buttons[i].layer.borderColor = UIColor.black.cgColor
                //buttons[i].backgroundColor = UIColor.white
                
                buttons[i].setTitleColor(.black, for: .normal)

            }
            
            
        }

        
        
    selected =     buttons[sender.tag].title(for: .normal)!
    
        //해당 카테고리의 아이템 숫자를 센다.
        if(selected != "전체"){
            
//        itemCount = items.filter { $0.welf_category == selected
//        }.count
            
            filtered = items.filter{ $0.welf_category.contains(selected)
            }

            
            

            
        }else{
            itemCount = items.count
        }
        self.resultTbView.reloadData()
//        resultTbView.dataSource = self
//        resultTbView.delegate = self
//

    }

    //네비게이션 바 세팅
    private func setBarButton() {
        
       
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
    
    
    
    
}
