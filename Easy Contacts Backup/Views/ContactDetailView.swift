//
//  ContactDetailView.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 23/09/22.
//

import SwiftUI
import ContactsUI
import UIKit

struct ContactDetailView: UIViewControllerRepresentable {
    
    var contact: CNContact
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = CNContactViewController(for: contact) // CNContactViewController(for: contact)
        vc.allowsEditing = false
        vc.allowsActions = false
        vc.delegate = context.coordinator
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.setNavigationBarHidden(true, animated: true)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    internal class Coordinator: NSObject, CNContactViewControllerDelegate {
        
        let parent : ContactDetailView
        
        init(_ parent: ContactDetailView) {
          self.parent = parent
        }
        
    }
    
}
