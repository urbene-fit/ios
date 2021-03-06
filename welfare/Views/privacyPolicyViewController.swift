//
//  privacyPolicyViewController.swift
//  welfare
//
//  Created by 김동현 on 2021/01/27.
//  Copyright © 2021 com. All rights reserved.
//

import UIKit

class privacyPolicyViewController: UIViewController {

    
    // 메인 세로 스크롤
    let m_Scrollview = UIScrollView()

    //개인정보처리방침 타이틀
    var privacyTitle : [String] = ["수집하는 회원의 개인정보","개인정보의 수집 및 이용목적","개인정보를 수집하는 방법","개인정보의 보유 및 이용기간","개인정보 파기절차 및 방법","회원 개인정보 정확성을 위한 내용","회원의 개인정보안전을 위해 취해질 수 있는 서비스 일시 중단조치","제 3자와의 정보공유 및 제공 관련 내용","회원의 개인정보 비밀유지를 위한 내용","회원이 자신의 개인정보를 보호하기 위해 알아야 할 사항","인지 못한 회원의 개인정보 및 기타 불만사항에 관한 처리","개인정보 취급자의 제한에 관한 내용","개인정보 취급자의 제한에 관한 내용","개인정보관리책임자 및 담당자의 연락처","고지의 의무","개인정보 자동수집 장치의 설치·운영 및 거부"]
    
    //서브타이틀
    var subTitle : [String] = ["수집하는 개인정보의 항목/개인정보 수집방법","알림 서비스를 위해 일부 회원정보를 활용합니다./회원관리를 위해 일부 회원 정보를 활용합니다./마케팅 및 광고에 활용"," ","회사 내부 방침에 의한 정보보유 사유/회원이 직접 개인정보의 보존을 요청한 경우 또는 회사가 개별적으로 회원의 동의를 얻은 경우/관련법령에 의한 정보보유 사유","파기절차/파기기준/파기방법회원"," "," "," "," "," "," "," "," "," ","회사는 이용자에게 특화된 맞춤서비스를 제공하기 위해서 이용자들의 정보를 수시로 저장하고 찾아내는 '세션(session)' 또는 '쿠키(cookie)' 등을 운용합니다./이용자가 쿠키 설치를 거부하는 경우 로그인이 필요한 일부 서비스 이용에 어려움이 있을 수 있습니다."," "]
    
