//
//  WhoAreYouVC.swift
//  Starwars-Messager
//
//  Created by Muhammed Emin Bardakcı on 3.03.2023.
//

import UIKit

class WhoAreYouVC: UIViewController {

    let image = UIImageView()
    let darthVaderButton = UIButton()
    let lukeSkywalkerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureImage()
        configureDarthVaderButton()
        configureLukeSkywalkerButton()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
    }
    
    func configureImage() {
        view.addSubview(image)
        
        image.image = UIImage(named: "TheMan")
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 200),
            image.widthAnchor.constraint(equalTo: image.heightAnchor)
        ])
    }
    
    func configureDarthVaderButton() {
        configureButtons(button: darthVaderButton, text: "Darth Vader", color: .systemRed)
        
        NSLayoutConstraint.activate([
            darthVaderButton.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 40)
        ])
    }
    
    func configureLukeSkywalkerButton() {
        configureButtons(button: lukeSkywalkerButton, text: "Luke Skywalker", color: .systemGreen)
        
        NSLayoutConstraint.activate([
            lukeSkywalkerButton.topAnchor.constraint(equalTo: darthVaderButton.bottomAnchor, constant: 15)
        ])
    }
    
    func configureButtons(button: UIButton, text: String, color: UIColor) {
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.configuration?.title = text
        button.configuration?.baseBackgroundColor = color
        button.configuration?.baseForegroundColor = UIColor.white
        button.configuration?.cornerStyle = .medium
        
        let padding: CGFloat = 25
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            button.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    @objc func buttonPressed(sender: UIButton!) {
        let chatVC = ChatVC()
        chatVC.title = sender!.titleLabel!.text! == "Luke Skywalker" ? "Darth Vader" : "Luke Skywalker"
        chatVC.messager = sender!.titleLabel!.text!
        navigationItem.backButtonTitle = ""
        chatVC.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
