//
//  MisterFusion+MartyJunior.swift
//  MartyJunior
//
//  Created by 鈴木大貴 on 2015/11/26.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import Foundation
import MisterFusion

func + (left: [MisterFusion], right: [MisterFusion]) -> [MisterFusion] {
    return [left, right].flatMap { $0 }
}

func + (left: [MisterFusion], right: MisterFusion) -> [MisterFusion] {
    return left + [right]
}

func + (left: MisterFusion, right: [MisterFusion]) -> [MisterFusion] {
    return [left] + right
}