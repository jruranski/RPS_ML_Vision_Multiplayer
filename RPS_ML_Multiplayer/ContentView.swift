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
                .background(FrameView(cameraHidden: $frameHandler.shouldStopCamera, image: frameHandler.frame))
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(show: .constant(true))
    }
}
