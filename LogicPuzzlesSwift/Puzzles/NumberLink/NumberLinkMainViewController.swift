//
//  NumberLinkMainViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/21.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit

class NumberLinkMainViewController: GameMainViewController {
    override func getGameDocument() -> GameDocumentBase { NumberLinkDocument.sharedInstance }
}

class NumberLinkOptionsViewController: GameOptionsViewController {
        override func getGameDocument() -> GameDocumentBase { NumberLinkDocument.sharedInstance }
}

class NumberLinkHelpViewController: GameHelpViewController {
    override func getGameDocument() -> GameDocumentBase { NumberLinkDocument.sharedInstance }
}
