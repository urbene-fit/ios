//
//  LoginManger.swift
//  welfare
//
//  Created by 김동현 on 2020/12/29.
//  Copyright © 2020 com. All rights reserved.
//

import Foundation
import Alamofire



class LoginManager {
    
    static let sharedInstance = LoginManager()
    
    
    var token : String = ""
    var checkInfo : Bool = false
    var nickName : String = ""
    var loginId = Int()
    
    //푸쉬알람 체크
    var push : Bool = false
    
    //세션id를 저장하는 변수
    var sessionID : String = ""
    
    //세션파싱
    struct parse: Decodable {
        let SessionId : String
 
    }
    
    //회원 세션 ID를 가져오는 메소드
    func memberGetSession(){
        
        
        print("멤버 세션받는 메소드")
        print("토큰 : \(token)")
        
        let parameters = ["type": "main"]
        
                let headers = [
                    "LoginToken": token
                  ]
    
        
        Alamofire.request("https://www.urbene-fit.com/log", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { (response) in

                
                switch response.result {
                case .success(let value):
 
                    do {

                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let parseResult = try JSONDecoder().decode(parse.self, from: data)

                        self.sessionID = parseResult.SessionId
                        print("세션아이디 : \(self.sessionID)")
                        print("로그쌓음")

                    }catch let DecodingError.dataCorrupted(context) {
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
                    print(error)
                }
                
            }//
        
    }
    
    
    //비회원 세션 ID를 가져오는 메소드
    func getSession(){
        
        
        
        let parameters = ["type": "main"]
        
                let headers = [
                    "LoginToken": token
                  ]
    
        
        Alamofire.request("https://www.urbene-fit.com/log", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { (response) in

                print("세션받는 메소드")

//        Alamofire.request("https://www.urbene-fit.com/log", method: .get, parameters: parameters)
//            .validate()
//            .responseJSON {  response in
//
                switch response.result {
                case .success(let value):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let parseResult = try JSONDecoder().decode(parse.self, from: data)

                        self.sessionID = parseResult.SessionId
                        print("세션아이디 : \(self.sessionID)")
                        print("로그쌓음")
                    }catch let DecodingError.dataCorrupted(context) {
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
                    print(error)
                }
                
            }//
        
    }
}


