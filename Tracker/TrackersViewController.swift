//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Nurbol on 31.10.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    var tracker = Tracker(id: UUID(), name: "32", color: .red, emoji: "ew", schedule: Date())
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate: Date = Date()
    
    private let imageView: UIImageView = {
        let image = UIImage(named: "empty")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        [imageView, emptyLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
    }
}
