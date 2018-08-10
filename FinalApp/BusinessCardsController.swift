//
//  ViewController.swift
//  FinalApp
//

import UIKit
import CoreData

class BusinessCardsController: UITableViewController {

    // var because the array has to change (adding/deleting elements from the array)
    var businessCards = [BusinessCard]() // empty array
    var filteredBusinessCards = [BusinessCard]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // setup the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false //
        searchController.searchBar.placeholder = "Search business cards"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true //
        definesPresentationContext = true
        
        // make the input readable (black to white)
        searchController.searchBar.barStyle = UIBarStyle.black
        // change the color of the cancel button (blue to white)
        searchController.searchBar.tintColor = UIColor.white
        
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
    
    private func searchBarIsEmpty() -> Bool {
        // returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filteredContentForSearchText(_ searchtext: String, scope: String = "All") {
        filteredBusinessCards = businessCards.filter({ (businessCard : BusinessCard) -> Bool in
            return (businessCard.fullName?.lowercased().contains(searchtext.lowercased()))! // review!
        })
        
        tableView.reloadData()
        
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

// UISearchResultsUpdating delegate
extension BusinessCardsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchController.searchBar.text!)
    }
}

