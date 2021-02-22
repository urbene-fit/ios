//
//  MenuViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/07/30.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import SnapKit

class MenuViewController: UIViewController {
    
    
    // 전달받을 데이터 변수 정리

    var paramEmail: String = ""
    var paramName: String = ""
    var paramInterval: Double = 0
    
//    //스크롤뷰 관련 변수
    let m_Scrollview = UIScrollView()
           let contentsView = UIView()
    let subContentsView = UIView()


    
    //페이징 버튼
    
    let pageControl = UIPageControl()

  
    //버튼 커스텀
    lazy var infoDarkButton: UIButton = {
        // Generate button.
        let button = UIButton(type: .infoDark)
        // Specify the position of the button.
        button.layer.position = CGPoint(x: self.view.frame.width/2, y: 200)
        // Tag a button.
        button.tag = 1
        // Add an event.
        
        button.setTitle("맞춤혜택 정보입력하러가기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)

        button.addTarget(self, action: #selector(onClickButtons(_:)), for: .touchUpInside)
        return button }()

   
    
    
    
   


    override func viewDidLoad() {
        super.viewDidLoad()

       // 백그라운드 색상지정
        //self.view.backgroundColor = UIColor(red: 0.6, green: 0.3, blue: 0.5, alpha: 0.3)

        //네비색상지정
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
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
        
        
        
        
        self.navigationController?.navigationBar.topItem?.titleView = nTitle
        
        //네비게이셔 메뉴바
        let barBtn = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(self.addTapped))
        
        //네비게이셔 개인정보
        let infoBtn = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self.addTapped))
        
        
        
        
       
//
//        let btnImg = UIImage(named: "open-menu")
//        btnImg?.resizingMode
//
//        let menuBtn = UIBarButtonItem(image: btnImg, style: .plain, target: self, action: #selector(addTapped))
//
//        menuBtn.tintColor = UIColor.black
//
//
//        let button = UIButton.init(type: .custom)
//        //set image for button
//        button.setImage(UIImage(named: "open-menu"), for: .normal)
//        //add function for button
//        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
//        //set frame
//        button.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
//
//        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar

        self.navigationController?.navigationBar.topItem!.leftBarButtonItem = barBtn
        self.navigationController?.navigationBar.topItem!.rightBarButtonItem = infoBtn


//       //맞춤 정책 라벨추가
//              let frame = CGRect(x: 0, y: 100, width: 100, height: view.frame.height/2)
//              let label = UILabel(frame: frame)
//              label.text="맞춤 혜택정책 "
//              label.textAlignment = NSTextAlignment.center
//              label.font = UIFont(name: "System", size: 100)
//              label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//
//                view.addSubview(label)
//
//
//        //회원정보 입력여부에 따라 입력되어있면 맞춤 정책 보여주고 아니면 버튼을 통해 정보입력하는 공간으로
//
//              self.view.addSubview(infoDarkButton)
//
//
//
        
        
        
        
        // Do any additional setup after loading the view.
        
        //print(paramEmail)
        
//            let alert = UIAlertController(title: "Your Title", message: "Your Message", preferredStyle: UIAlertController.Style.alert)
//
//        let okAction = UIAlertAction(title: "OK", style: .default, handler : nil )
//
//        alert.addAction(okAction)
//
//
//
//        present(alert, animated: true, completion: nil)





//스크롤뷰 설정
        
//        화면크기
//               뷰 전체 폭 길이
           let screenWidth = view.frame.width
               // 뷰 전체 높이 길이
        let screenHeight  = view.frame.height


        //메인스크롤뷰 그리기
        let scrollView = UIScrollView(frame: view.bounds)
        
        scrollView.isScrollEnabled = true
        
        //스크롤뷰 콘텐츠사이즈 지정
        scrollView.contentSize = CGSize(width: screenWidth , height: screenHeight+1000)
        
        
        
        
        
