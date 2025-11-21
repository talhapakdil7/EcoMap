//
//  MainTabBarController.swift
//  EcoMap
//
//  Created by Talha Pakdil on 20.11.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
    }
    
    private func setupTabs() {
        
        // 1) Feed
        let feedVC = FeedViewController()
        let feedNav = UINavigationController(rootViewController: feedVC)
        feedNav.tabBarItem = UITabBarItem(
            title: "Feed",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet")
        )
        
        // 2) Upload
        let uploadVC = UploadViewController()
        let uploadNav = UINavigationController(rootViewController: uploadVC)
        uploadNav.tabBarItem = UITabBarItem(
            title: "Upload",
            image: UIImage(systemName: "plus.app"),
            selectedImage: UIImage(systemName: "plus.app.fill")
        )
        
        // 3) Harita (TrashMap)
        let mapVC = TrashMapViewController()
        let mapNav = UINavigationController(rootViewController: mapVC)
        mapNav.tabBarItem = UITabBarItem(
            title: "Harita",
            image: UIImage(systemName: "map"),
            selectedImage: UIImage(systemName: "map.fill")
        )
        
        // 4) User
        let userVC = UserViewController()
        let userNav = UINavigationController(rootViewController: userVC)
        userNav.tabBarItem = UITabBarItem(
            title: "User",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        // TabBar'ı oluşturuyoruz
        viewControllers = [feedNav, uploadNav, mapNav, userNav]
        
        // Seçili tab icon rengi
        tabBar.tintColor = .systemGreen
    }
}