    //내용
    var content : [String] = ["회사는 회원가입, 원활한 고객상담, 각종 서비스의 제공을 위해 회원가입 및 서비스 이용시 아래와 같은 개인정보를 수집하고 있습니다. 선택수집 항목은 입력하지 않아도 회원가입이 가능합니다. 회사는 회원 가입 및 서비스 이용과정에서 필요 최소한의 범위로 개인정보를 수집하며, 그 수집 항목 및 목적을 사전에 고지합니다. 고객이 본 개인정보처리방침을 읽고 필수항목을 입력한 후 '가입하기' 버튼을 누르거나, '확인' 내지 '동의합니다'에 체크하는 경우 개인정보의 처리에 동의한 것으로 봅니다.\n아래는 수집∙이용 항목, 이용목적 내용을 포함하고 있습니다.- 필수항목 : 아이디\n- SNS로 간편회원가입시 필수항목 : 해당 SNS 고유식별번호,이메일\n- 선택항목 : 서비스 이용을 위한 정보(닉네임, 나이, 성별, 거주지역 등)는 정보주체가 결정하여 입력합니다.\n또한 아래의 항목들에 대해서도 안정된 서비스 제공을 위해 추가로 수집할 수 있습니다.\n가. 서비스 이용과정이나 사업처리 과정에서의 수집정보 : 방문 일시, 서비스 이용 기록, 불량 이용 기록, 접속 로그, 접속 기기정보 (ADID 및 IDFA 포함), 접속 기기의 IP Address\n나. 회원 식별자 등록 기능 이용시 수집정보 : 등록한 회원 식별자/회사는 다음과 같은 방법으로 개인정보를 수집하고 있습니다.\n- 홈페이지, 모바일앱, 모바일웹, 서면양식, 팩스, 전화, 상담 게시판, 이메일, 이벤트 응모\n- 협력회사로부터 공동 제휴 및 협력을 통한 정보 수집\n- 생성정보 수집 툴을 통한 정보 수집","- 나이,성별,거주지역등의 정보를 이용하여, 개개인에 맞는 혜택등의 정보를 알림으로 이용하기 위해 활용합니다./- 개인식별, 불량회원(너의혜택은 이용약관 중 회원의 의무 각항을 위반하거나 성실히 수행하지 않은 회원)의 부정 이용방지와 비인가 사용방지, 가입의사 확인, 가입 및 가입횟수 제한, 분쟁 조정을 위한 기록보존, 불만처리 등 민원처리, 고지사항 전달/- 신규 서비스(제품) 개발 및 특화, 이벤트 등 광고성 정보 전달, 인구통계학적 특성에 따른 서비스 제공 및 광고 게재, 접속 빈도 파악 또는 회원의 서비스 이용에 대한 통계, 서비스의 유효성 확인","#모든 회원이 회사로부터 서비스를 제공받기 위해서는 회원의 개인정보가 필요하며 개인정보는 서비스 이용 신청 시 신청양식에 신청자의 동의를 통해 수집됩니다.","#회원가입 시 및 서비스 이용 중 수집된 정보는 회원탈퇴 시 혹은 개인정보 수집 및 이용목적이 달성된 때까지 3개월간 보존하며 이후에는 해당 정보를 지체 없이 파기합니다. 단, 다음의 정보에 대해서는 하기의 이유로 회원탈퇴 후에도 명시한 기간 동안 해당 정보를 보존합니다./가. 부정이용 기록\n- 보존 항목 : 부정이용기록(부정가입, 규정위반 기록 등 비정상적 서비스 이용기록)\n- 보존 이유 : 부정가입 및 부정이용 방지\n- 보존 기간 : 3년/나. 반복적 탈퇴/재가입 방지를 위한 정보\n회원 탈퇴한 경우에는 회원 재가입, 임의 해지등을 반복적으로 행함으로써 회사가 제공하는 서비스의 부정이용 및 이벤트 혜택 등의 이익 등을 불•편법적으로 수취하거나 이 과정에서 명의도용 등의 우려가 있으므로 이러한 행위의 차단 목적으로 회원 탈퇴 후 3개월 동안 회원정보를 보관합니다.\n- 보존 항목 : 아이디\n - 보존 이유 : 재가입, 임의해지 등의 부정이용 방지\n- 보존 기간 : 3개월/-보유기간 및 보유정보 : 회원의 요청 또는 동의를 얻은 항목/기간에 한하여 해당 기간 동안 보유/n가. 앱 접속 기록\n- 보존 이유 : 통신비밀보호법\n- 보존 기간 : 2년\n나. 서비스 이용 기록, 접속 로그, 접속 IP 정보\n- 보존 이유 : 통신비밀보호법\n- 보존 기간 : 3개월","#회원의 개인정보는 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.\n회원이 회원가입 등을 위해 입력하신 정보는 목적이 달성된 후 별도의 DB로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조) 일정 기간 저장된 후 파기됩니다. 동 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다./- 회원 본인 혹은 법정대리인의 회원탈퇴 요청\n- 한국인터넷진흥원, 본인확인기관 등의 개인정보 관련기관을 통한 회원 탈퇴 요청\n- 개인정보 수집·이용 등에 대한 동의 철회 및 개인정보 삭제 또는 파기 요청\n- 정보통신망법에 따른 장기 미이용자/- 전자적 파일형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제\n- 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기","회원의 부정확한 개인정보로 인하여 사용상의 불편을 줄 수 있으므로 개인정보 관리자가 판단하기에 확연히 부정확한 개인정보를 기입한 경우에는 정확하지 않은 개인정보를 파기할 수 있습니다.","회사는 회원의 안전한 서비스 이용을 위해서 최선을 다하고 있습니다. 그러나 원하지 않는 방법에 의하여 회사의 서비스가 훼손을 당하는 경우에는 회원들의 개인정보 보호를 위하여, 문제가 완전하게 해결될 때까지 회원의 개인정보를 이용한 서비스를 일시 중단 할 수도 있습니다.","회사는 정보통신망 이용촉진 및 정보보호 등에 관한 법률 제24조의2(개인정보의 제공 동의 등)에 따라 회원의 동의가 있거나 법률에 특별한 규정이 있는 경우를 제외하고 개인정보를 고지 또는 명시한 범위를 초과하여 이용하거나 제3자에게 제공하지 않습니다.\n또한 개인정보보호법 제59조(금지행위)에 따라 회사의 서비스 제공을 위하여 개인정보를 취급하거나 취급하였던 자는 다음 각호의 행위를 하지 않습니다.\n가. 거짓이나 그 밖의 부정한 수단이나 방법으로 개인정보를 취득하거나 처리에 관한 동의를 받는 행위\n나. 업무상 알게 된 개인정보를 누설하거나 권한 없이 다른 사람이 이용하도록 제공하는 행위\n다. 정당한 권한 없이 또는 허용된 권한을 초과하여 다른 사람의 개인정보를 훼손, 멸실, 변경, 위조 또는 유출하는 행위","회사는 회원의 개인정보의 비밀을 유지하기 위하여 제3자에게는 회원의 동의 없이 개인정보를 유출하지 않습니다. 또한 회원이 동의를 하였다 하더라도, 제3자를 통하여 재유출이 될 확률이 있는 자에게는 회원의 개인정보를 유출하지 않습니다. 회사는 각종 정부기관의 회원 개인정보의 일방적 제공 요구에 대하여는 회원 개인정보를 제공하지 않습니다. 법령에 따른 정부기관이 법령에 따른 공식 절차를 완벽하게 거쳐 자료를 요구하는 경우에 한하여 회원 개인정보를 제공합니다. 회사는 회원의 개인정보를 회사가 정한 기본서비스 및 기타의 서비스 활동 이외에는 이용하지 않습니다. 위의 활동에 따라 회원의 정보가 필요할 시에는 별도의 양식을 통한 수집 및 동의의 절차를 거쳐서 회원의 개인정보를 이용합니다.","PC방 등 외부 장소에서 ‘너의혜택은’을 이용하실 경우 해킹 프로그램 기타 유해 프로그램이 없는지 유의하여 이용하시기 바랍니다. 회사는 개인정보보호에 최선을 다하지만 사용자 개인의 실수나 인터넷 상의 문제로 인한 일들에 대해서는 책임을 지지 않습니다.","회사가 인지하지 못하고 있는 회원의 개인정보 이용 및 기타의 불만사항에 관하여 회원 불만처리를 전담하는 관리자를 배정하여 지속적이고, 신속하게 회원의 불만사항을 처리하고, 처리한 결과에 대하여 즉시 응대합니다.","회사의 개인정보관련 취급 직원은 담당자에 한정시키고 있으며, 수시 교육을 통하여 개인정보취급방침의 준수를 강조하고 있습니다.","– 회원 및 법정 대리인은 언제든지 신청되어 있는 자신의 개인정보를 조회하거나 수정할 수 있으며 이용해지를 요청할 수 있습니다.\n– 회원의 개인정보 조회, 수정을 위해서는 직접 모바일 앱 또는 웹을 통해 수정하거나, 고객센터 또는 담당자에게 이메일 등을 통해 신청해야 합니다. 이용해지(동의철회)를 위해서는 회사가 정하는 탈퇴 신청 양식에 따른 고객센터에 이메일 문의 또는 모바일 앱 상 온라인 신청을 통하여 계약 해지 및 탈퇴가 가능합니다.\n– 회원이 개인정보의 오류에 대한 정정을 요청한 경우에는 정정을 완료하기 전까지 해당 개인정보를 이용 또는 제공하지 않습니다. 또한 잘못된 개인정보를 제3자에게 이미 제공한 경우에는 정정 처리결과를 제 3자에게 지체 없이 통지합니다.\n– 회사는 회원 혹은 법정 대리인의 요청에 의해 해지 또는 삭제된 개인정보를 개인정보취급방침 “4. 개인정보의 보유 및 이용기간”에 명시된 바에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록 처리하고 있습니다.","회사는 회원의 개인정보를 보호하고 개인정보와 관련한 불만을 처리하기 위하여 아래와 같이 개인정보관리책임자를 지정하고 있습니다.\n▶ 개인정보 보호책임자\n성명 : 김동현\n직위 : 대표\nE-mail : welfaremaster@naver.com\n기타 개인정보침해에 대한 신고나 상담이 필요하신 경우에는 아래 기관에 문의하시기 바랍니다.\n- 개인정보침해신고센터(www.118.or.kr / 118)\n- 정보보호마크인증위원회 (www.eprivacy.or.kr / 02-580-0533~4)\n- 대검찰청 첨단범죄수사과 (www.spo.go.kr / 02-3480-2000)\n- 경찰청 사이버테러대응센터 (www.ctrc.go.kr / 02-392-0330)","가. 세션 및 쿠키의 의미: 세션이란 Volla 서비스를 제공하는데 이용되는 서버가 이용자의 접속 시간 동안 이용 정보를 서버에 저장하는 것을 의미하고, 쿠키란 웹 또는 앱을 운영하는 데 이용되는 서버가 이용자의 브라우저에 보내는 아주 작은 텍스트 파일로서 이용자의 컴퓨터 하드디스크에 저장되기도 하는 정보를 말합니다.\n나. 세션 및 쿠키의 사용 목적: 회사는 세션 및 쿠키를 이용자의 접속 빈도나 방문 시간, 서비스이용 패턴을 분석하여 개인 맞춤 서비스를 제공하고 서비스 만족도를 높이기 위한 목적으로 사용합니다. 또한 각종 이벤트 참여 및 타겟 마케팅 등의 목적으로 쿠키 및 세션 정보를 사용합니다.\n다. 세션 및 쿠키의 설정 거부 방법: 이용자는 세션의 설치 및 설정에 대한 선택권을 가지지 않으나, 쿠키 설치 여부에 대한 선택권을 가지고 있습니다. 따라서, 이용자는 웹 브라우저에서 옵션을 설정함으로써 모든 쿠키를 허용하거나, 쿠키가 저장될 때마다 확인을 거치거나, 아니면 모든 쿠키의 저장을 거부할 수도 있습니다. 이용자는 사용하는 웹 브라우저의 옵션을 선택함으로써 모든 쿠키를 허용하거나 쿠키를 저장할 때마다 확인을 거치거나, 모든 쿠키의 저장을 거부할 수 있습니다.\n - 인터넷 익스플로러의 경우, 웹 브라우저 상단의 '도구'>'인터넷 옵션'>'개인정보'>'고급' 메뉴를 통하여 쿠키 설정의 거부가 가능합니다.\n - Safari의 경우, MacOS 상단 좌측 메뉴바에서 'Safari'>'환경설정'>'보안'을 통하여 쿠키 허용여부를 선택할 수 있습니다.","현 개인정보취급방침 내용 추가, 삭제 및 수정이 있을 시에는 개정 최소 7일전부터 홈페이지의 공지게시판을 통해 고지할 것입니다."]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("개인정보처리방침 페이지")
        
