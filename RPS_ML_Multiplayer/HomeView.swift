//
//  HomeView.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 07/07/2023.
//

import SwiftUI

struct HomeView: View {
    
    @State var onlinePlayers: [OpponentModel] = [OpponentModel(name: "Jacek", id: UUID(), move: .none), OpponentModel(name: "Wacek", id: UUID(), move: .none)]
    @State var showContentView: Bool = false
    
    var body: some View {
        VStack {
            
            Text("RPS")
                .font(.system(.title, design: .rounded, weight: .bold))
         
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(onlinePlayers, id: \.id) { player in
                        OnlinePlayerRow(player: player)
                    }
                }
            }
            .frame(height: 60 * 5)
            .padding()
            .background(Color(.systemBackground))
            .mask(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color(.systemGray6), lineWidth: 2))
            .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
            .padding()
            
            
            
            
            Button(action: {
             // invite players and start game
             
            }) {
                HStack {
                    Spacer()
                    Text("PLAY")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundColor(.white)
                    .padding()
                    Spacer()
            }
                .background(Color.blue)
                .mask(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(Color.blue.lighter() ?? .blue, lineWidth: 2).opacity(0.8).blendMode(.overlay))
                .padding()
                
            }
            
            Button(action: {
             // invite players and start game
                withAnimation(.easeInOut) {
                    self.showContentView.toggle()
                }
            }) {
                HStack {
                    Spacer()
                    Text("TEST")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundColor(.primary)
                    .padding()
                    Spacer()
            }
                .background(Color(.systemGray6))
                .mask(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(Color(.systemGray5), lineWidth: 2).opacity(0.8).blendMode(.overlay))
                .padding(.horizontal)
                
            }
            
        
            
            
        }
        .fullScreenCover(isPresented: $showContentView, onDismiss: {
            
        }) {
            ContentView(show: $showContentView)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

