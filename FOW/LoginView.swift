//
//  LoginView.swift
//  FOW
//
//  Created by Yvonne Chen on 7/8/23.
//

import SwiftUI

struct LoginView: View {
    let skyBlue = UIColor(rgb: 0x87B2CC)
    let logInBC = UIColor(rgb: 0x617073)
    let forgotBC = UIColor(rgb: 0x071C34)
    let color = Color(.white)
    
    // Proper credentials
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        NavigationView {
             
            ZStack{
                // Add color background
                Color(skyBlue).ignoresSafeArea()
                
                VStack{
                    Spacer()
                    HStack {
                        Spacer()
                        VStack{
                            
                            
                            VStack(alignment: .leading) {
                                
                                // Welcome sign
                                Text("Welcome Back! 👋🏻")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.white)
                                Text("Login to continue exploring!")
                                    .foregroundColor(.white)
                                    .padding(.bottom, 40)
                                
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
                                
                                Section {
                                    Button(action: something) {
                                        Text("Log in")
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 20)
                                            .frame(width: UIScreen.main.bounds.width-80)
                                    }.buttonStyle(.borderedProminent)
                                        .tint(Color(logInBC))
                                        .cornerRadius(16)
                                        .accentColor(.black)
                                        .padding(.top, 40)
                                }.disabled(email.isEmpty || password.isEmpty)
                                
                            } // main Vstack
                            
                            Button(action: something){
                                Text("Forgot Password?")
                                    .font(.footnote)
                                    .foregroundColor(Color(forgotBC))
                            }.padding(.bottom, 40)
                            
                            // ---- or ----
                            LabelledDivider(label: "or")
                            
                            Text("Login with your social media account")
                                .font(.footnote)
                                .foregroundColor(color)
                            
                            // TODO add social media here
                            
                            // Don't have account?
                            VStack(alignment: .leading) {
                                Text("Don't have an account?")
                            }
                            
                            
                        } // outer VStack
                        Spacer()
                    } // HStack
                    Spacer()
                }.ignoresSafeArea(.keyboard, edges: .bottom) // Final VStack
            } // ZStack
        } // NavigationView
    }
    func something(){
        print("hi")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
