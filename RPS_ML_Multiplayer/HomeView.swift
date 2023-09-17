//
//  HomeView.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 07/07/2023.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var serverManager: ServerManager = ServerManager()
    
    @State var onlinePlayers: [Opponent] = [Opponent(name: "Jacek", id: UUID().uuidString, move: .none), Opponent(name: "Wacek", id: UUID().uuidString, move: .none)]
    @State var showContentView: Bool = false
   @State var showProfileView: Bool = false
   @State var showSettingsView: Bool = false
    @State private var signedIn: Bool = false

    @State private var gameVM: GameViewModel? = nil
    @State private var appeared = false
    @State var selectedPlayer: Opponent? = nil
    @State var selectedGame: GameModel? = nil
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("RPS")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    Text(serverManager.getCurrentUser()?.uid ?? "")
                        .font(.system(.body, design: .rounded, weight: .light))
                }
            
         Spacer()
        Image(systemName: "person") // Sign In button
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .onTapGesture {
                    
                    //connect to auth
                    
                    
                    withAnimation(.easeInOut) {
                        self.showProfileView.toggle()
                    }
                }
                .padding()
               
                .fullScreenCover(isPresented: $showProfileView) {
                    if serverManager.isSignedIn() {
                    ProfileView(show: $showProfileView, serverManager: serverManager)
                    }else { 
                        SignUpView(show: $showProfileView, serverManager: serverManager)
                    }
                }
            
            Image(systemName: "gear")
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.showSettingsView.toggle()
                    }
                }
                .fullScreenCover(isPresented: $showSettingsView) {
                    SettingsView(show: $showSettingsView)
                }



            }
            .padding()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(serverManager.onlinePlayers, id: \.id) { player in
                        OnlinePlayerRow(player: player) {
                            // start new game with that player
                            print("OnlinePlayerRow closure triggered with player \(String(describing: player.id))")
                            selectedPlayer = player
                            gameVM =  GameViewModel(serverManager: serverManager, opponent: player)
                            // present game screen
                            withAnimation(.easeInOut) {
                                self.showContentView = true
                            }
                        }
                    }
                    if serverManager.onlinePlayers.isEmpty {
                        HStack {
                            Spacer()
                            Text("No online players!")
                                .font(.system(.body, design: .rounded, weight: .medium))
                            Spacer()
                        }
                    }
                }.padding()
            }
            .refreshable {
                serverManager.refreshOnlinePlayers()
            }
            .frame(height: 50 * 5)
            
            .background(Color(.systemBackground))
            .mask(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color(.systemGray6), lineWidth: 2))
            .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
            .padding()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(serverManager.invitedGames, id: \.gameID) { game in
                        GameRow(game: game) {
                            // join an existing game
                            selectedGame = game
                            gameVM = GameViewModel(serverManager: serverManager, game: game)
                            self.showContentView = true
                        }
                    }
                    if serverManager.invitedGames.isEmpty {
                        HStack {
                            Spacer()
                            Text("No game invites...")
                                .font(.system(.body, design: .rounded, weight: .medium))
                            Spacer()
                        }
                    }
                }.padding()
            }
            .frame(height: 50 * 5)
            .refreshable {
                self.serverManager.refreshOnlineGames()
            }
            .background(Color(.systemBackground))
            .mask(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color(.systemGray6), lineWidth: 2))
            .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
            .padding()
           
            Spacer()
            
//            Button(action: {
//             // invite players and start game
//
//            }) {
//                HStack {
//                    Spacer()
//                    Text("START PARTY")
//                    .font(.subheadline)
//                    .fontWeight(.bold)
//                    .fontDesign(.rounded)
//                    .foregroundColor(.white)
//                    .padding()
//                    Spacer()
//            }
//                .background(Color.blue)
//                .mask(RoundedRectangle(cornerRadius: 24, style: .continuous))
//                .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(Color.blue.lighter() ?? .blue, lineWidth: 2).opacity(0.8).blendMode(.overlay))
//                .padding()
//
//            }
//
//            Button(action: {
//             // invite players and start game
//
//            }) {
//                HStack {
//                    Spacer()
//                    Text("JOIN")
//                    .font(.subheadline)
//                    .fontWeight(.bold)
//                    .fontDesign(.rounded)
//                    .foregroundColor(.white)
//                    .padding()
//                    Spacer()
//            }
//                .background(Color.blue)
//                .mask(RoundedRectangle(cornerRadius: 24, style: .continuous))
//                .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(Color.blue.lighter() ?? .blue, lineWidth: 2).opacity(0.8).blendMode(.overlay))
//                .padding()
//
//            }
//
            
//            Button(action: {
//             // invite players and start game
//                withAnimation(.easeInOut) {
//                    self.showContentView.toggle()
//                }
//            }) {
//                HStack {
//                    Spacer()
//                    Text("TEST")
//                    .font(.subheadline)
//                    .fontWeight(.bold)
//                    .fontDesign(.rounded)
//                    .foregroundColor(.primary)
//                    .padding()
//                    Spacer()
//            }
//                .background(Color(.systemGray6))
//                .mask(RoundedRectangle(cornerRadius: 24, style: .continuous))
//                .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(Color(.systemGray5), lineWidth: 2).opacity(0.8).blendMode(.overlay))
//                .padding(.horizontal)
//
//            }
            
        
            
            
        }
        .fullScreenCover(isPresented: $showContentView, onDismiss: {
            showContentView = false
            gameVM = nil
            appeared.toggle()
        }) {
           ContentView(viewModel: gameVM ?? GameViewModel(), show: $showContentView)
        }
        .onAppear {
            serverManager.refreshOnlinePlayers()
            serverManager.refreshOnlineGames()
            appeared.toggle()
        }

        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active:
                print("app is active")
                serverManager.setOnlineStatus(isOnline: true)
            case .inactive:
                serverManager.setOnlineStatus(isOnline: false)
            default:
                print("unknown state")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

enum SignedInState {
    case signedIn
    case signedOut
}
