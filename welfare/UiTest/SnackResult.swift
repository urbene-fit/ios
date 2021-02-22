//
//  SnackResult.swift
//  welfare
//
//스낵결과를 보여주는 페이지

import UIKit
import Alamofire
import AlamofireImage





class SnackResult: UIViewController {
    
    
    //스낵컨텐츠 결과페이지
    
    //스낵컨텐츠 결과 나라
    var country : String = ""
    //나라에 대해 설명하는 태그
    var tag : String = ""
    //나라에 대해 설명하는 자세한 내용
    var detail : String = ""
    //이미지 url 주소
    var image_url : String = ""

    //나라 유형설명
      var snack_country_detail : String = ""


    // 메인 세로 스크롤
     let m_Scrollview = UIScrollView()
    

    override func viewDidLoad() {
        super.viewDidLoad()

            //화면 스크롤 크기
                   var screenWidth = Int(view.bounds.width)
                   var screenHeight = Int(view.bounds.height)
        //print("결과페이지 태그:\(tag)")
        
        //레이아웃 구성 ( 스크롤 뷰 )
        
        //당신의 복지국가스타일은? 라벨(최상단 위치)
        let topLabel = UILabel()
           topLabel.frame = CGRect(x: 0, y: 33, width: screenWidth , height: 30)
        topLabel.textAlignment = .center
           topLabel.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
           //폰트지정 추가
           
           topLabel.text = "당신의 복지국가 스타일은?"
           topLabel.font = UIFont(name: "TTCherryblossomR", size: 16)
           
            
           m_Scrollview.addSubview(topLabel)
        
        //유형설명 라벨
            let typeLabel = UILabel()
               typeLabel.frame = CGRect(x: 0, y: 63, width: screenWidth , height: 60)
            typeLabel.textAlignment = .center
               //typeLabel.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
            typeLabel.numberOfLines = 2

        
               //폰트지정 추가
               
               typeLabel.text = snack_country_detail
               typeLabel.font = UIFont(name: "TTCherryblossomR", size: 24)
               
                
               m_Scrollview.addSubview(typeLabel)
            
        
        //국가 이름
          let nationLabel = UILabel()
               nationLabel.frame = CGRect(x: 0, y: 126, width: screenWidth , height: 30)
            nationLabel.textAlignment = .center
               nationLabel.textColor = UIColor(displayP3Red: 245/255.0, green: 33/255.0, blue: 125/255.0, alpha: 1)

        
               //폰트지정 추가
               
               nationLabel.text = country
               nationLabel.font = UIFont(name: "TTCherryblossomR", size: 24)
               
                
               m_Scrollview.addSubview(nationLabel)
        
        
        
        //나라 메인 이미지
        //print("결과페이지 이미지주소:\(image_url)")
//        let imgView = UIImageView()
//            let img = UIImage(named: "america")
//            imgView.setImage(img!)
//            imgView.frame = CGRect(x: 50, y: 166, width: Double(screenWidth - 100), height: 300)
//
//            m_Scrollview.addSubview(imgView)
        
        
                   let imgView = UIImageView()
        
                   imgView.frame = CGRect(x: 50, y: 166, width: Double(screenWidth - 100), height: 300)
           let url = URL(string: image_url)
           Alamofire.request(url!).responseImage { response in
                               
                 if response.data == nil {
                                   
                       Alamofire.request("basic_image_URL").responseImage { response in
                                       
                       imgView.image = UIImage(data: response.data!, scale:1)
                         }
                 } else {
                       imgView.image = UIImage(data: response.data!, scale:1)
                 }
                               
           }
                     m_Scrollview.addSubview(imgView)

        
        
//        let url = URL(string: image_url)
//        var image : UIImage?
//        //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
//        //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
//        DispatchQueue.global().async {
//            let data = try? Data(contentsOf: url!)
//            //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//            DispatchQueue.main.async { image = UIImage(data: data!) }
//
//
//            let imgView = UIImageView()
//                       // let img = UIImage(data: data)
//                        imgView.setImage(image!)
//                        imgView.frame = CGRect(x: 25, y: 165, width: Double(screenWidth - 50), height: 132)
//
//            self.m_Scrollview.addSubview(imgView)
//
//
       // }

     
        
        //상위 태그
          let tagLabel = UILabel()
               tagLabel.frame = CGRect(x: 30, y: 503, width: screenWidth - 60 , height: 60)
            tagLabel.textAlignment = .center
               //tagLabel.textColor = UIColor(displayP3Red: 245/255.0, green: 33/255.0, blue: 125/255.0, alpha: 1)

        
               //폰트지정 추가
            tagLabel.numberOfLines = 2
               tagLabel.text = tag
               tagLabel.font = UIFont(name: "TTCherryblossomR", size: 22)
               tagLabel.textAlignment = .left

                
               m_Scrollview.addSubview(tagLabel)
        
        
        
        //설명
        print(detail)
        let detailLabel = UITextView(frame:  CGRect(x: 20, y: 563, width: screenWidth-40 , height: 330))
        detailLabel.isScrollEnabled = false
        //let detailLabel = UILabel()
               // detailLabel.frame = CGRect(x: 0, y: 393, width: screenWidth , height: 50)
             detailLabel.textAlignment = .left
                detailLabel.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
        
                //폰트지정 추가

                detailLabel.text = detail
        detailLabel.textAlignment = .left

                detailLabel.font = UIFont(name: "TTCherryblossomR", size: 18)
                
                 
                m_Scrollview.addSubview(detailLabel)
        
        
        
        
        //환상의케미국가 라벨
        let goodLabel = UILabel()
                goodLabel.frame = CGRect(x: 50, y: 896, width: 100 , height: 33)
             goodLabel.textAlignment = .center
        goodLabel.textColor = UIColor.blue

         
                //폰트지정 추가

                goodLabel.text = "환상의 케미국가"
                goodLabel.font = UIFont(name: "TTCherryblossomR", size: 16)
                
                 
                m_Scrollview.addSubview(goodLabel)
        
        //환상의 케미국가 이미지

        //환장의 케미국가 라벨
        let baddLabel = UILabel()
                 baddLabel.frame = CGRect(x: screenWidth/2 + 30, y: 896, width: 100 , height: 33)
              baddLabel.textAlignment = .center
         baddLabel.textColor = UIColor.red

          
                 //폰트지정 추가

                 baddLabel.text = "환장의 케미국가"
                 baddLabel.font = UIFont(name: "TTCherryblossomR", size: 16)
                 
                  
                 m_Scrollview.addSubview(baddLabel)
        
        //환장의 케미국가 이미지
        
        
        
        
        
 //메인스크롤 뷰 추가
     m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
     m_Scrollview.contentSize = CGSize(width:screenWidth, height: 1747)
     self.view.addSubview(m_Scrollview)
     
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
