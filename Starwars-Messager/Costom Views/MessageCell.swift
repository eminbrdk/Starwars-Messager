//
//  MessageCell.swift
//  Starwars-Messager
//
//  Created by Muhammed Emin Bardakcı on 3.03.2023.
//

import UIKit

class MessageCell: UITableViewCell {

    static let reuseID = "MessageCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        selectionStyle = .none
    }
}
