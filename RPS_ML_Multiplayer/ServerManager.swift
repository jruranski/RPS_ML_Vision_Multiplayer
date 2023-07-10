//
//  ServerManager.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 10/07/2023.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore


class ServerManager: ObservableObject {
    @Published var signedIn = false
    
    private var user: User?
    
    private var ref: DatabaseReference?
    
    init() {
        ref = Database.database().reference()
        user = nil
        tryLogin()
    }
    
    init(user: User) {
        ref = Database.database().reference()
        self.user = user
        
    }
    
    func passDbReference() -> DatabaseReference {
        return ref ?? Database.database().reference()
    }
    
    func isSignedIn() -> Bool {
        
            return user != nil && signedIn
        
    }
    
    func saveUser(user: User) {
        guard let ref = ref else {return}
        
        let userData: [String : Any] = [
            
            "username" : user.displayName ?? "Jack",
            "email" : user.email ?? "no_email",
            "playerOnline" : true,
            "wins" : 0
        ]
        
        ref.child("players").child(user.uid).setValue(userData)
        self.user = user
    }
    
    
    func setOnlineStatus(isOnline: Bool) {
        guard let ref = ref else {return}
        guard let user = user else {return}
        
        ref.child("players/\(user.uid)/playerOnline").setValue(isOnline)
        print("Saved online status \(isOnline)")
    }
    
    
    func tryLogin() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let currentUser = user {
                self.user = currentUser
                self.signedIn = true
                let ud = UserDefaults.standard
                if ud.string(forKey: "username") == "" {
                    // add data to Core Data


                    ud.set(currentUser.email, forKey: "username")
                    ud.set(currentUser.displayName, forKey: "userDisplayName")
                    ud.set(currentUser.uid, forKey: "userID")
              
           
//                                                                }catch let error {
//                                                                    alertTitle = "Could not create an account"
//                                                                    alertMessage = error.localizedDescription
//                                                                    showAlertView.toggle()
//                                                                }
                    print("setting new user")
                }else{
                  
                    
                    print("user is signed in")
                }
            }
        }
    }
    
    func logOut() {
        
    }
    
    
}
