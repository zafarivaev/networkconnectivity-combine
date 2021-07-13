//
//  ViewController.swift
//  NetworkConnectivity
//
//  Created by Zafar on 14/07/21.
//

import UIKit

import Combine
import Network

class ViewController: UIViewController {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let monitorQueue = DispatchQueue(label: "monitor")
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.observeNetworkStatus()
    }
    
    // MARK: - Network Status Observation
    private func observeNetworkStatus() {
        NWPathMonitor()
            .publisher(queue: monitorQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                
                self?.textLabel.text = status == .satisfied ?
                    "Connection is OK" : "Connection lost"
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Code
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            self.textLabel.centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            self.textLabel.centerYAnchor
                .constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
}
