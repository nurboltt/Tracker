//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Nurbol on 15.11.2024.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
       let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return titleLabel
    }()
    
    let switcher: UISwitch = {
       let switcher = UISwitch()
        switcher.onTintColor = UIColor(named: "coll-blue")
        switcher.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
       return switcher
    }()
    var onSwitchToggle: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCellUI()
    }
    
    private func setupCellUI() {
        selectionStyle = .none
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        backgroundColor = UIColor(named: "yp-light-gray")
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        [titleLabel, switcher].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: switcher.centerYAnchor),
            
            switcher.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switcher.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22)
        ])
    }
    
    @objc private func switchToggled(_ sender: UISwitch) {
           onSwitchToggle?(sender.isOn)
       }
    
    func configure(with title: String) {
           titleLabel.text = title
       }
    
}
