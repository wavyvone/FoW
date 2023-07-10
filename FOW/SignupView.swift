//
//  SignupView.swift
//  FOW
//
//  Created by Yvonne Chen on 7/8/23.
//

import SwiftUI

struct SignupView: View {
    
    // Custom RGB Colors here
    let lilac = UIColor(rgb: 0xA09CB0)
    let signUpBC = UIColor(rgb: 0x987D7C)
    
    // Proper name, email, password
    @State private var uname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
       NavigationView {
            
            ZStack{
                // Add color background
                Color(lilac).ignoresSafeArea()
                
                VStack(alignment: .leading){
                    // Welcome sign
                    Text("Hello, let's get exploring!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("Create a new account!")
                        .foregroundColor(.white)
                    
                    
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
                    }.disabled(uname.isEmpty || email.isEmpty || password.isEmpty)
                    
                }
                .padding(.leading, 15.0)
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
