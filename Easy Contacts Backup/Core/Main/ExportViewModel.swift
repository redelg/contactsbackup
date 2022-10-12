//
//  ExportViewModel.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 19/09/22.
//

import Contacts
import SwiftUI
import RevenueCat

enum MainAlert {
    case permission
    case noContacts
    case limit
}

class ExportViewModel: ObservableObject {
    
    @Published var contacts = [CNContact]()
    @Published var exportContacts = [CNContact]()
    @Published var size = 0.0
    @Published var alertType: MainAlert = .permission
    @Published var showingAlert = false
    @Published var showingError = false

    @Published var url: URL? = nil
    @Published var showShare = false
    @Published var loading = false
    
    private var isProActive: Bool = false
    private var limit = 70
    
    init() {
        getContacts()
    }
    
    init(contacts: [CNContact]) {
        self.contacts = contacts
        self.exportContacts = contacts
    }
    
    func checkPermission() -> Bool {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .authorized: return true
        case .notDetermined:
            requestPermission()
            return false
        case .restricted:
            alertType = .permission
            showingAlert.toggle()
            return false
        case .denied:
            alertType = .permission
            showingAlert.toggle()
            return false
        @unknown default:
            alertType = .permission
            showingAlert.toggle()
            return false
        }
    }
    
    func requestPermission() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: { success, error in
            if success {
                self.getContacts()
            } else {
                DispatchQueue.main.async {
                    self.alertType = .permission
                    self.showingAlert.toggle()
                }
            }
        })
    }
    
    func getContacts() {
        if !checkPermission() { return }
        contacts.removeAll()
        let store = CNContactStore()
        let request = CNContactFetchRequest(keysToFetch: CNContactKeys.keysToFetch)
        do {
            try store.enumerateContacts(with: request, usingBlock: { contact, stop in
                contacts.append(contact.toNewContact())
            })
            size = 1.0
        } catch {
            DispatchQueue.main.async {
                self.showingError.toggle()
            }
        }
    }
    
    
    // MARK: EXPORT
    
    func getContactsForExport() {
        if !checkPermission() { return }
        exportContacts.removeAll()
        let store = CNContactStore()
        let request = CNContactFetchRequest(keysToFetch: CNContactKeys.keysToFetch)
        do {
            try store.enumerateContacts(with: request, usingBlock: { contact, stop in
                exportContacts.append(contact.toNewContact())
            })
            size = 1.0
            
            if exportContacts.isEmpty {
                alertType = .noContacts
                showingAlert.toggle()
            }
            
            if !isProActive {
                if exportContacts.count > limit {
                    exportContacts = Array(contacts[..<limit])
                    alertType = .limit
                    showingAlert.toggle()
                }
            }
            
        } catch {
            DispatchQueue.main.async {
                self.showingError.toggle()
            }
        }
    }
    
    func export(format: ExportFormat) {
        if !checkPermission() { return }
        getContactsForExport()
        
        if exportContacts.isEmpty { return }
        if showingAlert { return }
        
        switch format {
        case .vcard:
            exportToVcard()
        case .csv:
            exportToCsv()
        }
    }
    
    func exportToVcard(_ save: Bool = true) {
        loading = true
        DispatchQueue.global().async {
            do {
                var data = Data()
                try data = CNContactVCardSerialization.data(with: self.exportContacts)
                let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    .appendingPathComponent("contacts")
                    .appendingPathExtension("vcf")
                try data.write(to: directory)
                DispatchQueue.main.async {
                    self.url = directory
                    self.showShare.toggle()
                    self.loading = false
                    if save {
                        self.saveToHistory()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.showingError.toggle()
                }
            }
        }
    }
    
    func exportToCsv(_ save: Bool = true) {
        loading = true
        DispatchQueue.global().async {
            do {
                let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    .appendingPathComponent("contacts")
                    .appendingPathExtension("csv")
                try CsvUtil.getCsvString(self.exportContacts.sorted { $0.givenName < $1.givenName }).write(to: directory, atomically: true, encoding: .utf8)
                DispatchQueue.main.async {
                    self.url = directory
                    self.showShare.toggle()
                    self.loading = false
                    if save {
                        self.saveToHistory()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.showingError.toggle()
                }
            }
        }
    }
    
    func saveToHistory() {
        let export = Export(context: DataController.shared.container.viewContext)
        export.device = UIDevice.current.name
        export.date = Date()
        export.id = UUID()
        export.count = Int32(exportContacts.count)
        do {
            export.contacts = try NSKeyedArchiver.archivedData(withRootObject: exportContacts, requiringSecureCoding: true)
            DataController.shared.save()
        } catch {
            showingError = true
        }
    }
    
    // MARK: REPLACE - ADD CONTACTS TO BOOK
    
    private func deleteContacts() {
        let store = CNContactStore()
        let request = CNContactFetchRequest(keysToFetch: CNContactKeys.keysToFetch)
        var contactsToDelete = [CNMutableContact]()
        do {
            try store.enumerateContacts(with: request, usingBlock: { contact, stop in
                contactsToDelete.append(contact.mutableCopy() as! CNMutableContact)
            })
            for contact in contactsToDelete {
                let deleteRequest = CNSaveRequest()
                deleteRequest.delete(contact)
                try store.execute(deleteRequest)
            }
        } catch {
            DispatchQueue.main.async {
                self.showingError.toggle()
            }
        }
    }
    
    func replaceContacts() {
        if !checkPermission() { return }
        loading = true
        DispatchQueue.global().async {
            self.deleteContacts()
            self.addContacts()
        }
    }
    
    func saveContacts() {
        if !checkPermission() { return }
        loading = true
        DispatchQueue.global().async {
            self.addContacts()
        }
    }
    
    private func addContacts() {
        let store = CNContactStore()
        do {
            for contact in contacts {
                let saveRequest = CNSaveRequest()
                saveRequest.add(contact.mutableCopy() as! CNMutableContact, toContainerWithIdentifier: nil)
                try store.execute(saveRequest)
            }
            DispatchQueue.main.async {
                self.loading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.showingError.toggle()
            }
        }
    }
    
    // REVENUECAT
    
    func checkSubscription() {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            self.isProActive = customerInfo?.entitlements.all["Pro"]?.isActive == true
        }
    }
    
}

