//
//  BusinessCardsController+UITableViewDelegate.swift
//  FinalApp
//

import UIKit

extension BusinessCardsController {
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // delete action
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete", handler: deleteHandlerFunction)
        deleteAction.backgroundColor = UIColor.lightRed
        
        // edit action
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit", handler: editHandlerFunction)
        editAction.backgroundColor = UIColor.black
        
        return [deleteAction, editAction]
    }
    
    private func deleteHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        let businessCard = self.businessCards[indexPath.row]
        
        // remove the business card from the tableview
        self.businessCards.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        
        // delete the business card fom Core Data
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(businessCard)
        
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to delete business card: \(saveErr)")
        }
    }
    
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        let editBusinessCardController = CreateBusinessCardController()
        editBusinessCardController.delegate = self
        editBusinessCardController.businessCard = businessCards[indexPath.row]
        let navController = CustomNavigationController(rootViewController: editBusinessCardController)
        present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightRed
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No business cards available..."
        //label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return businessCards.count == 0 ? 150 : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! BusinessCardCell

        let businessCard: BusinessCard
        if isFiltering() {
            businessCard = filteredBusinessCards[indexPath.row]
        } else {
            businessCard = businessCards[indexPath.row]

        }
        
        cell.businessCard = businessCard
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredBusinessCards.count
        } else {
            return businessCards.count
        }
    }
    
}
