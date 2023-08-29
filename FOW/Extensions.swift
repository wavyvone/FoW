//
//  Extensions.swift
//  FOW
//
//  Created by Yvonne Chen on 7/7/23.
//

import Foundation
import SwiftUI

//
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}


// https://stackoverflow.com/questions/56619043/show-line-separator-view-in-swiftui
struct LabelledDivider: View {

    let label: String
    let horizontalPadding: CGFloat
    let color: Color

    init(label: String, horizontalPadding: CGFloat = 15, color: Color = .white) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack {
            line
            Text(label).foregroundColor(color)
            line
        }
    }

    var line: some View {
        VStack {
            Divider().background(color)
                .frame(height: 2)
                .overlay(color)
        }.padding(horizontalPadding)
    }
}


// ViewModifier

struct TextInput: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .disableAutocorrection(true)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white)
            }
    }
}


extension View {
    func textInput() -> some View {
        modifier(TextInput())
    }
}
