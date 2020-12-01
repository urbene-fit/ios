//
//  SnackQuestion.swift
//  welfare
//스낵컨텐츠 문항 화면

import UIKit
import Alamofire
import AlamofireImage

//extension UIImageView {
//    func downloadImageFrom(_ link:String, contentMode: UIView.ContentMode) {
//        URLSession.shared.dataTask( with: URL(string:link)!, completionHandler: {
//            (data, response, error) -> Void in
//            DispatchQueue.main.async {
//                self.contentMode =  contentMode
//                if let data = data { self.image = UIImage(data: data) }
//            }
//        }).resume()
//    }
//
//    func downloadAndResizeImageFrom(_ link:String, contentMode: UIView.ContentMode ,newWidth:CGFloat) {
//        URLSession.shared.dataTask( with: URL(string:link)!, completionHandler: {
//            (data, response, error) -> Void in
//            DispatchQueue.main.async {
//                self.contentMode =  contentMode
//                if let data = data {
//                    if let tempImage = UIImage(data: data){
//                        let scale = newWidth / tempImage.size.width
//                        let newHeight = tempImage.size.height * scale
//                        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
//                        tempImage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
//                        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//                        UIGraphicsEndImageContext()
//                        self.image = newImage
//                    }
//                }
//            }
//        }).resume()
//    }
//}

class SnackQuestion: UIViewController {
    
    
    //스낵컨텐츠의 질문을 파싱하는 구조체
    struct snackList: Decodable {
        var question : String
        var choice_1 : String
        var choice_2 : String
        var choice_1_country : String
        var choice_2_country : String
        var snack_image : String

        
    }
    
    
    //스낵컨텐츠의 결과내용을 파싱하는 구조체
    struct snackResult: Decodable {
         var snack_country : String
         var snack_image : String
        //선택결과의 나라를 설명하는 부분
         var snack_tag : String
         var snack_detail : String
        //환상의 케미국가와 환장의 케미국가(케미가 좋은 나라와 안좋은 나라)
         var good_country : String
         var bad_country : String
        var snack_country_detail : String

     }
    
    
    //이미지url주소
    var imgurl : String = ""
    
    //몇번째 문항인지 세는 변수
    var number = 1
    
    //문항을 저장하는 변수
    var question : String = ""
    //선택지1을 저장하는 변수
    var choice : String = ""
    
    //선택지2를 저장하는 변수
    var sec_choice : String = ""
    
    //선택지 1을 골랐을 경우 더해야 하는 나라를 저장하는 변수
    var nation : String = ""
    
    //선택지 2을 골랐을 경우 더해야 하는 나라를 저장하는 변수
    var sec_nation : String = ""
    
  

    
    
    //어떤 나라가 많이 선택되었는지  자료구조
    struct item {
        var name: String
        var count : Int
        
    }
    
    var items: [item] = []
    
    
    var newNation : Bool = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SnackQuestion 화면시작")
       // print(number)
        //화면 스크롤 크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        
        
        //print("이미지 주소 \(imgurl)")
        
        //화면구조도
        
        
        //질문 라벨
        let questionLabel = UILabel()
        questionLabel.frame = CGRect(x: 10, y: 13, width: screenWidth - 5, height: 186)
        questionLabel.textAlignment = .left
        //titleLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
        //폰트지정 추가
        
     
        
        //23번째 글자뒤에서 띄어쓰기
        //질문이 길면 보기 특정길이를 넘어가면 띄어쓰기 를 추가해준다.
        //우선 문자열 총길이부터 검사
        if(question.count>26){
            let index = question.index(question.startIndex, offsetBy: 21)
            question.insert("\n", at: index)

            
        }
        
        questionLabel.text = question
             questionLabel.numberOfLines = 2
             questionLabel.font = UIFont(name: "TTCherryblossomR", size: 23)
        
        
        self.view.addSubview(questionLabel)
        
                let imgView = UIImageView()
     
