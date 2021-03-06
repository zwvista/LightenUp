//
//  LitsMainViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/21.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit

class LitsMainViewController: GameMainViewController {
    override func getGameDocument() -> GameDocumentBase { LitsDocument.sharedInstance }
}

class LitsOptionsViewController: GameOptionsViewController {
    override func getGameDocument() -> GameDocumentBase { LitsDocument.sharedInstance }
}

class LitsHelpViewController: GameHelpViewController {
    override func getGameDocument() -> GameDocumentBase { LitsDocument.sharedInstance }
}
