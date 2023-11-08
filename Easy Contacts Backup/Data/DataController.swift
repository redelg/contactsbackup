//
//  DataController.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 20/09/22.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    
    static let shared = DataController()
    
    let container = NSPersistentContainer(name: "Contacts")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let viewContext = container.viewContext
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func delete(_ item: Export) {
        let viewContext = container.viewContext
        do {
            viewContext.delete(item)
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
}
