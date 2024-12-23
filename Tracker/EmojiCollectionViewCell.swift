//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Nurbol on 13.11.2024.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    static let emojiCellIdentifier = "emojiCell"
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(text: String) {
        titleLabel.text = text
    }
}
