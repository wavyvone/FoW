//
//  AuthManager.swift
//  FOW
//
//  Created by Yvonne Chen on 8/10/23.
//

import Firebase
import SwiftUI

class AuthManager: ObservableObject {
    @Published var isLoggedIn = false
    
    init() {
        checkLoggedIn()
    }
    
    func checkLoggedIn() {
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        }
    }
    
    func signup() {
        
    }
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                completion(false)
            } else {
                self.isLoggedIn = true
                completion(true)
            }
        }
    }
    
    // have app set to signout
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

}
    
    
