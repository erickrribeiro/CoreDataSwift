//
//  ProductTableViewController.swift
//  CoreDataDemo
//
//  Created by Teewa on 03/03/17.
//  Copyright © 2017 Teewa. All rights reserved.
//

import UIKit
import CoreData

class ProductTableViewController: UITableViewController {
    var productsArray = [Product]()
    var managedObjectContext:NSManagedObjectContext?{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveProduct()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productsArray.count
    }

    let cellId = "productCell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProductTableViewCell

        // Configure the cell...
        cell.configureCell(product: productsArray[indexPath.row])

        return cell
    }
    

    func retrieveProduct(){
        fetchProductFromCoreData { (products) in
            if let products = products{
                print("retrieveProduct")
                self.productsArray = products
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchProductFromCoreData(completion:([Product]?)->Void){
        var results = [Product]()
        
        let requests:NSFetchRequest<Product> = Product.fetchRequest()
        do{
            print("before fetchProductFromCoreData")
            results = try managedObjectContext!.fetch(requests)
            print("Products: \(results)")
            print("after fetchProductFromCoreData")
            completion(results)
        }catch let error{
            print("Could not fetch Products from CoreData: \(error.localizedDescription)")
        }
    }
}
