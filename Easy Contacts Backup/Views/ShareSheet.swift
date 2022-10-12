//
//  ShareSheet.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 20/09/22.
//

import Foundation
import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    
    var item: URL
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
}
