//
//  DisconnectFourGameScene.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/09.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import SpriteKit

class DisconnectFourGameScene: GameScene<DisconnectFourGameState> {
    var gridNode: DisconnectFourGridNode {
        get { getGridNode() as! DisconnectFourGridNode }
        set { setGridNode(gridNode: newValue) }
    }
    
    func addTree(isY: Bool, s: AllowedObjectState, point: CGPoint, nodeName: String) {
        addImage(imageNamed: "tree", color: .red, colorBlendFactor: s == .normal ? 0.0 : 0.5, point: point, nodeName: nodeName, zRotation: isY ? 0 : CGFloat(Double.pi))
    }

    override func levelInitialized(_ game: AnyObject, state: DisconnectFourGameState, skView: SKView) {
        let game = game as! DisconnectFourGame
        removeAllChildren()
        let blockSize = CGFloat(skView.bounds.size.width) / CGFloat(game.cols)
        
        // addGrid
        let offset:CGFloat = 0.5
        addGrid(gridNode: DisconnectFourGridNode(blockSize: blockSize, rows: game.rows, cols: game.cols), point: CGPoint(x: skView.frame.midX - blockSize * CGFloat(game.cols) / 2 - offset, y: skView.frame.midY + blockSize * CGFloat(game.rows) / 2 + offset))
        
        // addHint
        for r in 0..<game.rows {
            for c in 0..<game.cols {
                let p = Position(r, c)
                let point = gridNode.gridPosition(p: p)
                let nodeNameSuffix = "-\(r)-\(c)"
                let treeNodeName = "tree" + nodeNameSuffix
                let o = state[p]
                guard o != .empty else {continue}
                addTree(isY: o == .yellow, s: state.pos2state[p] ?? .normal, point: point, nodeName: treeNodeName)
                addCircleMarker(color: .white, point: point, nodeName: "marker")
            }
        }
    }
    
    override func levelUpdated(from stateFrom: DisconnectFourGameState, to stateTo: DisconnectFourGameState) {
        for r in 0..<stateFrom.rows {
            for c in 0..<stateFrom.cols {
                let p = Position(r, c)
                let point = gridNode.gridPosition(p: p)
                let nodeNameSuffix = "-\(r)-\(c)"
                let treeNodeName = "tree" + nodeNameSuffix
                let (o1, o2) = (stateFrom[p], stateTo[p])
                let (s1, s2) = (stateFrom.pos2state[p] ?? .normal, stateTo.pos2state[p] ?? .normal)
                guard o1 != o2 || s1 != s2 else {continue}
                if o1 != .empty { removeNode(withName: treeNodeName) }
                if o2 != .empty { addTree(isY: o2 == .yellow, s: s2, point: point, nodeName: treeNodeName) }
            }
        }
    }
}
