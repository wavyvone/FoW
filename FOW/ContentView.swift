//
//  ContentView.swift
//  FOW
//
//  Created by Yvonne Chen on 7/7/23.
//

import SwiftUI
import SwiftyGif


struct ContentView: View {
    let myBlue = UIColor(rgb: 0xABDAE1)
    let logInColor = UIColor(rgb: 0xB3B3B3)
    let backColor = UIColor(rgb: 0x211103)
    
    let gifFile = "duck"
    
    var body: some View {
        
        NavigationView {
            
            ZStack{
                // Background
                Color(myBlue).ignoresSafeArea()
                
                VStack {
                    // Duck Gif
                    GifView(gifName: gifFile, size: CGSize(width: 200, height: 200))
                    
                    Text("Hello!").font(.largeTitle)
                        .bold()
                        .foregroundColor(Color.black)
                    Text("Are you ready to explore the world and \n view your progress?")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.black)
                    
                    // Log In Here
                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                            .padding(.vertical, 5)
                            .frame(width: UIScreen.main.bounds.width-75, alignment: .center)
                    }.buttonStyle(.borderedProminent)
                        .tint(Color(logInColor))
                        .cornerRadius(10)
                        .padding(5)

            
                    
                    // Sign Up Here
                    NavigationLink(destination: SignupView()) {
                        Text("Sign Up")
                            .foregroundColor(Color.black)
                            .padding(.vertical, 5)
                            .frame(width: UIScreen.main.bounds.width-75, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white, lineWidth: 2))
                    }.buttonStyle(.borderedProminent)
                        .tint(.white)
                        .cornerRadius(10)
 
                    
                }.padding(.bottom, 20.0) // VStack
            } // ZStack
        }.accentColor(Color(backColor)) // Nav View
    }
    // For Log in
    func logIn() {
        // Should move to Log In Page
        print("Log In")
    }
    // For Sign up
    func signUp() {
        // Should move to Sign Up Page
        print("Sign Up")
    }

}

// Run Gif with this
struct GifView: UIViewRepresentable {
    let gifName: String
    let size: CGSize
    
    init(gifName: String, size: CGSize) {
        self.gifName = gifName
        self.size = size
    }
    
    func makeUIView(context: UIViewRepresentableContext<GifView>) -> UIImageView {
        let imageView = UIImageView()
        
        if let gifURL = Bundle.main.url(forResource: gifName, withExtension: "gif") {
            do {
                let gifData = try Data(contentsOf: gifURL)
                let gif = try UIImage(gifData: gifData)
                
                imageView.setGifImage(gif)
            } catch {
                print("Error loading GIF image: \(error)")
            }
        }
        
        imageView.frame = CGRect(origin: .zero, size: size)
        
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: UIViewRepresentableContext<GifView>) {
        // No need to update the view in this example
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
