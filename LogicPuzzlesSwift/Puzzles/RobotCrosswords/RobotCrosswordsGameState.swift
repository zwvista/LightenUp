//
//  RobotCrosswordsGameState.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/19.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import Foundation

class RobotCrosswordsGameState: GridGameState {
    // http://stackoverflow.com/questions/24094158/overriding-superclass-property-with-different-type-in-swift
    var game: RobotCrosswordsGame {
        get {return getGame() as! RobotCrosswordsGame}
        set {setGame(game: newValue)}
    }
    var gameDocument: RobotCrosswordsDocument { return RobotCrosswordsDocument.sharedInstance }
    override func getGameDocument() -> GameDocumentBase! { return RobotCrosswordsDocument.sharedInstance }
    var objArray = [Int]()
    var pos2horzState = [Position: HintState]()
    var pos2vertState = [Position: HintState]()

    override func copy() -> RobotCrosswordsGameState {
        let v = RobotCrosswordsGameState(game: game, isCopy: true)
        return setup(v: v)
    }
    func setup(v: RobotCrosswordsGameState) -> RobotCrosswordsGameState {
        _ = super.setup(v: v)
        v.objArray = objArray
        v.pos2horzState = pos2horzState
        v.pos2vertState = pos2vertState
        return v
    }
    
    required init(game: RobotCrosswordsGame, isCopy: Bool = false) {
        super.init(game: game)
        guard !isCopy else {return}
        objArray = Array<Int>(repeating: 0, count: rows * cols)
        for r in 0..<rows {
            for c in 0..<cols {
                self[r, c] = game[r, c]
            }
        }
        updateIsSolved()
    }
    
    subscript(p: Position) -> Int {
        get {
            return self[p.row, p.col]
        }
        set(newValue) {
            self[p.row, p.col] = newValue
        }
    }
    subscript(row: Int, col: Int) -> Int {
        get {
            return objArray[row * cols + col]
        }
        set(newValue) {
            objArray[row * cols + col] = newValue
        }
    }

    func setObject(move: inout RobotCrosswordsGameMove) -> Bool {
        let p = move.p
        guard isValid(p: p) && game[p] == 0 && self[p] != move.obj else {return false}
        self[p] = move.obj
        updateIsSolved()
        return true
    }
    
    func switchObject(move: inout RobotCrosswordsGameMove) -> Bool {
        let p = move.p
        guard isValid(p: p) && game[p] == 0 else {return false}
        let o = self[p]
        move.obj = (o + 1) % 10
        return setObject(move: &move)
    }
    
    /*
        iOS Game: Logic Games/Puzzle Set 13/RobotCrosswords

        Summary
        BZZZZliip 4 across?

        Description
        1. In a possible crossword for Robots, letters are substituted with digits.
        2. Each 'word' is formed by an uninterrupted sequence of numbers (i.e.
           2-3-4-5), but in any order (i.e. 3-4-2-5).
    */
    private func updateIsSolved() {
        isSolved = true
        for i in 0..<game.areas.count {
            let a = game.areas[i]
            let nums = a.map({self[$0]})
            let count = nums.count
            let nums2 = Set<Int>(nums).sorted()
            let s: HintState = nums2.first! == 0 ? .normal : nums2.count == count ? .complete : .error
            for p in a {
                if i < game.horzAreaCount {
                    pos2horzState[p] = s
                } else {
                    pos2vertState[p] = s
                }
            }
            if s != .complete {isSolved = false}
        }
    }
}
