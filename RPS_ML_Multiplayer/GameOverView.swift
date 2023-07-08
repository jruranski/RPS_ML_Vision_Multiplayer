//
//  GameOverView.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 08/07/2023.
//

import SwiftUI

struct GameOverView: View {
    @Binding var show: Bool
    @ObservedObject var viewModel = GameViewModel()
    


    var body: some View {
        VStack {
        
        Text("Game Over")
        .font(.system(.largeTitle, design: .rounded, weight: .bold))
        .foregroundColor(.primary)
        VStack {

            Text(viewModel.endRoundTitle)
                        .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                        
                    
            Image(systemName: viewModel.endRoundImageName)
                        .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                        .scaleEffect(2)
                        .foregroundStyle(viewModel.roundResult == .enemy ? .red : .blue)
                        .padding()



            RoundDetail(viewModel: viewModel)



        }


        Spacer()

        Button(action: {
                    
                   
                }) {
                    HStack {
                        Spacer()
                        Text(viewModel.isGameOver ? "Next Round" : "Confirm")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .foregroundColor(.white)
                        .padding()
                        Spacer()
                }
                    .background((viewModel.roundResult == .enemy ? Color.red : Color.blue))
                    .mask(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke((viewModel.roundResult == .enemy ? Color.red : Color.blue).lighter() ?? .blue, lineWidth: 2).opacity(0.8).blendMode(.overlay))
                    .padding()
                    
                }


        }
        .padding()
        .background(BlurView(style: .systemUltraThinMaterial))
        .opacity(show ? 1 : 0)

        .animation(.easeIn.delay(2), value: show)



    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(show: .constant(true))
    }
}
