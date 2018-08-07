//
//  ViewController.swift
//  FinalApp
//

import UIKit
import CoreData

class BusinessCardsController: UITableViewController {

    // var because the array has to change (adding/deleting elements from the array)
    var businessCards = [BusinessCard]() // empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // table view reloads itelf at the end of this function
        // otherwise, I have to reload: tableView.reloadData()
        self.businessCards = CoreDataManager.shared.fetchBusinessCards()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "BC Wallet"
        
        tableView.backgroundColor = UIColor.mercury
        // hiding the separators
        //tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.separatorColor = UIColor.black
        // it doesn't show the separators outside of the table view
        tableView.tableFooterView = UIView() // blank UIView
        
        tableView.register(BusinessCardCell.self, forCellReuseIdentifier: "cellID")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleReset))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleAddBusinessCard))
        
        setupSearchBar()
    }
    
    @objc private func handleReset() {
        // reset core data and array
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: BusinessCard.fetchRequest())
        do{
            try context.execute(batchDeleteRequest)
            
            // animation
            var indexPathsToRemove = [IndexPath]()
            for (index, _) in businessCards.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            businessCards.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: UITableViewRowAnimation.left)
            
            // no animation
            //businessCards.removeAll()
            //tableView.reloadData()
        } catch let deleteErr {
            print("Failed to delete objects from Core Data: \(deleteErr)")
        }
    }
    
    @objc private func handleAddBusinessCard() {
        let createBusinessCard = CreateBusinessCardController()
        
        let navController = CustomNavigationController(rootViewController: createBusinessCard)
        
        createBusinessCard.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        //navigationItem.hidesSearchBarWhenScrolling = true
    }

}
