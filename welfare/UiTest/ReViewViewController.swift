//
//  ReViewViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/11/22.
//  Copyright © 2020 com. All rights reserved.
/*  혜택에 대한 리뷰 작성 페이지
1. 별점 주기(다이얼로그?) 별점 박스
2. 제목(텍스트 필드) 글자 제한
3. 내용(텍스트 필드) 글자 제한
4. 이미지(가져오기 보여주기 보내주기)


*/
//

import UIKit
import Photos
import Alamofire



class ReViewViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate , UITextViewDelegate{
    
    
    // UIImagePickerController 인스턴스 변수 생성
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var flagImageSave = false // 사진 저장 여부를 나타낼 변수
    
    
    //별점버튼 관리하는 배열
    var ratingBtns = [UIButton]()
    var ratingImgs = [UIImageView]()
    let picker = UIImagePickerController()
    var captureImage = UIImage()

    
    let titleField = PastelessTextField()
    let contentField = PastelessTextField()
    let contentUi = UIView()
    let contentView = UITextView()

    
    
    //후기에 사용하는 이미지
    var thumbnail = UIImageView()

    var screenWidth  = 0
    var screenHeight = 0
//작성완료 버튼
    let enterBtn = UIButton()

//평점을 보여주는 라벨
    var gradeLabel = UILabel()
    //평점 저장하는 변수
    var grade : Int = 0
    
    
    //리뷰를 받아와 파싱할 구조체
    struct item {
        var content: String
        
    }
    
    //구조체 배열 
    var items: [item] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCursorPosition()
        imagePicker.delegate = self
        
        //화면 스크롤 크기
        screenWidth = Int(view.bounds.width)
   screenHeight = Int(view.bounds.height)
        
        
        //상단 타이블 바
        //구성도 x 리뷰 작성 작성하기
        var topView = UIView()
        
        topView.frame = CGRect(x:0, y: 0, width: screenWidth, height: 90)
//        topView.layer.cornerRadius = 4.3
//        topView.layer.borderWidth = 1.3
//
//        topView.layer.borderColor =  UIColor(displayP3Red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1).cgColor

