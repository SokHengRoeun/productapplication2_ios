//
//  ViewController.swift
//  ProductAppProgramming
//
//  Created by SokHeng on 11/11/22.
//

import UIKit

class MainViewController: UIViewController {
    let encryptionProtocal = HengCryptology()
    let coreDM = CoreDataManager.shared
    var allProducts = CoreDataManager.shared.getAllProduct()
    var mainTableView: UITableView = {
        let myTable = UITableView()
        myTable.register(UITableViewCell.self, forCellReuseIdentifier: "MainCell")
        return myTable
    }()
    @objc func listenThenAct() {
        callBackAction()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(listenThenAct),
                                               name: Notification.Name(rawValue: "CallBack"),
                                               object: nil
        )
        title = "Home"
        view.backgroundColor = UIColor.white
        let addNavButton = UIBarButtonItem(barButtonSystemItem: .add,
                                           target: self,
                                           action: #selector(addBarButtonOnclick)
        )
        navigationItem.rightBarButtonItem = addNavButton
        mainTableView.register(MainTableCell.self, forCellReuseIdentifier: "MainCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        view.addSubview(mainTableView)
        HengCryptology().printFileLocation()
        configureConstraints()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainTableView.frame = view.bounds
    }
    @objc func addBarButtonOnclick() {
        let secondScreen = AddAndEditViewController()
        navigationController?.pushViewController(secondScreen, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allProducts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(
            withIdentifier: "MainCell") as! MainTableCell // swiftlint:disable:this force_cast
        // cell.productCategoryLabel.text = allProducts[indexPath.row].category!
        cell.productNameLabel.text = encryptionProtocal.decryptMessage(
            yourMessage: allProducts[indexPath.row].name!
        )
        // cell.productNameLabel.text = allProducts[indexPath.row].name!
        cell.productCategoryLabel.text = encryptionProtocal.decryptMessage(
            yourMessage: allProducts[indexPath.row].category!
        )
        return cell
    }
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let product = allProducts[indexPath.item]
            allProducts.remove(at: indexPath.item)
            coreDM.deleteProduct(theProduct: product)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addScreen = AddAndEditViewController()
        addScreen.tempProduct = allProducts[indexPath.row]
        addScreen.isEditingProduct = true
        navigationController?.pushViewController(addScreen, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func callBackAction() {
        let addScreen = AddAndEditViewController()
        allProducts = coreDM.getAllProduct()
        self.tableViewReloadData()
        addScreen.isEditingProduct = false
    }
    func tableViewReloadData() {
        self.mainTableView.reloadData()
    }
    func configureConstraints() {
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        mainTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
