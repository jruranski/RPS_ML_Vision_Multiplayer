//
//  GameOverlay.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 05/07/2023.
//

import SwiftUI

struct GameOverlay: View {
    @Binding var show: Bool
    @ObservedObject var viewModel: GameViewModel
    
    @Binding var result: String
    @Binding var shouldStopCamera: Bool

    

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.show.toggle()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(.body, design: .rounded, weight: .bold))
                        .modifier(BlurButtonModifier())
                }.buttonStyle(PlainButtonStyle())
                Spacer()
                Text(viewModel.gameStateDescription)
                    .font(.system(.body, design: .rounded, weight: .bold))
                    
                    .padding(.horizontal)
                    .modifier(BlurButtonModifier(radius: 18))
                Spacer()
                Text(viewModel.timerText)
                    .font(.system(.body, design: .rounded, weight: .bold))
                    .monospacedDigit()
                    .modifier(BlurButtonModifier())
                    
            }
            .foregroundColor(.secondary)
            
            .padding(.top, 60)
                .padding(.horizontal)
                .opacity(show ? 1 : 0)
                .animation(.easeIn.delay(2), value: show)
            
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 1)) {
                        self.shouldStopCamera.toggle()
                    }
                }) {
                    Image(systemName: shouldStopCamera ? "camera" : "camera.fill")
                        .foregroundColor(.blue)
                        .modifier(BlurButtonModifier())
                }.buttonStyle(PlainButtonStyle())
            }.padding()
            VStack {
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 40, height: 4, alignment: .center)
                    .opacity(0.4)
                    .padding()
                Text(result)
                    .hidden()
                if !viewModel.isGameOver {
                    VStack(alignment: .leading) {
                        Text("YOUR MOVE:")
                            .font(.system(.caption, design: .rounded, weight: .light))
                            .padding(.horizontal)
                        RPSButtons(result: $result)
                    }
                    
                }
                
           
                
                // Displays after the round is over
                if viewModel.isGameOver {
                 
                    Text(viewModel.endRoundTitle)
                        .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                        
                    
                    Image(systemName: viewModel.endRoundImageName)
                        .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                        .scaleEffect(2)
                        .foregroundStyle(viewModel.roundResult == .enemy ? .red : .blue)
                        .padding()
                    
                    
                    // Enemy pick
                    
                    
                 
                    
                    
                    
                    VStack(alignment: .leading) {
                        Text("PICKED MOVE:")
                            .font(.system(.caption, design: .rounded, weight: .light))
                            .padding(.horizontal)
                         
                        RPSButtonsConst(result: result)
                            
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text("ENEMY MOVE:")
                            .font(.system(.caption, design: .rounded, weight: .light))
                            .padding(.horizontal)
                        RPSButtons(result: $viewModel.enemyMoveString, color: .red)
                            
                    }
                    .padding(.vertical)
                    
                    VStack {
                        
                        RoundDetail(viewModel: viewModel)
                    }
                    .opacity(viewModel.isGameOver ? 1 : 0)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 1).delay(0.8), value: viewModel.isGameOver)
                    
                    
                }
                
                
                
                Button(action: {
                    
                    if viewModel.isGameOver
                    {
                        
                        
                        viewModel.nextRound()
                        
                        result = ""
                    }else{
                        viewModel.fetchEnemyMove()
                        viewModel.resolveRound(playerMove: Move(rawValue: result) ?? .none)
                    }
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
                    .background(result != "" ? (viewModel.roundResult == .enemy ? Color.red : Color.blue) : Color(.systemGray6).opacity(0.6))
                    .mask(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke((viewModel.roundResult == .enemy ? Color.red : Color.blue).lighter() ?? .blue, lineWidth: 2).opacity(0.8).blendMode(.overlay))
                    .padding()
                    
                }
                
                
            }
            .padding(.bottom, 40)
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(12)
        }.ignoresSafeArea(.all)
            .onChange(of: viewModel.isGameOver) { newValue in
                shouldStopCamera = newValue
            }
            .onChange(of: viewModel.gameFinished) { newValue in
                
                // #todo display the game over screen first!
                
                withAnimation(.easeInOut) {
                    self.show = false
                }
            }
    }
}

struct GameOverlay_Previews: PreviewProvider {
    static var previews: some View {
        GameOverlay(show: .constant(true), viewModel: GameViewModel(), result: .constant("None"), shouldStopCamera: .constant(false))
    }
}
