//
//  FeedViewController.swift
//  EcoMap
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
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    private func setupBindings() {
        viewModel.onReportsChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.reuseId, for: indexPath) as? FeedCell else {
            return UITableViewCell()
        }
        
        let report = viewModel.report(at: indexPath.row)
        cell.configure(with: report)
        return cell
    }
}

