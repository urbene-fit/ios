//
//  Test2ScrollViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/08/05.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import SwiftyGif


//테이블뷰 프로토콜
struct Company: Codable {
    var name: String
    var employees: [Employee]
}

struct Employee: Codable {
    var name: String
    var image: String
    var years: String
    var salary: String
}


//콜렉션 뷰 들어갈 아이ㅏㅌ;ㅁ
var collectionItems = [String]()






class Test2ScrollViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    
    let imagePicker = UIImagePickerController()

    
    // 메인 스크롤뷰
        var m_Scrollview = UIScrollView()

        // 메인 스크롤뷰에 추가할 서브 가로스크롤뷰
        var s_Scrollview_0 = UIScrollView()
    
    
    //복지뉴스를 가로로 보여줄 스크롤뷰
    var SubNewssScrollview = UIScrollView()
    
    //복지사례 스크롤뷰
    var SubRewardScrollview = UIScrollView()


    
    //테이블 뷰
    private var myTableView: UITableView!
     private var companies: [Company]!
    
    
    //@IBOutlet weak var tableView: UITableView!
    
    
    
    //버튼
    lazy var button: UIButton = {
        let button = UIButton()
        
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    
    //메인 이미지 뷰
    
      
        // 서브 스크롤뷰 갯수
        let count = 3
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            do {
                let gif = try UIImage(gifName: "Main.gif")
                let imageview = UIImageView(gifImage: gif, loopCount: -1) // Use -1 for infinite loop
                //imageview.frame = view.bounds
                imageview.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: 400)
                imageview.contentMode = .scaleAspectFit
                //view.addSubview(imageview)
                m_Scrollview.addSubview(imageview)

            } catch {
                print(error)
            }
            
            
            //네비색상지정
              self.navigationController?.navigationBar.barTintColor = UIColor.systemIndigo
           // self.navigationController?.navigationBar.backgroundColor = UIColor.systemIndigo

            //  self.navigationController?.title = "복지왕"
              
              
              let nTitle = UILabel(frame: CGRect(x:0, y:0, width: 200, height: 40))
                   
                                         nTitle.numberOfLines = 2 //줄 수
                   
                                         nTitle.textAlignment = .center  // 정렬
                   
              nTitle.textColor = UIColor.gray
                   
                                         nTitle.font = UIFont.systemFont(ofSize: 15) //font 사이즈
                   
                                         nTitle.text = "키워드로 검색해보세요"
              
              let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(titleEvent))
              nTitle.addGestureRecognizer(tapGestureRecognizer)

              
              
              
              
              
              
              //안되는 코드 : self.navigationBar?.topItem!.titleView  = nTitle
              
              
              
              
              //self.navigationController?.navigationBar.topItem?.titleView = nTitle
              
              //네비게이셔 메뉴바
