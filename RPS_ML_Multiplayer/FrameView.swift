//
//  FrameView.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 05/07/2023.
//

import SwiftUI

struct FrameView: View {
    @Binding var cameraHidden: Bool
    var image: CGImage?
    private let label = Text("frame")
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(image, scale: 1.0, orientation: .up, label: label)
            }else{
                Image("camera_loading")
                    .resizable()
                    .scaledToFill()
            }
            
            BlurView(style: .systemUltraThinMaterial)
                .opacity(cameraHidden ? 1 : 0)
        }
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView(cameraHidden: .constant(false))
    }
}
