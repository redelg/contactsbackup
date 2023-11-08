//
//  Easy_Contacts_BackupApp.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 15/09/22.
//

import SwiftUI
import GoogleMobileAds
import RevenueCat

@main
struct EasyContactsBackupApp: App {
    
    @StateObject private var dataController = DataController()
    
    
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID ]
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "091e683f9101cce7fb0314e3f99f6406" ]
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_BzAXGIserwzqQlGfPjWzifEmwQh")
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // configure
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.theme.accent ?? .black] // fix text color
        appearance.backButtonAppearance = backItemAppearance
        let image = UIImage(systemName: "chevron.backward")?.withTintColor(UIColor.theme.accent ?? .black, renderingMode: .alwaysOriginal) // fix indicator color
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
        UINavigationBar.appearance().tintColor = UIColor.theme.accent
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
