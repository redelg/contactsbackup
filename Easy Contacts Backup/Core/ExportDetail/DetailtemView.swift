//
//  DetailtemView.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 22/09/22.
//

import SwiftUI

struct DetailtemView: View {
    
    var imageData: Data? = nil
    var name: String = ""
    
    var body: some View {
        HStack {
            if imageData != nil {
                Image(uiImage: UIImage(data: imageData!)!)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
            } else {
                Circle()
                    .overlay(Text(name.prefix(1)).foregroundColor(Color.white), alignment: .center)
                    .foregroundColor(Color.gray)
                    .frame(width: 40, height: 40)
            }
            Text(name)
                .padding([.leading])
            Spacer()
        }
    }
}

struct DetailtemView_Previews: PreviewProvider {
    static var previews: some View {
        DetailtemView()
    }
}
