/*
 
 리뷰를 작성하는 페이지
 
 혜택에 대한 별점과
 신청과 실제 도움이 됬는지에 대한 의견
 그리고 간단한 리뷰를 작성할 수 있는 페이지
 
 1.상세페이지로부터 들어온다.
 
 2.작성과 수정에 따라 구분된다.
 
 3.사용자의 닉네임 정보를 받아온다. (스플래쉬화면에서 이미 닉네임여부를 검증해서 저장할텐데 다시 이 화면에서 불러와 저장하는건 이상하다.)
 
 작성일 경우
 
 5.작성일시 점수,내용,평가에 대한 정보를 새로 입력 받는다.
 
 5.plaeceholder를 통해 작성할 내용을 가이드 해준다.
 
 6.정보를 다 입력받았는지 체크한다.
 
 7.정보를 다 입력받았으면 등록하고 다시 원래페이지로 돌아간다.
 
 //수정일 경우
 
 4.작성일시 점수,내용,평가에 대한 정보를 기존에 입력된 정보로부터 받아오고 표시해준다.
 
 5.placeholder를 통ㅇ해 기존의 내용을 보여주고 클릭하면, 기존내용을 검은색 글씨로 변경해준다.
(기존 내용을 바탕으로 수정이 가능하게)
 
 6.정보를 다 입력받았는지 체크한다.
 
 7.정보를 다 입력받았으면 등록하고 다시 원래페이지로 돌아간다.

 
 
 */

import UIKit
import Alamofire

class NewReviewlViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    
    //별점버튼 관리하는 배열
    var ratingBtns = [UIButton]()
    var ratingImgs = [UIImageView]()
    
    
    //신청난이도를 체크시 사용하는 버튼과 이미지 배duf

    var levelBtns = [UIButton]()
    var levelImgs = [UIImageView]()
    var levels = ["쉬워요","어려워요"]
    
    //혜택만족도를 체크시 사용
    var satisfactionBtns = [UIButton]()
    var satisfactionImgs = [UIImageView]()
    var satisfactions = ["도움이 됐어요","도움이 안 됐어요"]
    
    
    //
    
    let contentView = UITextView()
    
    //만족도와 난이도 저장하는 변수
    var satisfaction = String()
    var difficulty_level  = String()
    
    //혜택 점수 기록
    var grade = Int()
    
    
    var nickName = String()
    
    
    //파싱
    struct parse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
        let Message : String
    }
    
    //혜택 id
    var welf_id = Int()
    //수정 여부를 확인하는
    var modify : Bool = false
    //수정하기전 내용
    var oldContent = String()
    
    //리뷰 아이디
    var review_id = Int()

    //선택 된 지역 및 혜택
    var selectedLocal = String()
    var selectedPolicy = String()


    
        //네비게이션 버튼 설정
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        DuViewController의 view가 사라짐
        //        ReViewViewController의 view가 화면에 나타남
        print("newReViewViewController의 viewDidAppear")
        setBarButton(modify: modify)
        //수정화면일 시 이전데이터들을 넣어준다.
        if(modify){
            oldrated(starIndex: grade)
            contentView.text = "\(oldContent)"
            print(oldContent)
        }
   
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("newReViewViewController의 viewDidLoad")

        
        //닉네임
        nickName = UserDefaults.standard.string(forKey: "nickName")!

        
        //별점
        //별점등록라벨
        let gradeLabel = UILabel()
        gradeLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 140 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width, height: 30)
        gradeLabel.textAlignment = .left
        
        gradeLabel.text = "혜택에 대한 점수를 매겨주세요."
        gradeLabel.font = UIFont(name: "NanumBarunGothicBold", size: 22  *  DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(gradeLabel)

        
        //별점 별을 클릭해주세요, + - 버튼 등록하기
        
        for i in 0..<5 {
            
            let button = UIButton(type: .system)
            let starImg = UIImage(named: "star_off")
            var starImgView = UIImageView()
            
            starImgView.setImage(starImg!)
            starImgView.frame = CGRect(x:0, y: 0, width: 40 *  DeviceManager.sharedInstance.widthRatio, height: 40 *  DeviceManager.sharedInstance.heightRatio)
            starImgView.image = starImgView.image?.withRenderingMode(.alwaysOriginal)
            button.tag = i
            
            button.frame = CGRect(x:CGFloat((i * 45) + 80) *  DeviceManager.sharedInstance.widthRatio, y: 190 *  DeviceManager.sharedInstance.heightRatio, width: 40 *  DeviceManager.sharedInstance.widthRatio, height: 40 *  DeviceManager.sharedInstance.heightRatio)
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
        
        
        //신청 난이도
        //별점등록라벨
        let levelLabel = UILabel()
        levelLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 500 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        levelLabel.textAlignment = .left
        
        levelLabel.text = "혜택 신청은 어떻셨나요?"
        levelLabel.font = UIFont(name: "NanumBarunGothicBold", size: 22  *  DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(levelLabel)
        
        for i in 0..<2 {

        var button = UIButton(type: .system)
        var imgView = UIImageView()
        button.tag = i
        
        //
            levelBtns.append(button)
        levelImgs.append(imgView)
        
            button.addTarget(self, action: #selector(self.choiceLevel), for: .touchUpInside)
            // button.frame = CGRect(x:22, y:Double(Int(175.2) * i/2) + 679.4, width: 177.4, height: 158.4)
            button.frame = CGRect(x:CGFloat((180 * i) + 40) *  DeviceManager.sharedInstance.widthRatio, y:560 *  DeviceManager.sharedInstance.heightRatio, width: 180 *  DeviceManager.sharedInstance.widthRatio, height: 31 *  DeviceManager.sharedInstance.heightRatio)
            
            button.setTitle(levels[i], for: .normal)
            
            
            //이미지 및 라벨 추가
            let img = UIImage(named: "check")
            imgView.setImage(img!)
            imgView.frame = CGRect(x: 0, y: 0, width: 31 *  DeviceManager.sharedInstance.widthRatio, height: 31 *  DeviceManager.sharedInstance.heightRatio)
            //imgView.image = imgView.image?.withRenderingMode(.alwaysOriginal)
            
            imgView.layer.cornerRadius = imgView.frame.height/2
            imgView.layer.borderWidth = 1
            imgView.layer.borderColor = UIColor.clear.cgColor
            imgView.clipsToBounds = true
            
            
            button.addSubview(imgView)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = .white
      
            
            //카테고리에 사용되는 뷰들을 리스트로 관리해서 선택됫을경우 선탟된 카테고리의 뷰들
            //에 대해 변형해준다.
            
            
            self.view.addSubview(button)
        }
        
        
        //혜택 만족도
        let satisfactionLabel = UILabel()
        satisfactionLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 620 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        satisfactionLabel.textAlignment = .left
        
        satisfactionLabel.text = "혜택이 실제로 도움이 되셨나요?"
        satisfactionLabel.font = UIFont(name: "NanumBarunGothicBold", size: 22  *  DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(satisfactionLabel)
        
        for i in 0..<2 {

        var button = UIButton(type: .system)
        var imgView = UIImageView()
        button.tag = i
        
        //
            satisfactionBtns.append(button)
            satisfactionImgs.append(imgView)
        
            button.addTarget(self, action: #selector(self.choiceSatisfaction), for: .touchUpInside)
            // button.frame = CGRect(x:22, y:Double(Int(175.2) * i/2) + 679.4, width: 177.4, height: 158.4)
            button.frame = CGRect(x:CGFloat((180 * i) + 40) *  DeviceManager.sharedInstance.widthRatio, y:680 *  DeviceManager.sharedInstance.heightRatio, width: 180 *  DeviceManager.sharedInstance.widthRatio, height: 31 *  DeviceManager.sharedInstance.heightRatio)
            
            button.setTitle(satisfactions[i], for: .normal)
            
            
            //이미지 및 라벨 추가
            let img = UIImage(named: "check")
            imgView.setImage(img!)
            imgView.frame = CGRect(x: 0, y: 0, width: 31 *  DeviceManager.sharedInstance.widthRatio, height: 31 *  DeviceManager.sharedInstance.heightRatio)
            //imgView.image = imgView.image?.withRenderingMode(.alwaysOriginal)
            
            imgView.layer.cornerRadius = imgView.frame.height/2
            imgView.layer.borderWidth = 1
            imgView.layer.borderColor = UIColor.clear.cgColor
            imgView.clipsToBounds = true
            
            
            button.addSubview(imgView)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = .white
      
            
            //카테고리에 사용되는 뷰들을 리스트로 관리해서 선택됫을경우 선탟된 카테고리의 뷰들
            //에 대해 변형해준다.
            
            
            self.view.addSubview(button)
        }
        
        //리뷰작성라벨
        let writeLabel = UILabel()
        //        levelLabel.frame = CGRect(x: 20, y: 270, width: DeviceManager.sharedInstance.width, height: 30)

        writeLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 270 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        writeLabel.textAlignment = .left
        
        writeLabel.text = "혜택에 대한 생각을 적어주세요(최대 165자)"
        writeLabel.font = UIFont(name: "NanumBarunGothicBold", size: 22  *  DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(writeLabel)
        
        
        //리뷰 입력하는 부분
        contentView.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 320 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - (40 *  DeviceManager.sharedInstance.widthRatio), height: 120 *  DeviceManager.sharedInstance.heightRatio)
        
        contentView.font = UIFont(name: "Jalnan", size: 12 *  DeviceManager.sharedInstance.heightRatio)
        //스크롤 금지
        contentView.isScrollEnabled = false
        
        //텍스트뷰 플레이스 홀더
        contentView.delegate = self // txtvReview가 유저가 선언한 outlet
        contentView.text = "다른사람들에게 혜택의 경험을 공유해보세요."
        contentView.textColor = UIColor.lightGray
        contentView.layer.borderColor = #colorLiteral(red: 0.650856599, green: 0.650856599, blue: 0.650856599, alpha: 1)
        contentView.layer.borderWidth = 1
        contentView.backgroundColor = #colorLiteral(red: 0.9093631028, green: 0.9093631028, blue: 0.9093631028, alpha: 1)
        self.view.addSubview(contentView)


    }
    

    //평점 클릭시 메소드
    @objc func rated(_ sender: UIButton) {
        
        //초기화
        for i in 0..<5 {
            //print("반복")
            //print(i)
            let Img = UIImage(named: "star_off")
            self.ratingImgs[i].setImage(Img!)
            
        }
        
        
        var k: Int = sender.tag+1
        
        //클릭한 버튼 기준으로 별점을 바꿔주는 메소드
        for i in 0..<k {
            //print("반복")
            //print(i)
            let Img = UIImage(named: "star_on")
            self.ratingImgs[i].setImage(Img!)
            
        }
        
        //평가등급 저장
        grade = k
        
        
        //등급라벨 변경
        var gradeText : String = "\(k).0 / 5.0"
        //gradeLabel.text = gradeText
        
        
        
        
    }
    
    //수정하기일시 이전 별점
    
   func oldrated(starIndex : Int) {
        
        //초기화
        for i in 0..<5 {
            //print("반복")
            //print(i)
            let Img = UIImage(named: "star_off")
            self.ratingImgs[i].setImage(Img!)
            
        }
        
        
        
        //클릭한 버튼 기준으로 별점을 바꿔주는 메소드
        for i in 0..<starIndex {
            //print("반복")
            //print(i)
            let Img = UIImage(named: "star_on")
            self.ratingImgs[i].setImage(Img!)
            
        }
        
   
        
        
    }
    

    //신청난이도 선택메소드
    @objc func choiceLevel(_ sender: UIButton) {
        
        
        
        //선택 해제하는 경우
        if(self.levelImgs[sender.tag].layer.borderColor != UIColor.clear.cgColor){
            //선택해제
            self.levelImgs[sender.tag].layer.borderColor = UIColor.clear.cgColor
            
            //키워드 리스트에서 삭제
//            keyWorlds = keyWorlds.filter(){$0 != buttons[sender.tag].currentTitle}

            
            let img = UIImage(named: "check")
            self.levelImgs[sender.tag].setImage(img!)
            satisfaction = ""
            
        }else{
            //선택표시
            self.levelImgs[sender.tag].layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
            let img = UIImage(named: "checked")
            self.levelImgs[sender.tag].setImage(img!)
            satisfaction = satisfactions[sender.tag]
            
            //다른 걸 선택해제
            for i in 0..<2 {
                if(i != sender.tag){
                    self.levelImgs[i].layer.borderColor = UIColor.clear.cgColor
                    let img = UIImage(named: "check")
                    self.levelImgs[i].setImage(img!)
                    //선택한 키워드를 리스트에 추가
                  
                }
            }
            
            //선택한 키워드를 리스트에 추가
           // keyWorlds.append(buttons[sender.tag].currentTitle!)

            
        }
        
    }
    //혜택만족도 선택메소드
    @objc func choiceSatisfaction(_ sender: UIButton) {
        
        
        
        //선택 해제하는 경우
        if(self.satisfactionImgs[sender.tag].layer.borderColor != UIColor.clear.cgColor){
            //선택해제
            self.satisfactionImgs[sender.tag].layer.borderColor = UIColor.clear.cgColor
            
            //키워드 리스트에서 삭제
//            keyWorlds = keyWorlds.filter(){$0 != buttons[sender.tag].currentTitle}

            
            let img = UIImage(named: "check")
            self.satisfactionImgs[sender.tag].setImage(img!)
            difficulty_level = ""
            
        }else{
            //선택표시
            self.satisfactionImgs[sender.tag].layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
            let img = UIImage(named: "checked")
            self.satisfactionImgs[sender.tag].setImage(img!)
            //선택한 키워드를 리스트에 추가
           // keyWorlds.append(buttons[sender.tag].currentTitle!)
            difficulty_level = levels[sender.tag]
            
            //다른 걸 선택해제
            for i in 0..<2 {
                if(i != sender.tag){
                    self.satisfactionImgs[i].layer.borderColor = UIColor.clear.cgColor
                    let img = UIImage(named: "check")
                    self.satisfactionImgs[i].setImage(img!)
                    //선택한 키워드를 리스트에 추가
                  
                }
            

            }
            
        }
    
    

}
    
    // Place Holder 메소드
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if (modify){
            textView.textColor = UIColor.black

        }
        else if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "최대 20자까지 입력해주세요."
            textView.textColor = UIColor.lightGray
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //키보드 숨키기
    func endEdit(textField: UITextField){
        
        self.contentView.resignFirstResponder()
    
    }
    
    //네비 버튼 설정
    private func setBarButton(modify : Bool) {
        print("ReViewViewController의 setBarButton")
        
        
//        let registerBtn = UIBarButtonItem()
//        registerBtn.title = "등록하기"
        if (!modify){
        let registerBtn = UIBarButtonItem(title: "등록하기", style: .done, target: self, action: #selector(completed))
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = registerBtn
        }else{
            let registerBtn = UIBarButtonItem(title: "수정하기", style: .done, target: self, action: #selector(modified))
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem = registerBtn
            
        }
//        let cancleBtn = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(self.backAction(_:)))
//        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = cancleBtn
//
        
        
        
    }
    
    //글자제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
     
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
     
        return changedText.count <= 165
    }
    
    //수정하기
    
    @objc func modified(){
        print("수정왼료")
        
        //다 입력되면
        if(grade > 0  && contentView.text != nil && difficulty_level != "" && satisfaction != ""){
            
            
            let PARAM:Parameters = [
                "login_token": LoginManager.sharedInstance.token,
                "review_id": review_id,
                "content":contentView.text!,
                "difficulty_level": difficulty_level,
                "satisfaction": satisfaction,
                "star_count": String(grade)
            ]
            
            //서버통신
            Alamofire.request("https://www.urbene-fit.com/review", method: .post, parameters: PARAM)
                .validate()
                .responseJSON { [self] response in
                    print("서버통신")
                    //메인화면으로 이동한다
                    
                    switch response.result {
                    case .success(let value): //
                        
                        do {
                            
                            let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let parseResult = try JSONDecoder().decode(parse.self, from: data)
                            if(parseResult.Status == "200"){
//
                                guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewDetailView") as?   NewDetailView       else{

                                    return

                                }
                                
                                RVC.welf_id = self.welf_id
                                RVC.setMenu = "리뷰"
                                RVC.selectedLocal = self.selectedLocal
                                RVC.selectedPolicy = self.selectedPolicy
                                RVC.modalPresentationStyle = .fullScreen

//                                RVC.reviewItems.append(RVC.reviewItem.init(content: resultList.Message![i].content,image_url : resultList.Message![i].image_url, id: resultList.Message![i].id, writer : resultList.Message![i].writer))
                                //혜택 상세보기 페이지로 이동
                                //self.present(RVC, animated: true, completion: nil)
                              ///  self.navigationController?.pushViewController(RVC, animated: true)
                                //self.tabBarController?.selectedIndex = 0
                                
                                
                                //스택삭제하면서 이동하는 메소드 
                                
                                for vc in self.navigationController!.viewControllers {
                                     if let NewDetailView  = vc as? NewDetailView {
                                         
                                         NewDetailView.welf_id = self.welf_id
                                         NewDetailView.setMenu = "리뷰"
                                         NewDetailView.selectedLocal = self.selectedLocal
                                         NewDetailView.selectedPolicy = self.selectedPolicy
                                         NewDetailView.modalPresentationStyle = .fullScreen
                                         
                                         self.navigationController?.popToViewController(NewDetailView, animated: true)
                                     }
                                 }

                                //로그인 페이지를 없애고 다른 페이지로 이동
//                                    self.dismiss(animated: true) {
//                                        RVC.navigationController?.pushViewController(RVC, animated: true)
//                                    }
                                
                                
                                
                            }

                    
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
                    print(error)
                }
                
            }//resoponse 종료괄호
            
            //모든정보가 다 입력되지 않은 경우
        }else{
            
            let alert = UIAlertController(title: "알림", message: "모든 정보를 다 입력해주세요", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "확인", style: .cancel){

                (action : UIAlertAction) -> Void in

                alert.dismiss(animated: false)

            }

          

            alert.addAction(cancelAction)


            self.present(alert, animated: true, completion: nil)
            
            
        }
        
        
        
    }
    @objc func completed(){
        print("작성왼료")
        
        
        //다 입력되면
        if(grade > 0  && contentView.text != nil && difficulty_level != "" && satisfaction != ""){
            
            
            let PARAM:Parameters = [
                "login_token": LoginManager.sharedInstance.token,
                "welf_id": welf_id,
                "content":contentView.text!,
                "difficulty_level": difficulty_level,
                "satisfaction": satisfaction,
                "star_count": String(grade)
            ]
            
            //서버통신
            Alamofire.request("https://www.urbene-fit.com/review", method: .post, parameters: PARAM)
                .validate()
                .responseJSON { response in
                    print("서버통신")
                    //메인화면으로 이동한다
                    
                    switch response.result {
                    case .success(let value): //
                        
                        do {
                            
                            let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let parseResult = try JSONDecoder().decode(parse.self, from: data)
                            if(parseResult.Status == "200"){
                                print("리뷰등록 성공")

                                guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewDetailView") as?   NewDetailView       else{

                                    return

                                }
                                
                                RVC.welf_id = self.welf_id
                                RVC.setMenu = "리뷰"
                                RVC.selectedLocal = self.selectedLocal
                                RVC.selectedPolicy = self.selectedPolicy
                                RVC.modalPresentationStyle = .fullScreen

                                for vc in self.navigationController!.viewControllers {
                                    if let NewDetailView  = vc as? NewDetailView {
                                        
                                        NewDetailView.welf_id = self.welf_id
                                        NewDetailView.setMenu = "리뷰"
                                        NewDetailView.selectedLocal = self.selectedLocal
                                        NewDetailView.selectedPolicy = self.selectedPolicy
                                        NewDetailView.modalPresentationStyle = .fullScreen
                                        
                                        self.navigationController?.popToViewController(NewDetailView, animated: true)
                                    }
                                }
                            }

                    
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
                    print(error)
                }
                
            }//resoponse 종료괄호
            
            
            //모든정보가 다 입력되지 않은 경우
        }else{
            
            let alert = UIAlertController(title: "알림", message: "모든 정보를 다 입력해주세요", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "확인", style: .cancel){

                (action : UIAlertAction) -> Void in

                alert.dismiss(animated: false)

            }

          

            alert.addAction(cancelAction)


            self.present(alert, animated: true, completion: nil)
            
            
        }
        
    }
}
