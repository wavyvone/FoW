//
//  ContentView.swift
//  FOW
//
//  Created by Yvonne Chen on 7/7/23.
//

import SwiftUI
import SwiftyGif
import Firebase


struct ContentView: View {
    let myBlue = UIColor(rgb: 0xABDAE1)
    let logInColor = UIColor(rgb: 0xB3B3B3)

    // AuthManager check if user is logged in or not.
    @EnvironmentObject var authManager: AuthManager
    
    // GIF file name
    let gifFile = "duck"
    
    var body: some View {
        
        // Check if user is logged in or not.
        if authManager.isLoggedIn {
            ViewToMainMapView().environmentObject(authManager)
        } else {
            ZStack{
                // Background Color
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
                    // need to pass in environment object to continute hierarchy
                    NavigationLink(destination: ContentToLoginView().environmentObject(authManager)) {
                        Text("Log In")
                            .padding(.vertical, 5)
                            .frame(width: UIScreen.main.bounds.width-75, alignment: .center)
                    }.buttonStyle(.borderedProminent)
                        .tint(Color(logInColor))
                        .cornerRadius(10)
                        .padding(5)
                    
                    
                    
                    // Sign Up Here
                    NavigationLink(destination: ContentToSignupView().environmentObject(authManager)) {
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
        } // else
    } // Nav View
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
