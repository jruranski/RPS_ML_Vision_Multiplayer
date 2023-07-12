//
//  GameRow.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 11/07/2023.
//

import SwiftUI

struct GameRow: View {
    var game: GameModel = GameModel()
    
    var playTapped: (() -> Void)
    
    @State  var selected = false
    var body: some View {
        HStack {
         
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(game.opponent.name)
                        .font(.system(.body, design: .rounded, weight: .semibold))
                    if !game.finished {
                        Circle()
                            .frame(width: 8, height: 8, alignment: .center)
                            .foregroundColor(.green)
                            .padding( -2)
                    }
                }
                Text(game.gameID)
                    .font(.system(.caption2, design: .rounded, weight: .ultraLight))
            }
         Spacer()
            Button(action: {
                
                playTapped()
                // invite player to the game
                withAnimation(.easeInOut) {
                    selected.toggle()
                }
            }) {
                Text("JOIN")
                    .font(.system(.caption, design: .rounded, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                
            }.buttonStyle(PlainButtonStyle())
                .modifier(ButtonModifier(backgroundColor: .purple ,opacity: selected ? 0.4 : 1))
                .scaleEffect(selected ? 1.1 : 1)
        }
    }
}

struct GameRow_Previews: PreviewProvider {
    static var previews: some View {
        GameRow( playTapped: {})
    }
}
