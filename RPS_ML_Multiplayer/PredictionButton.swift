//
//  PredictionButton.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 05/07/2023.
//

import SwiftUI

struct PredictionButton: View {
    var label: String = "Rock"
    var emoji: String = "🪨"
    var body: some View {
        HStack {
            Text(emoji)
            Text(label)
        }.font(.body)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
            .modifier(ButtonModifier())
    }
}

struct PredictionButton_Previews: PreviewProvider {
    static var previews: some View {
        PredictionButton()
    }
}
