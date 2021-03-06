//
//  GardenerMainViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/21.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit

class GardenerMainViewController: GameMainViewController {
    override func getGameDocument() -> GameDocumentBase { GardenerDocument.sharedInstance }
}

class GardenerOptionsViewController: GameOptionsViewController {
    override func getGameDocument() -> GameDocumentBase { GardenerDocument.sharedInstance }
}

class GardenerHelpViewController: GameHelpViewController {
    override func getGameDocument() -> GameDocumentBase { GardenerDocument.sharedInstance }
}
