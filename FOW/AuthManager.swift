//
//  AuthManager.swift
//  FOW
//
//  Created by Yvonne Chen on 8/10/23.
//

import Firebase
import FirebaseFirestore
import SwiftUI


class AuthManager: ObservableObject {
    @Published var isLoggedIn = false
    
    /**
     Authorization Manager. Keeps track of login status locally in the app.

     - Parameters: None

     - Returns: None
     
     # Notes: #
      1. use isLoggedIn to view user login status.
     */
    init() {
        checkLoggedIn()
    }
    
    /**
     Check the app status to see if user is logged in or not.
     Calling this method determines if `isLoggedIn` will be set to true or false.

     - Parameters: None
     
     - Returns: None
     */
    func checkLoggedIn() {
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        }
    }
    
    /**
     User sign up with their credentials. Upon success will create a document on firebase. A uid will be created per user.
     `isLoggedIn` will also be set to true. Upon failure, user will receive feedback.
     
     # Users receive feedback:
     1. Invalid email
     2. Weak password
     3. Existing email
     
     - Parameters:
        - email: The user's email
        - password: The user's password
        - uname: The user's name

     - Returns: None
     */
    func signup(email: String, password: String, uname: String, completion: @escaping (Result<AuthDataResult, SignupError>) -> Void) {
        var uid: String = ""
        // https://stackoverflow.com/questions/56806437/firebase-auth-and-swift-check-if-email-already-in-database
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let authResult = authResult {
                // Signup successful, you can extract user information if needed
                uid = authResult.user.uid
                self.createUserDocument(email: email, uname: uname, uid: uid)
                self.isLoggedIn = true
                completion(.success(authResult))
            // Upon failure, users will recieve an error
            } else if let error = error as NSError? {
                let signupError = SignupError(errorCode: error.code)
                completion(.failure(signupError))
            }
        }
    }
    
    /**
     Helper method for signup function to organize new user document on Firebase
     
     - Parameters:
        - email: The user's email
        - uname: The user's name
        - uid: The user's newly created uid

     - Returns: None
     */
    func createUserDocument(email: String, uname: String, uid: String) {
        //https://stackoverflow.com/questions/46590155/firestore-permission-denied-missing-or-insufficient-permissions
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
    }

    
    /**
     User login function. Will update `isLoggedIn` to true on successful login
     
     - Parameters:
        - email: The user's email
        - password: The user's password

     - Returns: None
     */
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
    
    /**
     User logout function. Will update `isLoggedIn` to false after logout.
     
     - Parameters: None

     - Returns: None
     */
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
    
    
/*
 Enum for Signup Error cases
 */
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