        //1.광고뷰
        
        
        //광고페이징
        let subFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 400)
        let subScrollView = UIScrollView(frame:subFrame)
        
        let pageFrame = CGRect(x: 0, y: 370, width: screenWidth, height: 30)
        //let pageControl = UIPageControl(frame: pageFrame)
        pageControl.frame = CGRect(x: 0, y: 370, width: screenWidth, height: 30)
        
        
        
        //let imgframe = CGRect(x: 0, y: 10, width: view.frame.width, height: 200)
        let imageView = UIImageView(image:UIImage(named:"welfare"))
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        let imageView2 = UIImageView(image:UIImage(named:"welfare2"))
               imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        let imageView3 = UIImageView(image:UIImage(named:"welfare3"))
               imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        
        
        //광고에 사용할 이미지뷰를 서브스크롤뷰에 추가
        subContentsView.addSubview(imageView)
        subContentsView.addSubview(imageView2)
        subContentsView.addSubview(imageView3)

        subScrollView.addSubview(subContentsView)
//        subScrollView.addSubview(imageView2)
//        subScrollView.addSubview(imageView3)
        
        //페이징
        subScrollView.isPagingEnabled = true

               // scrollView의 contentSize를 5 페이지 만큼으로 설정
               subScrollView.contentSize = CGSize(
                   width: UIScreen.main.bounds.width * 3,
                   height: 400
               )
        subScrollView.isScrollEnabled = true
               subScrollView.alwaysBounceVertical = false // 수직 스크롤 바운스 안되게 설정
               
               pageControl.numberOfPages = 3
        

        
//        scrollView.addSubview(imageView)

//        let imageView2 = UIImageView(image:UIImage(named:"main"))
//               scrollView.addSubview(imageView2)
//
//        let imageView3 = UIImageView(image:UIImage(named:"main"))
//                      scrollView.addSubview(imageView2)

        //스크롤뷰에게 콘텐츠사이즈를 알려줘, 스크롤이 가능하게한다.

        //광고뷰 추가
        contentsView.addSubview(subScrollView)
        contentsView.addSubview(pageControl)

     
        
        
               //맞춤 정책 라벨추가
                      let labelframe = CGRect(x: 0, y: 450, width: 100, height: 50)
                      let label = UILabel(frame: labelframe)
                      label.text="맞춤 혜택정책"
                      label.textAlignment = NSTextAlignment.center
                      label.font = UIFont(name: "System", size: 20)
        label.textColor = UIColor.black
        
        
        //맞춤정책뷰 추가
        contentsView.addSubview(label)

        //맞춤정책라러가기 버튼
        let button = UIButton.init(type: .system)
                //set image for button
        button.setTitle("맞춤 설정 하러가기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)

                //add function for button
                button.addTarget(self, action: #selector(targetTapped), for: .touchUpInside)
                //set frame
                button.frame = CGRect(x: 20, y: 500, width: screenWidth-40, height: 50)
        
        //버튼 터두리 설정
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
                //let targetButton = UIBarButtonItem(customView: button)
        
        
        
        //맞춤버튼 추가
           contentsView.addSubview(button)
        
        
        //3.인기정책
        
        //인기정책 라벨
                          let favorLabelFrame = CGRect(x: 0, y: 600, width: screenWidth, height: 50)
                          let favorLabel = UILabel(frame: favorLabelFrame)
                          favorLabel.text=" 지금 인기 있는 \n  혜택정책은"
        //라벨 텍스트 줄 차가 
                        favorLabel.numberOfLines = 2
                          favorLabel.font = UIFont(name: "System", size: 20)
            favorLabel.textColor = UIColor.black
        
        //인기정책라벨 추가
        contentsView.addSubview(favorLabel)
        
        
        //임시
        //인기정책 이미지 추가
        let favorImageView = UIImageView(image:UIImage(named:"welfare"))
                      favorImageView.frame = CGRect(x: 50, y: 650, width: view.frame.width-100, height: 300)
        
        
        //인기정책 이미지 추가
        contentsView.addSubview(favorImageView)
        
        //컨텐츠뷰 최종추가
        scrollView.addSubview(contentsView)
        view.addSubview(scrollView)

      
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    
    

    
    
    //맞춤선택라러가기 버튼클릭 이벤트
    @IBAction func targetTapped(sender: UIBarButtonItem) {
          
        
          print("맞춤선택 선택!")
      }
    
    
    
}



extension MenuViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // floor 내림, ceil 올림
        // contentOffset는 현재 스크롤된 좌표
        pageControl.currentPage = Int(floor(scrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}
