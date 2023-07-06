//
//  ContentView.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 05/07/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var frameHandler = FrameHandler()
    @State private var cameraHidden = false
    var body: some View {
        ZStack {
         //   FrameView(image: frameHandler.frame)
           //     .ignoresSafeArea()
           
                
                
            GameOverlay(result: $frameHandler.result)
                .background(FrameView(cameraHidden: $cameraHidden, image: frameHandler.frame))
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
