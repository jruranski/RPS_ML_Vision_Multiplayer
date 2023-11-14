//
//  RPSButtons.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 06/07/2023.
//

import SwiftUI

struct RPSButtons: View {
    @Binding var result: String
    
    var color = Color.blue
    
    var body: some View {
      //  GeometryReader { geometry in
            HStack {
                Spacer()
                PredictionButton(result: $result, color: color)
                    //.frame(width: geometry.size.width / 3.4)
                PredictionButton(result: $result, label: "Paper", emoji: "📄", color: color)
                    //.frame(width: geometry.size.width / 3.4)
                PredictionButton(result: $result, label: "Scissors", emoji: "✂️", color: color)
                   // .frame(width: geometry.size.width / 3.4)
                Spacer()
            }
      //  }
    }
}

struct RPSButtons_Previews: PreviewProvider {
    static var previews: some View {
        RPSButtons(result: .constant("Paper"))
    }
}


struct RPSButtonsConst: View {
    let result: String
    
    var color = Color.blue
    
    var body: some View {
      //  GeometryReader { geometry in
            HStack {
                Spacer()
                PredictionButton(result: .constant(result), color: color)
                    //.frame(width: geometry.size.width / 3.4)
                PredictionButton(result: .constant(result), label: "Paper", emoji: "📄", color: color)
                    //.frame(width: geometry.size.width / 3.4)
                PredictionButton(result: .constant(result), label: "Scissors", emoji: "✂️", color: color)
                   // .frame(width: geometry.size.width / 3.4)
                Spacer()
            }
      //  }
    }
}
