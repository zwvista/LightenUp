//
//  SlitherLinkGameState.swift
//  LogicGamesSwift
//
//  Created by 趙偉 on 2016/09/19.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import Foundation

struct SlitherLinkGameState {
    let game: SlitherLinkGame
    var size: Position { return game.size }
    var rows: Int { return size.row }
    var cols: Int { return size.col }    
    func isValid(p: Position) -> Bool {
        return game.isValid(p: p)
    }
    func isValid(row: Int, col: Int) -> Bool {
        return game.isValid(row: row, col: col)
    }
    var objArray = [SlitherLinkDotObject]()
    var pos2state = [Position: SlitherLinkHintState]()
    var options: SlitherLinkGameProgress { return SlitherLinkDocument.sharedInstance.gameProgress }
    
    init(game: SlitherLinkGame) {
        self.game = game
        objArray = Array<SlitherLinkDotObject>(repeating: Array<SlitherLinkObject>(repeating: .empty, count: 4), count: rows * cols)
    }
    
    subscript(p: Position) -> SlitherLinkDotObject {
        get {
            return objArray[p.row * cols + p.col]
        }
        set(newValue) {
            self[p.row, p.col] = newValue
        }
    }
    subscript(row: Int, col: Int) -> SlitherLinkDotObject {
        get {
            return objArray[row * cols + col]
        }
        set(newValue) {
            objArray[row * cols + col] = newValue
        }
    }
    
    mutating func setObject(move: inout SlitherLinkGameMove) -> Bool {
        var changed = false
        func f(o1: inout SlitherLinkObject, o2: inout SlitherLinkObject) {
            if o1 != move.obj {
                changed = true
                o1 = move.obj
                o2 = move.obj
                // updateIsSolved() cannot be called here
                // self[p] will not be updated until the function returns
            }
        }
        let p = move.p
        switch move.objOrientation {
        case .horizontal:
            f(o1: &self[p][1], o2: &self[p + SlitherLinkGame.offset[1]][3])
            if changed {updateIsSolved()}
        case .vertical:
            f(o1: &self[p][2], o2: &self[p + SlitherLinkGame.offset[2]][0])
            if changed {updateIsSolved()}
        }
        return changed
    }
    
    mutating func switchObject(move: inout SlitherLinkGameMove) -> Bool {
        let markerOption = SlitherLinkMarkerOptions(rawValue: options.markerOption)
        func f(o: SlitherLinkObject) -> SlitherLinkObject {
            switch o {
            case .empty:
                return markerOption == .markerBeforeLine ? .marker : .line
            case .line:
                return markerOption == .markerAfterLine ? .marker : .empty
            case .marker:
                return markerOption == .markerBeforeLine ? .line : .empty
            }
        }
        let p = move.p
        let o = f(o: self[p][move.objOrientation == .horizontal ? 1 : 2])
        move.obj = o
        return setObject(move: &move)
    }
    
    private(set) var isSolved = false
    
    private mutating func updateIsSolved() {
        isSolved = true
        for (p, n2) in game.pos2hint {
            var n1 = 0
            if self[p][1] == .line {n1 += 1}
            if self[p][2] == .line {n1 += 1}
            if self[p + Position(1, 1)][0] == .line {n1 += 1}
            if self[p + Position(1, 1)][3] == .line {n1 += 1}
            pos2state[p] = n1 < n2 ? .normal : n1 == n2 ? .complete : .error
            if n1 != n2 {isSolved = false}
        }
        guard isSolved else {return}
        let tree = Graph()
        var pos2node = [Position: Node]()
        for r in 0 ..< rows {
            for c in 0 ..< cols {
                let p = Position(r, c)
                let n = self[p].filter({$0 == .line}).count
                switch n {
                case 0:
                    continue
                case 2:
                    pos2node[p] = tree.addNode(label: p.description)
                default:
                    isSolved = false
                    return
                }
            }
        }
        for (p, _) in pos2node {
            let ots = self[p]
            for i in 0 ..< 4 {
                guard ots[i] == .line else {continue}
                let p2 = p + SlitherLinkGame.offset[i]
                tree.addEdge(source: pos2node[p]!, neighbor: pos2node[p2]!)
            }
        }
        let nodesExplored = breadthFirstSearch(tree, source: pos2node.values.first!)
        let n1 = nodesExplored.count
        let n2 = pos2node.values.count
        if n1 != n2 {isSolved = false}
    }
}
