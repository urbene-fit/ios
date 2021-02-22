//
//  MapTest.swift
//  welfare
//
//  Created by 김동현 on 2020/09/19.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class MapTest: UIViewController , XMLParserDelegate {

    
    var currentElement = ""
    // 현재 Element
    var placeItems = [[String : String]]()
    // 영화 item Dictional Array
    var placeItem = [String: String]()
    // 영화 item Dictionary
    var placeName = ""
    // 영화 제목
    var placeAddr = ""
    // 영화 내용

    enum TagType { case title, none }


    //각 태그의 데이터를 담긴 내용을 파싱하기 위해서
    //태그 시작시에만 데이터를 가져오게 끔 불린을 선언
    var TagName = false
    var TagAddr = false


    override func viewDidLoad() {
        super.viewDidLoad()

        print("공공데이터")
        // Do any additional setup after loading the view.
        //공공데이터의 키와 공공데이터의 url 주소를 연결
       // let key = "7a6878684464616c3536675a545561"
        let url = "http://openapi.seoul.go.kr:8088/7a6878684464616c3536675a545561/xml/ListDisabledFacilitiesService/1/5/"
        //xml로 받아온 데이터를 파싱하기 위해 xmlparser 객체 생성후 url로 연결 시킨후
        //파싱메소드를 재정의하여 내용을 받아온다.
        guard let xmlParser = XMLParser(contentsOf: URL(string: url)!) else { return }
        xmlParser.delegate = self
        xmlParser.parse()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // XML 파서가 시작 테그를 만나면 호출됨
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        //print(elementName)
        //print("파서시작")
        
        //새로운 장소를 추가하기 위해 장소아이템을 다시 선언
        if (elementName == "row") {
            placeItem = [String : String]()
            placeName = ""
            placeAddr = ""
          //  print(elementName)

        }
        
        //데이터를 파싱할 각 데이터의 시작지점을 알린다.
        if (elementName == "NAME") {

            TagName = true
            
            
            
        }
        if (elementName == "ADDR") {

            TagAddr = true
            
               }
            
        
        
    }

    // 현재 테그에 담겨있는 문자열 전달
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        //태그를 받아서 태그에 따른 데이터를 상응하는 키값에 저장
        //ex 태그가 장소이름이면 장소이름 변수에 저장
        if (currentElement == "NAME") {
          
            if(TagName){
           print("이름")
                     print(string)
                placeName = string
            }
            //장소의 주소
        } else if (currentElement == "ADDR") {
          // print("주소")
           // print(string)
            if(TagAddr){
            placeAddr = string
            }
            
        }

            
    }

    // XML 파서가 종료 테그를 만나면 호출됨
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        
        
        //데이터를 파싱할 각 데이터의 종료지점을 알린다.
               if (elementName == "NAME") {

                   TagName = false
                   
                   
                   
               }
               if (elementName == "ADDR") {

                   TagAddr = false
                   
                      }
        
        
       // print("종료태그")
        
        
//        if (elementName == "Name") {
//            print("로우진입")
//            placeItem["NAME"] = placeName
//            placeItem["ADDR"] = placeAddr
//        //print("파싱한 이름 ")
//        //print("이름")
//        print(placeName)
//
//            placeItems.append(placeItem)
//
//        }
 

          
    }

}
