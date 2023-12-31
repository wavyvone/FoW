//
//  LoginView.swift
//  FOW
//
//  Created by Yvonne Chen on 7/8/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    // Colors
    let skyBlue = UIColor(rgb: 0x87B2CC)
    let logInBC = UIColor(rgb: 0x617073)
    let forgotBC = UIColor(rgb: 0x071C34)
    let color = Color(.white)
    
    // Proper credentials
    @State private var email: String = ""
    @State private var password: String = ""
    
    // Insert Authmanager environment object.
    @EnvironmentObject var authManager: AuthManager
    
    // Password Incorrect
    @State var incorrectPassword = false
    
    // Double check if the user has location shared or not.
    //@ObservedObject var locationManager = LocationManager.shared
    
    //Login have to stay logged in now.
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        
        ZStack{
            // Add color background.
            Color("skyBlue").ignoresSafeArea()
            ScrollView {
                VStack {
                    Group {
                        // Welcome sign
                        Text("Welcome Back! 👋🏻")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.top, 100)
                        Text("Login to continue exploring!")
                            .foregroundColor(.white)
                            .padding(.bottom, 40)
                    }
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    
                    Group {
                        // Email Field
                        TextField("Email", text: $email)
                        
                        // Password Field
                        SecureField("Password", text: $password)
                    }
                    .textInput()
                    
                    // Login Button
                    Group {
                        Button(action: verifyLogin) {
                            Text("Log in")
                                .padding(.vertical, 5)
                                .padding(.horizontal, 20)
                                .frame(width: UIScreen.main.bounds.width-80)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color("logInBC"))
                        .cornerRadius(16)
                        .accentColor(.black)
                        .padding(.top, 40)
                    }.disabled(email.isEmpty || password.isEmpty)
                        .popover(isPresented: $incorrectPassword,
                                 attachmentAnchor: .point(.center),
                                 arrowEdge: .top) {
                            Text("Email or password is incorrect.\nTry again.")
                                .font(.headline)
                                .padding()
                                .presentationCompactAdaptation(.none)
                        }
                    
                    
                    
                    
                    // Reset Password Button
                    Button(action: forgetPassword){
                        Text("Forgot Password?")
                            .font(.footnote)
                            .foregroundColor(Color("forgotBC"))
                    }
                    .padding(.bottom, 40)
                    
                    // ---- or ----
                    LabelledDivider(label: "or")
                    
                    Text("Login with your social media account")
                        .font(.footnote)
                        .foregroundColor(color)
                    
                    // TODO add social media here
                    
                    
                    // Don't have account? Go to Sign Up.
                    HStack{
                        Text("Don't have an account?")
                            .font(.footnote)
                            .foregroundColor(color)
                        
                        // Sign Up Here
                        NavigationLink(destination: SignupView()) {
                            Text("Sign up")
                                .font(.footnote)
                                .bold()
                                .foregroundColor(Color(forgotBC))
                        }
                    }
                    .padding(.top, 80)
                } // ScrollView
                .padding(.horizontal, 40)
            }
        } // ZStack
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .toolbarBackground(Color("skyBlue"), for: .navigationBar)

    }
    
    /**
     Verify if the login success or not. AuthManager will determine if user can access the map.
     */
    func verifyLogin() {
        // https://designcode.io/swiftui-advanced-handbook-firebase-auth
        authManager.login(email: email, password: password) { success in
            if success {
                print("Success Login")
                // Navigate to another view, for example, after successful login.
            } else {
                print("Fail Login")
                // Display an error message or handle unsuccessful login.
                incorrectPassword = true
            }
        }
    }
    
    func forgetPassword(){
        print("Forget password not completed")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
