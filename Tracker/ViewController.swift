//
//  ViewController.swift
//  Tracker
//
//  Created by Nurbol on 26.10.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    let label = UILabel()
    
    func ad() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .red
        label.sizeToFit()
        label.textAlignment = .center
        view.addSubview(label)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ad()
        // Do any additional setup after loading the view.
    }


}

