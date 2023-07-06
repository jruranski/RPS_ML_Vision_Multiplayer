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
    
    var body: some View {
        Button(action: {
            
            withAnimation(.easeInOut) {
                self.result = label
            }
            
        }) {
            HStack {
                Text(emoji)
                Text(label)
            }.font(.body)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .foregroundColor(label.lowercased() == result.lowercased() ? .white : .primary)
                .modifier(ButtonModifier(backgroundColor: label.lowercased() == result.lowercased() ? .blue : Color(.systemBackground)))
                .animation(.easeInOut(duration: 0.5), value: result)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct PredictionButton_Previews: PreviewProvider {
    static var previews: some View {
        PredictionButton(result: .constant(""))
    }
}
