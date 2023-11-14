//
//  SettingsView.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 08/07/2023.
//

import SwiftUI

struct SettingsView: View {
    @Binding var show: Bool

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(show: .constant(true))
    }
}
