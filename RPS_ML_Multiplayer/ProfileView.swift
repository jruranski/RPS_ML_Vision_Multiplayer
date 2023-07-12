//
//  ProfileView.swift
//  SwiftUI Advanced
//
//  Created by Jakub Ruranski on 27/10/2021.
//

import SwiftUI
import FirebaseAuth
struct ProfileView: View {
    
    @Binding var show: Bool
    @StateObject var serverManager: ServerManager = ServerManager()
    
    @Environment(\.presentationMode) var presentationMode
    
    
    @State private var showSettingsView = false
    
    @AppStorage("userDisplayName") var name: String = ""

    @State private var currentAccount: Account? = Account()
    @State private var updater: Bool = false
    var body: some View {
        ZStack {
            Image("background-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    TextfieldIcon(iconName: "xmark", currentlyEditing: .constant(false), passedImage: .constant(nil))
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                self.show.toggle()
                            }
                            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true)
                        }
                    Spacer()
                }.padding()
                    .padding(.top)
                Spacer()
                
                VStack {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 16) {
                            
                            if let image = currentAccount?.profileImage  {
                                GradientProfilePictureView(profilePicture: image)
                                    .frame(width: 66, height: 66, alignment: .center)
                            }else{
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color("pink-gradient-1"))
                                        .frame(width: 66, height: 66, alignment: .center)
                                    
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24, weight: .medium, design: .rounded))
                                }
                                .frame(width: 66, height: 66, alignment: .center)
                            }
                            
                            
                            
                            VStack(alignment: .leading) {
                                TextField("Your name", text: $name, onCommit: {
                                    serverManager.saveUserDisplayName(name: name)
                                })
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .bold()
                                Text("View profile")
                                    .foregroundColor(.white)
                                    .opacity(0.7)
                                    .font(.footnote)
                                
                            }
                            Spacer()
                            Button(action: {showSettingsView.toggle()}) {
                                TextfieldIcon(iconName: "gearshape.fill", currentlyEditing: .constant(true), passedImage: .constant(nil))
                                
                            }
                        }
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.white.opacity(0.1))
                        Text(currentAccount?.bio ?? "Pro RPS player")
                            .foregroundColor(.white)
                        
                            .font(.title2.bold())
                            .minimumScaleFactor(0.05)
                        //                    if currentAccount?.numberOfCertificates != 0 {
                        //                        Label("Awarder \(currentAccount?.numberOfCertificates ?? 0) certificates since \(currentAccount?.userSince ?? Date())", image: "calendar")
                        //                        .foregroundColor(.white.opacity(0.7))
                        //                        .font(.footnote)
                        //                    }
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.white.opacity(0.1))
                        
                        //                    HStack(spacing: 16) {
                        //                        if currentAccount?.twitter != nil {
                        //                        Image("Twitter")
                        //                            .resizable()
                        //                            .foregroundColor(.white.opacity(0.7))
                        //                            .frame(width: 24, height: 24, alignment: .center)
                        //                        }
                        //                        if currentAccount?.website != nil {
                        //                        Image(systemName: "link")
                        //                            .foregroundColor(.white.opacity(0.7))
                        //                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                        //                        }
                        //                        Text("designcode.io")
                        //                            .foregroundColor(.white.opacity(0.7))
                        //                            .font(.footnote)
                        //                    }
                        
                    }
                    .padding(16)
                    
                    //                GradientButton(buttonTitle: "Purchase Lifetime Pro Plan") {
                    //                    print("iap")
                    //                }
                    //                .padding(.horizontal, 16)
                    //
                    //                Button(action: {}) {
                    //                    GradientText(text: "Restore Purchases")
                    //                        .font(.footnote.bold())
                    //                }
                    //                .padding(.bottom)
                    
                }
                .background(RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.2))
                    .background(Color("secondaryBackground").opacity(0.5))
                    .background(VisualEffectBlur(blurStyle: .dark))
                    .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 30)
                )
                .cornerRadius(30)
                .padding(.horizontal)
            Spacer()
                VStack {
                    Spacer()
                    Button(action: {signout()}) {
                        //Text("Button")
                        Image(systemName: "arrow.turn.up.forward.iphone.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 0, z:1))
                            .background(
                                Circle()
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    .frame(width: 42, height: 42, alignment: .center)
                                    .overlay(VisualEffectBlur(blurStyle: .dark)
                                        .cornerRadius(21)
                                        .frame(width: 42, height: 42, alignment: .center)
                                    )
                            )
                    }
                }.padding(.bottom)
                
                
            }.colorScheme(updater ? .dark : .dark)
                .padding(.bottom)
          
        }
    
            .sheet(isPresented: $showSettingsView) {
                SettingsView(show: $showSettingsView)
                   // .environment(\.managedObjectContext, viewContext)
                    .onDisappear {
                        
                        updater.toggle()
                    }
            }
            .onAppear {
                currentAccount = Account()
//                currentAccount = savedAccounts.first
//                if currentAccount == nil {
//                    let userDataToSave = Account(context: viewContext)
//                  //  userDataToSave.name = currentUser.displayName
//                    userDataToSave.bio = nil
//                 //   userDataToSave.userID = currentUser.uid
//                    userDataToSave.numberOfCertificates = 0
//                    userDataToSave.twitter = nil
//                    userDataToSave.website = nil
//                    userDataToSave.profileImage = nil
//                    userDataToSave.userSince = Date()
//
//                    do {
//                        try viewContext.save()
//                        DispatchQueue.main.async {
//                          //  showProfileView.toggle()
//                        }
//                    }catch let error {
//                        print(error.localizedDescription)
////                        alertTitle = "Could not create an account"
////                        alertMessage = error.localizedDescription
////                        showAlertView.toggle()
//                    }
//                }
            }
//            .onChange(of: name) { newValue in
//                serverManager.saveUserDisplayName(name: newValue)
//            }
    }
    
    
    func signout() {
        serverManager.logOut()
            presentationMode.wrappedValue.dismiss()
       
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(show: .constant(true))
    }
}


struct Account {
    let username = UserDefaults.standard.string(forKey: "username")
    let name = UserDefaults.standard.string(forKey: "userDisplayName")
    let userID = UserDefaults.standard.string(forKey: "userID")
    
    let profileImage = UIImage(named: "capybara.jpg")
    let bio = "Pro Rock Paper Scissors player"
}
