//
//  GameModel.swift
//  TicTacToe
//
//  Created by Артем Кривдин on 11.12.2022.
//

import Foundation
import SwiftUI

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    var indicator: String
    
    var color: Color {
        switch indicator {
        case "flame":
            return Color.red
        case "drop":
            return Color.blue
        case "leaf":
            return Color.green
        case "wind":
            return Color.yellow
        default:
            return Color.gray
        }
    }
}
