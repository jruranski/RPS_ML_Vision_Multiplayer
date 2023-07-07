//
//  OnlinePlayerRow.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 07/07/2023.
//

import SwiftUI

struct OnlinePlayerRow: View {
    var player: OpponentModel = OpponentModel()
    @State  var selected = false
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(player.name)
                    .font(.system(.body, design: .rounded, weight: .semibold))
                Text(player.id?.uuidString ?? "")
                    .font(.system(.caption2, design: .rounded, weight: .ultraLight))
            }
         Spacer()
            Button(action: {
                // invite player to the game
                withAnimation(.easeInOut) {
                    selected.toggle()
                }
            }) {
                Text("INVITE")
                    .font(.system(.caption, design: .rounded, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                
            }.buttonStyle(PlainButtonStyle())
                .modifier(ButtonModifier(backgroundColor: .blue ,opacity: selected ? 0.4 : 1))
                .scaleEffect(selected ? 1.1 : 1)
        }
    }
}

struct OnlinePlayerRow_Previews: PreviewProvider {
    static var previews: some View {
        OnlinePlayerRow()
    }
}
