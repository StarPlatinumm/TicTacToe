//
//  ContentView.swift
//  TicTacToe
//
//  Created by Артем Кривдин on 11.12.2022.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var vM = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                Text("Difficulty:")
                    .font(.system(size: geometry.size.width / 15))
                HStack(spacing: geometry.size.width / 10) {
                    DifficultyButton(vM: vM, proxy: geometry, title: "Easy")
                    DifficultyButton(vM: vM, proxy: geometry, title: "Normal")
                    DifficultyButton(vM: vM, proxy: geometry, title: "Hard")
                }
                Spacer()
                Text("Play as:")
                    .font(.system(size: geometry.size.width / 15))
                HStack {
                    ThemeButton(vM: vM, proxy: geometry, systemImageName: "flame")
                    ThemeButton(vM: vM, proxy: geometry, systemImageName: "drop")
                    ThemeButton(vM: vM, proxy: geometry, systemImageName: "leaf")
                    ThemeButton(vM: vM, proxy: geometry, systemImageName: "wind")
                }
                Spacer()
                HStack {
                    Spacer()
                    LazyVGrid(columns: vM.columns, spacing: 5) {
                        ForEach(0..<9) { i in
                            ZStack {
                                GameSquareView(proxy: geometry, color: vM.moves[i]?.color ?? Color.gray)
                                PlayerIndicator(proxy: geometry, systemImageName: vM.moves[i]?.indicator ?? "")
                            }
                            .onTapGesture {
                                vM.processPlayerMove(for: i)
                            }
                        }
                    }
                    Spacer()
                }
                Spacer()
                Button(action: { vM.resetGame() }) {
                    Text("Reset")
                        .foregroundColor(vM.themeColor1)
                        .font(.system(size: geometry.size.width / 15))
                        .padding()
                        .border(vM.themeColor1)
                }
            }
            .disabled(vM.isGameboardDisabled)
            .padding()
            .alert(item: $vM.alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: { vM.resetGame() }))
            })
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct GameSquareView: View {
    var proxy: GeometryProxy
    var color: Color
    var body: some View {
        Circle()
            .foregroundColor(color)
            .opacity(0.5)
    }
}

struct PlayerIndicator: View {
    var proxy: GeometryProxy
    var systemImageName: String
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: proxy.size.width/10, height: proxy.size.width/9)
            .foregroundColor(.white)
    }
}

struct ThemeButton: View {
    @StateObject var vM: GameViewModel
    
    var proxy: GeometryProxy
    var systemImageName: String
    var color: Color {
        return systemImageName == vM.humanIndicator ? vM.themeColor1 : .gray
    }
    var body : some View {
        Button(action: { vM.setHumanIndicator(to: systemImageName) }) {
            ZStack {
                Circle()
                    .strokeBorder(color,lineWidth: 4)
                    .foregroundColor(color)
                    .frame(width: proxy.size.width/7, height: proxy.size.width/7)
                Image(systemName: systemImageName)
                    .resizable()
                    .frame(width: proxy.size.width/12, height: proxy.size.width/12)
                    .foregroundColor(color)
            }
        }
    }
}

struct DifficultyButton: View {
    @StateObject var vM: GameViewModel
    var proxy: GeometryProxy
    var title: String
    var color: Color {
        return vM.difficultyStr == title ? vM.themeColor1 : .gray
    }
    var body: some View {
        Button(action: { vM.setDifficulty(to: title) }) {
            Text(title)
                .foregroundColor(color)
                .font(.system(size: proxy.size.width / 20))
                .padding()
                .border(color)
        }
    }
}
