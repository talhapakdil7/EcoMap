//
//  FeedViewController.swift
//  EcoMap
//
//  Created by Talha Pakdil on 20.11.2025.
//
import UIKit

final class FeedViewController: UIViewController {
    
    private let viewModel = FeedViewModel()
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Feed"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupBindings()
        
        viewModel.startListeningReports()
    }
    
    private func setupTableView() {
        // tableView'ı view'e ekle
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Basit bir standart hücre kullanalım
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FeedCell")
    }
    
    private func setupBindings() {
        viewModel.onReportsChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource & Delegate
extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath)
        
        let report = viewModel.report(at: indexPath.row)
        
        // Şimdilik sadece username + description gösterelim
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(report.username): \(report.description)"
        
        return cell
    }
}
