//
//  AuthManager.swift
//  FOW
//
//  Created by Yvonne Chen on 8/10/23.
//

import Firebase
import FirebaseFirestore
import SwiftUI

/*
 Authorization Manager:
 Keeps track of login status locally in the app.
 Arguments: None
 Functions:
    checkLoggedIn()
    signup(email, password, uname)
    createUserDocument(email, uname, uid)
    login(email, password)
    logout()
 */
class AuthManager: ObservableObject {
    @Published var isLoggedIn = false
    
    init() {
        checkLoggedIn()
    }
    
    /*
     Checks the app status to see if user is logged in or not.
     */
    func checkLoggedIn() {
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        }
    }
    
    /*
     
     */
    // https://stackoverflow.com/questions/56806437/firebase-auth-and-swift-check-if-email-already-in-database
    func signup(email: String, password: String, uname: String, completion: @escaping (Result<AuthDataResult, SignupError>) -> Void) {
        var uid: String = ""
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let authResult = authResult {
                // Signup successful, you can extract user information if needed
                uid = authResult.user.uid
                self.createUserDocument(email: email, uname: uname, uid: uid)
                self.isLoggedIn = true
                completion(.success(authResult))
            } else if let error = error as NSError? {
                let signupError = SignupError(errorCode: error.code)
                completion(.failure(signupError))
            }
        }
    }
    
    // helper function to create user document
    //https://stackoverflow.com/questions/46590155/firestore-permission-denied-missing-or-insufficient-permissions
    func createUserDocument(email: String, uname: String, uid: String) {
        // https://codewithchris.com/swift-string/
        let atSign = email.firstIndex(of: "@")!
        let documentId = email[..<atSign]
        //let subcollection: String = "fog_of_war"
        
        guard !documentId.isEmpty else {
            print("User name cannot be empty.")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(String(documentId)).setData([
            "name": uname,
            "uid": uid
            // Here I want to create a name field with their name
        ]) { error in
            if let error = error {
                print("Error creating user document: \(error.localizedDescription)")
            } else {
                print("User document created with the custom ID.")
            }
        }
            
    } //Created user Document func

    
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
    
    

enum SignupError: Error {
    case invalidEmail
    case accountExistsWithDifferentCredential
    case emailAlreadyInUse
    case weakPassword
    case unknown(FirebaseError)
    
    init(errorCode: Int) {
        switch errorCode {
            case AuthErrorCode.invalidEmail.rawValue:
                self = .invalidEmail
            case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                self = .accountExistsWithDifferentCredential
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                self = .emailAlreadyInUse
            case AuthErrorCode.weakPassword.rawValue:
                self = .weakPassword
            default:
            self = .unknown(FirebaseError(errorCode: errorCode))
        }
    }
    
    var localizedDescription: String {
            switch self {
            case .invalidEmail:
                return NSLocalizedString("invalid_email_error", comment: "")
            case .accountExistsWithDifferentCredential:
                return NSLocalizedString("account_exists_error", comment: "")
            case .emailAlreadyInUse:
                return NSLocalizedString("email_in_use_error", comment: "")
            case .weakPassword:
                return NSLocalizedString("weak_password_error", comment: "")
            case .unknown(let errorCode):
                return NSLocalizedString("unknown_error", comment: "") + " \(errorCode)"
            }
        }
}

struct FirebaseError: Error {
    let errorCode: Int
}
