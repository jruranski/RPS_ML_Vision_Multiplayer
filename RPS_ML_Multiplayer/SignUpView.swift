//
//  ContentView.swift
//  SwiftUI Advanced
//
//  Created by Jakub Ruranski on 26/10/2021.
//

import SwiftUI
//import CoreData
import AudioToolbox

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var editingEmailTextField = false
    @State var editingPasswordTextField = false
    @State var emailIconBounce: Bool = false
    @State var passwordIconBounce = false
    @State var showProfileView = false
  //  @State private var signInWithAppleObject = SignInWithAppleObject()
    @State private var signupToggle: Bool = true
    @State private var fadeToggle: Bool = true
    @State private var rotationAngle = 0.0
    
    
    @State var showAlertView: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
//    @Environment(\.managedObjectContext) private var viewContext
   // @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.userSince, ascending: true)], animation: .default) private var savedAccounts: FetchedResults<Account>
    
    private let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        ZStack {
            Image(signupToggle ? "background-3" : "background-1")
                .resizable()
                .aspectRatio( contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .opacity(fadeToggle ? 1.0 : 0.0)
            
            Color("secondaryBackground")
                .edgesIgnoringSafeArea(.all)
                .opacity(fadeToggle ? 0 : 1)
            
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text(signupToggle ? "Sign up" : "Sign in")
                        .font(Font.largeTitle.bold())
                        .foregroundColor(.white)
                    Text("Access to 120 hours of courses, tutorials and livestreams")
                        .font(.subheadline)
                        .foregroundColor(Color.white.opacity(0.7))
                    HStack(spacing: 12) {
                        TextfieldIcon(iconName: "envelope.open.fill", currentlyEditing: $editingEmailTextField, passedImage: .constant(nil))
                            .scaleEffect(emailIconBounce ? 1.2 : 1.0)
                        TextField("Email", text: $email) { isEditing in
                            editingEmailTextField = isEditing
                            editingPasswordTextField = false
                            generator.selectionChanged()
                            if isEditing {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                    emailIconBounce.toggle()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                        emailIconBounce.toggle()
                                    }
                                })
                            }
                        }
                        .colorScheme(.dark)
                        .foregroundColor(Color.white.opacity(0.7))
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                    }.frame(height: 50)
                        .overlay(RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white, lineWidth: 1.0)
                                    .blendMode(.overlay)
                        )
                        .background(Color("secondaryBackground").cornerRadius(16).opacity(0.8))
                    
                    
                    HStack(spacing: 12) {
                        TextfieldIcon(iconName: "key.fill", currentlyEditing: $editingPasswordTextField, passedImage: .constant(nil))
                            .scaleEffect(passwordIconBounce ? 1.2 : 1.0)
                        TextField("Password", text: $password) { isEditing in
                            editingEmailTextField = false
                            editingPasswordTextField = isEditing
                            
                            if isEditing {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                    passwordIconBounce.toggle()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                        passwordIconBounce.toggle()
                                    }
                                })
                            }
                        }
                        .colorScheme(.dark)
                        .foregroundColor(Color.white.opacity(0.7))
                        .autocapitalization(.none)
                        .textContentType(.password)
                    }.frame(height: 50)
                        .overlay(RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white, lineWidth: 1.0)
                                    .blendMode(.overlay)
                        )
                        .background(Color("secondaryBackground").cornerRadius(16).opacity(0.8))
                        .onTapGesture {
                            editingPasswordTextField = true
                            editingEmailTextField  = false
                        }
                    
                    GradientButton(buttonTitle: signupToggle ? "Create account" : "Sign in", buttonAction: {
                        generator.selectionChanged()
                        // # todo add signup
                      //  signUp()
                    })
                        .onAppear {
                            // #todo change to azure auth
//                            Auth.auth().addStateDidChangeListener { auth, user in
//                                if let currentUser = user {
//                                    if savedAccounts.count == 0 {
//                                        // add data to Core Data
//
//                                        let userDataToSave = Account(context: viewContext)
//                                        userDataToSave.name = currentUser.displayName
//                                        userDataToSave.bio = nil
//                                        userDataToSave.userID = currentUser.uid
//                                        userDataToSave.numberOfCertificates = 0
//                                        userDataToSave.twitter = nil
//                                        userDataToSave.website = nil
//                                        userDataToSave.profileImage = nil
//                                        userDataToSave.userSince = Date()
//
//                                        do {
//                                            try viewContext.save()
//                                            DispatchQueue.main.async {
//                                                showProfileView.toggle()
//                                            }
//                                        }catch let error {
//                                            alertTitle = "Could not create an account"
//                                            alertMessage = error.localizedDescription
//                                            showAlertView.toggle()
//                                        }
//                                    }else{
//                                        showProfileView.toggle()
//                                    }
//                                }
//                            }
                        }
                    if signupToggle {
                        Text("by clicking on sign up you agree to our terms of service and privacy policy")
                            .font(.footnote)
                            .foregroundColor(Color.white.opacity(0.7))
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.white.opacity(0.1))
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                fadeToggle.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                    withAnimation(.easeInOut(duration: 0.35)) {
                                        fadeToggle.toggle()
                                    }
                                }
                            }
                            
                            
                            withAnimation(.easeInOut(duration: 0.7)) {
                                
                                signupToggle.toggle()
                                self.rotationAngle += 180
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text(!signupToggle ? "Already have an account?" : "Don't have an account?")
                                    .font(.footnote)
                                    .foregroundColor(Color.white.opacity(0.7))
                                GradientText(text: !signupToggle ? "Sign up" : "Sign in")
                                    .font(Font.footnote.bold())
                            }
                        }
                            if !signupToggle {
                                Button(action:{
                                    
                                    sendPasswordResetEmail()}) {
                                    HStack(spacing: 4) {
                                        Text("Forgot password?")
                                            .font(.footnote)
                                            .foregroundColor(Color.white.opacity(0.7))
                                        GradientText(text: "Reset password")
                                            .font(.footnote
                                                    .bold())
                                    }
                                }
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.white.opacity(0.1))
                                // TODO add sign in with apple option
