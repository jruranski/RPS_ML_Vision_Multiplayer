//
//  GameOverlay.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 05/07/2023.
//

import SwiftUI

struct GameOverlay: View {
    @StateObject private var frameHandler: FrameHandler = FrameHandler()
    
    var body: some View {
        VStack {
            HStack {
                PredictionButton()
                PredictionButton(label: "Paper", emoji: "📄")
                PredictionButton(label: "Scissors", emoji: "✂️")
                
            }
        }
    }
}

struct GameOverlay_Previews: PreviewProvider {
    static var previews: some View {
        GameOverlay()
    }
}
