//
//  mapResultViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/11/29.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Alamofire

//지역의 혜택정보를 보여주는 화면

class mapResultViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate {
    

   
    
    
    //검색창 바
    let searchBar = UISearchBar()
    
    //지역 혜택정보
    struct  localPolicy : Decodable {
        let welf_name: String
    }
    
    
    //지역혜택의 정보를 보여줄 아이템
    struct item {
        var welf_name: String
        
    }
    
    var items: [item] = []

    //지역혜택을 보여주는 테이블 뷰
    private var localTbView: UITableView!
    
    //현재 지역을 저장하는 변수
    var local = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        //화면 스크롤 크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        
        let appLogo = UIImageView()
        let resultLabel = UILabel()
        //메인 좌측상단 로고 추가
        let LogoImg = UIImage(named: "appLogo")
        appLogo.image = LogoImg
        appLogo.frame = CGRect(x: 22.1, y: 26.7, width: 106, height: 14.3)
        self.view.addSubview(appLogo)
        
        
        //복지혜택 검색결과
        resultLabel.frame = CGRect(x: 31.3, y: 116, width: 400, height: 62.3)
        resultLabel.textAlignment = .left
        resultLabel.numberOfLines = 2
        

        self.view.addSubview(resultLabel)
        
        
        //혜택을 검색하는 검색바
        //서치바를 동작하기 위한 대리자 선언
        searchBar.showsScopeBar = true
        
        searchBar.delegate = self
        
        
        searchBar.placeholder = "혜택이름으로 검색해보세요"

        //서치 바 추가
        searchBar.frame = CGRect(x: 20, y: 200, width: screenWidth - 40, height: 50)
   
       searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        //searchBar.sizeToFit()
        self.view.addSubview(searchBar)
        
        //지역위 혜택을 요청한다.
        let parameters = ["local": "부산", "page_number": "2"]
        
  
        
        
        Alamofire.request("http://www.urbene-fit.com/map", method: .get, parameters: parameters)
            .validate()
            .responseJSON { [self] response in
                
                switch response.result {
                case .success(let value):
                    
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let areaLists = try JSONDecoder().decode([localPolicy].self, from: data)
                        
                        
                        for i in 1..<areaLists.count {
                            
                      
                            
                           items.append(                            item.init(welf_name: areaLists[i].welf_name))
                            print(areaLists[i].welf_name)
                            
                            
                            
                        }
                        
                        localTbView = UITableView(frame: CGRect(x: 0, y: 390, width: screenWidth, height: 400))
                        
                        //테이블 셀간의 줄 없애기
                        localTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
                        
                        localTbView.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.identifier)
                        
                        localTbView.dataSource = self
                        localTbView.delegate = self
                        
                     //   localTbView.backgroundColor = UIColor.darkGray
                        localTbView.rowHeight = 186
                        localTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
                        
                        self.view.addSubview(localTbView)
                        
                        
                        let shu : String = String(areaLists.count)
                        //resultLabel.text = "복지 혜택 결과가 +'100'+개가\n검색되었습니다."
                        resultLabel.text = "당신이 놓치고 있는 \(local) 지역의 혜택은 \n총 \(shu) 개 입니다."
                        
                        
                        let attributedStr = NSMutableAttributedString(string: resultLabel.text!)
                        
                        // let regex = try? NSRegularExpression(pattern: "'[0-9]'+", options: .caseInsensitive)
                        
                        //attributedStr.addAttribute(.foregroundColor, value: UIColor.blue, range: (resultLabel.text! as NSString).range(of: "[0-9]"))
                        attributedStr.addAttribute(.foregroundColor, value: UIColor(red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1.0), range: (resultLabel.text! as NSString).range(of: shu))
                        
                        
                        
                        
                        resultLabel.attributedText = attributedStr
                        
                        resultLabel.font = UIFont(name: "Jalnan", size: 16.1)
                        
                        
                        
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
                    print("Error: \(error)")
                    break
                    
                    
                }
            }
        
        
        
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
   
    }
    
    
    //셀 클릭이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("정책 선택")
        
        //상세페이지로 이동한다.
        print("\(items[indexPath.row].welf_name)")
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "DuViewController") as? DuViewController         else{
            
            return
            
        }
        RVC.selectedPolicy = "\(items[indexPath.row].welf_name)"
        //뷰 이동
        RVC.modalPresentationStyle = .fullScreen

        // B 컨트롤러 뷰로 넘어간다.
        self.present(RVC, animated: true, completion: nil)

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier, for: indexPath) as! ResultTableViewCell
        
    
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 1.0).cgColor
        cell.layer.borderWidth = 1.3
        cell.layer.cornerRadius = 34
        cell.clipsToBounds = true
        //cell.textLabel?.text = "\(firstItems[indexPath.row])"
        //cell.policyLank.text = String(indexPath.row)
        cell.policyName.text = "\(items[indexPath.row].welf_name)"
        return cell }
    
    
    
}
