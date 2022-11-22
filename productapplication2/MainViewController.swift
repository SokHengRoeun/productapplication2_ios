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
    var personalIndex: Int
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
    var mainSearchController = UISearchController()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addNewProduct(_:)),
                                               name: Notification.Name(rawValue: "addedProduct"),
                                               object: nil
        )
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editOldProduct(_:)),
                                               name: Notification.Name(rawValue: "productUpdate"),
                                               object: nil
        )
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deleteOldProduct(_:)),
                                               name: Notification.Name(rawValue: "deleteProduct"),
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
        navigationItem.searchController = mainSearchController
        mainSearchController.searchResultsUpdater = self
        view.addSubview(mainTableView)
        HengCryptology().printFileLocation()
        configureConstraints()
    }
    @objc func addBarButtonOnclick() {
        let secondScreen = AddAndEditViewController()
        secondScreen.totalProductAmount = allProducts.count
        navigationController?.pushViewController(secondScreen, animated: true)
    }
    func indexResolver() {
        for indexx in allProducts.indices {
            allProducts[indexx].personalIndex = indexx
        }
    }
}

extension MainViewController: UITableViewDelegate,
                              UITableViewDataSource,
                              UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text!.isEmpty {
            isSearching = false
        } else {
            isSearching = true
            filteredProduct = allProducts.filter { product in
                return product.name.lowercased().contains(searchController.searchBar.text!.lowercased())
            }
        }
        tableViewReloadData()
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
        if editingStyle == .delete {
            if isSearching {
                let product = coreDM.getAllProduct()[filteredProduct[indexPath.item].personalIndex]
                allProducts.remove(at: filteredProduct[indexPath.item].personalIndex)
                filteredProduct.remove(at: indexPath.item)
                coreDM.deleteProduct(theProduct: product)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                let product = coreDM.getAllProduct()[indexPath.item]
                allProducts.remove(at: indexPath.item)
                coreDM.deleteProduct(theProduct: product)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addScreen = AddAndEditViewController()
        if isSearching {
            addScreen.editProduct = coreDM.getAllProduct()[filteredProduct[indexPath.item].personalIndex]
            addScreen.editInIndex = filteredProduct[indexPath.item].personalIndex
        } else {
            addScreen.editProduct = coreDM.getAllProduct()[indexPath.row]
            addScreen.editInIndex = indexPath.row
        }
        addScreen.isEditingProduct = true
        navigationController?.pushViewController(addScreen, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @objc func addNewProduct(_ notification: NSNotification) {
        allProducts.append(notification.object as! DisplayProduct)
        indexResolver()
        self.tableViewReloadData()
    }
    @objc func editOldProduct(_ notification: NSNotification) {
        let returnedObj = notification.object as! PassBackObj
        allProducts[returnedObj.theIndex] = returnedObj.theProduct
        // self.tableViewReloadData()
    }
    @objc func deleteOldProduct(_ notification: NSNotification) {
        let returnedObj = notification.object as! PassBackObj
        allProducts.remove(at: returnedObj.theIndex)
        indexResolver()
        self.tableViewReloadData()
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