//              let barBtn = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(self.addTapped))
            
            //let  naviBtn = UIBarButtonItem(image: UIImage(named: "open-menu"),style: UIBarButtonItem.Style.plain,target: nil, action: nil)
            
            //self.navigationController?.navigationBar.topItem?.rightBarButtonItem = naviBtn
            
           
            
            //≡
         
           
            let MenuBtn = UIBarButtonItem(title: "≡", style: .done, target: self, action: #selector(self.addTapped))
            
            let SerchBtn = UIBarButtonItem(title: "키워드로 검색해보세요", style: .done, target: self, action: #selector(self.addTapped))
                               // Specify the position of the button.
                   //MenuBtn.frame = CGRect(x: 0, y: 0, width: view.frame.width-20, height: 100)
           

                
           // let MenuBtn = UIBarButtonItem(title: "≡", style: .plain, target: self, action: #selector(self.addTapped))
                               
//            let MenuBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
//            MenuBtn.addTarget(self, action: #selector(self.addTapped), for: UIControl.Event.touchUpInside)
//            MenuBtn.setTitle("≡", for: .normal)
//
//            MenuBtn.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
//            let MenuBarBtn = UIBarButtonItem(customView: MenuBtn)
//            var editImage = UIImage(named: "open-menu")!
//
//            let testButton : UIButton = UIButton.init(type: .custom)
//            testButton.setImage(editImage, for: .normal)
//            //testButton.addTarget(self, action: #selector(didTapCameraButton), for: .touchUpInside)
//            //testButton.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
//            testButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 10, bottom: 7, right: 0)
//            let addButton = UIBarButtonItem(customView: testButton)

//
//            let image = UIImage(named: "open-menu")!
//             let btn: UIButton = UIButton(type: UIButton.ButtonType.custom)
//             btn.setImage(image, for: .normal)
//             btn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
//             btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//             let barBtn = UIBarButtonItem(customView: btn)
            
            
            // Specify the position of the button.
                   //MenuBtn.frame = CGRect(x: 0, y: 0, width: view.frame.width-20, height: 100)
//            let font:UIFont = UIFont(name: "≡", size: 18) ?? UIFont()
//            MenuBtn.setTitleTextAttributes([NSAttributedString.Key.font: font], for: UIControl.State.normal);
//
            self.navigationController?.navigationBar.topItem?.leftBarButtonItems = [MenuBtn,SerchBtn]
            
                            //버튼 터두리 설정
//                         SetBtn.backgroundColor = .systemBlue
//                            SetBtn.layer.cornerRadius = 5
//                            SetBtn.layer.borderWidth = 1
//                     SetBtn.layer.borderColor = UIColor.systemBlue.cgColor
//
            
            //get data for display, this can be WEB Service API as well
                  companies = getCompanyData()
                  
                  myTableView = UITableView()
            myTableView.register(MyTableViewCell.self, forCellReuseIdentifier: "MyCell")
                  myTableView.dataSource = self
                  myTableView.delegate = self
                  
                  //for auto layout rendering
                  myTableView.translatesAutoresizingMaskIntoConstraints = false
                  
                  //hide extra lines
                  myTableView.tableFooterView = UIView()
            myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            
            myTableView.frame = CGRect(x: 0, y: 1800, width: view.frame.width, height: 400)
                  
//                  //add to layout
//                  self.view.addSubview(myTableView)
//
//                  //auto layout for the table view
//                  let views = ["view": view!, "tableView" : myTableView]
//                  var allConstraints: [NSLayoutConstraint] = []
//                  allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: views as [String : Any])
//                  allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: views as [String : Any])
//                  NSLayoutConstraint.activate(allConstraints)
            
            
            
            
            //        화면크기
            //               뷰 전체 폭 길이
                       let screenWidth = view.frame.width
                           // 뷰 전체 높이 길이
                    let screenHeight  = view.frame.height
                   
           //테이블뷰 설정
            //tableView.frame = CGRect(x: 0, y: 800, width: screenWidth, height: 400)
            
            
            //화면순서
            //메인이미지 -> 메인라벨 -> 혜택설정버튼 -> 복지사례 -> 복지사례 이미지 -> 복지뉴스 -> 복지뉴스 이미지 ->
            // -> 인기정책 라벨 -> 버튼(가로스크롤뷰) -> 테이블뷰
            
           //메인이미지뷰
            let MainImgView = UIImageView(image:UIImage(named:"MainImg2"))
                  MainImgView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
            
         
            
            
            
//            let subImgView = UIImageView(image:UIImage(named:"welfare"))
//            subImgView.frame = CGRect(x: 0, y: 500, width: view.frame.width, height: 100)
//
//            let subImgView2 = UIImageView(image:UIImage(named:"welfare2"))
//                      subImgView.frame = CGRect(x: view.frame.width * 2, y: 500, width: view.frame.width, height: 100)
//
//            let subImgView3 = UIImageView(image:UIImage(named:"welfare3"))
//                      subImgView.frame = CGRect(x:view.frame.width * 3, y: 500, width: view.frame.width, height: 100)
//
            
            
            
               
           
            //메인문구
//            let MainFrame = CGRect(x: 0, y: 1000, width: 100, height: 50)
//            let MainLabel = UILabel(frame: MainFrame)
//            MainLabel.text="당신이 놓치고 있는 혜택은"
//           // MainLabel.textAlignment = NSTextAlignment.center
//           MainLabel.font = UIFont(name: "System", size: 20)
//            MainLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            
            
            //라벨들
            
            //메인 라벨
            var MainLabel: UILabel = UILabel()
            MainLabel.frame = CGRect(x: 0, y: 450, width: screenWidth, height: 100)
            MainLabel.backgroundColor = .clear
            MainLabel.textColor = UIColor.black
            //MainLabel.textAlignment = NSTextAlignment.center
//            MainLabel.text = "당신이 놓치고 \n 있는 혜택은"
//            MainLabel.numberOfLines = 2
            MainLabel.text = "당신이 놓치고 있는 혜택은"
            MainLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(30))
            MainLabel.tintColor = UIColor.black
            //self.view.addSubview(yourLabel)
            
                       //복지사례 라벨
            var ExampleLabel: UILabel = UILabel()
            ExampleLabel.frame = CGRect(x: 0, y: 650, width: screenWidth, height: 100)
           ExampleLabel.backgroundColor = .clear
           ExampleLabel.textColor = UIColor.black
             ExampleLabel.text = "복지사례"
            //ExampleLabel.textAlignment = NSTextAlignment.center

            ExampleLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(30))
           ExampleLabel.tintColor = UIColor.black
            
            //복지뉴스
            var NewsLabel: UILabel = UILabel()
            NewsLabel.frame = CGRect(x: 0, y: 1150, width: screenWidth, height: 100)
            NewsLabel.backgroundColor = .clear
            NewsLabel.textColor = UIColor.black
            //NewsLabel.textAlignment = NSTextAlignment.center
            NewsLabel.text = "복지뉴스"
            NewsLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(30))
            NewsLabel.tintColor = UIColor.black
            
            //인기혜택
            var FavorLabel: UILabel = UILabel()
                FavorLabel.frame = CGRect(x: 0, y: 1600, width: screenWidth, height: 100)
                FavorLabel.backgroundColor = .clear
                FavorLabel.textColor = UIColor.black
                FavorLabel.text = "지금 인기있는 \n 복지혜택은"
                FavorLabel.numberOfLines = 2
                FavorLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(30))
                FavorLabel.tintColor = UIColor.black
            
            
            

