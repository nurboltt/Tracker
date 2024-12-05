//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Nurbol on 11.11.2024.
//

import UIKit

final class NewHabitViewController: UIViewController, UITextFieldDelegate {
    
    var trackerSelectedClosure: ((Tracker) -> Void)?
    
    var isScheduleSelected = false
    private var titleText: String?
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var cells: [TableViewCellType]
    private var newSchedule: [WeekDay] = []
 
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = UIColor(named: "yp-light-gray")
        textField.layer.cornerRadius = 17
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.delegate = self
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor(named: "yp-light-red"), for: .normal)
        cancelButton.layer.borderColor = UIColor(named: "yp-light-red")?.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return cancelButton
    }()
    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.setTitle("Создать", for: .normal)
        createButton.backgroundColor = UIColor(named: "yp-gray")
        createButton.layer.cornerRadius = 16
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return createButton
    }()
    
    init(titleText: String? = nil, cells: [TableViewCellType]) {
        self.titleText = titleText
        self.cells = cells
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateCreateButtonState()
        collectionView.reloadData()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white
        title = titleText
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(named: "yp-black") ?? .black,
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.cellIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.emojiCellIdentifier)
        
        [ textField, cancelButton, createButton, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.heightAnchor.constraint(equalToConstant: 200),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor),
            
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func updateCellDescription(in cells: inout [TableViewCellType], at index: Int, with newDescription: String) {
        if case .schedule = cells[index] {
            cells[index] = .schedule(newDescription)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldDidChange() {
        updateCreateButtonState()
        guard let text = textField.text, !text.isEmpty else {
            createButton.backgroundColor = UIColor(named: "yp-gray")
            return
        }
        createButton.backgroundColor = UIColor(named: "yp-black")
    }
    
    private func updateCreateButtonState() {
        createButton.isEnabled = !(textField.text?.isEmpty ?? true)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func createButtonTapped() {
        
        guard let trackerTitle = textField.text, !trackerTitle.isEmpty else {
            return
        }
        
        let isIrregular = cells.firstIndex {
            if case .schedule = $0 { return true }
            return false
        } == nil
        
        let newTracker = Tracker(
            id: UUID(),
            title: trackerTitle,
            color: UIColor(named: "coll-orange") ?? .orange,
            emoji: "❤️",
            schedule: isIrregular ? [] : newSchedule,
            eventDate: isIrregular ? Date() : nil
        )
        trackerSelectedClosure?(newTracker)
        
        dismiss(animated: true, completion: nil)
    }
}

extension NewHabitViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.cellIdentifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: cells[indexPath.row].title, description: cells[indexPath.row].description)
        return cell
    }
    
    
}

extension NewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let scheduleTableViewController = ScheduleTableViewController(titleText: "Расписание")
            scheduleTableViewController.delegate = self
            let vc = UINavigationController(rootViewController: scheduleTableViewController)
            vc.modalPresentationStyle = .popover
            present(vc, animated: true, completion: nil)
        }
    }
}

extension NewHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Constants.emoji.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.emojiCellIdentifier, for: indexPath) as? EmojiCollectionViewCell else { return UICollectionViewCell() }
        cell.titleLabel.text = Constants.emoji[indexPath.row]
        return cell
    }
}

extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 10) / 6, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension NewHabitViewController: ScheduleTableViewControllerDelegate {
    func saveSchedule(selectedDays: [WeekDay]) {
        
        newSchedule = selectedDays
        let daysString = selectedDays.map { $0.shortName }.joined(separator: ", ")
        if let index = cells.firstIndex(where: {
            if case .schedule = $0 { return true }
            return false
        }) {
            updateCellDescription(in: &cells, at: index, with: daysString)
        }
        tableView.reloadData()
    }
}

extension NewHabitViewController: CategoryTableViewControllerDelegate {
    func addCategory(category: String) {
        if let index = cells.firstIndex(where: {
            if case .category = $0 { return true }
            return false
        }) {
            cells[index] = .category(category)
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
}