//                                Button(action: {
//                                    signInWithAppleObject.signInWithApple()
//                                    print("sign in with apple")}) {
//                                   SignInWithAppleButton()
//                                        .frame(height: 50)
//                                        .cornerRadius(16)
//                                }
                            }
                        
                    }
                }
                .padding(20)
            }
            .rotation3DEffect(Angle(degrees: self.rotationAngle), axis: (x: 0, y: 1, z: 0))
            .background(RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.2))
                            .background(Color("secondaryBackground").opacity(0.5))
                            .background(VisualEffectBlur(blurStyle: .systemThinMaterialDark))
                            .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 30)
                        
            )
            .cornerRadius(30)
            .padding(.horizontal)
            .rotation3DEffect(Angle(degrees: self.rotationAngle), axis: (x: 0, y: 1, z: 0))
            .alert(isPresented: $showAlertView) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel())
            }
        }
        // #todo add profile view to the game
//                .fullScreenCover(isPresented: $showProfileView) {
//                    ProfileView()
//                        .environment(\.managedObjectContext, self.viewContext)
//                }
    }
    
    func signUp() {
//       if signupToggle {Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            guard error == nil else {
//                self.alertTitle = "uh-oh"
//
//                self.alertMessage = error!.localizedDescription
//                self.showAlertView.toggle()
//                return
//            }
//            print("User signed up")
//       }}else{
//           Auth.auth().signIn(withEmail: email, password: password) { result, error in
//               guard error == nil else {
//                   print(error!.localizedDescription)
//                   return
//               }
//               print("User signed in")
//           }
//       }
    }

    func sendPasswordResetEmail() {
//        Auth.auth().sendPasswordReset(withEmail: email) {
//            error in
//            guard error == nil else{
//                print(error!.localizedDescription)
//                return
//            }
//            self.alertTitle = "password reset sent"
//            self.alertMessage = "Check your inbox for a reset email"
//            self.showAlertView.toggle()
//        }
    }

    
    
    
}


struct SignUpView_Preview: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}




