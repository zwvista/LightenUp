//
//  MasyuGameScene.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/09.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import SpriteKit

class MasyuGameScene: GameScene<MasyuGameState> {
    private(set) var gridNode: MasyuGridNode!
    
    func coloredRectSize() -> CGSize {
        let sz = gridNode.blockSize - 4
        return CGSize(width: sz, height: sz)
    }
    
    override func levelInitialized(_ game: AnyObject, state: MasyuGameState, skView: SKView) {
        let game = game as! MasyuGame
        removeAllChildren()
        let blockSize = CGFloat(skView.bounds.size.width) / CGFloat(game.cols)
        
        // add Grid
        let offset:CGFloat = 0.5
        scaleMode = .resizeFill
        gridNode = MasyuGridNode(blockSize: blockSize, rows: game.rows, cols: game.cols)
        gridNode.position = CGPoint(x: skView.frame.midX - blockSize * CGFloat(game.cols) / 2 - offset, y: skView.frame.midY + blockSize * CGFloat(game.rows) / 2 + offset)
        addChild(gridNode)
        gridNode.anchorPoint = CGPoint(x: 0, y: 1.0)
        
        // add Pearls
        for r in 0..<game.rows {
            for c in 0..<game.cols {
                let p = Position(r, c)
                let ch = game[r, c]
                guard ch != " " else {continue}
                let point = gridNode.gridPosition(p: p)
                let pearlNode = SKShapeNode(circleOfRadius: gridNode.blockSize / 2)
                pearlNode.position = point
                pearlNode.name = "pearl"
                pearlNode.strokeColor = SKColor.white
                pearlNode.fillColor = ch == "W" ? SKColor.white : SKColor.black
                pearlNode.glowWidth = 1.0
                gridNode.addChild(pearlNode)
            }
        }
    }
    
    override func levelUpdated(from stateFrom: MasyuGameState, to stateTo: MasyuGameState) {
        for row in 0..<stateFrom.rows {
            for col in 0..<stateFrom.cols {
                for dir in 1...2 {
                    let p = Position(row, col)
                    let point = gridNode.gridPosition(p: p)
                    let nodeNameSuffix = "-\(row)-\(col)-\(dir)"
                    let lineNodeName = "line" + nodeNameSuffix
                    func removeNode(withName: String) {
                        gridNode.enumerateChildNodes(withName: withName) { (node, pointer) in
                            node.removeFromParent()
                        }
                    }
                    func removeLine() { removeNode(withName: lineNodeName) }
                    func addLine() {
                        let pathToDraw = CGMutablePath()
                        let lineNode = SKShapeNode(path:pathToDraw)
                        lineNode.glowWidth = 8
                        switch dir {
                        case 1:
                            pathToDraw.move(to: CGPoint(x: point.x, y: point.y))
                            pathToDraw.addLine(to: CGPoint(x: point.x + gridNode.blockSize, y: point.y))
                        case 2:
                            pathToDraw.move(to: CGPoint(x: point.x, y: point.y))
                            pathToDraw.addLine(to: CGPoint(x: point.x, y: point.y - gridNode.blockSize))
                        default:
                            break
                        }
                        lineNode.path = pathToDraw
                        lineNode.strokeColor = SKColor.green
                        lineNode.name = lineNodeName
                        gridNode.addChild(lineNode)
                    }
                    let (o1, o2) = (stateFrom[p][dir], stateTo[p][dir])
                    guard o1 != o2 else {continue}
                    if o1 {removeLine()}
                    if o2 {addLine()}
                 }
            }
        }
    }
}