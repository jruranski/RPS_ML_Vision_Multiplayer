//
//  RoundDetail.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 06/07/2023.
//

import SwiftUI

struct RoundDetail: View {
    @ObservedObject var viewModel: GameViewModel
    var body: some View {
        VStack {
            
          
            
            VStack {
                
                Text("Round \(viewModel.game.rounds)")
                    .font(.system(.caption, design: .rounded, weight: .light))
                HStack {
                    VStack {
                        Text("YOU")
                            .font(.system(.caption, design: .rounded, weight: .heavy))
                            .foregroundColor(.blue)
                        Text(viewModel.game.playerScore.description)
                            .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                    }
                    
                    Spacer()
                    Text(":")
                        .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                    Spacer()
                    VStack {
                        Text("ENEMY")
                            .font(.system(.caption, design: .rounded, weight: .heavy))
                            .foregroundColor(.red)
                        Text(viewModel.game.enemyScore.description)
                            .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                        
                    }
                }
                
                
                Text("Best of \(viewModel.game.maxScore)")
                    .font(.system(.caption, design: .rounded, weight: .light))
            }
            
            
            .padding(.horizontal)
            .modifier(ButtonModifier(backgroundColor: viewModel.roundResult == .enemy ? .red : .blue, padding: 12, radius: 20, opacity: 0.14))
            .padding()
            
            
            
        }
       
    }
}

struct RoundDetail_Previews: PreviewProvider {
    static var previews: some View {
        RoundDetail(viewModel:  GameViewModel())
    }
}
