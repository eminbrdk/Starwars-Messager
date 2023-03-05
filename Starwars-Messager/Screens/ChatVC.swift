//
//  ChatVC.swift
//  Starwars-Messager
//
//  Created by Muhammed Emin Bardakcı on 3.03.2023.
//

import UIKit

class ChatVC: UIViewController {
    
    var messager: String!
    var messages: [Message] = []

    let tableView = UITableView()
    
    let bottomView = UIView()
    let textField = UITextField()
    let sentButton = UIButton()

    let textFieldHeihgt: CGFloat = 38
    let padding: CGFloat = 10
    let bottomViewHeight: CGFloat = 60
    
    var topOfTableViewConstraint: NSLayoutConstraint!
    var heightOfTableView: CGFloat = 600
    var keyboardHeight: CGFloat = 0
    var unusedBottomAreaHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        takeSizeData()
        addFuncsForKeyboard()
        configureVC()
        configureBottomView()
        configureSentButton()
        configureTextField()
        takeData()
        configureTableView()
    }
    
// MARK: - Keyboard and TableView Size
    func addFuncsForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func takeSizeData() {
        if #available(iOS 15.0, *) {
            let window = UIApplication.shared.windows.first
            let nbh = self.navigationController!.navigationBar.frame.size.height
            let topPadding = window!.safeAreaInsets.top
            unusedBottomAreaHeight = window!.safeAreaInsets.bottom
            let viewHeight = view.frame.height
            
            heightOfTableView = viewHeight - topPadding - unusedBottomAreaHeight - nbh - bottomViewHeight
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                
                heightOfTableView -= keyboardHeight
                topOfTableViewConstraint.constant = -heightOfTableView - unusedBottomAreaHeight
            }
        }
    }
    
    @objc func keyboardDidShow() {
        scrollToBottomOfChat()
    }
    
    @objc func keyboardDidHide() {
        scrollToBottomOfChat()
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            
            heightOfTableView += keyboardHeight
            topOfTableViewConstraint.constant = -heightOfTableView
            
            scrollToBottomOfChat()
        }
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
// MARK: -Configuration
    func configureVC() {
        view.backgroundColor = .systemBackground
    }
    
    func configureBottomView() {
        bottomView.backgroundColor = .systemGray
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomViewHeight),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureTextField() {
        textField.placeholder = "A long time ago in a galaxy far, far away"
        textField.backgroundColor = .white
        textField.textAlignment = .left
        textField.textColor = .black
        textField.layer.cornerRadius = textFieldHeihgt / 2
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(gray: 0.3, alpha: 0)
        textField.autocorrectionType = .no
        textField.returnKeyType = .send
        
        textField.delegate = self
        createDismissKeyboardTapGesture()
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.rightViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: padding),
            textField.trailingAnchor.constraint(equalTo: sentButton.leadingAnchor, constant: -padding),
            textField.heightAnchor.constraint(equalToConstant: textFieldHeihgt)
        ])
    }
    
    func configureSentButton() {
        sentButton.configuration = .filled()
        sentButton.configuration?.cornerStyle = .capsule
        sentButton.configuration?.baseBackgroundColor = .systemGreen // arka plan rengi
        sentButton.configuration?.baseForegroundColor = .systemBackground
        
        sentButton.configuration?.image = UIImage(systemName: "paperplane")
        sentButton.configuration?.imagePlacement = .all
        
        sentButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(sentButton)
        
        sentButton.addTarget(self, action: #selector(sentButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            sentButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10),
            sentButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -padding),
            sentButton.heightAnchor.constraint(equalToConstant: textFieldHeihgt),
            sentButton.widthAnchor.constraint(equalTo: sentButton.heightAnchor)
        ])
    }
    
    @objc func sentButtonPressed() {
        guard let text = textField.text else { return }
        
        PersistanceManager.addData(message: text, person: messager) { [weak self] error in
            guard let self = self else { return }
            self.textField.text = ""
            
            guard let error = error else {
                self.messages.append(Message(message: text, person: self.messager))
                self.tableView.reloadData()
                self.scrollToBottomOfChat()
                return
            }
            print(error.rawValue)
        }
    }
    
// MARK: - Table View
    func takeData() {
        PersistanceManager.takeData { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let messages):
                self.messages = messages
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none // çizgileri kaldırdık
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseID)
        
        scrollToBottomOfChat()
        
        topOfTableViewConstraint = tableView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: -heightOfTableView)
        
        NSLayoutConstraint.activate([
            topOfTableViewConstraint,
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
        ])
    }
    
    func scrollToBottomOfChat() {
        let indexPath = IndexPath(row: self.messages.count-1, section: 0)
        if !messages.isEmpty {
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}


extension ChatVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sentButtonPressed()
        return true
    }
}


extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseID) as! MessageCell
        let message = messages[indexPath.row]
        
        cell.textLabel?.text = message.message
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = message.person == self.messager ? .right : .left
        
        return cell
    }
}
