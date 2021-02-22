//
//  Value.swift
//  welfare
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 com. All rights reserved.
//

import Foundation


class Value {
    
    public var globalString : String = "test"
    
    struct StaticInstance {
        static var instance : Value?
        
    }
    
    class func sharedInstance() -> Value{
        if (StaticInstance.instance == nil){
            StaticInstance.instance = Value()
            
        }
        
        return StaticInstance.instance!
    }
    
    
    
}