                    let titleLabel = UILabel()
                    titleLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 0, width: DeviceManager.sharedInstance.width - 20, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        
                    titleLabel.text = "개인정보 처리방침(v1.0)"
                    titleLabel.font = UIFont(name: "Jalnan", size:16 *  DeviceManager.sharedInstance.heightRatio)
                    m_Scrollview.addSubview(titleLabel)
        
        let firLabel = UILabel()
        firLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 30 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 160 *  DeviceManager.sharedInstance.heightRatio)
        firLabel.numberOfLines = 12
        firLabel.text = "주 너의혜택은(이하 ‘회사’라 함)은 개인정보보호와 정보주체자의 권익보장을 위해 최선의 노력을 다하고 있습니다. 회사는 ‘개인정보 보호법’ 관련 조항과 ‘정보통신망 이용촉진 및 정보보호 등에 관한 법률’의 기준에 따라 ‘개인정보처리방침’을 수립하여 이를 준수하고 있습니다. 회원의 개인정보가 어떠한 목적과 절차로 수집 이용되고 있으며, 개인정보보호를 위해 어떠한 조치가 취해지고 있는지 다음과 같이 알려드립니다."
        firLabel.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(firLabel)
        
        let secLabel = UILabel()
        secLabel.numberOfLines = 10
        secLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 200 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        secLabel.text = "1. 수집하는 회원의 개인정보"
        secLabel.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(secLabel)
        
        let Label3 = UILabel()
        Label3.numberOfLines = 10
        Label3.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 240 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label3.text = "1) 수집하는 개인정보의 항목"
        Label3.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label3)
        
        
        let Label4 = UILabel()
        Label4.numberOfLines = 50
        Label4.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 280 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 530 *  DeviceManager.sharedInstance.heightRatio)

        Label4.text = "회사는 회원가입, 원활한 고객상담, 각종 서비스의 제공을 위해 회원가입 및 서비스 이용시 아래와 같은 개인정보를 수집하고 있습니다. 선택수집 항목은 입력하지 않아도 회원가입이 가능합니다. 회사는 회원 가입 및 서비스 이용과정에서 필요 최소한의 범위로 개인정보를 수집하며, 그 수집 항목 및 목적을 사전에 고지합니다. 고객이 본 개인정보처리방침을 읽고 필수항목을 입력한 후 '가입하기' 버튼을 누르거나, '확인' 내지 '동의합니다'에 체크하는 경우 개인정보의 처리에 동의한 것으로 봅니다.\n아래는 수집∙이용 항목, 이용목적 내용을 포함하고 있습니다.\n- 필수항목 : 아이디\n- SNS로 간편회원가입시 필수항목 : 해당 SNS 고유식별번호,이메일\n- 선택항목 : 서비스 이용을 위한 정보(닉네임, 나이, 성별, 거주지역 등)는 정보주체가 결정하여 입력합니다.\n또한 아래의 항목들에 대해서도 안정된 서비스 제공을 위해 추가로 수집할 수 있습니다.\n가. 서비스 이용과정이나 사업처리 과정에서의 수집정보 : 방문 일시, 서비스 이용 기록, 불량 이용 기록, 접속 로그, 접속 기기정보 (ADID 및 IDFA 포함), 접속 기기의 IP Address\n나. 회원 식별자 등록 기능 이용시 수집정보 : 등록한 회원 식별자/회사는 다음과 같은 방법으로 개인정보를 수집하고 있습니다.\n- 홈페이지, 모바일앱, 모바일웹, 서면양식, 팩스, 전화, 상담 게시판, 이메일, 이벤트 응모\n- 협력회사로부터 공동 제휴 및 협력을 통한 정보 수집\n- 생성정보 수집 툴을 통한 정보 수집"
        Label4.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label4)
        
        let Label5 = UILabel()
        Label5.numberOfLines = 30
        Label5.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 830 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label5.text = "2) 개인정보 수집방법"
        Label5.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label5)
        
        let Label6 = UILabel()
        Label6.numberOfLines = 10
         Label6.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 870 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)

         Label6.text = "회사는 다음과 같은 방법으로 개인정보를 수집하고 있습니다.\n- 홈페이지, 모바일앱, 모바일웹, 서면양식, 팩스, 전화, 상담 게시판, 이메일, 이벤트 응모 \n- 협력회사로부터 공동 제휴 및 협력을 통한 정보 수집 \n- 생성정보 수집 툴을 통한 정보 수집"
         Label6.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview( Label6)

        let Label7 = UILabel()
        Label7.numberOfLines = 10
        Label7.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 990 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label7.text = "2. 개인정보의 수집 및 이용목적"
        Label7.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label7)

        
        
        let Label8 = UILabel()
        Label8.numberOfLines = 10
        Label8.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1030 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label8.text = "1)알림 서비스를 위해 일부 회원정보를 활용합니다."
        Label8.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label8)



        let Label9 = UILabel()
        Label9.numberOfLines = 10
        Label9.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1070 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 40 *  DeviceManager.sharedInstance.heightRatio)

        Label9.text = "- 나이,성별,거주지역등의 정보를 이용하여, 개개인에 맞는 혜택등의 정보를 알림으로 이용하기 위해 활용합니다."
        Label9.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label9)

        let Label10 = UILabel()
        Label10.numberOfLines = 10
        Label10.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1130 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label10.text = "2) 회원관리를 위해 일부 회원 정보를 활용합니다."
        Label10.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label10)

        let Label11 = UILabel()
        Label11.numberOfLines = 10
        Label11.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1170 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)

        Label11.text = "- 개인식별, 불량회원(너의혜택은 이용약관 중 회원의 의무 각항을 위반하거나 성실히 수행하지 않은 회원)의 부정 이용방지와 비인가 사용방지, 가입의사 확인, 가입 및 가입횟수 제한, 분쟁 조정을 위한 기록보존, 불만처리 등 민원처리, 고지사항 전달"
        Label11.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label11)

        let Label12 = UILabel()
        Label12.numberOfLines = 10
        Label12.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1290 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label12.text = "3) 마케팅 및 광고에 활용"
        Label12.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label12)

        let Label13 = UILabel()
        Label13.numberOfLines = 10
        Label13.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1330 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 80 *  DeviceManager.sharedInstance.heightRatio)

        Label13.text = "- 신규 서비스(제품) 개발 및 특화, 이벤트 등 광고성 정보 전달, 인구통계학적 특성에 따른 서비스 제공 및 광고 게재, 접속 빈도 파악 또는 회원의 서비스 이용에 대한 통계, 서비스의 유효성 확인"
        Label13.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label13)

        let Label14 = UILabel()
        Label14.numberOfLines = 10
        Label14.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1430 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label14.text = "3. 개인정보를 수집하는 방법"
        Label14.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label14)

        let Label15 = UILabel()
        Label15.numberOfLines = 10
        Label15.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1470 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 60 *  DeviceManager.sharedInstance.heightRatio)

        Label15.text = "모든 회원이 회사로부터 서비스를 제공받기 위해서는 회원의 개인정보가 필요하며 개인정보는 서비스 이용 신청 시 신청양식에 신청자의 동의를 통해 수집됩니다."
        Label15.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label15)

        let Label16 = UILabel()
        Label16.numberOfLines = 10
        Label16.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1550 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label16.text = "4. 개인정보의 보유 및 이용기간"
        Label16.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label16)

        let Label17 = UILabel()
        Label17.numberOfLines = 10
        Label17.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1590 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)

        Label17.text = "회원가입 시 및 서비스 이용 중 수집된 정보는 회원탈퇴 시 혹은 개인정보 수집 및 이용목적이 달성된 때까지 3개월간 보존하며 이후에는 해당 정보를 지체 없이 파기합니다. 단, 다음의 정보에 대해서는 하기의 이유로 회원탈퇴 후에도 명시한 기간 동안 해당 정보를 보존합니다."
        Label17.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label17)

        let Label18 = UILabel()
        Label18.numberOfLines = 10
        Label18.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1710 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label18.text = "1) 회사 내부 방침에 의한 정보보유 사유"
        Label18.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label18)

        let Label19 = UILabel()
        Label19.numberOfLines = 15
        Label19.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1750 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 300 *  DeviceManager.sharedInstance.heightRatio)

        Label19.text = "가. 부정이용 기록\n- 보존 항목 : 부정이용기록(부정가입, 규정위반 기록 등 비정상적 서비스 이용기록)\n- 보존 이유 : 부정가입 및 부정이용 방지\n- 보존 기간 : 3년\n나. 반복적 탈퇴/재가입 방지를 위한 정보\n회원 탈퇴한 경우에는 회원 재가입, 임의 해지등을 반복적으로 행함으로써 회사가 제공하는 서비스의 부정이용 및 이벤트 혜택 등의 이익 등을 불•편법적으로 수취하거나 이 과정에서 명의도용 등의 우려가 있으므로 이러한 행위의 차단 목적으로 회원 탈퇴 후 3개월 동안 회원정보를 보관합니다.\n- 보존 항목 : 아이디\n- 보존 이유 : 재가입, 임의해지 등의 부정이용 방지\n- 보존 기간 : 3개월"
        Label19.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label19)

        let Label20 = UILabel()
        Label20.numberOfLines = 10
        Label20.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2070 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 40 *  DeviceManager.sharedInstance.heightRatio)

        Label20.text = "2) 회원이 직접 개인정보의 보존을 요청한 경우 또는 회사가 개별적으로 회원의 동의를 얻은 경우"
        Label20.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label20)

        let Label21 = UILabel()
        Label21.numberOfLines = 10
        Label21.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2130 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 40 *  DeviceManager.sharedInstance.heightRatio)

        Label21.text = "-보유기간 및 보유정보 : 회원의 요청 또는 동의를 얻은 항목/기간에 한하여 해당 기간 동안 보유"
        Label21.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label21)

        let Label23 = UILabel()
        Label23.numberOfLines = 10
        Label23.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2190 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label23.text = "3) 관련법령에 의한 정보보유 사유"
        Label23.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label23)

        let Label24 = UILabel()
        Label24.numberOfLines = 10
        Label24.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2230 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 120 *  DeviceManager.sharedInstance.heightRatio)

        Label24.text = "가. 앱 접속 기록\n- 보존 이유 : 통신비밀보호법\n- 보존 기간 : 2년\n나. 서비스 이용 기록, 접속 로그, 접속 IP 정보\n- 보존 이유 : 통신비밀보호법\n- 보존 기간 : 3개월"
        Label24.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label24)


        let Label25 = UILabel()
        Label25.numberOfLines = 10
        Label25.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2370 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label25.text = "5. 개인정보 파기절차 및 방법"
        Label25.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label25)

        let Label26 = UILabel()
        Label26.numberOfLines = 10
        Label26.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2410 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 60 *  DeviceManager.sharedInstance.heightRatio)

        Label26.text = "회원의 개인정보는 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체없이 파기합니다. 파기절차 및 방법은 다음과 같습니다."
        Label26.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label26)

        let Label27 = UILabel()
        Label27.numberOfLines = 10
        Label27.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2490 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label27.text = "1) 파기절차"
        Label27.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label27)

        let Label28 = UILabel()
        Label28.numberOfLines = 10
        Label28.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2530 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)

        Label28.text = "회원이 회원가입 등을 위해 입력하신 정보는 목적이 달성된 후 별도의 DB로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조) 일정 기간 저장된 후 파기됩니다. 동 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다."
        Label28.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label28)

        let Label29 = UILabel()
        Label29.numberOfLines = 10
        Label29.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2650 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label29.text = "2) 파기기준"
        Label29.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label29)

        let Label30 = UILabel()
        Label30.numberOfLines = 10
        Label30.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2690 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 120 *  DeviceManager.sharedInstance.heightRatio)

        Label30.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        Label30.text = "- 회원 본인 혹은 법정대리인의 회원탈퇴 요청\n- 한국인터넷진흥원, 본인확인기관 등의 개인정보 관련기관을 통한 회원 탈퇴 요청\n- 개인정보 수집·이용 등에 대한 동의 철회 및 개인정보 삭제 또는 파기 요청\n- 정보통신망법에 따른 장기 미이용자"
        m_Scrollview.addSubview(Label30)

        let Label31 = UILabel()
        Label31.numberOfLines = 10
        Label31.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2830 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label31.text = "3) 파기방법"
        Label31.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label31)

        let Label32 = UILabel()
        Label32.numberOfLines = 10
        Label32.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2870 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 80 *  DeviceManager.sharedInstance.heightRatio)
        Label32.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        Label32.text = "- 전자적 파일형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제\n- 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기"
        m_Scrollview.addSubview(Label32)

        let Label33 = UILabel()
        Label33.numberOfLines = 10
        Label33.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 2970 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label33.text = "6. 회원 개인정보 정확성을 위한 내용"
        Label33.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label33)

        let Label34 = UILabel()
        Label34.numberOfLines = 10
        Label34.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 3010 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 80 *  DeviceManager.sharedInstance.heightRatio)
        Label34.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        Label34.text = "회원의 부정확한 개인정보로 인하여 사용상의 불편을 줄 수 있으므로 개인정보 관리자가 판단하기에 확연히 부정확한 개인정보를 기입한 경우에는 정확하지 않은 개인정보를 파기할 수 있습니다."
        m_Scrollview.addSubview(Label34)

        let Label35 = UILabel()
        Label35.numberOfLines = 10
        Label35.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 3110 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 40 *  DeviceManager.sharedInstance.heightRatio)

        Label35.text = "7. 회원의 개인정보안전을 위해 취해질 수 있는 서비스 일시 중단조치"
        Label35.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label35)

        let Label36 = UILabel()
        Label36.numberOfLines = 10
        Label36.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 3150 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        Label36.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        Label36.text = "회사는 회원의 안전한 서비스 이용을 위해서 최선을 다하고 있습니다. 그러나 원하지 않는 방법에 의하여 회사의 서비스가 훼손을 당하는 경우에는 회원들의 개인정보 보호를 위하여, 문제가 완전하게 해결될 때까지 회원의 개인정보를 이용한 서비스를 일시 중단 할 수도 있습니다."
        m_Scrollview.addSubview(Label36)

        let Label37 = UILabel()
        Label37.numberOfLines = 10
        Label37.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 3290 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label37.text = "8. 제 3자와의 정보공유 및 제공 관련 내용"
        Label37.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label37)

        let Label38 = UILabel()
        Label38.numberOfLines = 20
        Label38.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 3330 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 300 *  DeviceManager.sharedInstance.heightRatio)
        Label38.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        Label38.text = "회사는 정보통신망 이용촉진 및 정보보호 등에 관한 법률 제24조의2(개인정보의 제공 동의 등)에 따라 회원의 동의가 있거나 법률에 특별한 규정이 있는 경우를 제외하고 개인정보를 고지 또는 명시한 범위를 초과하여 이용하거나 제3자에게 제공하지 않습니다.\n또한 개인정보보호법 제59조(금지행위)에 따라 회사의 서비스 제공을 위하여 개인정보를 취급하거나 취급하였던 자는 다음 각호의 행위를 하지 않습니다.\n가. 거짓이나 그 밖의 부정한 수단이나 방법으로 개인정보를 취득하거나 처리에 관한 동의를 받는 행위\n나. 업무상 알게 된 개인정보를 누설하거나 권한 없이 다른 사람이 이용하도록 제공하는 행위다. \n정당한 권한 없이 또는 허용된 권한을 초과하여 다른 사람의 개인정보를 훼손, 멸실, 변경, 위조 또는 유출하는 행위"
        m_Scrollview.addSubview(Label38)


        let Label39 = UILabel()
        Label39.numberOfLines = 10
        Label39.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 3650 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label39.text = "9. 회원의 개인정보 비밀유지를 위한 내용"
        Label39.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label39)



        let Label40 = UILabel()
        Label40.numberOfLines = 20
        Label40.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 3690 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 300 *  DeviceManager.sharedInstance.heightRatio)
        Label40.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        Label40.text = "회사는 회원의 개인정보의 비밀을 유지하기 위하여 제3자에게는 회원의 동의 없이 개인정보를 유출하지 않습니다. 또한 회원이 동의를 하였다 하더라도, 제3자를 통하여 재유출이 될 확률이 있는 자에게는 회원의 개인정보를 유출하지 않습니다. 회사는 각종 정부기관의 회원 개인정보의 일방적 제공 요구에 대하여는 회원 개인정보를 제공하지 않습니다. 법령에 따른 정부기관이 법령에 따른 공식 절차를 완벽하게 거쳐 자료를 요구하는 경우에 한하여 회원 개인정보를 제공합니다. 회사는 회원의 개인정보를 회사가 정한 기본서비스 및 기타의 서비스 활동 이외에는 이용하지 않습니다. 위의 활동에 따라 회원의 정보가 필요할 시에는 별도의 양식을 통한 수집 및 동의의 절차를 거쳐서 회원의 개인정보를 이용합니다."
        m_Scrollview.addSubview(Label40)

        let Label41 = UILabel()
        Label41.numberOfLines = 10
        Label41.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 4010 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label41.text = "10. 회원이 자신의 개인정보를 보호하기 위해 알아야 할 사항"
        Label41.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label41)


        let Label42 = UILabel()
        Label42.numberOfLines = 10
        Label42.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 4050 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 100 *  DeviceManager.sharedInstance.heightRatio)
        Label42.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        Label42.text = "PC방 등 외부 장소에서 ‘너의혜택은’을 이용하실 경우 해킹 프로그램 기타 유해 프로그램이 없는지 유의하여 이용하시기 바랍니다. 회사는 개인정보보호에 최선을 다하지만 사용자 개인의 실수나 인터넷 상의 문제로 인한 일들에 대해서는 책임을 지지 않습니다."
        m_Scrollview.addSubview(Label42)

        let Label43 = UILabel()
        Label43.numberOfLines = 10
        Label43.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 4170 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label43.text = "11. 인지 못한 회원의 개인정보 및 기타 불만사항에 관한 처리"
        Label43.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label43)

        let Label44 = UILabel()
        Label44.numberOfLines = 10
        Label44.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 4190 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 80 *  DeviceManager.sharedInstance.heightRatio)
        Label44.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        Label44.text = "회사가 인지하지 못하고 있는 회원의 개인정보 이용 및 기타의 불만사항에 관하여 회원 불만처리를 전담하는 관리자를 배정하여 지속적이고, 신속하게 회원의 불만사항을 처리하고, 처리한 결과에 대하여 즉시 응대합니다."
        m_Scrollview.addSubview(Label44)

        let Label45 = UILabel()
        Label45.numberOfLines = 10
        Label45.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 4310 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label45.text = "12. 개인정보 취급자의 제한에 관한 내용"
        Label45.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label45)


        let Label46 = UILabel()
        Label46.numberOfLines = 10
        Label46.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 4350 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 60 *  DeviceManager.sharedInstance.heightRatio)
        Label46.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        Label46.text = "회사의 개인정보관련 취급 직원은 담당자에 한정시키고 있으며, 수시 교육을 통하여 개인정보취급방침의 준수를 강조하고 있습니다."
        m_Scrollview.addSubview(Label46)

        let Label47 = UILabel()
        Label47.numberOfLines = 10
        Label47.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 4430 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label47.text = "13. 회원 및 법정대리인의 권리와 그 행사방법"
        Label47.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label47)

        let Label48 = UILabel()
        Label48.numberOfLines = 20
        Label48.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 4470 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 340 *  DeviceManager.sharedInstance.heightRatio)
      Label48.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        Label48.text = "– 회원 및 법정 대리인은 언제든지 신청되어 있는 자신의 개인정보를 조회하거나 수정할 수 있으며 이용해지를 요청할 수 있습니다.\n– 회원의 개인정보 조회, 수정을 위해서는 직접 모바일 앱 또는 웹을 통해 수정하거나, 고객센터 또는 담당자에게 이메일 등을 통해 신청해야 합니다. 이용해지(동의철회)를 위해서는 회사가 정하는 탈퇴 신청 양식에 따른 고객센터에 이메일 문의 또는 모바일 앱 상 온라인 신청을 통하여 계약 해지 및 탈퇴가 가능합니다.\n– 회원이 개인정보의 오류에 대한 정정을 요청한 경우에는 정정을 완료하기 전까지 해당 개인정보를 이용 또는 제공하지 않습니다. 또한 잘못된 개인정보를 제3자에게 이미 제공한 경우에는 정정 처리결과를 제 3자에게 지체 없이 통지합니다.\n– 회사는 회원 혹은 법정 대리인의 요청에 의해 해지 또는 삭제된 개인정보를 개인정보취급방침 “4. 개인정보의 보유 및 이용기간”에 명시된 바에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록 처리하고 있습니다."
        m_Scrollview.addSubview(Label48)

        let Label49 = UILabel()
        Label49.numberOfLines = 10
        Label49.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 4830 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label49.text = "14. 개인정보관리책임자 및 담당자의 연락처"
        Label49.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label49)

        
