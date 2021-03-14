//디바이스의 버전/기종/크기를 받아 UI의 비율을 정하는 싱글턴 패턴 클래스
//로그 및 기기별 UI 변경시 사용하는 싱글턴패턴 클래스

import Foundation
import Alamofire
import DeviceKit


public enum DeviceGroup {
    case fourInches
    case fiveInches
    case xSeries
    case iPads
    public var rawValue: [Device] {
        switch self {
        case .fourInches:
            return [.iPhone5s, .iPhoneSE]
        case .fiveInches:
            return [.iPhone6, .iPhone6s, .iPhone7, .iPhone8, .simulator(.iPhone8), .simulator(.iPhone7)]
        case .xSeries:
            return Device.allXSeriesDevices
        case .iPads:
            return Device.allPads
        }
    }
}


class DeviceManager {
    
    static let sharedInstance = DeviceManager()
    
    var widthRatio : CGFloat = 0.0
    var heightRatio : CGFloat = 0.0
    var modelName = UIDevice.modelName
    var systemVersion = "IOS\(UIDevice.current.systemVersion)"
    var width : CGFloat = 0.0
    var height : CGFloat = 0.0
    
    
    //APi에 보내는 로그 변수값
    var log = "IOS|\(UIDevice.modelName)|\(UIDevice.current.systemVersion)"
    
    //세션id를 저장하는 변수
    var sessionID : String = ""
    //사용자 토큰을 저장하는 변수
    var token : String = ""
    
    
    //4인치 5인치 기종들을 구분하기 위한 메소드
    func isFourIncheDevices() -> Bool {
        return Device.current.isOneOf(DeviceGroup.fourInches.rawValue)
    }
    
    func isFiveIncheDevices() -> Bool {
        return Device.current.isOneOf(DeviceGroup.fiveInches.rawValue)
    }
    
    func isSixIncheDevices() -> Bool {
        return Device.current.isOneOf(DeviceGroup.xSeries.rawValue)
    }
    
    func isIPadDevices() -> Bool {
        return Device.current.isOneOf(DeviceGroup.iPads.rawValue)
    }
    
    
    
    //로그로 보낼 정보
    //로그 보내는 메소드
    //헤더에 사용자 인증용 로그인 토큰과 접속상태에서 행동을 추천하기 위한 세션아이디를 보낸다.
    //바디에서 요청타입(type)을 통해 어떤 화면에서 요청을 하는지 구분
    //Action을 통해 해당화면에서 어떤 요청을 했는지 구분
    //keyword를 통해 사용자가 파라미터로 전달한 정보를 저장
    //userAgent 사용자의 기기정보를 저장
    func sendLog (content : String, type : String){
        
        let parameters = ["os_type": systemVersion, "os_version": modelName, "login_token": LoginManager.sharedInstance.token, "content": content, "type": type]
        
        let headers = ["LoginToken": LoginManager.sharedInstance.token,"SessionId": LoginManager.sharedInstance.sessionID]
        
        
        Alamofire.request("https://www.hyemo.com/log", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { (response) in
                print("로그쌓음")
            }
    }
}


//기기정보 받기 위한 장치
public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "AudioAccessory5,1":                       return "HomePod mini"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
}
