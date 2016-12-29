//
//  BoxItAroundGameScene.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/09.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import SpriteKit

class BoxItAroundGameScene: GameScene<BoxItAroundGameState> {
    var gridNode: BoxItAroundGridNode {
        get {return getGridNode() as! BoxItAroundGridNode}
        set {setGridNode(gridNode: newValue)}
    }
    
    func addHintNumber(n: Int, s: HintState, point: CGPoint, nodeName: String) {
        addLabel(text: String(n), fontColor: s == .normal ? .white : s == .complete ? .green : .red, point: point, nodeName: nodeName)
    }
    
    override func levelInitialized(_ game: AnyObject, state: BoxItAroundGameState, skView: SKView) {
        let game = game as! BoxItAroundGame
        removeAllChildren()
        let blockSize = CGFloat(skView.bounds.size.width) / CGFloat(game.cols - 1)
        
        // addGrid
        let offset:CGFloat = 0.5
        addGrid(gridNode: BoxItAroundGridNode(blockSize: blockSize, rows: game.rows - 1, cols: game.cols - 1), point: CGPoint(x: skView.frame.midX - blockSize * CGFloat(game.cols - 1) / 2 - offset, y: skView.frame.midY + blockSize * CGFloat(game.rows - 1) / 2 + offset))
        
        // addHints
        for (p, n) in game.pos2hint {
            let point = gridNode.gridPosition(p: p)
            let nodeNameSuffix = "-\(p.row)-\(p.col)"
            let hintNumberNodeName = "hintNumber" + nodeNameSuffix
            addHintNumber(n: n, s: state.pos2state[p]!, point: point, nodeName: hintNumberNodeName)
        }
    }
    
    override func levelUpdated(from stateFrom: BoxItAroundGameState, to stateTo: BoxItAroundGameState) {
        let markerOffset: CGFloat = 7.5
        for r in 0..<stateFrom.rows {
            for c in 0..<stateFrom.cols {
                let p = Position(r, c)
                let point = gridNode.gridPosition(p: p)
                let nodeNameSuffix = "-\(r)-\(c)"
                let horzLineNodeName = "horzLine" + nodeNameSuffix
                let vertlineNodeName = "vertline" + nodeNameSuffix
                let hintNumberNodeName = "hintNumber" + nodeNameSuffix
                func removeHintNumber() { removeNode(withName: hintNumberNodeName) }
                func addHorzLine(objType: BoxItAroundObject) {
                    guard objType != .empty else {return}
                    let pathToDraw = CGMutablePath()
                    let lineNode = SKShapeNode(path:pathToDraw)
                    switch objType {
                    case .line:
                        pathToDraw.move(to: CGPoint(x: point.x - gridNode.blockSize / 2, y: point.y + gridNode.blockSize / 2))
                        pathToDraw.addLine(to: CGPoint(x: point.x + gridNode.blockSize / 2, y: point.y + gridNode.blockSize / 2))
                        lineNode.glowWidth = 8
                    case .marker:
                        pathToDraw.move(to: CGPoint(x: point.x - markerOffset, y: point.y + gridNode.blockSize / 2 + markerOffset))
                        pathToDraw.addLine(to: CGPoint(x: point.x + markerOffset, y: point.y + gridNode.blockSize / 2 - markerOffset))
                        pathToDraw.move(to: CGPoint(x: point.x + markerOffset, y: point.y + gridNode.blockSize / 2 + markerOffset))
                        pathToDraw.addLine(to: CGPoint(x: point.x - markerOffset, y: point.y + gridNode.blockSize / 2 - markerOffset))
                        lineNode.glowWidth = 2
                    default:
                        break
                    }
                    lineNode.path = pathToDraw
                    lineNode.strokeColor = .yellow
                    lineNode.name = horzLineNodeName
                    gridNode.addChild(lineNode)
                }
                func removeHorzLine(objType: BoxItAroundObject) {
                    if objType != .empty { removeNode(withName: horzLineNodeName) }
                }
                func addVertLine(objType: BoxItAroundObject) {
                    guard objType != .empty else {return}
                    let pathToDraw = CGMutablePath()
                    let lineNode = SKShapeNode(path:pathToDraw)
                    switch objType {
                    case .line:
                        pathToDraw.move(to: CGPoint(x: point.x - gridNode.blockSize / 2, y: point.y + gridNode.blockSize / 2))
                        pathToDraw.addLine(to: CGPoint(x: point.x - gridNode.blockSize / 2, y: point.y - gridNode.blockSize / 2))
                        lineNode.glowWidth = 8
                    case .marker:
                        pathToDraw.move(to: CGPoint(x: point.x - gridNode.blockSize / 2 - markerOffset, y: point.y + markerOffset))
                        pathToDraw.addLine(to: CGPoint(x: point.x - gridNode.blockSize / 2 + markerOffset, y: point.y - markerOffset))
                        pathToDraw.move(to: CGPoint(x: point.x - gridNode.blockSize / 2 - markerOffset, y: point.y - markerOffset))
                        pathToDraw.addLine(to: CGPoint(x: point.x - gridNode.blockSize / 2 + markerOffset, y: point.y + markerOffset))
                        lineNode.glowWidth = 2
                    default:
                        break
                    }
                    lineNode.path = pathToDraw
                    lineNode.strokeColor = .yellow
                    lineNode.name = vertlineNodeName
                    gridNode.addChild(lineNode)
                }
                func removeVertLine(objType: BoxItAroundObject) {
                    if objType != .empty { removeNode(withName: vertlineNodeName) }
                }
                var (o1, o2) = (stateFrom[p][1], stateTo[p][1])
                if o1 != o2 {
                    removeHorzLine(objType: o1)
                    addHorzLine(objType: o2)
                }
                (o1, o2) = (stateFrom[p][2], stateTo[p][2])
                if o1 != o2 {
                    removeVertLine(objType: o1)
                    addVertLine(objType: o2)
                }
                guard let s1 = stateFrom.pos2state[p], let s2 = stateTo.pos2state[p] else {continue}
                if s1 != s2 {
                    removeHintNumber()
                    addHintNumber(n: stateFrom.game.pos2hint[p]!, s: s2, point: point, nodeName: hintNumberNodeName)
                }
            }
        }
    }
}