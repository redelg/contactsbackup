//
//  SettingsView.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 27/09/22.
//

import SwiftUI

enum SettingEvent {
    case premium
    case privacy
    case ourApps
    case none
}

struct Setting: Identifiable {
    
    let id: SettingEvent
    let icon: String
    let title: LocalizedStringKey
    
}

struct SettingsView: View {
    
    @State private var showPremium = false
    private var items = [
        Setting(id: .premium, icon: "crown", title: StaticTexts.GetPro),
        Setting(id: .ourApps, icon: "square.grid.2x2", title: StaticTexts.MoreApps),
        Setting(id: .privacy, icon: "exclamationmark.shield", title: StaticTexts.PrivacyPolicy)
    ]
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .foregroundColor(Color.theme.background)
                    .frame(height: 20)
                ForEach(items) { item in
                    Button(action: {
                        self.handleEvent(item.id)
                    }, label: {
                        HStack {
                            Image(systemName: item.icon)
                                .foregroundColor(.theme.accent)
                            Text(item.title)
                                .fontWeight(.semibold)
                                .font(.subheadline)
                                .padding(.leading, 10)
                            Spacer()
                        }
                    })
                    .padding(.leading, 20)
                    .frame(height: 35)
                    Divider()
                }
                .buttonStyle(.plain)
                HStack {
                    Image(systemName: "exclamationmark.circle")
                        .foregroundColor(.theme.accent)
                    Text("Version \(StaticTexts.appVersion ?? "")")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .padding(.leading, 10)
                    Spacer()
                }
                .padding(.leading, 20)
                .frame(height: 35)
                Spacer()
            }
        }
        .sheet(isPresented: $showPremium) {
            PremiumView()
        }
        .navigationBarHidden(false)
        .navigationTitle(StaticTexts.Settings)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(EnvironmentViewModel())
    }
}

extension SettingsView {
    
    func handleEvent(_ type: SettingEvent) {
        switch type {
        case .premium:
            showPremium.toggle()
        case .privacy:
            handlePrivacy()
        case .ourApps:
            handleMoreApps()
        case .none:
            break
        }
    }
    
    func handleMoreApps() {
        guard let url = URL(string: "https://apps.apple.com/pe/developer/renzo-delgado/id1506040089")
                else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(url)
    }
    
    func handlePrivacy() {
        guard let url = URL(string: "https://codergangteam.com/?page_id=3")
                else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(url)
    }
    
}

