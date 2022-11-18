//
//  CoreDataManager.swift
//  RealCoreDataDemo
//
//  Created by SokHeng on 4/11/22.
//

import Foundation
import CoreData

class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    static let shared = CoreDataManager()
    init() {
        persistentContainer = NSPersistentContainer(name: "productapplication2")
        persistentContainer.loadPersistentStores {(_, error) in
            if let error = error {
                fatalError("Core Data Store Failed: \(error)")
            }
        }
    }
    func createProduct(productName: String, productCategory: String) {
        let product = Product(context: persistentContainer.viewContext)
        product.name = productName
        product.category = productCategory
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Fail to create : \(error)")
        }
    }
    func getAllProduct() -> [Product] {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    func getAllProduct(withName: String) -> [Product] {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", withName)
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    func getProduct(withName: String) -> Product? {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "name == %@", withName)
        do {
            let user = try persistentContainer.viewContext.fetch(fetchRequest)
            return user.first
        } catch let fetchError {
            print("Failed to fetch : \(fetchError)")
            return nil
        }
    }
    func deleteProduct(theProduct: Product) {
        persistentContainer.viewContext.delete(theProduct)
        do {
            try persistentContainer.viewContext.save()
        } catch let saveError {
            print("Failed to delete: \(saveError)")
        }
    }
    func deleteProductList(arrayList: [Product]) {
        for index in arrayList {
            persistentContainer.viewContext.delete(index)
        }
        do {
            try persistentContainer.viewContext.save()
        } catch let saveError {
            print("Failed to delete: \(saveError)")
        }
    }
    func updateProduct(theProduct: Product) {
        do {
            try persistentContainer.viewContext.save()
        } catch let createError {
            print("Failed to update: \(createError)")
        }
    }
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}
