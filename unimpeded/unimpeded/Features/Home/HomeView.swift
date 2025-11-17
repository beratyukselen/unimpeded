//
//  ContentView.swift
//  unimpeded
//
//  Created by Berat Yükselen on 17.11.2025.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text(viewModel.title)
                .padding()
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
