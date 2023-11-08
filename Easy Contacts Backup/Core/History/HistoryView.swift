//
//  HistoryView.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 20/09/22.
//

import SwiftUI

struct HistoryView: View {
    
    @StateObject private var viewModel = HistoryViewModel()
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel

    var body: some View {
        VStack {
            if viewModel.history.isEmpty {
                Spacer()
                Text(StaticTexts.NoHistory)
                Spacer()
            } else {
                List(viewModel.history) { history in
                    NavigationLink {
                        ExportDetailView(export: history)
                            .environmentObject(environmentViewModel)
                    } label: {
                        HistoryItemView(export: history)
                    }
                    .buttonStyle(.borderless)
                }
                .listStyle(.plain)
            }
            if !environmentViewModel.isProActive {
                BannerAdView(adUnit: Ads.banner_main, adFormat: .adaptiveBanner)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(StaticTexts.History)
        .onAppear {
            viewModel.updateHistory()
        }
    }
    
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(EnvironmentViewModel())
    }
}