                imgView.frame = CGRect(x: 40, y: 169, width: Double(screenWidth - 80), height: 221)
        let url = URL(string: imgurl)
        Alamofire.request(url!).responseImage { response in
                            
              if response.data == nil {
                                
                    Alamofire.request("basic_image_URL").responseImage { response in
                                    
                    imgView.image = UIImage(data: response.data!, scale:1)
                      }
              } else {
                    imgView.image = UIImage(data: response.data!, scale:1)
              }
                            
        }
        self.view.addSubview(imgView)



//              let frame = self.view.frame
//                let urlImageImageView = UIImageView(frame: CGRect(x: 40, y: 165, width: Double(screenWidth - 80), height: 221))
//                let urlResizedImageView = UIImageView(frame: CGRect(x: 40, y: 165, width: Double(screenWidth - 80), height: 221))
//
//                urlImageImageView.downloadImageFrom(imgurl, contentMode: .scaleToFill)
//                //urlResizedImageView.downloadAndResizeImageFrom(imgurl, contentMode: .scaleToFill, newWidth: 50)
//
//                self.view.addSubview(urlImageImageView)
                //self.view.addSubview(urlResizedImageView)


        
        //메인 이미지뷰
//        let imgView = UIImageView()
//        let img = UIImage(named: "Q1")
//        imgView.setImage(img!)
//        imgView.frame = CGRect(x: 40, y: 165, width: Double(screenWidth - 80), height: 221)
//
//        self.view.addSubview(imgView)
//                 let url = URL(string: imgurl)
//        var image = UIImage()
//        //뷰 선언은 메인만 가능
//            let imgView = UIImageView()
//
//                 //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
//                 //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
//                 DispatchQueue.global().async {
//                     let data = try? Data(contentsOf: url!)
//                     //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//                    DispatchQueue.main.async { image = UIImage(data: data!)! }
//
//
//                                // let img = UIImage(data: data)
//                    imgView.setImage(image)
//                                 imgView.frame = CGRect(x: 40, y: 165, width: Double(screenWidth - 80), height: 221)
//
//                     self.view.addSubview(imgView)
//
//
//                 }
//
        
        //첫번째 선택버튼
        var firBtn = UIButton(type: .system)
        
        firBtn.setTitle(choice, for: .normal)
        firBtn.frame = CGRect(x: 20, y: 442, width: 335, height: 53.7)
        //firBtn.frame = CGRect(x: 20, y: 363, width: 335, height: 60)

        
        firBtn.titleLabel!.font = UIFont(name: "TTCherryblossomR", size:16.7)
        //firBtn.titleLabel!.font = UIFont(name: "jalan", size:100)

        firBtn.setTitleColor( UIColor.white, for: .normal)
        firBtn.backgroundColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
        
