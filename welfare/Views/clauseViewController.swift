//  clauseViewController.swift
//  welfare
//
//  Created by 김동현 on 2021/01/26.
//  Copyright © 2021 com. All rights reserved.


import UIKit


class clauseViewController: UIViewController {

    
    // 메인 세로 스크롤
    let m_Scrollview = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("이용약관 페이지")

        
        //최상단 라벨
        let topLabel = UILabel()
        topLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 0  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        topLabel.text = "너의 혜택은 이용약관"
        topLabel.font = UIFont(name: "Jalnan", size:19 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(topLabel)
        
        //총칙 라벨
        let generalLabel = UILabel()
        generalLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 40  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        generalLabel.text = "제1장 총칙"
        generalLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(generalLabel)
        
        let generalText = UITextView()
        generalText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 70  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        generalText.isEditable = false
        generalText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        generalText.text = "이 약관은 “너의 혜택은“에서 제공하는 회원 서비스(이하 '서비스'라 합니다)를 이용함에 있어 모든 정보, 텍스트, 이미지 및 기타 자료를 이용하는 이용자(이하 '회원')와 '너의 혜택은' 간의 권리•의무 및 책임사항과 기타 필요한 사항을 규정함을 목적으로 합니다."
        m_Scrollview.addSubview(generalText)
        
        //2번째 조항(약관효력)
        let secLabel = UILabel()
        secLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 190  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        secLabel.text = "제 2조 (약관의 효력 및 변경)"
        secLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(secLabel)
        
        let secText = UITextView()
        secText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 220  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        secText.isEditable = false
        secText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        secText.text = "1. '너의 혜택은'은 귀하가 이 약관의 내용에 동의하는 경우 '너의 혜택은'의 서비스 제공 행위 및 귀하의 서비스 이용 행위에 이 약관이 우선적으로 적용됩니다.\n2. '너의 혜택은'은 본 약관을 사전 고지 없이 변경할 수 있고, 변경된 약관은 '너의 혜택은' 내에 공지하거나 e-mail을 통해 회원에게 공지하며, 공지와 동시에 그 효력이 발생됩니다.\n3. 이용자가 변경된 약관에 동의하지 않는 경우, 서비스 이용을 중단하고 본인의 회원등록을 취소(회원탈퇴)할 수 있으며, 계속 사용의 경우는 약관 변경에 동의한 것으로 간주됩니다."
        m_Scrollview.addSubview(secText)
        
        //3번째 조항(준칙)
        let thirdLabel = UILabel()
        thirdLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 340  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        thirdLabel.text = "제 3조 (약관 외 준칙)"
        thirdLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(thirdLabel)
        
        let thirdText = UITextView()
        thirdText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 370  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        thirdText.isEditable = false
        thirdText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        thirdText.text = "1. 이 약관은 '너의 혜택은' 사이트가 제공하는 서비스에 관한 이용규정 및 별도 약관과 함께 적용됩니다.\n2. 이 약관에 명시되지 않은 사항은 개인정보보호법 등 기타 대한민국의 관련법령과 상관습에 의합니다."
        m_Scrollview.addSubview(thirdText)
        
        //4번째 조항(용어의 정의)
        let fourthLabel = UILabel()
        fourthLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 490  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        fourthLabel.text = "제 4조 (용어의 정의)"
        fourthLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(fourthLabel)
        
        let fourthText = UITextView()
        fourthText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 520  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        fourthText.isEditable = false
        fourthText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        fourthText.text = "이 약관에서 사용하는 용어의 정의는 다음과 같습니다.\n1. 회원 : '너의 혜택은'(은)에 개인 정보를 제공하여 회원 등록을 한 자로서 '너의 혜택은'에서 제공하는 서비스를 계속해서 이용할 수 있는 자.\n2. 가입 : '너의 혜택은'에서 제공하는 회원가입 양식에 해당 정보를 기입하고, 본 약관에 동의하여 서비스 이용계약을 완료시키는 행위.\n3. 탈퇴 : 회원이 이용계약을 종료시키는 행위.\n4. 이 약관에서 정의하지 않은 용어는 개별 서비스에 대한 약관 및 이용규정에서 정하는 바에 의합니다."
        m_Scrollview.addSubview(fourthText)
        
        //5번째 조항(이용계약의 성립)
        let fifthLabel = UILabel()
        fifthLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 640  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        fifthLabel.text = "제5조 (이용계약의 성립)"
        fifthLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(fifthLabel)
        
        let fifthText = UITextView()
        fifthText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 670  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        fifthText.isEditable = false
        fifthText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        fifthText.text = "이 약관에서 사용하는 용어의 정의는 다음과 같습니다.\n1. 이용계약은 이용약관에 동의한다는 의사표시를 한 후 '너의 혜택은'에서 제공하는 회원가입 양식에 따라 회원정보를 기입함으로써 가입을 완료하는 것으로 성립됩니다.\n2. 당 사이트는 다음 각 호에 해당하는 이용계약에 대하여는 가입을 취소할 수 있습니다.\n1) 다른 사람의 명의를 사용하여 신청하였을 때\n2) 이용 계약 신청서의 내용을 허위로 기재하였거나 신청하였을 때\n3) 사회의 안녕 질서 혹은 미풍양속을 저해할 목적으로 신청하였을 때\n4) 다른 사람의 '너의 혜택은' 사이트 서비스 이용을 방해하거나 그 정보를 도용하는 등의 행위를 하였을 때\n5) '너의 혜택은' 사이트를 이용하여 법령과 본 약관이 금지하는 행위를 하는 경우\n3. 당 사이트는 다음 각 호에 해당하는 경우 그 사유가 해소될 때까지 이용계약 성립을 유보할 수 있습니다.\n1) 서비스 관련 제반 용량이 부족한 경우\n2) 기술상 장애 사유가 있는 경우"
        m_Scrollview.addSubview(fifthText)
        
        
        //6번째 조항(회원정보 사용에 대한 동의))
        let sixthLabel = UILabel()
        sixthLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 790  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        sixthLabel.text = "제6조 (회원정보 사용에 대한 동의)"
        sixthLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(sixthLabel)
        
        let sixthText = UITextView()
        sixthText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 820  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        sixthText.isEditable = false
        sixthText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        sixthText.text = "1. 회원의 개인정보는 개인정보보호법에 의해 보호됩니다.\n2. '너의 혜택은'의 회원정보는 다음과 같이 수집, 사용, 관리, 보호됩니다.\n1) 개인정보의 수집 : '너의 혜택은'는 귀하의 당 사이트 서비스 가입 때 귀하가 제공하는 정보를 통하여 귀하에 관한 정보를 수집합니다.\n2) 개인정보의 사용 : '너의 혜택은'는 서비스 제공과 관련해서 수집된 회원의 신상정보를 본인의 승낙 없이 제3자에게 누설, 배포하지 않습니다. 단, 다른 법률의 규정에 의해 국가기관의 요구가 있는 경우, 범죄에 대한 수사상의 목적이 있거나 정보통신윤리위원회의 요청이 있는 경우 또는 기타 관계법령에서 정한 절차에 따른 요청이 있는 경우, 귀하가 '너의 혜택은'에 제공한 개인정보를 스스로 공개한 경우에는 그러하지 않습니다.\n3) 개인정보의 관리 : 귀하는 개인정보의 보호 및 관리를 위하여 서비스의 개인정보관리에서 수시로 귀하의 개인정보를 수정/삭제할 수 있습니다.\n4) 개인정보의 보호 : 귀하의 개인정보는 오직 귀하만이 열람/수정/삭제 할 수 있으며, 이는 전적으로 귀하의 아이디와 비밀번호에 의해 관리되고 있습니다. 따라서 타인에게 본인의 아이디와 비밀번호를 알려주어서는 안 되며, 작업 종료 시에는 반드시 로그아웃 해주시고, 웹 브라우저의 창을 닫아주시기 바랍니다(이는 타인과 컴퓨터를 공유하는 인터넷 카페나 도서관 같은 공공장소에서 컴퓨터를 사용하는 경우에 귀하의 정보의 보호를 위하여 필요한 사항입니다).\n3. 회원이 본 약관에 따라 회원가입을 하는 것은, '너의 혜택은' 회원 가입 시 기재한 회원정보를 수집, 이용하는 것에 동의하는 것으로 간주됩니다."
        m_Scrollview.addSubview(sixthText)
        
        
        //7번째 조항(사용자의 정보 보안)
        let seventhLabel = UILabel()
        seventhLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 940  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        seventhLabel.text = "제7조 (사용자의 정보 보안)"
        seventhLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(seventhLabel)
        
        let seventhText = UITextView()
        seventhText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 970  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        seventhText.isEditable = false
        seventhText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        seventhText.text = "1. 가입 신청자가 '너의 혜택은' 가입 절차를 완료하는 순간부터 귀하는 입력한 정보의 비밀을 유지할 책임이 있으며, 회원의 아이디와 비밀번호를 사용하여 발생하는 모든 결과에 대한 책임은 회원 본인에게 있습니다.\n2. 아이디와 비밀번호에 관한 모든 관리의 책임은 회원에게 있으며, 회원의 아이디나 비밀번호가 부정하게 사용되었다는 사실을 발견한 경우에는 즉시 '너의 혜택은'에 신고하여야 합니다. 신고를 하지 않음으로 인한 모든 책임은 회원 본인에게 있습니다.\n3. 이용자는 너의 혜택은 서비스의 사용 종료 시 마다 정확히 접속을 종료해야 하며, 정확히 종료하지 아니함으로써 제3자가 귀하에 관한 정보를 이용하게 되는 등의 결과로 인해 발생하는 손해 및 손실에 대하여 '너의 혜택은'은 책임을 부담하지 아니합니다."
        m_Scrollview.addSubview(seventhText)
        
        //8번째  조항(서비스 이용))
        let eighthLabel = UILabel()
        eighthLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1090  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)

