//
//  SignupView.swift
//  FOW
//
//  Created by Yvonne Chen on 7/8/23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct SignupView: View {
    
    // Custom RGB Colors here
    let lilac = UIColor(rgb: 0xA09CB0)
    let signUpBC = UIColor(rgb: 0x987D7C)
    let color = Color(.white)
    let horizontalPadding: Int = 15
    
    // Window deprecation https://stackoverflow.com/questions/57134259/how-to-resolve-keywindow-was-deprecated-in-ios-13-0
    let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    
    // Proper name, email, password
    @State private var uname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordRe: String = ""
    
    
    var body: some View {
        
       NavigationView {
            
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
                                Text("Hello, let's get exploring!")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.white)
                                Text("Create a new account!")
                                    .foregroundColor(.white)
                                    .padding(.bottom, 40)
                                
                                
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
                                
                                
                                SecureField("Password", text: $password)
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width-100, height: 40)
                                    .padding(.horizontal, 20)
                                    .cornerRadius(16)
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white))
                                
                                
                                SecureField("Enter password again", text: $passwordRe)
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width-100, height: 40)
                                    .padding(.horizontal, 20)
                                    .cornerRadius(16)
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white))
                                
                                
                                Section {
                                    Button(action: something) {
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
                            
                            Text("Sign up with your social media account")
                                .font(.footnote)
                                .foregroundColor(color)
                            GoogleSignInButton(action: handleSignInButton)
                            
                        } // Outer Vstack
                        
                        Spacer()
                    } // HStack of Spacer
                    Spacer()
                }.ignoresSafeArea(.keyboard, edges: .bottom) // Vstack of Spacern
                // Add alignment guide
                                
            }

        }
    }
    func handleSignInButton() {
        guard let rootViewController = keyWindow?.rootViewController else {
                return
            }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
                if let error = error {
                    // Handle error
                    print("Sign In Error: \(error.localizedDescription)")
                    return
                }
                
                // Sign in succeeded
                if let result = signInResult {
                    print("Sign In Success: \(result)")
                    // Display the app's main content View
                }
            }
        }
    func something(){
        print("hi")
    }
    
}


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
