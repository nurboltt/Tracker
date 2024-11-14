//
//  TabBarController.swift
//  Tracker
//
//  Created by Nurbol on 31.10.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let trackers = self.createNav(with: "Трекеры", and: UIImage(named: "trackers-on"), vc: TrackersViewController())
        
        let statistics = self.createNav(with: "Статистика", and: UIImage(named: "stat-off"), vc: StatisticsViewController())
        self.setViewControllers([trackers, statistics], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.navigationBar.prefersLargeTitles = true
        vc.navigationItem.title = title
        vc.navigationItem.largeTitleDisplayMode = .always
        
        if vc is TrackersViewController {
            let leftButton = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(handleLeftButton))
            leftButton.tintColor = .black
            vc.navigationItem.leftBarButtonItem = leftButton
            
            let datePicker = UIDatePicker()
            datePicker.preferredDatePickerStyle = .compact
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
                        
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Поиск"
            vc.navigationItem.searchController = searchController
        }
        
        return nav
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    @objc private func handleLeftButton() {
        let addTrackerViewController = AddTrackerViewController()
        addTrackerViewController.modalPresentationStyle = .popover
        present(addTrackerViewController, animated: true, completion: nil)
        print("Левая кнопка нажата")
    }
    
}
