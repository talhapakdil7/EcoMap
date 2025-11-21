//
//  FeedCell.swift
//  EcoMap
//
//  Created by Talha Pakdil on 21.11.2025.
//

//
//  FeedCell.swift
//  EcoMap
//

import UIKit
import SDWebImage

final class FeedCell: UITableViewCell {
    
    static let reuseId = "FeedCell"
    
    private let reportImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        reportImageView.translatesAutoresizingMaskIntoConstraints = false
        reportImageView.contentMode = .scaleAspectFill
        reportImageView.clipsToBounds = true
        reportImageView.layer.cornerRadius = 8
        reportImageView.backgroundColor = .secondarySystemBackground
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.font = .boldSystemFont(ofSize: 14)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        
        contentView.addSubview(reportImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            reportImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            reportImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            reportImageView.widthAnchor.constraint(equalToConstant: 80),
            reportImageView.heightAnchor.constraint(equalToConstant: 80),
            reportImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: reportImageView.trailingAnchor, constant: 12),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            descriptionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: reportImageView.trailingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with report: Report) {
        usernameLabel.text = report.username
        descriptionLabel.text = report.description
        
        if let url = URL(string: report.imageUrl) {
            reportImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            reportImageView.image = UIImage(systemName: "photo")
        }
    }
}
