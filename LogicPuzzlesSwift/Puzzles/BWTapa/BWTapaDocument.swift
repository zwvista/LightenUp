//
//  BWTapaDocument.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/18.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit
import SharkORM

class BWTapaDocument: GameDocument<BWTapaGame, BWTapaGameMove> {
    static var sharedInstance = BWTapaDocument()
    
    override func saveMove(_ move: BWTapaGameMove, to rec: MoveProgress) {
        (rec.row, rec.col) = move.p.unapply()
        rec.strValue1 = move.obj.toString()
    }
    
    override func loadMove(from rec: MoveProgress) -> BWTapaGameMove? {
        return BWTapaGameMove(p: Position(rec.row, rec.col), obj: BWTapaObject.fromString(str: rec.strValue1!))
    }
}