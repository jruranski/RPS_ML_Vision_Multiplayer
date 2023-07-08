//
//  ProfileView.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 08/07/2023.
//

import SwiftUI

struct ProfileView: View {
    @Binding var show: Bool
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(show: .constant(false))
    }
}
