//
//  PowerGridGame.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/10.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import Foundation

class PowerGridGame: GridGame<PowerGridGameState> {
    static let offset = [
        Position(-1, 0),
        Position(0, 1),
        Position(1, 0),
        Position(0, -1),
    ]

    var row2hint = [Int]()
    var col2hint = [Int]()
    var pos2post = [Position]()
    
    init(layout: [String], delegate: PowerGridGameViewController? = nil) {
        super.init(delegate: delegate)
        
        size = Position(layout.count - 1, layout[0].length - 1)
        row2hint = Array<Int>(repeating: 0, count: rows)
        col2hint = Array<Int>(repeating: 0, count: cols)
        
        for r in 0..<rows + 1 {
            let str = layout[r]
            for c in 0..<cols + 1 {
                let ch = str[c]
                guard case "0"..."9" = ch else {continue}
                let n = ch.toInt!
                if r == rows {
                    col2hint[c] = n
                } else if c == cols {
                    row2hint[r] = n
                }
            }
        }
        
        let state = PowerGridGameState(game: self)
        levelInitilized(state: state)
    }
    
}
