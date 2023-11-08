//
//  HistoryItemView.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 21/09/22.
//

import SwiftUI

struct HistoryItemView: View {
    
    private let dateFormat: DateFormatter = {
        var mydf = DateFormatter()
        mydf.dateStyle = .long // set as desired
        mydf.timeStyle = .medium
        return mydf
    }()
    var export: Export
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text(dateFormat.string(from: export.date!))
                    .font(.subheadline)
                Text(export.device ?? "")
                    .font(.caption)
            }
            Spacer()
            Text("\(export.count)")
                .font(.title3)
        }
        .padding(2)
    }
}

struct HistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryItemView(export: Export.preview())
    }
}

extension Export {
    
    static func preview() -> Export {
        let export = Export()
        export.date = Date()
        export.device = "Iphone de Renzo"
        export.count = 20
        return export
    }
    
}
