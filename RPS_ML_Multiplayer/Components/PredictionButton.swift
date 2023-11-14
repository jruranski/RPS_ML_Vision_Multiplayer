//
//  PredictionButton.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 05/07/2023.
//

import SwiftUI

struct PredictionButton: View {
    @Binding var result: String
    var label: String = "Rock"
    var emoji: String = "🪨"
    var color = Color.blue
    var body: some View {
        Button(action: {
            
                withAnimation(.easeInOut) {
                    if color != .red {
                    self.result = label
                }
            }
        }) {
            HStack {
                Spacer()
                Text(emoji)
             
                Text(label)
                Spacer()
            }.font(.body)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .minimumScaleFactor(0.4)
            
                .lineLimit(1)
                .foregroundColor(label.lowercased() == result.lowercased() ? .white : .primary)
                .modifier(ButtonModifier(backgroundColor: label.lowercased() == result.lowercased() ? color : Color(.systemBackground)))
                .animation(.easeInOut(duration: 0.5), value: result)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct PredictionButton_Previews: PreviewProvider {
    static var previews: some View {
        PredictionButton(result: .constant(""))
    }
}
