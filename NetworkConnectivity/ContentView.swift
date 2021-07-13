//
//  ContentView.swift
//  NetworkConnectivity
//
//  Created by Zafar on 13/07/21.
//

import SwiftUI
import Combine
import Network

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        Text(viewModel.networkStatus == .satisfied ? "Connection is OK" : "Connection lost")
            .padding()
    }
}


class ViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let monitorQueue = DispatchQueue(label: "monitor")
    
    @Published var networkStatus: NWPath.Status = .satisfied
    
    init() {
        NWPathMonitor()
            .publisher(queue: monitorQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.networkStatus = status
            }
            .store(in: &cancellables)
    }
}
