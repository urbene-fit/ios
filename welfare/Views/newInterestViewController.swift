//
//  newInterestViewController.swift
//  welfare
//
//  Created by 김동현 on 2021/03/10.
//  Copyright © 2021 com. All rights reserved.
//

import UIKit 
import Alamofire



class newInterestViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
  
    
    private var observer: NSObjectProtocol?
    private let ageValues: [String] = ["연령대","10대","20대","30대","40대","50대","60대","70세 이상"]

    
    var LabelName = ["남자","여자"]
    //버튼들을 담을 배열
    var buttons = [UIButton]()
    
    //필터링에 필요한 정보
    var gender : String = ""
    var age : String = ""
    
    //파싱구조체
    
    struct StatusParse: Decodable {
        let Status : String
        let Message : [[String: String]]
    }
    
    
    struct Test : Decodable{
        let name: String
        let age: Int
        let height: Double
        var dictionary: [String: Any] {
            return ["10대,남자": name,
                    "10대,여자": age,
                    "20대,남자": height]
        }
        var nsDictionary: NSDictionary {
            return dictionary as NSDictionary
        }
    }
    
    

    
    struct interstItem{
        var target : String
        var intersts : [String]
    }
    
    var interstItems = [interstItem]()
    

    var filterItems = [interstItem]()
    
    //관심사 선택을 보여줄 콜렉션 뷰
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var totalWidthPerRow = CGFloat(0)
    var rowCounts = 0
    let spaceBetweenCell = CGFloat(10) // whatever the space between each cell is
    @objc var selected : String = "전체"
    var itemCount : Int = 20

    var alert = UIAlertController()
    let pickerView = UIPickerView()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("관심사 선택 : viewDidAppear")
        
        // 네비게이션 컨트롤러 변경, DuViewController의 view가 사라짐, ReViewViewController의 view가 화면에 나타남
        //setBarButton()
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("관심사 선택 viewWillDisappear")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("관심사 선택 viewWillAppear")
   
    
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "callFunction"), object: nil)


        
        // Do any additional setup after loading the view.
        setKeyworld()
        
        
        
        
        
        
        //라벨
        let bannerLabel = UILabel()
        bannerLabel.frame = CGRect(x: 20  *  DeviceManager.sharedInstance.widthRatio, y: 180  *  DeviceManager.sharedInstance.heightRatio, width: 400 * DeviceManager.sharedInstance.widthRatio, height: 20 *  DeviceManager.sharedInstance.heightRatio)
        bannerLabel.backgroundColor = UIColor.clear
        bannerLabel.text = "관심사 선택"
        bannerLabel.textColor = UIColor.black
        bannerLabel.font = UIFont(name: "NanumBarunGothicBold", size: 16  *  DeviceManager.sharedInstance.heightRatio)
        
        let attrString = NSMutableAttributedString(string: bannerLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 20  *  DeviceManager.sharedInstance.heightRatio
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        bannerLabel.attributedText = attrString
        bannerLabel.textAlignment = .left
        self.view.addSubview(bannerLabel)
        
        
        //필터설정버튼
        let button = UIButton(type: .system)

        button.addTarget(self, action: #selector(self.goFilter), for: .touchUpInside)
        button.frame = CGRect(x:360 * DeviceManager.sharedInstance.widthRatio, y: 100 * DeviceManager.sharedInstance.heightRatio, width: 30 * DeviceManager.sharedInstance.widthRatio, height: 30 * DeviceManager.sharedInstance.heightRatio)
        
        
        
        //이미지 및 라벨 추가
        let img = UIImage(named: "settings")
        let imgView = UIImageView()
        imgView.setImage(img!)
        imgView.frame = CGRect(x: 0, y: 0, width: 30, height: 30 * DeviceManager.sharedInstance.heightRatio)
        //imgView.image = imgView.image?.withRenderingMode(.alwaysOriginal)
        
//        imgView.layer.cornerRadius = imgView.frame.height/2
//        imgView.layer.borderWidth = 1
//        imgView.layer.borderColor = UIColor.clear.cgColor
//        imgView.clipsToBounds = true
        
        
        button.addSubview(imgView)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .white
        
        //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
        
        //카테고리에 사용되는 뷰들을 리스트로 관리해서 선택됫을경우 선탟된 카테고리의 뷰들
        //에 대해 변형해준다.
        
        
        self.view.addSubview(button)
        
        

    }
    
    
    
    //키워드를 받아오는 부분
    func setKeyworld(){
        
        let parameters = ["type":"all"]
        
        
        Alamofire.request("https://www.hyemo.com/user", method: .get, parameters: parameters)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    
                    
                    
                    //                    if let json = value as? [String: Any] {
                    //                        //print(json)
                    //                        for (key, value2) in json {
                    //                            //카테고리데이터를 집어넣는다.
                    //
                    //                           print(value2)
                    //
                    //
                    //
                    //                        }
                    //
                    //                    }
                    
                    
                    //print(value)
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let parseResult = try JSONDecoder().decode(StatusParse.self, from: data)
                        
                        print(parseResult.Message[0])
                        for i in 0..<parseResult.Message.count {
                            
                            
                            
                            for (key, value) in parseResult.Message[i] {
                                //print("\(key) : \(value)")

                                //각 타겟별 관심사를 String으로 바꿔준다.
                                var transe = value as! String
                                var itemKey = key as! String


                                //split
                                var arr = transe.components(separatedBy: ",")

                                self.interstItems.append(newInterestViewController.interstItem.init(target: itemKey, intersts: arr))
                                print("타겟 : \(self.interstItems[i].target)")

                            }
                        }//이중 반복문 파싱종료
                        
                        let layout = UICollectionViewFlowLayout()
                           //layout.itemSize = CGSize(width: 300, height: 40)
            //            //콜렉션뷰 스크롤 방향
            //            layout.scrollDirection = .horizontal
            //            layout.minimumInteritemSpacing = 40
                        
                        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 220 * DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width, height: DeviceManager.sharedInstance.height - 220), collectionViewLayout: layout)
                    
                    
                        self.view.addSubview(self.collectionView)
                        self.collectionView.delegate   = self
                        self.collectionView.dataSource = self
                        self.collectionView.register(interestCell.self, forCellWithReuseIdentifier: "interestCell")
                    //collectionView.isPagingEnabled = true
                        self.collectionView.backgroundColor = UIColor.white
                    // 스크롤 시 빠르게 감속 되도록 설정
                        self.collectionView.decelerationRate = .fast
                        self.collectionView.showsHorizontalScrollIndicator = false

                        //셀 다중선택
                        self.collectionView.allowsMultipleSelection = true

                    

                        self.view.addSubview(self.collectionView)
                        
                        
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
                //
                //
                //
                case .failure(let error):
                    print(error)
                }
            }
        
        
    }
    
    //관심사들을 담은 컬렉션 뷰 관련 메소드
    //관심사의 길이에 따라 버튼길이를 결정해준다.
    //처음에는 모든 관심사를 보여주고, 필터설정후에는 필터링된 관심사의 갯수로 바꿔준다.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return interstItems[interstItems.count - 1].intersts.count
        switch selected {

        case ("전체"):
            return itemCount

            
        case (let value) where value != "전체":
            return itemCount

        default:

            return itemCount

        
        }
        
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCell", for: indexPath as IndexPath) as! interestCell
        
        print("콜렉션뷰 셀 생성")
        
        if(selected == "전체"){
            print("콜렉션뷰 셀 생성(전체)")

        var title = interstItems[interstItems.count - 1].intersts[indexPath.row]
        
        cell.selectBtn.setTitle("\(title)", for: .normal)

        }else{
            print("콜렉션뷰 셀 생성(필터링)")

            var title = filterItems[0].intersts[indexPath.row]
            
            cell.selectBtn.setTitle("\(title)", for: .normal)
            
        }
        

    
         return cell
    }
    
    
    //셀크기 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        switch selected {

        case ("전체"):
            print("전체")
            var title = interstItems[interstItems.count - 1].intersts[indexPath.row]
            //let width = self.estimatedFrame(text: title, font: UIFont(name: "NanumBarunGothicBold", size: 12  *  DeviceManager.sharedInstance.heightRatio)!).width
            let font = UIFont(name: "NanumBarunGothicBold", size: 16)
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = title.size(withAttributes:[.font: UIFont(name: "NanumBarunGothicBold", size: 16)])

            return CGSize(width: 30 + size.width * 1.3, height: 45)
            
        case (let value) where value != "전체":
            
            var title = filterItems[0].intersts[indexPath.row]
            //let width = self.estimatedFrame(text: title, font: UIFont(name: "NanumBarunGothicBold", size: 12  *  DeviceManager.sharedInstance.heightRatio)!).width
            let font = UIFont(name: "NanumBarunGothicBold", size: 16)
            let fontAttributes = [NSAttributedString.Key.font: font]
            //let size = (title as NSString).size(withAttributes: fontAttributes)
            
            let size = title.size(withAttributes:[.font: UIFont(name: "NanumBarunGothicBold", size: 16)])
            
            return CGSize(width: 30 + size.width * 1.3, height: 45)
        default:

            var title = ""

            let size = title.size(withAttributes:[.font: UIFont(name: "NanumBarunGothicBold", size: 16)])

            return CGSize(width: 30, height: 45)

        
        }
        