//
        let Label50 = UILabel()
        Label50.numberOfLines = 20
        Label50.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 4870 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 360 *  DeviceManager.sharedInstance.heightRatio)
        Label50.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        Label50.text = "회사는 회원의 개인정보를 보호하고 개인정보와 관련한 불만을 처리하기 위하여 아래와 같이 개인정보관리책임자를 지정하고 있습니다.\n▶ 개인정보 보호책임자\n성명 : 김동현\n직위 : 대표\nE-mail : welfaremaster@naver.com\n기타 개인정보침해에 대한 신고나 상담이 필요하신 경우에는 아래 기관에 문의하시기 바랍니다.\n- 개인정보침해신고센터 (www.118.or.kr / 118)\n- 정보보호마크인증위원회 (www.eprivacy.or.kr / 02-580-0533~4)\n- 대검찰청 첨단범죄수사과 (www.spo.go.kr / 02-3480-2000)\n- 경찰청 사이버테러대응센터 (www.ctrc.go.kr / 02-392-0330)"
        m_Scrollview.addSubview(Label50)

        let Label51 = UILabel()
        Label51.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 5230 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label51.text = "15. 고지의 의무"
        Label51.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label51)

        let Label52 = UILabel()
        Label52.numberOfLines = 5

        Label52.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 5270 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 60 *  DeviceManager.sharedInstance.heightRatio)
        Label52.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        Label52.text = "1) 회사는 이용자에게 특화된 맞춤서비스를 제공하기 위해서 이용자들의 정보를 수시로 저장하고 찾아내는 '세션(session)' 또는 '쿠키(cookie)' 등을 운용합니다."
        Label52.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label52)

        let Label53 = UILabel()
        Label53.numberOfLines = 30
        Label53.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 5310 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 580 *  DeviceManager.sharedInstance.heightRatio)
        Label53.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        Label53.text = "1) 회사는 이용자에게 특화된 맞춤서비스를 제공하기 위해서 이용자들의 정보를 수시로 저장하고 찾아내는 '세션(session)' 또는 '쿠키(cookie)' 등을 운용합니다.\n가. 세션 및 쿠키의 의미: 세션이란 Volla 서비스를 제공하는데 이용되는 서버가 이용자의 접속 시간 동안 이용 정보를 서버에 저장하는 것을 의미하고, 쿠키란 웹 또는 앱을 운영하는 데 이용되는 서버가 이용자의 브라우저에 보내는 아주 작은 텍스트 파일로서 이용자의 컴퓨터 하드디스크에 저장되기도 하는 정보를 말합니다.\n나. 세션 및 쿠키의 사용 목적: 회사는 세션 및 쿠키를 이용자의 접속 빈도나 방문 시간, 서비스이용 패턴을 분석하여 개인 맞춤 서비스를 제공하고 서비스 만족도를 높이기 위한 목적으로 사용합니다. 또한 각종 이벤트 참여 및 타겟 마케팅 등의 목적으로 쿠키 및 세션 정보를 사용합니다.\n세션 및 쿠키의 설정 거부 방법: 이용자는 세션의 설치 및 설정에 대한 선택권을 가지지 않으나, 쿠키 설치 여부에 대한 선택권을 가지고 있습니다. 따라서, 이용자는 웹 브라우저에서 옵션을 설정함으로써 모든 쿠키를 허용하거나, 쿠키가 저장될 때마다 확인을 거치거나, 아니면 모든 쿠키의 저장을 거부할 수도 있습니다. 이용자는 사용하는 웹 브라우저의 옵션을 선택함으로써 모든 쿠키를 허용하거나 쿠키를 저장할 때마다 확인을 거치거나, 모든 쿠키의 저장을 거부할 수 있습니다.\n - 인터넷 익스플로러의 경우, 웹 브라우저 상단의 '도구'>'인터넷 옵션'>'개인정보'>'고급' 메뉴를 통하여 쿠키 설정의 거부가 가능합니다.\n - Safari의 경우, MacOS 상단 좌측 메뉴바에서 'Safari'>'환경설정'>'보안'을 통하여 쿠키 허용여부를 선택할 수 있습니다."
        m_Scrollview.addSubview(Label53)


        let Label54 = UILabel()
        Label54.numberOfLines = 3

        Label54.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 5890 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 40 *  DeviceManager.sharedInstance.heightRatio)

        Label54.text = "2) 이용자가 쿠키 설치를 거부하는 경우 로그인이 필요한 일부 서비스 이용에 어려움이 있을 수 있습니다."
        Label54.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label54)

        let Label55 = UILabel()
        Label55.numberOfLines = 3

        Label55.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 5950 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 20 *  DeviceManager.sharedInstance.heightRatio)

        Label55.text = "16. 개인정보 자동수집 장치의 설치·운영 및 거부"
        Label55.font = UIFont(name: "Jalnan", size:14 *  DeviceManager.sharedInstance.heightRatio)
        m_Scrollview.addSubview(Label55)

        let Label56 = UILabel()
        Label56.numberOfLines = 20
        Label56.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 5990 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 160 *  DeviceManager.sharedInstance.heightRatio)
        Label56.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        Label56.text = "현 개인정보취급방침 내용 추가, 삭제 및 수정이 있을 시에는 개정 최소 7일전부터 홈페이지의 공지게시판을 통해 고지할 것입니다.\n부칙\n본 개인정보처리방침에서 규정되지 않은 사항은 관계법령의 범위 내에서 당사 이용약관을 우선적으로 적용합니다.\n - 개인정보처리방침 공고일자 : 2021년 1월 20일\n- 개인정보처리방침 시행일자 : 2021년 1월 20일"
        m_Scrollview.addSubview(Label56)


        m_Scrollview.frame = CGRect(x: 0, y: 20 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width, height: DeviceManager.sharedInstance.height)
        m_Scrollview.contentSize = CGSize(width:DeviceManager.sharedInstance.width, height: 6200 * DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(m_Scrollview)
    }
}
