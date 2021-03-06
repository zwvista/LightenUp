//
//  TapaMainViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/21.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit

class TapaMainViewController: GameMainViewController {
    override func getGameDocument() -> GameDocumentBase { TapaDocument.sharedInstance }
}

class TapaOptionsViewController: GameOptionsViewController {
    override func getGameDocument() -> GameDocumentBase { TapaDocument.sharedInstance }
}

class TapaHelpViewController: GameHelpViewController {
    override func getGameDocument() -> GameDocumentBase { TapaDocument.sharedInstance }
}
