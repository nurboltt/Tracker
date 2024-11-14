//
//  AddTrackerViewController.swift
//  Tracker
//
//  Created by Nurbol on 11.11.2024.
//

import UIKit

final class AddTrackerViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Создание трекера"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        let habitButton = createCustomButton(withTitle: "Привычка")
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        let irregularEventButton = createCustomButton(withTitle: "Нерегулярное событие")
        irregularEventButton.addTarget(self, action: #selector(irregularEventButtonTapped), for: .touchUpInside)
        
        view.backgroundColor = .white
        [titleLabel,habitButton, irregularEventButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 50),
            
            irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 10),
            irregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    private func createCustomButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    @objc private func habitButtonTapped() {
        let newHabitViewController = NewHabitViewController()
        newHabitViewController.titleText = "Новая привычка"
        newHabitViewController.modalPresentationStyle = .popover
        present(newHabitViewController, animated: true, completion: nil)
        print("Привычка tapped")
    }
    
    @objc private func irregularEventButtonTapped() {
        let newHabitViewController = NewHabitViewController()
        newHabitViewController.titleText = "Новое нерегулярное событие"
        newHabitViewController.modalPresentationStyle = .popover
        present(newHabitViewController, animated: true, completion: nil)
        print("Нерегулярное событие tapped")
    }
}