        firBtn.layer.cornerRadius = 6.3
        firBtn.layer.borderWidth = 1.3
        firBtn.layer.borderColor =  UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1).cgColor
        firBtn.tag = 1
        
        //문항 선택시 다음 문항으로 넘어가는 메소드
        firBtn.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
        self.view.addSubview(firBtn)
        
        
        
        
        //두번째 버튼
        var secBtn = UIButton(type: .system)
        
        secBtn.setTitle(sec_choice, for: .normal)
        secBtn.frame = CGRect(x: 20, y: 505, width: 335, height: 53.7)
        
        secBtn.titleLabel!.font = UIFont(name: "TTCherryblossomR", size:16.7)
        secBtn.setTitleColor( UIColor.white, for: .normal)
        secBtn.backgroundColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
        
        secBtn.layer.cornerRadius = 6.3
        secBtn.layer.borderWidth = 1.3
        secBtn.layer.borderColor =  UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1).cgColor
        secBtn.tag = 2
        //문항 선택시 다음 문항으로 넘어가는 메소드
        secBtn.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
        self.view.addSubview(secBtn)
        
        //하단 진행바
        // Create a ProgressView.
        let pv: UIProgressView = UIProgressView(frame: CGRect(x:0, y:561, width:200, height:10))
        pv.progressTintColor = UIColor.systemPink
        pv.trackTintColor = UIColor.white
        // Set the coordinates.
        pv.layer.position = CGPoint(x: screenWidth/2, y: screenHeight - 50)
        // Set the height of the bar (1.0 times horizontally, 2.0 times vertically).
        pv.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        // Set the progress degree (0.0 to 1.0).
        pv.progress = 0.0
        // 문항을 프로그레스바에 반영해준다.
        var pvNumber : Float = Float(number) * 0.1
        pv.setProgress(pvNumber, animated: true)
        
        self.view.addSubview(pv)
        
        
        
    }
    
    
    //문항선택에 대한 메소드 
    @objc func selected(_ sender: UIButton) {
        //print("테스트 시작")
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "SnackQuestion") as? SnackQuestion         else{
              
              return
              
          }
        
        //스낵컨텐츠에 참여한 사용자가 선택한 문항에 따라
        //해당 유형의 나라의 선택된 횟수를 계산해준다
        //let index = items.name.firstIndex(where: {$0 == "A"})
        
        //첫번째 문항 선택과 두번째 문항선택을 구분
        if(sender.tag == 1){
            
  
            print("1번 선택\(nation)")
            
            //기존에 이미 선택되었던 나라면 횟수를 더해주고
            if let i = items.firstIndex(where: { $0.name == nation }) {
                
        
                items[i].count = items[i].count+1
                print("선택된 나라명 \(items[i].name)")
                print("나라 카운팅 \(items[i].count)")
                //처음 선택된 경우 나라를 추가하고 카운팅을해준다.
                
            }else{
                items.append(item.init(name: nation, count: 1))
                print("선택된 나라명 \(items[items.count-1].name)")
            }
            
            
            //2번째 문항
        }else if(sender.tag == 2){
            
            print("2번 선택\(sec_nation)")
            
            //기존에 이미 선택되었던 나라면 횟수를 더해주고
            if let i = items.firstIndex(where: { $0.name == sec_nation }) {
                items[i].count = items[i].count+1
                print("선택된 나라명 \(items[i].name)")
                print("나라 카운팅 \(items[i].count)")
                //처음 선택된 경우 나라를 추가하고 카운팅을해준다.
                
            }else{
                items.append(item.init(name: sec_nation, count: 1))
                print("선택된 나라명 \(items[items.count-1].name)")
            }
        }
        
        //
        //다음 문항으로 넘어가기때문에 문항넘버를 더해준다.
        number += 1
        RVC.number = number
        //추가된 나라사항을 저장한다
        RVC.items = items
    
        
        //문항수가 마지막에 도달하면
        //오름차순을 통해서 가장많이 선택된 유형(나라)를 정렬 후
        //서버로 그 나라의 정보를 요청한다.
        print("정렬 전 국가")
        for i in 0..<items.count {
        print(items[i].name)
        }
        
        //문항이 종료되면
        if(number == 5){
            print("문항종료 정렬 후 ")
            items = items.sorted(by: {$0.count > $1.count})
            for i in 0..<items.count {
                 print(items[i].name)
                 }
            
            
            //문항이 종료되면 결과페이지로 이동한다.
            guard let result = self.storyboard?.instantiateViewController(withIdentifier: "SnackResult") as? SnackResult         else{
                    
                    return
                    
                }
            
            //결과페이지에 사용할 데이터를 서버로부터 받아온다.
            let parameters = ["resultCountry": "덴마크"]
                    
                    Alamofire.request("http://3.34.4.196/backend/android/and_snack_result.php", method: .post, parameters: parameters)
                        .validate()
                        .responseJSON { response in
                            
                            switch response.result {
                            case .success(let value):
                                //print(value)
                                //스낵컨텐츠 질문페이지에서 사용할 내용들을 받아온다.
                                do {
                                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                                    let resultList = try JSONDecoder().decode(snackResult.self, from: data)
                                    result.country = resultList.snack_country
                                    result.tag = resultList.snack_tag
                                    result.detail = resultList.snack_detail
                                    result.image_url = resultList.snack_image
                                    result.snack_country_detail = resultList.snack_country_detail
                                    print(resultList.snack_image)

                                    
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
                                
                                //뷰 이동
                                result.modalPresentationStyle = .fullScreen
                                
                                // 결과 페이지로 이동
                                //self.present(result, animated: true, completion: nil)
                                
                                self.navigationController?.pushViewController(result, animated: true)

                                
                            case .failure(let error):
                                print(error)
                            }
            }
            
            
            
            
                 
        }else{

        
        
        //다음 문항을 요청한다.
        let parameters = ["problemIndex": number]
        
        Alamofire.request("http://3.34.4.196/backend/android/and_snack_contents.php", method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    
                    //스낵컨텐츠 질문페이지에서 사용할 내용들을 받아온다.
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let list = try JSONDecoder().decode(snackList.self, from: data)
                        RVC.question = list.question
                        RVC.choice = list.choice_1
                        RVC.sec_choice = list.choice_2
                        RVC.nation = list.choice_1_country
                        RVC.sec_nation = list.choice_2_country
                        RVC.imgurl = list.snack_image

                        
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
                    
                    //뷰 이동
                    RVC.modalPresentationStyle = .fullScreen
                    
                    //다시 질문 페이지로 이동
                   // self.present(RVC, animated: true, completion: nil)
                    self.navigationController?.pushViewController(RVC, animated: true)
                case .failure(let error):
                    print(error)
                }
                
                
                
        }
        
        }
        
    }
    
    
    
    //url 이미지 세팅
    
    
    
}
