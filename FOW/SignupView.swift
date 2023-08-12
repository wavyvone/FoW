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
    @State var passNotMatch = false
    @State var emailAlreadyInUse = false
    @State var invalidEmail = false
    @State var weakPass = false
    
    @State private var errorFlag = false

    
    // Proper name, email, password
    @State private var uname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordRe: String = ""
    @State private var uid: String = ""
    
    @ObservedObject var locationManager = LocationManager.shared
    
    // Insert Authmanager environment object
    @EnvironmentObject var authManager: AuthManager
    @State private var signupResult: SignupError?
    
    // Sign in stay signed in
    //@AppStorage("uid") var userID: String = ""
    
    var body: some View {
    
        /*// if user successfully signs in and userlocation is not given
        // user didnt give us their location
        if completedSignUp && locationManager.userLocation == nil {
            LocationQueryView()
        } else if completedSignUp && locationManager.userLocation != nil {
            MainMapView()
        } else {*/
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
                                .popover(isPresented: $emailAlreadyInUse,
                                         attachmentAnchor: .point(.center),
                                         arrowEdge: .top) {
                                    Text("Email is already in use...")
                                        .font(.headline)
                                        .padding()
                                        .presentationCompactAdaptation(.none)
                                }
                                         .popover(isPresented: $invalidEmail,
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
                                .popover(isPresented: $passNotMatch,
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
                                .popover(isPresented: $errorFlag,
                                         attachmentAnchor: .point(.center),
                                         arrowEdge: .top) {
                                    if let error = signupResult {
                                        Text("\(error.localizedDescription)")
                                            .font(.headline)
                                            .padding()
                                            .presentationCompactAdaptation(.none)
                                    }
                                }

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
                            
                            // Go to Login page
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
            }.ignoresSafeArea(.keyboard, edges: .bottom) // Vstack of Spacer
            // Add alignment guide
        } // ZStack
            
    } // body
        
    func signUpCheck(){
        // Check if password text are the same else show a pop up that theyre incorrect.
        if password != passwordRe {
            passNotMatch = true
            return
        }
        authManager.signup(email: email, password: password, uname: uname) { result in
            switch result {
            case .success(_):
                print("Successful Sign up")
                break
                // Handle successful signup
            case .failure(let error):
                if case .weakPassword = error {
                    weakPass = true
                } else if case .emailAlreadyInUse = error {
                    emailAlreadyInUse = true
                } else if case .accountExistsWithDifferentCredential = error {
                    emailAlreadyInUse = true
                } else if case .invalidEmail = error {
                    invalidEmail = true
                } else {
                    signupResult = error // Store the signup error
                    errorFlag = true
                }
            }
        }
    
    } // signuP end
    
}


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