        eighthLabel.text = "제8조 (서비스 이용)"
        eighthLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(eighthLabel)
        
        let eighthText = UITextView()
        eighthText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1120  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        eighthText.isEditable = false
        eighthText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        eighthText.text = "1. 서비스의 이용은 연중무휴 1일 24시간을 원칙으로 합니다. 다만, '너의 혜택은'의 업무상 또는 기술상의 이유로 서비스가 일시 중지될 수 있고, 또한 정기점검 등 운영상의 목적으로 '너의 혜택은'이 정한 기간에는 서비스가 일시 중지될 수 있습니다. 이러한 경우 '너의 혜택은'은 사전 또는 사후에 이를 공지합니다.\n2. '너의 혜택은'은 서비스를 일정범위로 분할하여 각 범위 별로 이용가능 시간을 별도로 정할 수 있습니다. 이 경우 그 내용을 사전에 공지합니다.\n3. '너의 혜택은'이 제공하는 서비스는 아래와 같습니다.\n1) '너의 혜택은'이 자체 개발하거나 다른 기관과의 협의 등을 통해 제공하는 일체의 서비스\n2) 회원에게 제공되는 서비스 중 일부 서비스는 추가 정보를 입력해야 서비스 이용이 가능합니다. (맞춤 혜택, 맞춤 혜택 푸시 알림)"
        m_Scrollview.addSubview(eighthText)
        
