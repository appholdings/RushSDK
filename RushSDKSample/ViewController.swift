//
//  ViewController.swift
//  RushSDKSample
//
//  Created by Andrey Chernyshev on 06.10.2020.
//

import UIKit
import RushSDK

class ViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(displayP3Red: 244, green: 244, blue: 244, alpha: 1)
        button.setTitle("Tap", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }()
    
    private let test = Test()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 42),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -42),
            button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50)
        ])
        
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc
    func tapped() {
        titleLabel.text = "123"
    }
}
