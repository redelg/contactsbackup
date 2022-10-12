//
//  Colors.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 17/09/22.
//

import SwiftUI
import UIKit

extension Color {
 
    static let theme = ColorTheme()
    
}

struct ColorTheme {
    
    //let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let backgroundSlider = Color("BackgroundSlider")
    let loadingBackgroundColor = Color("LoadingBackgroundColor")
    let itemBackground = Color("ItemBackgroundColor")
    let gradientStart = Color("GradientStart")
    let gradientEnd = Color("GradientEnd")
    let accent = Color("AccentColor")

}

extension UIColor {
    
    static let theme = UIColorTheme()
    
}

struct UIColorTheme {
    
    let accent = UIColor(named: "AccentColor")
    
}
