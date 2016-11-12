//
//  Extensions.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/11/13.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import Foundation

// http://stackoverflow.com/questions/29835242/whats-the-simplest-way-to-convert-from-a-single-character-string-to-an-ascii-va
extension String {
    var asciiArray: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }
}
extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
}
