//
//  HolidayIslandGameState.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/19.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import Foundation

class HolidayIslandGameState: GridGameState {
    // http://stackoverflow.com/questions/24094158/overriding-superclass-property-with-different-type-in-swift
    var game: HolidayIslandGame {
        get {return getGame() as! HolidayIslandGame}
        set {setGame(game: newValue)}
    }
    var gameDocument: HolidayIslandDocument { return HolidayIslandDocument.sharedInstance }
    override func getGameDocument() -> GameDocumentBase! { return HolidayIslandDocument.sharedInstance }
    var objArray = [HolidayIslandObject]()
    
    override func copy() -> HolidayIslandGameState {
        let v = HolidayIslandGameState(game: game, isCopy: true)
        return setup(v: v)
    }
    func setup(v: HolidayIslandGameState) -> HolidayIslandGameState {
        _ = super.setup(v: v)
        v.objArray = objArray
        return v
    }
    
    required init(game: HolidayIslandGame, isCopy: Bool = false) {
        super.init(game: game)
        guard !isCopy else {return}
        objArray = Array<HolidayIslandObject>(repeating: .empty, count: rows * cols)
        for (p, n) in game.pos2hint {
            self[p] = .hint(tiles: n, state: .normal)
        }
        updateIsSolved()
    }
    
    subscript(p: Position) -> HolidayIslandObject {
        get {
            return self[p.row, p.col]
        }
        set(newValue) {
            self[p.row, p.col] = newValue
        }
    }
    subscript(row: Int, col: Int) -> HolidayIslandObject {
        get {
            return objArray[row * cols + col]
        }
        set(newValue) {
            objArray[row * cols + col] = newValue
        }
    }
    
    func setObject(move: inout HolidayIslandGameMove) -> Bool {
        let p = move.p
        guard isValid(p: p), game.pos2hint[p] == nil, String(describing: self[p]) != String(describing: move.obj) else {return false}
        self[p] = move.obj
        updateIsSolved()
        return true
    }
    
    func switchObject(move: inout HolidayIslandGameMove) -> Bool {
        let markerOption = MarkerOptions(rawValue: self.markerOption)
        func f(o: HolidayIslandObject) -> HolidayIslandObject {
            switch o {
            case .empty:
                return markerOption == .markerFirst ? .marker : .tree
            case .tree:
                return markerOption == .markerLast ? .marker : .empty
            case .marker:
                return markerOption == .markerFirst ? .tree : .empty
            default:
                return o
            }
        }
        let p = move.p
        guard isValid(p: p), game.pos2hint[p] == nil else {return false}
        move.obj = f(o: self[p])
        return setObject(move: &move)
    }
    
    /*
        iOS Game: Logic Games/Puzzle Set 11/Holiday Island

        Summary
        This time the campers won't have their way!

        Description
        1. This time the resort is an island, the place is packed and the campers
           (Tents) must compromise!
        2. The board represents an Island, where there are a few Tents, identified
           by the numbers.
        3. Your job is to find the water surrounding the island, with these rules:
        4. There is only one, continuous island.
        5. The numbers tell you how many tiles that camper can walk from his Tent,
           by moving horizontally or vertically. A camper can't cross water or
           other Tents.
    */
    private func updateIsSolved() {
        let allowedObjectsOnly = self.allowedObjectsOnly
        isSolved = true
        var g = Graph()
        var pos2node = [Position: Node]()
        var rngHints = [Position]()
        for r in 0..<rows {
            for c in 0..<cols {
                let p = Position(r, c)
                switch self[p] {
                case .forbidden:
                    self[p] = .empty
                case let .hint(tiles, _):
                    self[p] = .hint(tiles: tiles, state: .normal)
                    rngHints.append(p)
                default:
                    break
                }
                if case .tree = self[p] {continue}
                pos2node[p] = g.addNode(p.description)
            }
        }
        for (p, node) in pos2node {
            for os in HolidayIslandGame.offset {
                let p2 = p + os
                guard let node2 = pos2node[p2] else {continue}
                g.addEdge(node, neighbor: node2)
            }
        }
        do {
            let nodesExplored = breadthFirstSearch(g, source: pos2node.first!.value)
            if nodesExplored.count != pos2node.count {isSolved = false}
        }
        g = Graph()
        pos2node.removeAll()
        for r in 0..<rows {
            for c in 0..<cols {
                let p = Position(r, c)
                switch self[p] {
                case .tree, .hint:
                    break
                default:
                    pos2node[p] = g.addNode(p.description)
                }
            }
        }
        for (p, node) in pos2node {
            for os in HolidayIslandGame.offset {
                let p2 = p + os
                guard let node2 = pos2node[p2] else {continue}
                g.addEdge(node, neighbor: node2)
            }
        }
        var areas = [[Position]]()
        var pos2area = [Position: Int]()
        while !pos2node.isEmpty {
            let nodesExplored = breadthFirstSearch(g, source: pos2node.first!.value)
            let area = pos2node.filter({(p, _) in nodesExplored.contains(p.description)}).map{$0.0}
            pos2node = pos2node.filter({(p, _) in !nodesExplored.contains(p.description)})
            let n = areas.count
            for p in area {
                pos2area[p] = n
            }
            areas.append(area)
        }
        for p in rngHints {
            let n2 = game.pos2hint[p]!
            var rng = Set<Position>()
            for os in HolidayIslandGame.offset {
                let p2 = p + os
                guard let i = pos2area[p2] else {continue}
                rng = rng.union(areas[i])
            }
            let n1 = rng.count
            let s: HintState = n1 > n2 ? .normal : n1 == n2 ? .complete : .error
            self[p] = .hint(tiles: n2, state: s)
            if s != .complete {isSolved = false}
            if allowedObjectsOnly && n1 <= n2 {
                for p2 in rng {
                    self[p2] = .forbidden
                }
            }
        }
    }
}