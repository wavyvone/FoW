//
//  FOWApp.swift
//  FOW
//
//  Created by Yvonne Chen on 7/7/23.
//

import SwiftUI
import GoogleSignIn

@main
struct FOWApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
            .onAppear {
                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    // Check if `user` exists; otherwise, do something with `error`
                }
            }
        }
    }
}
