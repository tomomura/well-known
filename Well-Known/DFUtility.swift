//
//  DFUtility.swift
//  Well-Known
//
//  Created by hw14d002 on 2015/01/22.
//  Copyright (c) 2015年 DualFang. All rights reserved.
//

import UIKit

let PI:Double = 3.14159265
let TUDE_UNIT:Double = 110574.0

internal func toRadian(degree:Double) -> Double {
    return degree * PI / 180.0
}

// メートルを緯度経度の単位に変換して返す
internal func getTudeUnit(metre:Double) -> Double {
    return metre / TUDE_UNIT
}

class DFUtility: NSObject {
   
}
