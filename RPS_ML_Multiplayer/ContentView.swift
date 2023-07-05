//
//  ContentView.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 05/07/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var frameHandler = FrameHandler()
    
    var body: some View {
        ZStack {
            FrameView(image: frameHandler.frame)
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                
                Text(frameHandler.result)
                    .padding()
//                    .buttonModifier()
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
