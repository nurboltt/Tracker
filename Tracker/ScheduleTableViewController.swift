//
//  ScheduleTableViewController.swift
//  Tracker
//
//  Created by Nurbol on 15.11.2024.
//

import UIKit

enum WeekDay: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    
    var shortName: String {
        switch self {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
    
    var numberValue: Int {
            switch self {
            case .monday:
                return 1
            case .tuesday:
                return 2
            case .wednesday:
                return 3
            case .thursday:
                return 4
            case .friday:
                return 5
            case .saturday:
                return 6
            case .sunday:
                return 7
            }
        }
}

protocol ScheduleTableViewControllerDelegate: AnyObject {
    func saveSchedule(selectedDays: [WeekDay])
}

final class ScheduleTableViewController: UIViewController {
    
    weak var delegate: ScheduleTableViewControllerDelegate?
    private var selectedDays: [WeekDay] = []
    private var titleText: String?
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let scheduleCellIdentifier = "scheduleCellIdentifier"
    private let doneButton: UIButton = {
        let doneButton = UIButton()
        doneButton.setTitle("Готово", for: .normal)
        doneButton.backgroundColor = UIColor(named: "yp-black")
        doneButton.layer.cornerRadius = 16
        doneButton.addTarget(self, action: #selector(doneButtonTap), for: .touchUpInside)
        return doneButton
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
    
    private func setupUI() {
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: scheduleCellIdentifier)
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
        
        [tableView, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.heightAnchor.constraint(equalToConstant: 600),
            
            doneButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -10),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    @objc private func doneButtonTap() {
        print("done button tapped")
        delegate?.saveSchedule(selectedDays: selectedDays)
        dismiss(animated: true, completion: nil)
    }
}

extension ScheduleTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension ScheduleTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: scheduleCellIdentifier, for: indexPath) as? ScheduleTableViewCell else {
            return UITableViewCell()
        }
        let weekDay = WeekDay.allCases[indexPath.row]
        cell.configure(with: weekDay.rawValue)
        cell.switcher.isOn = selectedDays.contains(weekDay)
        
        cell.onSwitchToggle = { [weak self] isOn in
            guard let self else { return }
            if isOn {
                self.selectedDays.append(weekDay)
            } else {
                self.selectedDays.removeAll { $0 == weekDay }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
}