        //9번째  조항(서비스의 변경, 중지 및 정보의 저장과 사용)
        let ninthLabel = UILabel()
        ninthLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1240  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 30 *  DeviceManager.sharedInstance.heightRatio)

        ninthLabel.text = "제9조 (서비스의 변경, 중지 및 정보의 저장과 사용)"
        ninthLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(ninthLabel)
        
        let ninthText = UITextView()
        ninthText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1270  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        ninthText.isEditable = false
        ninthText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        ninthText.text = "1) 회원은 본 서비스에 보관되거나 전송된 메시지 및 기타 통신 메시지 등의 내용이 국가의 비상사태, 정전, '너의 혜택은'의 관리범위 외의 서비스 설비 장애 및 기타 불가항력에 의하여 보관되지 못하였거나 삭제된 경우, 전송되지 못한 경우 및 기타 통신 데이터의 손실에 대해 '너의 혜택은'이 관련 책임을 부담하지 아니합니다.\n2) '너의 혜택은'이 정상적인 서비스 제공의 어려움으로 인하여 일시적으로 서비스를 중지하여야 할 경우에는 서비스 중지 1주일 전에 고지 후 서비스를 중지할 수 있으며, 이 기간 동안 회원이 고지내용을 인지하지 못한 데 대하여 '너의 혜택은'은 책임을 부담하지 아니합니다. 상당한 이유가 있을 경우 위 사전 고지기간은 감축되거나 생략될 수 있습니다. 또한 위 서비스 중지에 의하여 본 서비스에 보관되거나 전송된 메시지 및 기타 통신 메시지 등의 내용이 보관되지 못하였거나 삭제된 경우, 전송되지 못한 경우 및 기타 통신 데이터의 손실이 있을 경우에 대하여도 '너의 혜택은'은 책임을 부담하지 아니합니다.\n3) '너의 혜택은'의 사정으로 서비스를 영구적으로 중단하여야 할 경우 제2항을 준용합니다. 다만, 이 경우 사전 고지기간은 1개월로 합니다.\n4) '너의 혜택은'은 사전 고지 후 서비스를 일시적으로 수정, 변경 및 중단할 수 있으며, 이에 대하여 회원 또는 제3자에게 어떠한 책임도 부담하지 아니합니다.\n5) '너의 혜택은'은 회원이 이 약관의 내용에 위배되는 행동을 한 경우, 임의로 서비스 사용을 중지할 수 있습니다. 이 경우 '너의 혜택은'은 회원의 접속을 금지할 수 있으며, 회원이 게시한 내용의 전부 또는 일부를 임의로 삭제할 수 있습니다.\n6) 장기간 휴면 회원인 경우 안내 메일 또는 공지사항 발표 후 1달(30일)간의 통지 기간을 거쳐 서비스 사용을 중지할 수 있습니다."
        m_Scrollview.addSubview(ninthText)
        
        //10번째  조항(정보 제공 및 홍보물 게재)
        let tenthLabel = UILabel()
        tenthLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1390  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)

        tenthLabel.text = "제10조 (정보 제공 및 홍보물 게재)"
        tenthLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(tenthLabel)
        
        let tenthText = UITextView()
        tenthText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1420  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        tenthText.isEditable = false
        tenthText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        tenthText.text = "1. '너의 혜택은' 사이트는 서비스를 운영함에 있어서 각종 정보를 서비스를 게재하는 방법 등으로 회원에게 제공할 수 있습니다.\n2. '너의 혜택은' 사이트는 서비스에 적절하다고 판단되거나 활용 가능성이 있는 홍보물을 게재할 수 있습니다."
        m_Scrollview.addSubview(tenthText)

        
        //11번째  조항(게시물 또는 내용물의 삭제)
        let eleventhLabel = UILabel()
        eleventhLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1540  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)

        eleventhLabel.text = "제11조 (게시물 또는 내용물의 삭제)"
        eleventhLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(eleventhLabel)
        
        let eleventhText = UITextView()
        eleventhText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1570  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        eleventhText.isEditable = false
        eleventhText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        eleventhText.text = "1. '너의 혜택은'은 회원이 게시하거나 등록하는 서비스 내의 모든 내용물이 다음 각 호의 경우에 해당된다고 판단되는 경우 사전 통지 없이 삭제할 수 있으며, 이에 대해 '너의 혜택은'은 어떠한 책임도 지지 않습니다.\n1) '너의 혜택은', 다른 회원 또는 제3자를 비방하거나 중상 모략으로 명예를 손상시키는 내용인 경우\n2) 공공질서 및 미풍양속에 위반되는 내용인 경우\n3) 범죄적 행위에 결부된다고 인정되는 내용일 경우\n4) 제3자의 저작권 등 기타 권리를 침해하는 내용인 경우\n5) 본 서비스 약관에 위배되거나 상용 또는 불법, 음란, 저속하다고 판단되는 게시물을 게시한 경우\n6) 기타 관계 법령 및 '너의 혜택은'에서 정한 규정 등에 위배되는 경우"
        m_Scrollview.addSubview(eleventhText)
        
        //12번째  조항(게시물의 저작권)
        let twelfthLabel = UILabel()
        twelfthLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1690  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)

        twelfthLabel.text = "제12조 (게시물의 저작권)"
        twelfthLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(twelfthLabel)
        
        let twelfthText = UITextView()
        twelfthText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1720  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        twelfthText.isEditable = false
        twelfthText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        twelfthText.text = "1. 회원이 서비스 내에 게시한 게시물의 저작권은 회원에게 있으며, '너의 혜택은'은 회원 게시물의 일부 또는 전체를 인용하거나 편집하여 다른 서비스에서의 개재 등 활용할 수 있습니다.\n2. 회원의 게시물이 타인의 저작권, 프로그램 저작권 등을 침해함으로써 발생하는 민, 형사상의 책임은 전적으로 회원이 부담하여야 합니다.\n3. 회원은 서비스를 이용하여 얻은 정보를 가공, 판매하는 행위 등 서비스에 게재된 자료를 상업적으로 사용할 수 없습니다."
        m_Scrollview.addSubview(twelfthText)
        
        //13번째  조항(너의 혜택은"의 소유권)
        let thirteenthLabel = UILabel()
        thirteenthLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1840  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)

        thirteenthLabel.text = "제13조 ('너의 혜택은'의 소유권)"
        thirteenthLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(thirteenthLabel)
        
        let thirteenthText = UITextView()
        thirteenthText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1870  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        thirteenthText.isEditable = false
        thirteenthText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        thirteenthText.text = "1. '너의 혜택은'이 제공하는 서비스, 그에 필요한 소프트웨어, 이미지, 마크, 로고, 디자인, 서비스명칭, 정보 및 상표 등과 관련된 지적재산권 및 기타권리는 보건복지부와 한국사회보장정보원에 소유권이 있습니다.\n2. 회원은 보건복지부 또는 한국사회보장정보원이 명시적으로 승인한 경우를 제외하고는 제1항 소정의 각 재산에 대한 전부 또는 일부의 수정, 대여, 대출, 판매, 배포, 제작, 양도, 재 라이센스, 담보권 설정행위, 상업적 이용행위를 할 수 없으며, 제3자로 하여금 이와 같은 행위를 하도록 허락할 수 없습니다."
        m_Scrollview.addSubview(thirteenthText)
        
        //14번째  조항(사용자의 행동규범 및 서비스 이용제한))
        let fourteenthLabel = UILabel()
        fourteenthLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1990  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)

        fourteenthLabel.text = "제14조 (사용자의 행동규범 및 서비스 이용제한)"
        fourteenthLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(fourteenthLabel)
        
        let fourteenthText = UITextView()
        fourteenthText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2020  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        fourteenthText.isEditable = false
        fourteenthText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        fourteenthText.text = "1. 귀하가 제공하는 정보의 내용이 허위인 것으로 판명되거나, 그러하다고 의심할 만한 합리적인 사유가 발생할 경우 당 사이트는 귀하의 본 서비스 사용을 일부 또는 전부 중지할 수 있으며, 이로 인해 발생하는 불이익에 대해 책임을 부담하지 아니합니다.회원은 '너의 혜택은'이 명시적으로 승인한 경우를 제외하고는 제1항 소정의 각 재산에 대한 전부 또는 일부의 수정, 대여, 대출, 판매, 배포, 제작, 양도, 재 라이센스, 담보권 설정행위, 상업적 이용행위를 할 수 없으며, 제3자로 하여금 이와 같은 행위를 하도록 허락할 수 없습니다.\n2. 귀하가 당 사이트 서비스를 통하여 게시, 전송, 입수하였거나 전자메일 기타 다른 수단에 의하여 게시, 전송 또는 입수한 모든 형태의 정보에 대하여는 귀하가 모든 책임을 부담하며 당 사이트는 어떠한 책임도 부담하지 아니합니다.\n3. 당 사이트는 당 사이트가 제공한 서비스가 아닌 가입자 또는 기타 유관기관이 제공하는 서비스의 내용상의 정확성, 완전성 및 질에 대하여 보장하지 않습니다. 따라서 당 사이트는 귀하가 위 내용을 이용함으로 인하여 입게 된 모든 종류의 손실이나 손해에 대하여 책임을 부담하지 아니합니다.\n4. 귀하는 본 서비스를 통하여 다음과 같은 행동을 하지 않는데 동의합니다.\n1) 타인의 아이디(ID)와 비밀번호를 도용하는 행위\n2) 저속, 음란, 모욕적, 위협적이거나 타인의 프라이버시를 침해할 수 있는 내용을 전송, 게시, 게재, 전자메일 또는 기타의 방법으로 전송하는 행위\n3) 서비스를 통하여 전송된 내용의 출처를 위장하는 행위\n4) 법률, 계약에 의하여 이용할 수 없는 내용을 게시, 게재, 전자메일 또는 기타의 방법으로 전송하는 행위\n5) 타인의 특허, 상표, 영업비밀, 저작권, 기타 지적재산권을 침해하는 내용을 게시, 게재, 전자메일 또는 기타의 방법으로 전송하는 행위\n6) 당 사이트의 승인을 받지 아니한 광고, 판촉물, 정크메일, 스팸, 행운의 편지, 피라미드 조직 기타 다른 형태의 권유를 게시, 게재, 전자메일 또는 기타의 방법으로 전송하는 행위.\n7) 다른 사용자의 개인정보를 수집 또는 저장하는 행위\n5. 당 사이트는 회원이 본 약관을 위배했다고 판단되면 서비스와 관련된 모든 정보를 이용자의 동의 없이 삭제할 수 있습니다."
        m_Scrollview.addSubview(fourteenthText)
        
        
        //15번째  조항("너의 혜택은"의 의무)
        let fifteenthLabel = UILabel()
        fifteenthLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2140  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)

        fifteenthLabel.text = "제15조 ('너의 혜택은'의 의무)"
        fifteenthLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(fifteenthLabel)
        
        let fifteenthText = UITextView()
        fifteenthText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2170  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        fifteenthText.isEditable = false
        fifteenthText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        fifteenthText.text = "1. '너의 혜택은'은 이 약관에서 정한 바에 따라 계속적, 안정적으로 서비스를 제공하기 위해 노력할 의무가 있습니다.\n2. '너의 혜택은'은 회원의 개인 신상 정보를 본인의 승낙 없이 타인에게 누설, 배포하지 않습니다. 다만, 전기통신관련법령 등 관계법령에 의하여 관계 국가기관 등의 요구가 있는 경우에는 그러하지 않습니다.\n3. '너의 혜택은'은 이용자가 안전하게 당 사이트 서비스를 이용할 수 있도록 이용자의 개인정보 (신용정보 포함) 보호를 위한 보안시스템을 갖추어야 합니다.\n4. '너의 혜택은'은 이용자의 귀책사유로 인한 서비스 이용 장애에 대하여 책임을 지지 않습니다."
        m_Scrollview.addSubview(fifteenthText)
        
        
        //16번째  조항(회원의 의무)
        let sixteenthLabel = UILabel()
        sixteenthLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2290  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)

        sixteenthLabel.text = "제16조 (회원의 의무)"
        sixteenthLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(sixteenthLabel)
        
        let sixteenthText = UITextView()
        sixteenthText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2320  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        sixteenthText.isEditable = false
        sixteenthText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        sixteenthText.text = "1. 회원 가입시에 요구되는 정보는 정확하게 기입하여야 합니다. 또한 이미 제공된 귀하에 대한 정보가 정확한 정보가 되도록 유지, 갱신하여야 하며, 회원은 자신의 ID 및 비밀번호를 제3자에게 이용하게 해서는 안됩니다.\n2. 회원은 당 사이트의 사전 승낙 없이 서비스를 이용하여 어떠한 영리행위도 할 수 없습니다.\n3. 회원은 당 사이트 서비스를 이용하여 얻은 정보를 당 사이트의 사전승낙 없이 복사, 복제, 변경, 번역, 출판•방송 기타의 방법으로 사용하거나 이를 타인에게 제공할 수 없습니다.\n4. 회원은 '너의 혜택은' 서비스 이용과 관련하여 다음 각 호의 행위를 하여서는 안됩니다.\n1) 다른 회원의 ID를 부정 사용하는 행위\n2) 범죄행위를 목적으로 하거나 기타 범죄행위와 관련된 행위\n3) 선량한 풍속, 기타 사회질서를 해하는 행위\n4) 타인의 명예를 훼손하거나 모욕하는 행위\n5) 타인의 지적재산권 등의 권리를 침해하는 행위\n6) 해킹행위 또는 컴퓨터바이러스의 유포행위\n7) 타인의 의사에 반하여 광고성 정보 등 일정한 내용을 지속적으로 전송하는 행위\n8) 서비스의 안전적인 운영에 지장을 주거나 줄 우려가 있는 일체의 행위\n9) 당 사이트에 게시된 정보의 변경."
        m_Scrollview.addSubview(sixteenthText)

        //17번째  조항(양도금지)
        let seventeenthLabel = UILabel()
        seventeenthLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2440  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)

        seventeenthLabel.text = "제17조 (양도금지)"
        seventeenthLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(seventeenthLabel)
        
        let seventeenthText = UITextView()
        seventeenthText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2470  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        seventeenthText.isEditable = false
        seventeenthText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        seventeenthText.text = "회원은 서비스의 이용권한, 기타 이용계약상의 지위를 타인에게 양도, 증여할 수 없습니다."
        m_Scrollview.addSubview(seventeenthText)
        
        //18번째  조항(손해배상)
        let eighteenthLabel = UILabel()
        eighteenthLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2590  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)

        eighteenthLabel.text = "제18조 (손해배상)"
        eighteenthLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(eighteenthLabel)
        
        let eighteenthText = UITextView()
        eighteenthText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2620  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        eighteenthText.isEditable = false
        eighteenthText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        eighteenthText.text = "'너의 혜택은'은 무료로 제공되는 서비스와 관련하여 회원에게 어떠한 손해가 발생하더라도 '너의 혜택은'의 고의로 행한 범죄행위를 제외하고 이에 대하여 책임을 부담하지 아니합니다."
        m_Scrollview.addSubview(eighteenthText)
        
        //19번째  조항(면책조항)
        let nineteenthLabel = UILabel()
        nineteenthLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2740  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)

        nineteenthLabel.text = "제19조 (면책조항)"
        nineteenthLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(nineteenthLabel)
        
        let nineteenthText = UITextView()
        nineteenthText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2770  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        nineteenthText.isEditable = false
        nineteenthText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        nineteenthText.text = "1. 당 사이트는 서비스에 표출된 어떠한 의견이나 정보에 대해 확신이나 대표할 의무가 없으며 회원이나 제3자에 의해 표출된 의견을 승인하거나 반대하거나 수정하지 않습니다. 당 사이트는 어떠한 경우라도 회원이 서비스에 담긴 정보에 의존해 얻은 이득이나 입은 손해에 대해 책임이 없습니다.\n2. 당 사이트는 회원간 또는 회원과 제3자간에 서비스를 매개로 하여 물품거래 혹은 금전적 거래 등과 관련하여 어떠한 책임도 부담하지 아니하고, 회원이 서비스의 이용과 관련하여 기대하는 이익에 관하여 책임을 부담하지 않습니다."
        m_Scrollview.addSubview(nineteenthText)
        
        
        //마지막  조항(관할법원)
        let lastLabel = UILabel()
        lastLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2890  *  DeviceManager.sharedInstance.heightRatio, width: 300 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)

        lastLabel.text = "제20조 (관할법원)"
        lastLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(lastLabel)
        
        let lastText = UITextView()
        lastText.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2920  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        
        lastText.isEditable = false
        lastText.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        lastText.text = "'너의 혜택은'과 이용자 간에 발생한 서비스 이용에 관한 분쟁에 대하여는 대한민국 법을 적용하며, 본 분쟁으로 인한 소는 대한민국의 법원에 제기합니다."
        m_Scrollview.addSubview(lastText)
        
        //마지막  조항(관할법원)
        let Label = UILabel()
        Label.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 3040  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width, height: 30 *  DeviceManager.sharedInstance.heightRatio)

        Label.text = "(시행일) 이 약관은 2021년 1월 26일부터 시행됩니다."
        Label.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label)
        
        //메인 스크롤뷰 설정
        var x = view.safeAreaInsets.left
        var y = view.safeAreaInsets.top
        var width = view.bounds.width - view.safeAreaInsets.left - view.safeAreaInsets.right
        
        
        //safelayout 문제로 안됨
        m_Scrollview.frame = CGRect(x: 0, y: 20 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width, height: DeviceManager.sharedInstance.height)
        
        //태그숫자에 따라 스크롤뷰 길이 변동되게 추후 수정
        var contentHeight : Int =  Int(2790 * DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.contentSize = CGSize(width:DeviceManager.sharedInstance.width, height: 3100 * DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(m_Scrollview)
    }
}
