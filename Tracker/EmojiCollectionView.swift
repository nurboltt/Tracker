//
//  EmojiCollectionView.swift
//  Tracker
//
//  Created by Nurbol on 13.11.2024.
//

import UIKit

final class EmojiCollectionView: UICollectionReusableView {
    let titleLabel = UILabel()
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                   titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                   titleLabel.topAnchor.constraint(equalTo: topAnchor),
                   titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
               ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
