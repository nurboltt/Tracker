//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Nurbol on 31.10.2024.
//

import UIKit

final class TrackersViewController: UIViewController, UITextFieldDelegate {
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date = Date()
    
    private let countNumber: CGFloat = 2
    
    private let headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let plusButton: UIButton = {
        let plusButton = UIButton(type: .system)
        plusButton.setImage(UIImage(named: "addButton"), for: .normal)
        plusButton.tintColor = UIColor(named: "yp-black")
        plusButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        return plusButton
    }()
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .clear
        datePicker.locale = Locale(identifier: "ru_Ru")
        datePicker.calendar.firstWeekday = 2
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 8
        datePicker.tintColor = .blue
        datePicker.maximumDate = currentDate
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return datePicker
    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Трекеры"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        return titleLabel
    }()
    private let searchStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 14
        return stack
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.backgroundColor = UIColor(named: "yp-light-gray")
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 17, weight: .medium)
        textField.layer.cornerRadius = 16
        textField.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]
        let attriButedPlaceHolder = NSAttributedString(
            string: "Поиск",
            attributes: attributes
        )
        textField.attributedPlaceholder = attriButedPlaceHolder
        textField.delegate = self
        return textField
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.tintColor = .blue
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.isHidden = true
        return button
    }()
    
    private let placeHolderView: UIView = {
        let placeHolderView = UIView()
        placeHolderView.backgroundColor = .lightGray
        return placeHolderView
    }()
    
    private let imageView: UIImageView = {
        let image = UIImage(named: "empty-tracker")
        let view = UIImageView(image: image)
        return view
    }()
    private let emptyLabel: UILabel = {
        let emptyLabel = UILabel()
        emptyLabel.text = "Что будем отслеживать?"
        emptyLabel.textColor = .black
        emptyLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return emptyLabel
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 167, height: 148)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 9
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView
            .register(
                TrackerCell.self,
                forCellWithReuseIdentifier: TrackerCell.trackerCellIdentifier
            )
        collectionView.register(
            EmojiCollectionView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateChanged(datePicker)
        setupConstraints()
        reloadData()
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
         currentDate = sender.date
        reloadVisibleCategories(text: searchTextField.text, date: datePicker.date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func addTask() {
        let addTrackerViewController = AddTrackerViewController(titleText: "Создание трекера")
        addTrackerViewController.trackerSelectedClosure = { [weak self] tracker in
            self?.dismiss(animated: true)
            
            guard let self = self else { return }
            
            if let index = self.categories.firstIndex(where: { $0.title == "Важное" }) {
                self.categories[index] = TrackerCategory(
                    title: self.categories[index].title,
                    trackers: self.categories[index].trackers + [tracker]
                )
            } else {
                self.categories.append(TrackerCategory(title: "Важное", trackers: [tracker]))
            }
            self.reloadVisibleCategories(text: nil, date: self.datePicker.date)
        }
        
        let vc = UINavigationController(rootViewController: addTrackerViewController)
        vc.modalPresentationStyle = .popover
        present(vc, animated: true, completion: nil)
    }
    
    private func reloadVisibleCategories(text: String?, date: Date) {
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: date)
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                if let eventDate = tracker.eventDate {
                    return calendar.isDate(eventDate, inSameDayAs: date)
                } else if !tracker.schedule.isEmpty {
                    return tracker
                        .schedule
                        .map { $0.numberValue }
                        .contains(filterWeekday)
                }
                return false
            }
            
            guard !trackers.isEmpty else { return nil }
            
            return  TrackerCategory(
                title: category.title,
                trackers: trackers
            )
        }
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
    private func reloadPlaceholder() {
        placeHolderView.isHidden = !visibleCategories.isEmpty
    }
    
    private func reloadData() {
        reloadVisibleCategories(text: nil, date: datePicker.date)
        guard !visibleCategories.isEmpty else {
            return
        }
        collectionView.reloadData()
    }
    
    private func setupConstraints() {
        view.backgroundColor = .white
        [headerView, collectionView, placeHolderView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        [plusButton, titleLabel, datePicker, searchStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview($0)
        }
        [imageView, emptyLabel,].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            placeHolderView.addSubview($0)
        }
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 138),
            
            plusButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            plusButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 5),
            
            datePicker.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            datePicker.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: 128),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            
            searchStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            searchStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -1),
            searchStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            placeHolderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 220),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let trackers = visibleCategories[section].trackers
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.trackerCellIdentifier,
            for: indexPath
        ) as? TrackerCell else { return UICollectionViewCell() }
        cell.contentView.backgroundColor = .white
        cell.prepareForReuse()
        
        let cellData = visibleCategories
        
        if indexPath.section < cellData.count,
           indexPath.row < cellData[indexPath.section].trackers.count {
            let tracker = cellData[indexPath.section].trackers[indexPath.row]
            let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
            let completedDays = completedTrackers.filter { $0.trackerId == tracker.id }.count
            cell.configure(
                with: tracker,
                isCompletedToday: isCompletedToday,
                completedDays: completedDays,
                indexPath: indexPath)
        } else {
            print("Invalid index path: \(indexPath)")
        }
        cell.delegate = self
        return cell
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
    }
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.trackerId == id && isSameDay
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let id: String = (kind == UICollectionView.elementKindSectionHeader) ? "header" : ""
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? EmojiCollectionView else { return UICollectionReusableView() }
        view.titleLabel.text = visibleCategories[indexPath.section].title
        return view
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = (countNumber - 1) * 9
        
        let availableWidth = collectionView.bounds.width - spacing
        let cellWidth = availableWidth / countNumber
        let cellHeight: CGFloat = 148
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: 30),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(trackerId: id, date: datePicker.date)
        if !completedTrackers.contains(where: { $0.trackerId == id && Calendar.current.isDate($0.date, inSameDayAs: datePicker.date)}) {
            completedTrackers.append(trackerRecord)
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}
