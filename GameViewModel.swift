//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Артем Кривдин on 11.12.2022.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible(maximum: 140)),
                               GridItem(.flexible(maximum: 140)),
                               GridItem(.flexible(maximum: 140))]
    
    @Published var difficulty: Int = 1
    @Published var difficultyStr: String = "Normal"
    @Published var humanIndicator: String = "flame"
    @Published var computerIndicator: String = "drop"
    @Published var themeColor1: Color = .red
    @Published var themeColor2: Color = .blue
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    
    
    func processPlayerMove(for position: Int) {
        
        // human move processing
        if isSquareOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human, boardIndex: position, indicator: humanIndicator)
        
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        isGameboardDisabled = true
        
        // computer move processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition, indicator: computerIndicator)
            isGameboardDisabled = false
            
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWin
                return
            }
            
            if checkForDraw(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6],
                                          [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        if difficulty > 0 {
            // If AI can win, then win
            let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
            let computerPositions = Set(computerMoves.map { $0.boardIndex })
            for pattern in winPatterns {
                let  winPositions = pattern.subtracting(computerPositions)
                if winPositions.count == 1 {
                    let isAvalible = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                    if isAvalible { return winPositions.first! }
                }
            }
        }
        if difficulty == 2 {
            // If AI can't win, then block
            let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
            let humanPositions = Set(humanMoves.map { $0.boardIndex })
            for pattern in winPatterns {
                let  winPositions = pattern.subtracting(humanPositions)
                if winPositions.count == 1 {
                    let isAvalible = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                    if isAvalible { return winPositions.first! }
                }
            }
            // If AI can't block, then take the middle square
            let centerSquare = 4
            if !isSquareOccupied(in: moves, forIndex: centerSquare) { return centerSquare }
        }
        // If AI can't take the middle square, then random avalible square
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6],
                                          [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func setDifficulty(to difficultyName: String) {
        switch difficultyName {
        case "Easy":
            difficulty = 0
        case "Normal":
            difficulty = 1
        default:
            difficulty = 2
        }
        difficultyStr = difficultyName
    }
    
    func setHumanIndicator(to indicator: String) {
        switch indicator {
        case "flame":
            humanIndicator = "flame"
            computerIndicator = "drop"
            themeColor1 = Color.red
            themeColor2 = Color.blue
        case "drop":
            humanIndicator = "drop"
            computerIndicator = "flame"
            themeColor1 = Color.blue
            themeColor2 = Color.red
        case "leaf":
            humanIndicator = "leaf"
            computerIndicator = "wind"
            themeColor1 = Color.green
            themeColor2 = Color.yellow
        case "wind":
            humanIndicator = "wind"
            computerIndicator = "leaf"
            themeColor1 = Color.yellow
            themeColor2 = Color.green
        default:
            humanIndicator = "xmark"
            computerIndicator = "circle"
            themeColor1 = Color.gray
            themeColor2 = Color.gray
        }
        for move in moves.compactMap({ $0 }){
            moves[move.boardIndex] = Move(player: move.player,
                                          boardIndex: move.boardIndex,
                                          indicator: move.player == .human ? humanIndicator : computerIndicator)
        }
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
