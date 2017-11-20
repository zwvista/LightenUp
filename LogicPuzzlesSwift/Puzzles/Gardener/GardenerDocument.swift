//
//  GardenerDocument.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/18.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit
import SharkORM

class GardenerDocument: GameDocument<GardenerGame, GardenerGameMove> {
    static var sharedInstance = GardenerDocument()
    
    override func saveMove(_ move: GardenerGameMove, to rec: MoveProgress) {
        (rec.row, rec.col) = move.p.unapply()
        rec.strValue1 = move.obj.toString()
    }
    
    override func loadMove(from rec: MoveProgress) -> GardenerGameMove? {
        return GardenerGameMove(p: Position(rec.row, rec.col), obj: GardenerObject.fromString(str: rec.strValue1!))
    }
}