        // Do any additional setup after loading the view.
        //라벨위에 별점  버튼
        //취소버튼
        let cancleBtn = UIButton(type: .system)
        cancleBtn.frame = CGRect(x:20, y: 20, width: 70, height: 70)
        cancleBtn.addTarget(self, action: #selector(self.rated), for: .touchUpInside)
        cancleBtn.setTitle("취소", for: .normal)
        cancleBtn.titleLabel!.font = UIFont(name: "Jalnan", size:14.7)
        cancleBtn.setTitleColor(UIColor.red, for: .normal)
      
        //각 성별을 나타내는 라벨과 이미지뷰를 각각 관리해주는 자료구조에 추가한다.
  
        
        topView.addSubview(cancleBtn)
        
        
        //화면을 설명하는 라벨
        var mainLabel = UILabel()
        
        mainLabel.frame = CGRect(x: screenWidth/2 - 70, y: 20, width: 120, height: 70)
        mainLabel.textAlignment = .center
        
        //폰트지정 추가
        mainLabel.text = "혜택리뷰 작성"
        mainLabel.font = UIFont(name: "Jalnan", size: 16.1)
        
        
        //각 성별을 나타내는 라벨과 이미지뷰를 각각 관리해주는 자료구조에 추가한다.
        
        topView.addSubview(mainLabel)
        
        
        //작성하기 버튼
        enterBtn.frame = CGRect(x: screenWidth - 80, y: 20, width: 70, height: 70)
        enterBtn.setTitle("등록하기", for: .normal)
        enterBtn.titleLabel!.font = UIFont(name: "Jalnan", size:14.7)
        enterBtn.setTitleColor(UIColor.blue, for: .normal)
//        enterBtn.layer.cornerRadius = 4.3
//        enterBtn.layer.borderWidth = 1.3
//        enterBtn.backgroundColor = UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1)
//        enterBtn.layer.borderColor =  UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1).cgColor
        //선택결과 페이지로 이동하는 메소드
        enterBtn.addTarget(self, action: #selector(self.move), for: .touchUpInside)
        
        topView.addSubview(enterBtn)
        
        self.view.addSubview(topView)
        
        
        //어떤 혜택을 리뷰하려는건지 알려주는 라벨
        var descriptionView = UIView()
        
        descriptionView.frame = CGRect(x:-1.3, y: 90, width: Double(screenWidth)+2.6, height: 90)
        descriptionView.layer.cornerRadius = 4.3
        descriptionView.layer.borderWidth = 1.3

        descriptionView.layer.borderColor =  UIColor(displayP3Red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1).cgColor
        
        let descriptImg = UIImage(named: "woman")
        var descriptImgView = UIImageView()
        
        descriptImgView.setImage(descriptImg!)
        descriptImgView.frame = CGRect(x: 1.3, y: 5, width: 80, height: 80)

        
        descriptImgView.image = descriptImgView.image?.withRenderingMode(.alwaysOriginal)

        //descriptionView.addSubview(descriptImgView)

        //혜택 라벨
        var  descriptLabel = UILabel()
        
        descriptLabel.frame = CGRect(x: 101.3, y: 0, width: 200, height: 90)
        descriptLabel.textAlignment = .center
        descriptLabel.numberOfLines = 2
        //폰트지정 추가
        descriptLabel.text = "조제분유 혜택 립"
        descriptLabel.font = UIFont(name: "Jalnan", size: 12.1)
        descriptionView.addSubview(descriptLabel)

        
        //self.view.addSubview(descriptionView)

        
        
        //별점 별을 클릭해주세요, + - 버튼 등록하기
        
        for i in 0..<5 {

            let button = UIButton(type: .system)
            let starImg = UIImage(named: "star_off")
            var starImgView = UIImageView()

            starImgView.setImage(starImg!)
            starImgView.frame = CGRect(x:0, y: 0, width: 50, height: 50)
            starImgView.image = starImgView.image?.withRenderingMode(.alwaysOriginal)
            button.tag = i

            button.frame = CGRect(x:(i * 60) + 60, y: 170, width: 50, height: 50)
            button.addSubview(starImgView)
            button.backgroundColor = .white


            //버튼 클릭시 메소드
            //클릭한 별점까지 별의 색상변경
            button.addTarget(self, action: #selector(self.rated), for: .touchUpInside)
            //별점 점수 기록


            //버튼들을 배열에 관리
            ratingBtns.append(button)
            //이미지뷰들을 배열에 관리
            ratingImgs.append(starImgView)



            self.view.addSubview(button)


        }
        
        
        //평점 라벨
        
        gradeLabel.frame = CGRect(x: 0, y: 250, width: screenWidth, height: 40)
        gradeLabel.textAlignment = .center
        
        //폰트지정 추가
        gradeLabel.text = "0.0 / 5.0"
        gradeLabel.font = UIFont(name: "Jalnan", size: 16.1)
        
        
        //각 성별을 나타내는 라벨과 이미지뷰를 각각 관리해주는 자료구조에 추가한다.
        self.view.addSubview(gradeLabel)
        //제목
        //let titleField = PastelessTextField()

        titleField.frame = CGRect(x: 0, y: 330, width: screenWidth , height: 70)
        //var myField: UITextField = UITextField (frame:CGRect(x: screenWidth/2 - 60, y: 220, width: 120, height: 60))
        //m_Scrollview.addSubview(myField)
       // titleField.layer.cornerRadius = 3.3
        titleField.layer.borderWidth = 1
         //myField.layer.borderColor =  UIColor(displayP3Red: 72/255.0, green:18/255.0, blue: 165/255.0, alpha: 1).cgColor
        titleField.layer.borderColor =  UIColor(displayP3Red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1).cgColor
        titleField.clipsToBounds = true
        
        //입력위치 설정
        titleField.beginFloatingCursor(at: CGPoint(x: 30.0, y: 0))

        //숫자입력 폰트
        titleField.font = UIFont(name: "Jalnan", size: 22)

        //입력한 숫자가 텍스트필드의 좌측에 붙지 않게 패딩을 준다.
       // myField.addLeftPadding()
        titleField.attributedPlaceholder = NSAttributedString(string: "제목", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])


            self.titleField.delegate = self
             //self.view.addSubview(titleField)
        
        
        
        //내용 입력
        
        contentUi.frame = CGRect(x: 0, y: 400, width: screenWidth , height: 200)
        
       // contentUi.layer.borderWidth = 1.3

        contentView.frame = CGRect(x: 0, y: 0, width: screenWidth - 40, height: 200)
        
        contentView.font = UIFont(name: "Jalnan", size: 12)
        //스크롤 금지
        contentView.isScrollEnabled = false
        
        //텍스트뷰 플레이스 홀더
        contentView.delegate = self // txtvReview가 유저가 선언한 outlet
        contentView.text = "복지혜택에 대한 후기를 남겨주세요."
        contentView.textColor = UIColor.lightGray


        
        
        //사진추가하기 버튼
        var photoView = UIView()
        
        photoView.frame = CGRect(x:0, y: 700, width: screenWidth, height: 70)
        let imgBtn = UIButton(type: .system)
      
        
        imgBtn.frame = CGRect(x: 20, y: 0, width: 120, height: 70)
  
        photoView.layer.borderWidth = 1
        photoView.layer.borderColor =  UIColor(displayP3Red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1).cgColor
        imgBtn.addTarget(self, action: #selector(self.photo), for: .touchUpInside)
        
        imgBtn.setTitle("사진 추가하기", for: .normal)
        
        photoView.addSubview(imgBtn)
        self.view.addSubview(photoView)
        
        
//        contentView.beginFloatingCursor(at: CGPoint(x: 100.0, y: 100.0))

        
       // contentField.frame = CGRect(x: 20, y: 320, width: screenWidth - 40, height: 200)
        //var myField: UITextField = UITextField (frame:CGRect(x: screenWidth/2 - 60, y: 220, width: 120, height: 60))
        //contentField.layer.cornerRadius = 3.3
        //contentField.layer.borderWidth = 1
         //myField.layer.borderColor =  UIColor(displayP3Red: 72/255.0, green:18/255.0, blue: 165/255.0, alpha: 1).cgColor
       // contentField.clipsToBounds = true
        
        
        //입력위치 설정
        //contentField.beginFloatingCursor(at: CGPoint(x: 30.0, y: 0))

        //숫자입력 폰트
       // contentField.font = UIFont(name: "Jalnan", size: 22)

        //입력한 숫자가 텍스트필드의 좌측에 붙지 않게 패딩을 준다.
       // myField.addLeftPadding()


          //  self.contentField.delegate = self
        contentUi.addSubview(contentView)
             self.view.addSubview(contentUi)
        
   

        //작성완료 버튼
//        enterBtn.setTitle("확인", for: .normal)
//        enterBtn.frame = CGRect(x: 20, y: screenHeight - 60, width: 335, height: Int(53.7))
//
//        enterBtn.titleLabel!.font = UIFont(name: "Jalnan", size:14.7)
//        enterBtn.layer.cornerRadius = 4.3
//        enterBtn.layer.borderWidth = 1.3
//        enterBtn.backgroundColor = UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1)
//        enterBtn.layer.borderColor =  UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1).cgColor
//        //선택결과 페이지로 이동하는 메소드
//        enterBtn.addTarget(self, action: #selector(self.move), for: .touchUpInside)
//
//        self.view.addSubview(enterBtn)
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    //평점 클릭시 메소드
    @objc func rated(_ sender: UIButton) {
        
        //초기화
        for i in 0..<5 {
            print("반복")
            print(i)
        let Img = UIImage(named: "star_off")
        self.ratingImgs[i].setImage(Img!)
            
        }
        
        
        var k: Int = sender.tag+1
        
    //클릭한 버튼 기준으로 별점을 바꿔주는 메소드
        for i in 0..<k {
            print("반복")
            print(i)
        let Img = UIImage(named: "star_on")
        self.ratingImgs[i].setImage(Img!)
            
        }
        
        //평가등급 저장
        grade = k
        
        
        //등급라벨 변경
        var gradeText : String = "\(k).0 / 5.0"
        gradeLabel.text = gradeText

        
        
        
    }
    
    
    
    //키보드 delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField.isEqual(self.titleField)){ //titleField에서 리턴키를 눌렀다면
            self.contentField.becomeFirstResponder()//컨텐츠필드로 포커스 이동
        }
        return true
    }
    
    func endEdit(textField: UITextField){
        if(textField.isEqual(self.titleField)){ //titleField에서

        self.titleField.resignFirstResponder()//키보드 숨기기
        }else{
            self.contentField.resignFirstResponder()//키보드 숨기기
        
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //앨범으로 이동해서 사진선택하게 하는 메소드
    @objc func photo(_ sender: UIButton) {
        
//        picker.delegate = self
//        picker.allowsEditing = true
//
        
//        self.imagePicker.sourceType = .photoLibrary
//
//
//        self.present(imagePicker,animated: false)
        
        
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                    flagImageSave = false
                    
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary // 이미지 피커의 소스 타입을 PotoLibrary로 설정
                  //  imagePicker.mediaTypes =
                    imagePicker.allowsEditing = true // 편집을 허용
                    
                    present(imagePicker, animated: true, completion: nil)
                } else {
                    myAlert("Photo album inaccessable", message: "Application cannot access the photo albm.")
                }
//
        
    }
    
    //사진가져왔을때 처리하는 메소드
    
    // 사진 촬영이나 선택이 끝났을 때 호출되는 델리게이트 메서드
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           // 미디어 종류 확인
           let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
           // 미디어가 사진이면
               // 사진을 가져옴
             captureImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
               
               if flagImageSave { // flagImageSave가 true일 때
                   // 사진을 포토 라이브러리에 저장
                   UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
               }

        
        //사진이 있는지 없는지 체크
//        if(thumbnail.image != nil) {
//            <#code#>
//        }else if(){
//
//
//        }
        
               // 가져온 사진을 해당하는 이미지 뷰에 넣기...
        thumbnail.image = captureImage // 가져온 사진을 이미지 뷰에 출력
        thumbnail.frame = CGRect(x: screenWidth/2 - 90, y: 0, width: 180, height: 180)
       // self.view.addSubview(imgView1)
        
        //사진이 추가되면 적었던 내용을 사진 밑으로 옮겨준다.
        contentUi.addSubview(thumbnail)
        contentView.frame = CGRect(x:0, y: 195, width: self.screenWidth, height: 80)
           // 현재의 뷰(이미지 피커) 제거
           self.dismiss(animated: true, completion: nil)
        
        //텍스트 입력위치를 변경해준다.
        setCursorPosition()
        
        
//
//        let arbitraryValue: Int = 20
//        if let newPosition = contentView.positionFromPosition(contentView.beginningOfDocument, inDirection: UITextLayoutDirection.Right, offset: arbitraryValue) {
//
//            contentView.selectedTextRange = contentView.textRangeFromPosition(newPosition, toPosition: newPosition)
//        }
//
       }
    
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage{
//
//               // imageView.image = image
//
//            print(info)
//
//            }
//
//            dismiss(animated: true, completion: nil)
//
//        }


    // 경고 창 츨력 함수
     func myAlert(_ title: String,message: String) {
         // Alert show
         let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
         let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
         alert.addAction(action)
         self.present(alert, animated: true, completion: nil)
     }
    

//
//    @available(iOS 2.0, *)
//    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
//        self.dismiss(animated: true, completion: nil)
//    }
//
//
    
    
    
    
    //확인시 질문지 선택페이지로 이동하는 메소드
    @objc func move(_ sender: UIButton) {
        print("리뷰 작성완료")
        
        
        
        var userEmail = UserDefaults.standard.string(forKey: "email")
        //let parameters = ["email": userEmail!]
        
//
//        let url = "fileupload url"
//        let image = UIImage(named: "Image")
//        let imgData = image!.jpegData(compressionQuality: 0.2)!
        
        
        //Set Your URL
//            guard let asurl = URL(string: "http://3.34.4.196/backend/php/common/benefit_info_register.php") else {
//                return
//            }
//
//            var urlRequest = URLRequest(url: asurl, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
//            urlRequest.httpMethod = "POST"
//            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
//
//            //Set Your Parameter
//            let parameterDict = NSMutableDictionary()
//            parameterDict.setValue(userEmail, forKey: "name")
//
//        let image = UIImage(named: "Image")
//           let imgData = image!.jpegData(compressionQuality: 0.2)!
//
//           // Now Execute
//            Alamofire.upload(multipartFormData: { multiPart in
//                for (key, value) in parameterDict {
//                    if let temp = value as? String {
//                        multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
//                    }
//                    if let temp = value as? Int {
//                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
//                    }
//                    if let temp = value as? NSArray {
//                        temp.forEach({ element in
//                            let keyObj = key as! String + "[]"
//                            if let string = element as? String {
//                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
//                            } else
//                                if let num = element as? Int {
//                                    let value = "\(num)"
//                                    multiPart.append(value.data(using: .utf8)!, withName: keyObj)
//                            }
//                        })
//                    }
//                }
//                multiPart.append(imgData, withName: "file", fileName: "file.png", mimeType: "image/png")
//            }, with: urlRequest)
//                .uploadProgress(queue: .main, closure: { progress in
//                    //Current upload progress of file
//                    print("Upload Progress: \(progress.fractionCompleted)")
//                })
//                .responseJSON(completionHandler: { data in
//
//                           switch data.result {
//
//                           case .success(_):
//                            do {
//
//                            let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
//
//                                print("Success!")
//                                print(dictionary)
//                           }
//                           catch {
//                              // catch error.
//                            print("catch error")
//
//                                  }
//                            break
//
//                           case .failure(_):
//                            print("failure")
//
//                            break
//
//                        }
//
//
//                })
           // let image = UIImage(named: "Book")
        //let imgData = image!.jpegData(compressionQuality: 0.2)

                    let parameterDict = NSMutableDictionary()
                    parameterDict.setValue("userEmail!", forKey: "email")
        parameterDict.setValue("24일", forKey: "welf_name")
        parameterDict.setValue(contentView.text!, forKey: "content")
        parameterDict.setValue("24일", forKey: "writer")
        parameterDict.setValue("24일", forKey: "like_count")
        parameterDict.setValue("24일", forKey: "bad_count")
        parameterDict.setValue("24일", forKey: "star_count")

       // print(contentView.text!)
        
        ///이미지를 추가한 경우
        //if(captureImage != nil){
        
        
//            let url = try! URLRequest(url: URL(string:"http://3.34.64.143//backend/php/common/review_register.php")!, method: .post, headers: nil)
//
//            Alamofire.upload(
//                multipartFormData: { multipartFormData in
//                    for (key, value) in parameterDict {
//                        if let temp = value as? String {
//                            multipartFormData.append(temp.data(using: .utf8)!, withName: key as! String)
//                        }
//                        if let temp = value as? Int {
//                            multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key as! String)
//                        }
//                        if let temp = value as? NSArray {
//                            temp.forEach({ element in
//                                let keyObj = key as! String + "[]"
//                                if let string = element as? String {
//                                    multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
//                                } else
//                                    if let num = element as? Int {
//                                        let value = "\(num)"
//                                        multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
//                                }
//                            })
//                        }
//                    }
//                   
//                },
//                with: url,
//                encodingCompletion: { encodingResult in
//                    switch encodingResult {
//                    case .success(let upload, _, _):
//                        upload.responseJSON { response in
//                            if((response.result.value) != nil) {
//
//
//
//                        if let json = response.result.value as? [String: Any] {
//                              //print(json)
//                            for (key, value) in json {
//                                print(value)
//
//                            }
//                        }
//                            } else {
//                                print(response.result.value)
//
//                            }
//                        }
//                    case .failure( _):
//                        print("실패")
//                        break
//                    }
//                }
//            )
            
        //사진을 업로드 할경우)
   // }else if(captureImage != nil){
        let Img = UIImage(named: "star_on")

        let imgData = captureImage.jpegData(compressionQuality: 0.2)

        let url = try! URLRequest(url: URL(string:"http://3.34.64.143//backend/php/common/review_register.php")!, method: .post, headers: nil)

        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameterDict {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key as! String + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                                if let num = element as? Int {
                                    let value = "\(num)"
                                    multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                multipartFormData.append(imgData!, withName: "file", fileName: "24일", mimeType: "image/png")
            },
            with: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if((response.result.value) != nil) {



                    if let json = response.result.value as? [String: Any] {
                          //print(json)
                        for (key, value) in json {
                            print(value)

                        }
                    }
                        } else {
                            print(response.result.value)

                        }
                    }
                case .failure( _):
                    print("실패")
                    break
                }
            }
        )
        //}
    }
    
    //텍스트뷰 위치변경
    func setCursorPosition() {
            let newPosition = contentView.endOfDocument
        contentView.selectedTextRange = contentView.textRange(from: newPosition, to: newPosition)
        }
    
    
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "제가 바로 PlaceHolder입니다."
            textView.textColor = UIColor.lightGray
        }
    }


    
    
}


