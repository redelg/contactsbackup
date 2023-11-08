//
//  MainView.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 17/09/22.
//

import SwiftUI

struct MainView: View {
    
    @State private var fill = 0.0
    @StateObject private var exportVM = ExportViewModel()
    @State private var exportFormat: ExportFormat = .vcard
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel

    var body: some View {
        ZStack {
            Color.theme.background
            VStack {
                Spacer()
                contactsInfo
                if exportVM.size > 0 {
                    Picker(StaticTexts.ExportFormat, selection: $exportFormat) {
                        Text("vCard").tag(ExportFormat.vcard)
                        Text("CSV/Excel").tag(ExportFormat.csv)
                    }
                    .frame(width: 350)
                    .pickerStyle(.segmented)
                    .padding(.top, 20)
                }
                exportButton
                historyButton
                Spacer()
                if !environmentViewModel.isProActive {
                    BannerAdView(adUnit: Ads.banner_main, adFormat: .adaptiveBanner)
                } else {
                    HStack {
                        Text("Pro")
                            .fontWeight(.semibold)
                        Image(systemName: "crown")
                    }
                    .foregroundColor(.theme.accent)
                    .padding()
                }
            }
            .onReceive(exportVM.$size, perform: { size in
                fill = size
            })
            if exportVM.loading {
                LoadingView()
            }
        }
        .navigationBarHidden(true)
        .overlay(
            NavigationLink (destination: SettingsView().environmentObject(environmentViewModel), label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .foregroundColor(Color.theme.accent)
            }), alignment: .topTrailing
        )
        .onAppear {
            exportVM.getContacts()
            exportVM.checkSubscription()
        }
        .sheet(isPresented: $exportVM.showShare, content: {
            ShareSheet(item: exportVM.url!)
        })
        .alert(isPresented: $exportVM.showingAlert) {
            switch exportVM.alertType {
            case .permission:
                return Alert(title: Text(StaticTexts.PermissionTitle), message: Text(StaticTexts.PermissionDescription), dismissButton: .default(Text(StaticTexts.GotIt), action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
            case .noContacts:
                return Alert(title: Text(StaticTexts.NoContactsTitle), message: Text(StaticTexts.NoContactsDescription), dismissButton: .default(Text(StaticTexts.GotIt), action: {}))
            case .limit:
                return Alert(title: Text(StaticTexts.LimitTitle), message: Text(StaticTexts.LimitDescription), dismissButton: .default(Text(StaticTexts.GotIt), action: {
                    switch exportFormat {
                    case .vcard:
                        exportVM.exportToVcard()
                    case .csv:
                        exportVM.exportToCsv()
                    }
                }))
            }
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension MainView {
    
    var contactsInfo: some View {
        ZStack {
            
            Circle()
                .stroke(Color.black.opacity(0.1) ,style: StrokeStyle(lineWidth: 35))
            
            Circle()
                .trim(from: 0, to: fill)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color.theme.gradientStart, Color.theme.gradientEnd]), startPoint: .top, endPoint: .bottom)
                    ,style: StrokeStyle(lineWidth: 25, lineCap: .round))
                .rotationEffect(.init(degrees: -90))
                .animation(.linear(duration: 2), value: fill)
            
            VStack {
                Text("\(exportVM.contacts.count)")
                    .font(.title)
                Text(StaticTexts.Contacts)
                    .fontWeight(.medium)
            }
            
        }
        .frame(width: 250)
        .padding(.bottom, 10)
    }
    
    var exportButton: some View {
        Button(action: {
            exportVM.export(format: exportFormat)
        }, label: {
            Text(StaticTexts.Export)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(width: 300, height: 55)
        })
        .background(Color.theme.accent)
        .contentShape(Rectangle())
        .cornerRadius(40)
        .padding(.top, 20)
    }
 
    var historyButton: some View {
        NavigationLink(destination: HistoryView().environmentObject(environmentViewModel)) {
            Text(StaticTexts.History)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(width: 300, height: 55)
        }
        .background(Color.theme.accent)
        .cornerRadius(40)
        .padding(.top, 10)
    }

    
}
