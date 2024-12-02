//
//  TabBarController.swift
//  Tracker
//
//  Created by Nurbol on 31.10.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "trackers-on"), tag: 0)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "stat-off"), tag: 1)
        
        viewControllers = [trackersViewController, statisticsViewController]
    }
}