//        print("현재 행 수  : \(rowCounts)")
//        print("텍스트 길이 : \(title.count)  셀 너비 : \(size.width)")
//        return CGSize(width: 30 + size.width * 1.3, height: 45)
    }

//    func estimatedFrame(text: String, font: UIFont) -> CGRect {
//        let size = CGSize(width: 300, height: 40) // temporary size
//        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
//        return NSString(string: text).boundingRect(with: size,
//                                                   options: options,
//                                                   attributes: [NSAttributedString.Key.font: font],
//                                                   context: nil)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("콜렉션 아이템 선택")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCell", for: indexPath as IndexPath) as! interestCell
        
        
        cell.isSelected = true
        
        // 선택한 키워드들 배열에 관리
        

    }
    
    //필터버튼을 선택하면
    @objc func goFilter(){
        
        // Set the delegate.
        pickerView.delegate = self
        // Set the dataSource.
        pickerView.dataSource = self
        
        alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
     
        pickerView.frame = CGRect(x: 15 * DeviceManager.sharedInstance.widthRatio, y: 90 * DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - (30 * DeviceManager.sharedInstance.widthRatio) , height: 130  * DeviceManager.sharedInstance.heightRatio)
        
        
        
        
     let confirmBtn = UIButton(type: .system)
     confirmBtn.frame =  CGRect(x: 300 * DeviceManager.sharedInstance.widthRatio, y: 0, width: 100 * DeviceManager.sharedInstance.widthRatio, height: 50  * DeviceManager.sharedInstance.heightRatio)

     confirmBtn.setTitle("확인", for: .normal)
     confirmBtn.titleLabel!.font = UIFont(name: "Jalnan", size:14 * DeviceManager.sharedInstance.heightRatio)
     confirmBtn.setTitleColor(UIColor.black, for: .normal)
     confirmBtn.addTarget(self, action: #selector(self.dismissAlert), for: .touchUpInside)
     confirmBtn.tag = 1
     let customView = UIView()
     
        alert.view.addSubview(confirmBtn)

     customView.addSubview(pickerView)

     alert.view.addSubview(customView)
     
        //남녀선택 버튼
        for i in 0..<2 {

        var button = UIButton(type: .system)
      
                  
            button.translatesAutoresizingMaskIntoConstraints = false

        button.frame = CGRect(x: CGFloat((20 + (80 * i)))  * DeviceManager.sharedInstance.widthRatio, y: 40  * DeviceManager.sharedInstance.heightRatio, width: 60 * DeviceManager.sharedInstance.widthRatio, height: 40 * DeviceManager.sharedInstance.heightRatio)

        
        buttons.append(button)
                              
                              button.tag = i
        button.setTitle("\(LabelName[i])", for: .normal)
        button.titleLabel?.font = UIFont(name: "Jalnan", size: 12 *  DeviceManager.sharedInstance.heightRatio)!
        button.setTitleColor(UIColor.black, for: .normal)
                       
                        button.layer.cornerRadius = 17 *  DeviceManager.sharedInstance.heightRatio
        button.layer.borderWidth = 0.1
            button.addTarget(self, action: #selector(self.selectGender), for: .touchUpInside)

        
        
            customView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = true


        }
     
        pickerView.translatesAutoresizingMaskIntoConstraints = false

     customView.translatesAutoresizingMaskIntoConstraints = false
     customView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50).isActive = true
     customView.rightAnchor.constraint(equalTo: alert.view.rightAnchor, constant: 50).isActive = true
     customView.leftAnchor.constraint(equalTo: alert.view.leftAnchor, constant:50).isActive = true
     customView.heightAnchor.constraint(equalToConstant: 360 * DeviceManager.sharedInstance.heightRatio).isActive = true
     
  
     
     alert.view.translatesAutoresizingMaskIntoConstraints = false
     alert.view.widthAnchor.constraint(equalToConstant: DeviceManager.sharedInstance.width).isActive = true
     //alert.view.backgroundColor =  #colorLiteral(red: 0.9017364597, green: 0.9017364597, blue: 0.9017364597, alpha: 1)
     alert.view.heightAnchor.constraint(equalToConstant: 250 * DeviceManager.sharedInstance.heightRatio).isActive = true
     
     //customView.backgroundColor =  #colorLiteral(red: 0.9017364597, green: 0.9017364597, blue: 0.9017364597, alpha: 1)
     self.present(alert, animated: false, completion: nil)
        
        
//
//
//        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "filterViewController") as? filterViewController         else{
//
//            return
//
//        }
//
//        for i in 0..<interstItems.count {
//
//            uvc.interstItems.append(filterViewController.interstItem.init(target: interstItems[i].target, intersts: interstItems[i].intersts))
//        }
        //전환된 화면의 형태지정
        //uvc.modalPresentationStyle = .


       // self.navigationController?.pushViewController(uvc, animated: true)
       // self.present(uvc, animated: true, completion: nil)
        
//        selected = "변경"
//        filterItems = interstItems.filter{ $0.target.contains("10대,남자")}
//
//        collectionView.reloadData()

        
    }
    
    

 
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
      
            return ageValues.count
        
            
        }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        
            var label = view as! UILabel?
            if label == nil {
                label = UILabel()
                label?.textAlignment = .center
            }
         

                label?.text = ageValues[row]
                 label?.font = UIFont(name: "Jalnan", size: 22 * DeviceManager.sharedInstance.heightRatio)
              
                return label!
            
           
           

       }
    
    //선택한 연령대를 저장ㅇ
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        age = ageValues[row]
        print("연령대 저장 \(age)")

        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
 
    //액션시트 관련 메소드
    @objc func dismissAlert(_ sender: UIButton) {

        //액션시트를 없애주고
        alert.dismiss(animated: false, completion: nil)
        
        selected = "변경"
        filterItems = interstItems.filter{ $0.target.contains("\(age),\(gender)")}

        
           itemCount = filterItems[0].intersts.count

        collectionView.reloadData()

    }
    
 
    
    
    @objc func selectGender(_ sender: UIButton) {
        //키워드 선택시
        
        
        //선택 해제하는 경우
        if(buttons[sender.tag].layer.borderColor == UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor){
            //선택해제
            buttons[sender.tag].layer.borderColor = UIColor.black.cgColor
            
            //키워드 리스트에서 삭제
            //keyWorlds = keyWorlds.filter(){$0 != buttons[sender.tag].currentTitle}
            buttons[sender.tag].setTitleColor(UIColor.black, for: .normal)
                       
            gender = ""
            print("성별 해제 \(gender)")

            
        }else{
            //선택표시
            buttons[sender.tag].layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
         
            buttons[sender.tag].setTitleColor(UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), for: .normal)
            
            
            gender = LabelName[sender.tag]
            print("성별 저징 \(gender)")
            
            
            //다른 성별버튼 해제
            
            var tag = Int()
            if (sender.tag == 0){
                tag = 1
            }else{
                tag = 0

            }
            buttons[tag].layer.borderColor = UIColor.black.cgColor
            
            //키워드 리스트에서 삭제
            //keyWorlds = keyWorlds.filter(){$0 != buttons[sender.tag].currentTitle}
            buttons[tag].setTitleColor(UIColor.black, for: .normal)


            
        }
        
        
        
        
        
    }
}
