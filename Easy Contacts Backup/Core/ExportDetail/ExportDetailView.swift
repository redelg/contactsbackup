//
//  ExportDetailView.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 21/09/22.
//

import SwiftUI
import Contacts

enum ConfirmationType {
    case restore
    case delete
    case export
}

struct ContactGroup: Hashable {
    var header: String = ""
    var contacts: [CNContact] = []
}

extension CNContact: Identifiable { 
    public var id: UUID { UUID() } 
}

struct ExportDetailView: View {
    
    private let dateFormat: DateFormatter = {
        var mydf = DateFormatter()
        mydf.dateStyle = .medium // set as desired
        mydf.timeStyle = .short
        return mydf
    }()
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel

    var export: Export
    private var contacts: [CNContact]
    private var contactGroup: [ContactGroup]
    
    @StateObject private var exportViewModel: ExportViewModel
    @State private var contact: CNContact? = nil
    @State private var showConfirmation = false
    @State private var confirmationType: ConfirmationType = .restore
    
    init(export: Export) {
        self.export = export
        contacts = []
        contactGroup = []
        do {
            let temp = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(self.export.contacts!) as! [CNContact]
            _exportViewModel = StateObject(wrappedValue: ExportViewModel(contacts: temp))
            contacts = temp
            contacts = contacts.sorted { $0.givenName < $1.givenName }
        } catch {
            contacts = []
            _exportViewModel = StateObject(wrappedValue: ExportViewModel(contacts: []))
        }
        String.alphabet.forEach { letter in
            let filter = contacts.filter({
                if $0.givenName.isEmpty {
                    return $0.organizationName.first?.uppercased() == letter
                } else {
                    return $0.givenName.first?.uppercased() == letter
                }
            })
            if !filter.isEmpty {
                var group = ContactGroup()
                group.header = letter.uppercased()
                group.contacts = filter
                contactGroup.append(group)
            }
        }
        let filter = contacts.filter({
            if $0.givenName.isEmpty {
                return !($0.organizationName.first?.isLetter ?? true)
            } else {
                return !($0.givenName.first?.isLetter ?? true)
            }
        })
        if !filter.isEmpty {
            var group = ContactGroup()
            group.header = "#"
            group.contacts = filter
            contactGroup.append(group)
        }
    }
    
    // MARK: MAIN VIEW
    
    var body: some View {
        ZStack (alignment: .bottom) {
            contactList
            buttons
            if exportViewModel.loading {
                LoadingView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(dateFormat.string(from: export.date ?? Date()))
        .navigationViewStyle(StackNavigationViewStyle())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(StaticTexts.Delete) {
                    confirmationType = .delete
                    showConfirmation = true
                }
                .foregroundColor(Color.theme.accent)
            }
            ToolbarItem(placement: .navigationBarLeading) {
              Text("") // empty text in left to prevent back button to disappear
            }
        }
        .sheet(item: $contact, content: { item in
            ZStack (alignment: .topTrailing) {
                ContactDetailView(contact: item)
                Button {
                    self.contact = nil
                } label: {
                    Text(StaticTexts.Done)
                        .fontWeight(.bold)
                }
                .padding()
            }
        })
        .actionSheet(isPresented: $showConfirmation) {
            switch confirmationType {
            case .restore:
                return ActionSheet(title: Text(StaticTexts.RestoreContacts), buttons: [
                    .default(Text(StaticTexts.ReplaceContacts)) {
                        exportViewModel.replaceContacts()
                    },
                    .default(Text(StaticTexts.AddToContacts)) {
                        exportViewModel.saveContacts()
                    },
                    .cancel(Text(StaticTexts.Cancel)) {
                        showConfirmation = false
                    }
                ])
            case .delete:
                return ActionSheet(title: Text(StaticTexts.SelectAction), buttons: [
                    .destructive(Text(StaticTexts.DeleteBackup)) {
                        DataController.shared.delete(export)
                        presentationMode.wrappedValue.dismiss()
                    },
                    .cancel(Text(StaticTexts.Cancel)) {
                        showConfirmation = false
                    }
                ])
            case .export:
                return ActionSheet(title: Text(StaticTexts.ExportContacts), buttons: [
                    .default(Text(StaticTexts.ExportToCSVExcel)) {
                        exportViewModel.exportToCsv(false)
                    },
                    .default(Text(StaticTexts.ExportToVCard)) {
                        exportViewModel.exportToVcard(false)
                    },
                    .cancel(Text(StaticTexts.Cancel)) {
                        showConfirmation = false
                    }
                ])
            }
        }
        .sheet(isPresented: $exportViewModel.showShare, content: {
            ShareSheet(item: exportViewModel.url!)
        })
    }
}

struct ExportDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExportDetailView(export: Export())
            .environmentObject(EnvironmentViewModel())
    }
}


extension ExportDetailView {
    
    var contactList: some View {
        VStack {
            if !environmentViewModel.isProActive {
                BannerAdView(adUnit: Ads.banner_main, adFormat: .adaptiveBanner)
            }
            List(contactGroup, id:\.self) { group in
                Section(header: Text(group.header)) {
                    ForEach(group.contacts, id:\.self) { contact in
                        Button {
                            self.contact = contact
                        } label: {
                            DetailtemView(imageData: contact.imageData,
                                          name: contact.givenName.isEmpty ? contact.organizationName : contact.givenName)
                        }
                        .foregroundColor(.black)
                    }
                }
                if group.header == contactGroup.last!.header {
                    Section(header: Text("")) {
                        EmptyView()
                    }
                    Section(header: Text("")) {
                        EmptyView()
                    }
                }
            }
            .listStyle(.grouped)
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    var buttons: some View {
        HStack {
            Button {
                showConfirmation = true
                confirmationType = .restore
            } label: {
                Text(StaticTexts.Restore)
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
            }
            .background(Color.theme.accent)
            .cornerRadius(30)
            .padding(.leading, 10)
            .padding(.trailing, 5)
            .padding(.bottom, 5)
            
            Button {
                showConfirmation = true
                confirmationType = .export
            } label: {
                Text(StaticTexts.Export)
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
            }
            .background(Color.theme.accent)
            .cornerRadius(30)
            .padding(.trailing, 10)
            .padding(.leading, 5)
            .padding(.bottom, 5)
        }
    }
    
}
