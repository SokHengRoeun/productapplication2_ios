//
//  ViewController.swift
//  ProductAppProgramming
//
//  Created by SokHeng on 11/11/22.
//
// swiftlint:disable force_cast

import UIKit

struct DisplayProduct {
    var name: String
    var category: String
}

class MainViewController: UIViewController {
    let coreDM = CoreDataManager.shared
    var allProducts = HengCryptology().decryptAllProduct()
    var filteredProduct = [DisplayProduct]()
    var isSearching = false
    var mainTableView: UITableView = {
        let myTable = UITableView()
        myTable.register(UITableViewCell.self, forCellReuseIdentifier: "MainCell")
        return myTable
    }()
    var mainSearchBar: UISearchBar = {
        let mySeachBar = UISearchBar()
        mySeachBar.placeholder = "search"
        return mySeachBar
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
        mainSearchBar.delegate = self
        view.addSubview(mainSearchBar)
        view.addSubview(mainTableView)
        HengCryptology().printFileLocation()
        mainSearchBar.delegate = self
        configureConstraints()
    }
    @objc func addBarButtonOnclick() {
        let secondScreen = AddAndEditViewController()
        navigationController?.pushViewController(secondScreen, animated: true)
    }
    func taptapAction() {
        view.endEditing(true)
    }
}

extension MainViewController: UITableViewDelegate,
                              UITableViewDataSource,
                              UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        taptapAction()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredProduct.count
        } else {
            return allProducts.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(
            withIdentifier: "MainCell") as! MainTableCell
        let product: DisplayProduct
        if isSearching {
            product = filteredProduct[indexPath.row]
        } else {
            product = allProducts[indexPath.row]
        }
        cell.productNameLabel.text = product.name
        cell.productCategoryLabel.text = product.category
        return cell
    }
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath
    ) {
        if !isSearching {
            if editingStyle == .delete {
                let product = coreDM.getAllProduct()[indexPath.item]
                allProducts.remove(at: indexPath.item)
                coreDM.deleteProduct(theProduct: product)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addScreen = AddAndEditViewController()
        addScreen.tempProduct = coreDM.getAllProduct()[indexPath.row]
        addScreen.isEditingProduct = true
        navigationController?.pushViewController(addScreen, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func callBackAction() {
        let addScreen = AddAndEditViewController()
        refreshAllProduct()
        self.tableViewReloadData()
        addScreen.isEditingProduct = false
    }
    func tableViewReloadData() {
        self.mainTableView.reloadData()
    }
    func refreshAllProduct() {
        allProducts = HengCryptology().decryptAllProduct()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
        } else {
            isSearching = true
            filteredProduct = allProducts.filter { product in
                return product.name.lowercased().contains(searchText.lowercased())
            }
        }
        tableViewReloadData()
    }
    func configureConstraints() {
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.topAnchor.constraint(equalTo: mainSearchBar.bottomAnchor).isActive = true
        mainTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        mainTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mainSearchBar.translatesAutoresizingMaskIntoConstraints = false
        mainSearchBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        mainSearchBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        mainSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
}
