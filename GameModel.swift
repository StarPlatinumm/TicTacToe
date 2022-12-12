//
//  GameModel.swift
//  TicTacToe
//
//  Created by Артем Кривдин on 11.12.2022.
//

import Foundation

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}
