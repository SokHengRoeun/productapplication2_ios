//
//  MainTableViewCell.swift
//  ProductAppProgramming
//
//  Created by SokHeng on 11/11/22.
//

import UIKit

class MainTableCell: UITableViewCell {
    var productNameLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Name"
        myLabel.font = .boldSystemFont(ofSize: 18)
        return myLabel
    }()
    var productCategoryLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Category"
        return myLabel
    }()
    var wowContainer: UIStackView = {
        let myStackView = UIStackView()
        myStackView.axis = .vertical
        return myStackView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(wowContainer)
        wowContainer.addArrangedSubview(productNameLabel)
        wowContainer.addArrangedSubview(productCategoryLabel)
        configureConstrants()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension MainTableCell {
    func configureConstrants() {
        wowContainer.translatesAutoresizingMaskIntoConstraints = false
        wowContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        wowContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10).isActive = true
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.leftAnchor.constraint(equalTo: wowContainer.leftAnchor, constant: 10).isActive = true
        productNameLabel.rightAnchor.constraint(equalTo: wowContainer.rightAnchor, constant: 10).isActive = true
        productCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        productCategoryLabel.leftAnchor.constraint(equalTo: wowContainer.leftAnchor, constant: 10).isActive = true
        productCategoryLabel.rightAnchor.constraint(equalTo: wowContainer.rightAnchor, constant: 10).isActive = true
    }
}
