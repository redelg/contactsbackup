//
//  LoadingView.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 21/09/22.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.1)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.theme.accent))
                .scaleEffect(2)
                .frame(width: 50)
            
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
