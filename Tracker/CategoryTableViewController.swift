//
//  CategoryTableViewController.swift
//  Tracker
//
//  Created by Nurbol on 15.11.2024.
//

import UIKit

enum FakeCategories: String, CaseIterable {
    case important = "Важное"
    case habits = "Привычки"
    case sport = "Спорт"
    case nutrition = "Питание"
}

protocol CategoryTableViewControllerDelegate: AnyObject {
    func addCategory(category: String)
}

final class CategoryTableViewController: UIViewController {
    
    weak var delegate: CategoryTableViewControllerDelegate?
    private var titleText: String?
    private var selectedCategory: String?
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let categoryCellIdentifier = "categoryCellIdentifier"
    
    private let addButton: UIButton = {
        let addButton = UIButton()
        addButton.setTitle("Добавить категорию", for: .normal)
        addButton.backgroundColor = UIColor(named: "yp-black")
        addButton.layer.cornerRadius = 16
        addButton.addTarget(self, action: #selector(addButtonTap), for: .touchUpInside)
        return addButton
    }()
    
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
    
    @objc func addButtonTap() {
        guard let selectedCategory else { return }
        delegate?.addCategory(category: selectedCategory)
        dismiss(animated: true)
    }
    
    private func setupUI() {
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: categoryCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        view.backgroundColor = .white
        title = titleText
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(named: "yp-black") ?? .black,
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        
        [tableView, addButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.heightAnchor.constraint(equalToConstant: 300),
            
            addButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
}

extension CategoryTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension CategoryTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellIdentifier, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        let category = FakeCategories.allCases[indexPath.row]
        cell.textLabel?.text = category.rawValue
        cell.accessoryType = (category.rawValue == selectedCategory) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FakeCategories.allCases.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = FakeCategories.allCases[indexPath.row].rawValue
        tableView.reloadData()
    }
}
