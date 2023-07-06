//
//  GameOverlay.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 05/07/2023.
//

import SwiftUI

struct GameOverlay: View {
    @Binding var result: String
    
    
    var body: some View {
        VStack {
            HStack {
                
                Image(systemName: "xmark")
                    .modifier(BlurButtonModifier())
                Spacer()
                Text("1/3")
                    .modifier(BlurButtonModifier())
            }.padding(.top, 60)
                .padding(.horizontal)
            
            Spacer()
            
            VStack {
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 40, height: 4, alignment: .center)
                    .opacity(0.4)
                    .padding()
                Text(result)
                    .hidden()
                
                HStack {
                    Spacer()
                    PredictionButton(result: $result)
                    PredictionButton(result: $result, label: "Paper", emoji: "📄")
                    PredictionButton(result: $result, label: "Scissors", emoji: "✂️")
                    Spacer()
                }
                
                Button(action: {
                    
                    
                }) {
                    HStack {
                        Spacer()
                    Text("Confirm")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .foregroundColor(.white)
                        .padding()
                        Spacer()
                }
                    .background(result != "" ? Color.blue.opacity(0.9) : Color(.systemGray6).opacity(0.6))
                    .mask(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(Color.blue.lighter() ?? .blue, lineWidth: 2).opacity(0.8).blendMode(.overlay))
                    .padding()
                    
                }
                
                
            }
            .padding(.bottom, 40)
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(12)
        }.ignoresSafeArea(.all)
    }
}

struct GameOverlay_Previews: PreviewProvider {
    static var previews: some View {
        GameOverlay(result: .constant("None"))
    }
}
