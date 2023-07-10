//
//  ContentView.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 26/10/2021.
//  Refactored by Jakub Ruranski on 09/06/2023.

import SwiftUI
//import CoreData
import AudioToolbox
import FirebaseAuth


struct SignUpView: View {


    @Binding var show: Bool
// var applicationContext: MSALPublicClientApplication!
    @ObservedObject var serverManager: ServerManager
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
                .onTapGesture {
                    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true)
                }
            Color("secondaryBackground")
                .edgesIgnoringSafeArea(.all)
                .opacity(fadeToggle ? 0 : 1)
            
            VStack {
                
                HStack {
                    TextfieldIcon(iconName: "xmark", currentlyEditing: .constant(false), passedImage: .constant(nil))
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                self.show.toggle()
                            }
                        }
                    Spacer()
                }.padding()
                    .padding(.top)
            Spacer()
                // main card
            VStack {
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(signupToggle ? "Sign up" : "Sign in")
                        .font(Font.largeTitle.bold())
                        .foregroundColor(.white)
                    Text("Get started with the best rock, paper scissors game you have ever played!")
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
                        SecureField("Password", text: $password)
//                        { isEditing in
//                            editingEmailTextField = false
//                            editingPasswordTextField = isEditing
//
//                            if isEditing {
//                                withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
//                                    passwordIconBounce.toggle()
//                                }
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
//                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
//                                        passwordIconBounce.toggle()
//                                    }
//                                })
//                            }
//                        }
                        .onChange(of: password, perform: { changed in
                            let isEditing = true
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
                        })
                        .onSubmit({
                            editingPasswordTextField = false
                        })
                        .colorScheme(.dark)
                        .foregroundColor(Color.white.opacity(0.7))
                        .autocapitalization(.none)
//                        .textContentType(.password)
//                        .keyboardType(.password)
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
                        	  signUp()
                    })
                    .onAppear {
                        // #todo change to azure auth
                        serverManager.tryLogin()
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
           
                Spacer()
        }
            .alert(isPresented: $showAlertView) {
//                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: Alert.Button(action: {
//                    withAnimation {
//                        self.show.toggle()
//                    }
//                }, label: {
//                    Text("OK")
//                }))
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel(Text("OK"), action: {
                    withAnimation {
                                           self.show.toggle()
                        }
                }))
            }
            .opacity(show ? 1 : 0)
        }
        // #todo add profile view to the game
//                .fullScreenCover(isPresented: $showProfileView) {
//                    ProfileView()
//                        .environment(\.managedObjectContext, self.viewContext)
//                }
    }
    
    func signUp() {
  
        
        if signupToggle {Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                self.alertTitle = "uh-oh"
                
                self.alertMessage = error!.localizedDescription
                self.showAlertView.toggle()
                return
            }
           
           // save user
            guard let result = result else {
                self.alertTitle = "Cannot save user info"
                self.alertMessage = "Please try again "
                self.showAlertView.toggle()
                return
                
            }
            
            saveUserData(authResult: result)
            
            print("User signed up")
       }}else{
           Auth.auth().signIn(withEmail: email, password: password) { result, error in
               guard error == nil else {
                   print(error!.localizedDescription)
                   return
               }
               guard let result = result else {
                   self.alertTitle = "Cannot save user info"
                   self.alertMessage = "Please try again "
                   self.showAlertView.toggle()
                   return
                   
               }
               
               saveUserData(authResult: result)
               print("User signed in")
           }
       }
        
        // save user data
        
        
        
     
        
        
        
    }
    
    func saveUserData(authResult: AuthDataResult) {
        let ud = UserDefaults.standard
        let user = authResult.user
        ud.set(user.email, forKey: "username")
        ud.set(user.displayName, forKey: "userDisplayName")
        ud.set(user.uid, forKey: "userID")
        
        
        // save to firebase database
        serverManager.saveUser(user: user)
        
        self.alertTitle = "You are logged in!"
        self.alertMessage = "Welcome to RPS Multiplayer!"
        self.showAlertView.toggle()
    }
    
    func sendPasswordResetEmail() {
        Auth.auth().sendPasswordReset(withEmail: email) {
            error in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
            self.alertTitle = "password reset sent"
            self.alertMessage = "Check your inbox for a reset email"
            self.showAlertView.toggle()
        }
    }
    
    
    
    
}


struct SignUpView_Preview: PreviewProvider {
    static var previews: some View {
        SignUpView(show: .constant(true), serverManager: ServerManager())
    }
}




