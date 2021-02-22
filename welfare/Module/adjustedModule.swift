//
//  adjustedModule.swift
//  welfare
//
//  Created by 김동현 on 2021/02/04.
//  Copyright © 2021 com. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    var adjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 414
        return self * ratio
    }
}

extension Double {
    var adjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 414
        return CGFloat(self) * ratio
    }
}
