//
//  AddAndEditViewController.swift
//  ProductAppProgramming
//
//  Created by SokHeng on 11/11/22.
//

import UIKit

class AddAndEditViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    let encryptionProtocal = HengCryptology()
    var tempProduct = Product()
    var isEditingProduct = false
    let coreDM = CoreDataManager.shared
    var tapTapRecogn = UITapGestureRecognizer()
    var inputContainerStack: UIStackView = {
        let myStack = UIStackView()
        myStack.axis = .vertical
        myStack.distribution  = UIStackView.Distribution.equalSpacing
        myStack.alignment = UIStackView.Alignment.center
        myStack.spacing   = 10.0
        return myStack
    }()
    var productNameInputfield: UITextField = {
        let myInputfield = UITextField()
        myInputfield.placeholder = "Enter Product Name"
        myInputfield.clearButtonMode = .always
        myInputfield.borderStyle = .roundedRect
        return myInputfield
    }()
    var productCategoryInputfield: UITextField = {
        let myInputfield = UITextField()
        myInputfield.placeholder = "Enter Product Category"
        myInputfield.clearButtonMode = .always
        myInputfield.borderStyle = .roundedRect
        return myInputfield
    }()
    var productNameLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Product Name"
        myLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return myLabel
    }()
    var productCategoryLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Product Category"
        myLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return myLabel
    }()
    var saveButton: UIButton = {
        let myButton = UIButton()
        myButton.backgroundColor = .link
        myButton.hasRoundCorner(theCornerRadius: 10)
        myButton.setTitle("Save", for: .normal)
        return myButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEditingProduct {
            title = "Edit Product"
        } else {
            title = "Add Product"
        }
        view.backgroundColor = .white
        view.addSubview(inputContainerStack)
        inputContainerStack.addArrangedSubview(productNameLabel)
        inputContainerStack.addArrangedSubview(productNameInputfield)
        inputContainerStack.addArrangedSubview(productCategoryLabel)
        inputContainerStack.addArrangedSubview(productCategoryInputfield)
        view.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonOnclick), for: .touchUpInside)
        productNameInputfield.delegate = self
        productCategoryInputfield.delegate = self
        tapTapRecogn.delegate = self
        view.addGestureRecognizer(tapTapRecogn)
        tapTapRecogn.addTarget(self, action: #selector(taptapAction))
        configureConstraints()
        initializeIfEditng()
    }
    func initializeIfEditng() {
        if isEditingProduct {
            productNameInputfield.text! = encryptionProtocal.decryptMessage(yourMessage: tempProduct.name!)
            productCategoryInputfield.text! = encryptionProtocal.decryptMessage(yourMessage: tempProduct.category!)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "CallBack"), object: self))
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func highlightEmptyInputfield() {
        if productNameInputfield.text == ""{
            productNameInputfield.sasBorderOutline(outlineColor: UIColor.red.cgColor,
                                                   outlineWidth: 1,
                                                   cornerRadius: 5)
        }
        if productCategoryInputfield.text == "" {
            productCategoryInputfield.sasBorderOutline(outlineColor: UIColor.red.cgColor,
                                                       outlineWidth: 1,
                                                       cornerRadius: 5
            )
        }
        showAlertBox(title: "Invalid product",
                     message: "Product information should not be empty",
                     buttonAction: nil,
                     buttonText: "Okay",
                     buttonStyle: .default
        )
    }
    func hasValueInInputfield() -> Bool {
        if productNameInputfield.text == ""{
            return false
        } else if productCategoryInputfield.text == ""{
            return false
        } else {
            return true
        }
    }
    func dismissNavigationView() {
        navigationController?.popViewController(animated: true)
    }
    func hasSpecialCharacter(theString: String) -> Bool {
        let specialChar = ["<", "-", "_", ">", ".", "(", ")", "+", "=", "*", "/", "[", "]", "^", "'",
                           "{", "}", "|", "!", "@", "#", "$", "%", "&", "?", ",", ":", ";", "\"", "\\"]
        var doHaveSpecialChar = false
        for index in specialChar where theString.contains(index) {
            doHaveSpecialChar = true
        }
        return doHaveSpecialChar
    }
    func alertSpecialError() {
        showAlertBox(title: "Invalid character",
                     message: "Product name or category should not contain special character",
                     buttonAction: nil,
                     buttonText: "Okay",
                     buttonStyle: .default)
    }
    func hasOverLimitCharacter() -> Bool {
        if productNameInputfield.text!.count > 40 || productCategoryInputfield.text!.count > 40 {
            return true
        } else {
            return false
        }
    }
    func alertLimitError() {
        showAlertBox(title: "Too many character",
                     message: "Product name or category should not contain more than 40 characters",
                     buttonAction: nil,
                     buttonText: "Got it",
                     buttonStyle: .default)
    }
    @objc func taptapAction() {
        view.endEditing(true)
    }
    @objc func saveButtonOnclick() {
        let totalInputValue = productNameInputfield.text! + productCategoryInputfield.text!
        let encryptedProductName = encryptionProtocal.encryptMessage(yourMessage: productNameInputfield.text!)
        let encryptedProductCategory = encryptionProtocal.encryptMessage(yourMessage: productCategoryInputfield.text!)
        if hasValueInInputfield() {
            if !hasOverLimitCharacter() {
                if isEditingProduct {
                    if hasSpecialCharacter(theString: totalInputValue) == false {
                        tempProduct.name = encryptedProductName
                        tempProduct.category = encryptedProductCategory
                        coreDM.updateProduct(theProduct: tempProduct)
                        dismissNavigationView()
                    } else {
                        alertSpecialError()
                    }
                } else {
                    if hasSpecialCharacter(theString: totalInputValue) == false {
                        coreDM.createProduct(productName: encryptedProductName,
                                             productCategory: encryptedProductCategory
                        )
                        dismissNavigationView()
                    } else {
                        alertSpecialError()
                    }
                }
            } else {
                alertLimitError()
            }
        } else {
            highlightEmptyInputfield()
        }
    }
}

extension AddAndEditViewController {
    func configureConstraints() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                           constant: 10
        ).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                          constant: -30
        ).isActive = true
        saveButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                         constant: 30
        ).isActive = true
        inputContainerStack.translatesAutoresizingMaskIntoConstraints = false
        inputContainerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: 10
        ).isActive = true
        inputContainerStack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                   constant: -20
        ).isActive = true
        inputContainerStack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                  constant: 20
        ).isActive = true
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.leftAnchor.constraint(equalTo: inputContainerStack.leftAnchor).isActive = true
        productNameLabel.rightAnchor.constraint(equalTo: inputContainerStack.rightAnchor).isActive = true
        productNameInputfield.translatesAutoresizingMaskIntoConstraints = false
        productNameInputfield.leftAnchor.constraint(equalTo: inputContainerStack.leftAnchor).isActive = true
        productNameInputfield.rightAnchor.constraint(equalTo: inputContainerStack.rightAnchor).isActive = true
        productCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        productCategoryLabel.leftAnchor.constraint(equalTo: inputContainerStack.leftAnchor).isActive = true
        productCategoryLabel.rightAnchor.constraint(equalTo: inputContainerStack.rightAnchor).isActive = true
        productCategoryInputfield.translatesAutoresizingMaskIntoConstraints = false
        productCategoryInputfield.leftAnchor.constraint(equalTo: inputContainerStack.leftAnchor).isActive = true
        productCategoryInputfield.rightAnchor.constraint(equalTo: inputContainerStack.rightAnchor).isActive = true
    }
}