////
            //버튼들 추가
            //혜택 설정하러가기 버튼
            let SetBtn = UIButton(type: .system)
                          // Specify the position of the button.
              SetBtn.frame = CGRect(x: 10, y: 550, width: view.frame.width-20, height: 100)

             SetBtn.setTitle("맞춤혜택 설정하러 가기", for: .normal)
            SetBtn.setTitleColor(UIColor.white, for: .normal)


                            //화면이동 설정 (수정전)
             SetBtn.addTarget(self, action: #selector(SetMove), for: .touchUpInside)
                               //set frame
                       
                       //버튼 터두리 설정
                    SetBtn.backgroundColor = .systemIndigo
                       SetBtn.layer.cornerRadius = 5
                       SetBtn.layer.borderWidth = 1
                SetBtn.layer.borderColor = UIColor.systemIndigo.cgColor
                       
            
            
            
            
            
            button.frame = CGRect(x: 0, y: 0, width: 100, height: 50)

            
            //혜택카테고리 설정버튼
            let AllBtn = UIButton(type: .system)
               // Specify the position of the button.
                AllBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 50)

               AllBtn.setTitle("전체", for: .normal)
            

                 //add function for button
                    AllBtn.addTarget(self, action: #selector(targetTapped), for: .touchUpInside)
                    //set frame
            //버튼 타이틀색상지정
            AllBtn.setTitleColor(UIColor.white, for: .normal)

            
            
            //버튼 터두리 설정
            AllBtn.backgroundColor = .systemIndigo
            AllBtn.layer.cornerRadius = 5
            AllBtn.layer.borderWidth = 1
            AllBtn.layer.borderColor = UIColor.systemIndigo.cgColor
            AllBtn.tag = 1
            
            
            
            //노인 카테고리 버튼
            let OldBtn = UIButton(type: .system)
                         // Specify the position of the button.
            OldBtn.frame = CGRect(x: 120, y: 0, width: 100, height: 50)

            OldBtn.setTitle("노인", for: .normal)
            OldBtn.setTitleColor(UIColor.white, for: .normal)



                           //add function for button
            OldBtn.addTarget(self, action: #selector(targetTapped), for: .touchUpInside)
                              //set frame
                      
                      //버튼 터두리 설정
            OldBtn.backgroundColor = .systemIndigo
            OldBtn.layer.cornerRadius = 5
            OldBtn.layer.borderWidth = 1
            OldBtn.layer.borderColor = UIColor.systemIndigo.cgColor
            OldBtn.tag = 2
            
            //학생
            let StudentBtn = UIButton(type: .system)
                         // Specify the position of the button.
            StudentBtn.frame = CGRect(x: 240, y: 0, width: 100, height: 50)

            StudentBtn.setTitle("학생", for: .normal)
            StudentBtn.setTitleColor(UIColor.white, for: .normal)



                           //add function for button
            StudentBtn.addTarget(self, action: #selector(targetTapped), for: .touchUpInside)
                              //set frame
                      
                      //버튼 터두리 설정
            StudentBtn.backgroundColor = .systemIndigo
            StudentBtn.layer.cornerRadius = 5
            StudentBtn.layer.borderWidth = 1
            StudentBtn.layer.borderColor = UIColor.systemIndigo.cgColor
            StudentBtn.tag = 2
            
            
            ///장애인
            let DisableBtn = UIButton(type: .system)
                         // Specify the position of the button.
            DisableBtn.frame = CGRect(x: 360, y: 0, width: 100, height: 50)

            DisableBtn.setTitle("장애인", for: .normal)
            DisableBtn.setTitleColor(UIColor.white, for: .normal)


                           //add function for button
            DisableBtn.addTarget(self, action: #selector(targetTapped), for: .touchUpInside)
                              //set frame
                      
                      //버튼 터두리 설정
            DisableBtn.backgroundColor = .systemIndigo
            DisableBtn.layer.cornerRadius = 5
            DisableBtn.layer.borderWidth = 1
            DisableBtn.layer.borderColor = UIColor.systemIndigo.cgColor
            DisableBtn.tag = 2
            

            
            //여성
            let WoomenBtn = UIButton(type: .system)
                         // Specify the position of the button.
            WoomenBtn.frame = CGRect(x: 480, y: 0, width: 100, height: 50)

            WoomenBtn.setTitle("여성", for: .normal)
            WoomenBtn.setTitleColor(UIColor.white, for: .normal)


                           //add function for button
            WoomenBtn.addTarget(self, action: #selector(targetTapped), for: .touchUpInside)
                              //set frame
                      
                      //버튼 터두리 설정
            WoomenBtn.backgroundColor = .systemIndigo
            WoomenBtn.layer.cornerRadius = 5
            WoomenBtn.layer.borderWidth = 1
            WoomenBtn.layer.borderColor = UIColor.systemIndigo.cgColor
            WoomenBtn.tag = 2
            
            
            
//
//
//
//
//            //노인
//            let OldBtn = UIButton(type: .infoDark)
//                        //set image for button
//                        //add function for button
//                        //set frame
//            OldBtn.frame = CGRect(x: 160, y: 500, width: 100, height: 80)
//                OldBtn.setTitle("노인", for: .normal)
//
//            //학생
//          let StudentBtn = UIButton(type: .infoDark)
//
//        StudentBtn.frame = CGRect(x: 320, y: 500, width: 100, height: 80)
//         StudentBtn.setTitle("학생", for: .normal)
//
//          //장애인
//            let DisableBtn = UIButton(type: .infoDark)
//
//                  DisableBtn.frame = CGRect(x: 480, y: 500, width: 100, height: 80)
//                   DisableBtn.setTitle("학생", for: .normal)
//
//            //여성
//            let WoomenBtn = UIButton(type: .infoDark)
//
//            WoomenBtn.frame = CGRect(x: 640, y: 500, width: 100, height: 80)
//             WoomenBtn.setTitle("여성", for: .normal)
//
            
            
            
            // 메인 스크롤뷰 그리기
            // 디바이스 메인 기준으로 포인트를 잡아줘야 한다.
            m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            
            // 서브 스크롤뷰 그리기
            // 서브 스크롤뷰를 그릴때에는 메인 스크롤뷰에 기준으로 포인트를 잡아줘야한다.
            // 가로 방향으로 추가하여 x를 기준으로 생성되는 넓이만큼 띄어서 그려준다.
            s_Scrollview_0.frame = CGRect( x: 0, y: 1700, width: screenWidth, height: 100)
            
            
            //서브(가로)스크롤뷰에 버튼들을 추가해준다.
            //추후에 배열에 집어넣고 반복문으로 관리한다.
//            s_Scrollview_0.addSubview(subImgView2)
//            s_Scrollview_0.addSubview(subImgView3)

            s_Scrollview_0.addSubview(AllBtn)
            s_Scrollview_0.addSubview(OldBtn)
            s_Scrollview_0.addSubview(StudentBtn)
            s_Scrollview_0.addSubview(DisableBtn)
            s_Scrollview_0.addSubview(WoomenBtn)


            s_Scrollview_0.contentSize = CGSize(width:screenWidth * 3, height: 100)

            // 메인 스크롤에 서브스크롤을 포함하여 뷰들을 넣어준다.
           //역시 자료구조에 만들어넣은다음 추가시 자료구조에서 꺼내서 추가한다.
            
        
          //  m_Scrollview.addSubview(AllBtn)
           // m_Scrollview.addSubview(button)

            
            
            //복지사례를 보여주는 가로스크롤뷰
            SubRewardScrollview.frame = CGRect(x: 0, y: 750, width: screenWidth, height: 300)
            
            
            let RewardView = UIImageView(image:UIImage(named:"welfare"))
                      RewardView.frame = CGRect(x: 20, y: 0, width: view.frame.width-80, height: 300)
                      //이미지뷰 비율 맞추기
                      RewardView.contentMode = .scaleAspectFit

                      
                      let RewardView2 = UIImageView(image:UIImage(named:"welfare2"))
                      RewardView2.frame = CGRect(x: view.frame.width+20, y: 0, width: view.frame.width, height: 300)
                      //이미지뷰 비율 맞추기
                                 RewardView2.contentMode = .scaleAspectFit
                      let RewardView3 = UIImageView(image:UIImage(named:"welfare3"))
                      RewardView3.frame = CGRect(x: view.frame.width * 2 + 20, y: 0, width: view.frame.width, height: 300)
                      //이미지뷰 비율 맞추기
                                     RewardView3.contentMode = .scaleAspectFit
                      
                      //뉴스를 스크롤뷰에 넣어준다.
                      SubRewardScrollview.addSubview(RewardView)
                      SubRewardScrollview.addSubview(RewardView2)
                      SubRewardScrollview.addSubview(RewardView3)
                      
                      //스크롤뷰의 컨텐츠 크기 설정
                      SubRewardScrollview.contentSize = CGSize(width:screenWidth * 3, height: 100)
                      //페이징 처리
                      SubRewardScrollview.isPagingEnabled = true
            
            m_Scrollview.addSubview(SubRewardScrollview)

            //뉴스를 보여줄 스크롤뷰 SubNewssScrollview
            //보여줄 뉴스를 서버에서 받아온다.
            //이미지주소를 이용해 이미지뷰를 만들어준다.
            
            //프레임 지정
            SubNewssScrollview.frame = CGRect(x: 0, y: 1250, width: screenWidth, height: 300)

            
            let NewsImgView = UIImageView(image:UIImage(named:"welfare"))
            NewsImgView.frame = CGRect(x: 20, y: 0, width: view.frame.width-80, height: 300)
            //이미지뷰 비율 맞추기
            NewsImgView.contentMode = .scaleAspectFit

            
            let NewsImgView2 = UIImageView(image:UIImage(named:"welfare2"))
            NewsImgView2.frame = CGRect(x: view.frame.width+20, y: 0, width: view.frame.width, height: 300)
            //이미지뷰 비율 맞추기
                       NewsImgView2.contentMode = .scaleAspectFit
            let NewsImgView3 = UIImageView(image:UIImage(named:"welfare3"))
            NewsImgView3.frame = CGRect(x: view.frame.width * 2 + 20, y: 0, width: view.frame.width, height: 300)
            //이미지뷰 비율 맞추기
                           NewsImgView3.contentMode = .scaleAspectFit
            
            //뉴스를 스크롤뷰에 넣어준다.
            SubNewssScrollview.addSubview(NewsImgView)
            SubNewssScrollview.addSubview(NewsImgView2)
            SubNewssScrollview.addSubview(NewsImgView3)
            
            //스크롤뷰의 컨텐츠 크기 설정
            SubNewssScrollview.contentSize = CGSize(width:screenWidth * 3, height: 100)
            //페이징 처리
            SubNewssScrollview.isPagingEnabled = true
            //스크롤바 없애기
            
            //메인스크롤에 넣어주기
            m_Scrollview.addSubview(SubNewssScrollview)

            
            
            
            //라벨넣어주기
              m_Scrollview.addSubview(MainLabel)
            m_Scrollview.addSubview(ExampleLabel)
            m_Scrollview.addSubview(NewsLabel)
            m_Scrollview.addSubview(FavorLabel)

        
            
            
           //m_Scrollview.addSubview(MainImgView)
            m_Scrollview.addSubview(SetBtn)

        
            m_Scrollview.addSubview(s_Scrollview_0)
            m_Scrollview.addSubview(myTableView)

            
            // 서브 스크롤뷰에 대한 사이즈를 지정하는 부분이다.
            // 즉. 스크롤 안에 들어간 뷰들의 총 크기를 지정해줘야 해당 크기만큼 스크롤이 가능해진다.
            // 서브 스크롤뷰0에 뷰를 3개를 추가할것이다.
            // 세로방향으로 추가할 것이다.
            // 뷰가 총 3개가 추가할 것이니 3개가 다 보여질수 있도록 크기를 넣어준다.
            // 메인 스크롤 뷰는 가로 방향으로 3개를 넣었으니 총 가로 길이를 넣어준다.
            m_Scrollview.contentSize = CGSize(width: screenWidth, height: 2100)
            
            // 페이징 설정
            // 디폴트는 false이며 뷰 단위로 스크롤한다.
            //m_Scrollview.isPagingEnabled = true
            
            // 메인 스크롤뷰를 실제 메인에 넣기
            self.view.addSubview(m_Scrollview)
            
            //self.view.addSubview(MainLabel)
            
        }
    
    
    //테이블 클릭이벤트
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print("Company Selected: \(companies[indexPath.section].name)")
         print("Employee Selected: \(companies[indexPath.section].employees[indexPath.row].name)")
     }
     
     //no of sections for the list
     func numberOfSections(in tableView: UITableView) -> Int {
         return companies.count
     }
     
    //테이블뷰 색션 나눠주는 부분
     //section heading
//     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//         if section < companies.count {
//             return companies[section].name
//         }
//         return nil
//     }
     
     //number of rows for that section
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return companies[section].employees.count
     }
     
     //render the cell and display data
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyTableViewCell
         
         let formatter = NumberFormatter()
         formatter.numberStyle = .currency
         
         let employee = companies[indexPath.section].employees[indexPath.row]
         cell.employeeImage.image = UIImage(named: employee.image)
         cell.employeeName.text = "\(employee.name)"
         cell.yearsInService.text = "\(employee.years)"
         //cell.salary.text = formatter.string(from: NSNumber(value: employee.salary))
        cell.salary.text = "\(employee.salary)"
        //cell.salary.text = "\(employee.salary)"
         return cell
     }
     
     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         
     }
     
     //get JSON data into object for display
     func getCompanyData() -> [Company] {
         
         var companies: [Company] = [Company]()
         let myJsonData = """
             [{
                     "name": "ABC Company",
                     "employees": [{
                             "years": "2020.12.11",
                             "name": "청년배당금",
                             "image": "welfare",
                             "salary": "지원금 : 300,000원"
                         },
                         {
                             "years": "2020.12.11",
                             "name": "기초수당",
                             "image": "welfare2",
                             "salary": "지원금 : 250,000원"
                         },
                    {
                            "years": "2020.12.11",
                            "name": "조손가정지원",
                            "image": "welfare3",
                            "salary": "지원금 : 50,000원"
                        }
                     ]
                 }
             ]
             """
         
         //Decode JSON Data String to Swift Objects
         if let jsonData = myJsonData.data(using: .utf8) {
             let decoder = JSONDecoder()
             do {
                 companies = try decoder.decode([Company].self, from: jsonData)
                 for company in companies {
                     print("===")
                     print(company.name)
                     for employee in company.employees {
                         print("---")
                         print(employee.name)
                         
                     }
                     
                 }
                 
             } catch {
                 //do nothing
             }
             
             
         }
         
         return companies
         
     }
    
    
    //버튼메소드
    //맞춤선택라러가기 버튼클릭 이벤트
    @objc private func SetMove(sender: UIBarButtonItem) {
             
        //네비게이션 통해서  이동
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "FirstCategoryViewController")  else{return}

        self.navigationController?.pushViewController(uvc, animated: true)
             
           }
    
    
    
    
        //선택한 카테고리별 정책을 보여주는 버튼
      @objc private func targetTapped(sender: UIBarButtonItem) {
            if(sender.tag == 1){

                var abc = "1번" //Do something for tag 5
                print(abc)

            }else{
                
                var abc = "기타" //Do something for tag 5
                             print(abc)
                
        }
          
        }
      
    
    //맞춤정보입력하러가기 버튼 클릭이벤트
      @objc private func onClickButtons(_ sender: Any) {
          if let button = sender as? UIButton {
              print("상세정보입력으로 이동")
              
          }
          
      }
      
      //검색입력하러가기 버튼 클릭이벤트
         @objc private func addTapped(_ sender: Any) {
                 print("검색창으로 이동")
                 
             
             
         }
    
    
    //검색입력하러가기 버튼 클릭이벤트
       @objc private func titleEvent(_ sender: Any) {
               print("검색창으로 이동")
               
           
           
       }
    
    }

