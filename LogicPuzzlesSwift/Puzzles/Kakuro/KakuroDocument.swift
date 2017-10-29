//
//  KakuroDocument.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/18.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit
import SharkORM

class KakuroDocument: GameDocument<KakuroGame, KakuroGameMove> {
    static var sharedInstance = KakuroDocument()
    
    override func saveMove(_ move: KakuroGameMove, to rec: MoveProgress) {
        (rec.row, rec.col) = move.p.unapply()
        rec.intValue1 = move.obj
    }
    
    override func loadMove(from rec: MoveProgress) -> KakuroGameMove? {
        return KakuroGameMove(p: Position(rec.row, rec.col), obj: rec.intValue1)
    }
}