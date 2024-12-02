//
//  AddTrackerViewController.swift
//  Tracker
//
//  Created by Nurbol on 11.11.2024.
//

import UIKit

protocol AddTrackerViewControllerDelegate: AnyObject {
    func didOpenNewModal(_ button: UIButton)
}

final class AddTrackerViewController: UIViewController {
    
    private let habitButton: UIButton = {
       let habitButton = UIButton()
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        habitButton.setTitleColor(.white, for: .normal)
        habitButton.backgroundColor = .black
        habitButton.layer.cornerRadius = 16
        habitButton.tag = 0
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        return habitButton
    }()
    
    private let irregularEventButton: UIButton = {
       let irregularEventButton = UIButton()
        irregularEventButton.setTitle("Нерегулярное событие", for: .normal)
        irregularEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        irregularEventButton.setTitleColor(.white, for: .normal)
        irregularEventButton.backgroundColor = .black
        irregularEventButton.layer.cornerRadius = 16
        irregularEventButton.tag = 1
        irregularEventButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        return irregularEventButton
    }()
    
    weak var delegate: AddTrackerViewControllerDelegate?
    private var titleText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(titleText: String? = nil) {
        self.titleText = titleText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        title = titleText
        view.backgroundColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(named: "yp-black") ?? .black,
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        
        [habitButton, irregularEventButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
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
    
    @objc private func habitButtonTapped(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didOpenNewModal(sender)
        }
    }
}
