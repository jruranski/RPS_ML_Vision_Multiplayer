//
//  ContentView.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 05/07/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var frameHandler = FrameHandler()
    @StateObject private var viewModel = GameViewModel()
    @State private var cameraHidden = false
    
    @Binding var show: Bool
    var body: some View {
        ZStack {
         //   FrameView(image: frameHandler.frame)
           //     .ignoresSafeArea()
           
                
                
            GameOverlay(show: $show, viewModel: viewModel, result: viewModel.isGameOver ? .constant(frameHandler.result) : $frameHandler.result, shouldStopCamera: $frameHandler.shouldStopCamera)
                .opacity(show ? 1 : 0)
                .transition(.move(edge: .bottom))
                .animation(.easeInOut.delay(1), value: show)
                .background(
                    
                    FrameView(cameraHidden: $frameHandler.shouldStopCamera, image: frameHandler.frame)
                        .opacity(show ? 1 : 0)
                        .animation(.easeInOut, value: show)
                )
                .onDisappear {
                    self.frameHandler.stopCapture()
                }
                
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(show: .constant(true))
    }
}
