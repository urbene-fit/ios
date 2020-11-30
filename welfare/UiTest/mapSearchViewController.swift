//
//  mapSearchViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/11/29.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class mapSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    
    
    //관심 지역
    var Items = ["서울 서초구 효령로 164","팀노바 학원","우리집","느그집","너그집"]
    
    
//    struct BorderOptions: OptionSet {
//        let rawValue: Int
//
//        static let top = BorderOptions(rawValue: 1 << 0)
//        static let left = BorderOptions(rawValue: 1 << 1)
//        static let bottom = BorderOptions(rawValue: 1 << 2)
//        static let right = BorderOptions(rawValue: 1 << 3)
//
//        static let horizontal: BorderOptions = [.left, .rigt]
//        static let vertical: BorderOptions = [.top, .bottom]
//    }
    
    var local : String = ""
    
    //상단 라벨
    let topLabel = UILabel()

    //관심지역 라벨
    let interestLabel = UILabel()

    
    
    //검색창 바
    let searchBar = UISearchBar()
    

    
    //관심지역을 보여주는 테이블 뷰
    private var AoItbView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //화면 스크롤 크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        
        
        // Do any additional setup after loading the view.
        topLabel.font = UIFont(name: "Jalnan", size: 17)
        topLabel.numberOfLines = 2
        topLabel.text = "지번,도로명,건물명등을\n입력해서 지역을 설정해보세요."
        topLabel.frame = CGRect(x: 20, y: 200, width: 246, height: 50)
        topLabel.textAlignment = .left
        
        self.view.addSubview(topLabel)
        
        //서치바를 동작하기 위한 대리자 선언
        searchBar.showsScopeBar = true
        
        searchBar.delegate = self
        
        
        searchBar.placeholder = "예) 신림동132"

        //서치 바 추가
        searchBar.frame = CGRect(x: 20, y: 270, width: screenWidth - 40, height: 50)
   
       searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        //searchBar.sizeToFit()
        self.view.addSubview(searchBar)
        
        
        
        //관심지역들을 보여주는 부분
        
        interestLabel.font = UIFont(name: "Jalnan", size: 17)
        interestLabel.text = "관심지역"
        interestLabel.frame = CGRect(x: 20, y: 350, width: 246, height: 30)
        interestLabel.textAlignment = .left
        
        self.view.addSubview(interestLabel)

        let interestLabel = UILabel()

        AoItbView = UITableView(frame: CGRect(x: 0, y: 390, width: screenWidth, height: 400))
        
        //테이블 셀간의 줄 없애기
        AoItbView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //커스텀 테이블뷰를 등록
        //myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        
        AoItbView.register(IoAtableViewCell.self, forCellReuseIdentifier: IoAtableViewCell.identifier)
        
        AoItbView.dataSource = self
        AoItbView.delegate = self
        
        AoItbView.rowHeight = 35
        //myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.view.addSubview(AoItbView)
        
        

        
 
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //검색요청 시
    
    func searchBarSearchButtonClicked(_ seachBar: UISearchBar) {
        var search : String = seachBar.text!

        print("엔터감지")
        
        
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "mapTestViewController") as? mapTestViewController         else{
            
            return
            
        }
        
       // RVC.local = local
        
        //뷰 이동
        RVC.modalPresentationStyle = .fullScreen
        
        // B 컨트롤러 뷰로 넘어간다.
        self.present(RVC, animated: true, completion: nil)
        
        
    }
    
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("searchText \(searchText)")
        }
    

//    extension UIView {
//        func addBorder(
//            toSide options: BorderOptions,
//            color: UIColor,
//            borderWidth width: CGFloat
//        ) {
//            // options에 .top이 포함되어있는지 확인
//            if options.contains(.top) {
//                // 이미 해당 사이드에 경계선이 있는지 확인하고, 있으면 제거
//                if let exist = layer.sublayers?.first(where: { $0.name == "top" }) {
//                    exist.removeFromSuperlayer()
//                }
//                let border: CALayer = CALayer()
//                border.borderColor = color.cgColor
//                border.name = "top"
//                // 현재 UIView의 frame 정보를 통해 경계선이 그려질 레이어의 영역을 지정
//                border.frame = CGRect(
//                    x: 0, y: 0,
//                    width: frame.size.width, height: width)
//                border.borderWidth = width
//                // 현재 그려지고 있는 UIView의 layer의 sublayer중에 가장 앞으로 추가해줌
//                let index = layer.sublayers?.count ?? 0
//                layer.insertSublayer(border, at: UInt32(index))
//            }
//            /**
//            각 사이드에 동일한 과정을 적용
//            */
//        }
    //}
    
    //테이블뷰 총 섹션 숫자
    //섹션별 로우 숫자
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return 5
   
    }
    
    //셀 클릭이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.text = Items[indexPath.row]
        
    }
    
    
    //테이블뷰의 셀을 만드는 메소드
    //테이블뷰의 셀이 어떤 커스텀셀을 참조하는지 지정해준다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: IoAtableViewCell.identifier, for: indexPath) as! IoAtableViewCell
        cell.selectionStyle = .none
        cell.IoAname.text = Items[indexPath.row]
        
        
        return cell
    }
    
    //화면의 다른 부분 터치하여 키보드 사라지게 하기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

         self.view.endEditing(true)

   }

    
}

