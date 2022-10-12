//
//  HistoryViewModel.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 21/09/22.
//

import Foundation

class HistoryViewModel: ObservableObject {
    
    @Published var history = [Export]()
    
    init() {
        updateHistory()
    }
    
    func updateHistory() {
        let context = DataController.shared.container.viewContext
        let request = Export.fetchRequest()
        do {
            history = try context.fetch(request).reversed()
        } catch {
            print(error)
        }
    }
    
}
