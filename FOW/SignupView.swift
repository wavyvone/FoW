//
//  SignupView.swift
//  FOW
//
//  Created by Yvonne Chen on 7/8/23.
//

import SwiftUI
import Firebase
// https://stackoverflow.com/questions/61875244/swiftui-cant-get-firebase-firestore-instance
import FirebaseFirestore
//import GoogleSignIn
//import GoogleSignInSwift

struct SignupView: View {
    
    // Custom RGB Colors here
    let lilac = UIColor(rgb: 0xA09CB0)
    let signUpBC = UIColor(rgb: 0x987D7C)
    let lightBlue = UIColor(rgb: 0x071C34)
    let color = Color(.white)
    let horizontalPadding: Int = 15
    
    // Window deprecation https://stackoverflow.com/questions/57134259/how-to-resolve-keywindow-was-deprecated-in-ios-13-0
    let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    
    // show popup
    @State var showingPopup = false
    @State var showUsedEmail = false
    @State var notCorrectEmail = false
    @State var weakPass = false
    
    @State var completedSignUp = false

    
    // Proper name, email, password
    @State private var uname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordRe: String = ""
    @State private var uid: String = ""
    
    @ObservedObject var locationManager = LocationManager.shared
    
    // Sign in stay signed in
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
    
        // if user successfully signs in and userlocation is not given
        // user didnt give us their location
        if completedSignUp && locationManager.userLocation == nil {
            LocationQueryView()
        } else if completedSignUp && locationManager.userLocation != nil {
            MainMapView()
        } else {
            ZStack{
                // Add color background
                Color(lilac).ignoresSafeArea()
                
                VStack{
                    Spacer()
                    HStack {
                        Spacer()
                        
                        VStack{
                            VStack(alignment: .leading) {
                                
                                // Welcome sign
                                Text("Hello! ☁️☀️☁️\nLet's get exploring!")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.white)
                                Text("Create a new account!")
                                    .foregroundColor(.white)
                                    .padding(.bottom, 20)
                                
                                
                                TextField("Name", text: $uname)
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width-100, height: 40)
                                    .padding(.horizontal, 20)
                                    .cornerRadius(16)
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white))
                                
                                
                                TextField("Email", text: $email)
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width-100, height: 40)
                                    .padding(.horizontal, 20)
                                    .cornerRadius(16)
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white))
                                    .popover(isPresented: $showUsedEmail,
                                             attachmentAnchor: .point(.center),
                                             arrowEdge: .top) {
                                        Text("Email is already in use...")
                                            .font(.headline)
                                            .padding()
                                            .presentationCompactAdaptation(.none)
                                    }
                                             .popover(isPresented: $notCorrectEmail,
                                                      attachmentAnchor: .point(.center),
                                                      arrowEdge: .top) {
                                                 Text("Email is invalid.")
                                                     .font(.headline)
                                                     .padding()
                                                     .presentationCompactAdaptation(.none)
                                             }
                                
                                
                                
                                SecureField("Password", text: $password)
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width-100, height: 40)
                                    .padding(.horizontal, 20)
                                    .cornerRadius(16)
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white))
                                    .popover(isPresented: $weakPass,
                                             attachmentAnchor: .point(.center),
                                             arrowEdge: .top) {
                                        Text("Password is less than 6 characters.")
                                            .font(.headline)
                                            .padding()
                                            .presentationCompactAdaptation(.none)
                                    }
                                        
                                        
                                    SecureField("Enter password again", text: $passwordRe)
                                        .foregroundColor(.white)
                                        .frame(width: UIScreen.main.bounds.width-100, height: 40)
                                        .padding(.horizontal, 20)
                                        .cornerRadius(16)
                                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white))
                                        .popover(isPresented: $showingPopup,
                                                 attachmentAnchor: .point(.center),
                                                 arrowEdge: .top) {
                                            Text("Password does not match, try again.")
                                                .font(.headline)
                                                .padding()
                                                .presentationCompactAdaptation(.none)
                                        } // https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-a-popover-view
                                    //if password doesnt match just return whew.
                                        
                                        
                                    Section {
                                        Button(action: signUpCheck) {
                                            Text("Sign up")
                                                .padding(.vertical, 5)
                                                .padding(.horizontal, 20)
                                                .frame(width: UIScreen.main.bounds.width-80)
                                        }.buttonStyle(.borderedProminent)
                                            .tint(Color(signUpBC))
                                            .cornerRadius(16)
                                            .accentColor(.black)
                                            .padding(.vertical, 40)
                                        
                                    }.disabled(uname.isEmpty || email.isEmpty || password.isEmpty || passwordRe.isEmpty)
                                        
                                } // VStack with Text, TextField, and Sign up Button
                                
                                // ---- or ----
                                LabelledDivider(label: "or")
                                
                                // Just start with email and password sign in
                                /*Text("Sign up with your social media account")
                                 .font(.footnote)
                                 .foregroundColor(color)
                                 GoogleSignInButton(action: handleSignInButton)*/
                                
                                // Already have account?
                                HStack{
                                    Text("Already have an account?")
                                        .font(.footnote)
                                        .foregroundColor(color)
                                    
                                    // Sign Up Here
                                    NavigationLink(destination: LoginView()) {
                                        Text("Log in")
                                            .font(.footnote)
                                            .bold()
                                            .foregroundColor(Color(lightBlue))
                                    }
                                }.padding(.top, 80)
                            } // Outer Vstack
                            
                            Spacer()
                        } // HStack of Spacer
                        Spacer()
                    }.ignoresSafeArea(.keyboard, edges: .bottom) // Vstack of Spacern
                    // Add alignment guide
                } // ZStack
        } // else
        
            
    } // body
        
    func signUpCheck(){
        // Check if password text are the same else show a pop up that theyre incorrect.
        if password != passwordRe {
            showingPopup = true
            return
        }
        // https://stackoverflow.com/questions/56806437/firebase-auth-and-swift-check-if-email-already-in-database
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let authResult = authResult {
                uid = authResult.user.uid
            }
            if let x = error {
                let err = x as NSError
                switch err.code {
                case AuthErrorCode.invalidEmail.rawValue:
                    notCorrectEmail = true
                    print("invalid email")
                case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                    print("accountExistsWithDifferentCredential")
                case AuthErrorCode.emailAlreadyInUse.rawValue: //<- Your Error
                    showUsedEmail = true
                    print("email is already in use")
                case AuthErrorCode.weakPassword.rawValue:
                    weakPass = true
                    print("password weak")
                default:
                    print("unknown error: \(err.localizedDescription)")
                }
                //return
            } else {
                createUserDocument()
                completedSignUp = true
                userID = uid
                print("SIGN UP SUCCESS") //continue to app
                
            }
        }
        // After create user go to main map view
        // TODO Need to figure out this step
    } // signuP end
    
    //https://stackoverflow.com/questions/46590155/firestore-permission-denied-missing-or-insufficient-permissions
    func createUserDocument() {
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
        // Subcollections must be created after user logs in
        /*if createdDocument {
         db.collection("users").document(String(documentId)).collection(subcollection).document() { error in
         if let error = error {
         print("Error creating user document: \(error.localizedDescription)")
         } else {
         print("User collection created.")
         }
         }
         } //create Document*/
            
    } //Created user Document func
}


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
