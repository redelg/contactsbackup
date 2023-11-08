//
//  ContentView.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 15/09/22.
//

import SwiftUI
import RevenueCat

class EnvironmentViewModel: ObservableObject {
    
    @Published var isProActive: Bool = false
    
    init() {
        checkSubscription()
    }
    
    func checkSubscription() {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            self.isProActive = customerInfo?.entitlements.all["Pro"]?.isActive == true
        }
    }
    
}


struct ContentView: View {
        
    @StateObject var environmentViewModel = EnvironmentViewModel()

    var body: some View {
        
        NavigationView {
            MainView()
                .environmentObject(environmentViewModel)
        }
        .preferredColorScheme(.light)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
