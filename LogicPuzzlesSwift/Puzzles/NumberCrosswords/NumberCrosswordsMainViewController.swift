//
//  NumberCrosswordsMainViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/21.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit

class NumberCrosswordsMainViewController: GameMainViewController {
    override func getGameDocument() -> GameDocumentBase { NumberCrosswordsDocument.sharedInstance }
}

class NumberCrosswordsOptionsViewController: GameOptionsViewController {
    override func getGameDocument() -> GameDocumentBase { NumberCrosswordsDocument.sharedInstance }
}

class NumberCrosswordsHelpViewController: GameHelpViewController {
    override func getGameDocument() -> GameDocumentBase { NumberCrosswordsDocument.sharedInstance }
}
