//
//  BusinessCardsController+CreateCompanyDelegate.swift
//  FinalApp
//

import UIKit

extension BusinessCardsController: CreateBusinessCardControllerDelegate {
    
    func didAddBusinessCard(businessCard: BusinessCard) {
        // modify array
        businessCards.append(businessCard)
        
        // insert a new index path into tableView
        let indexPath = IndexPath(row: businessCards.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
    func didEditBusinessCard(businessCard: BusinessCard) {
        // update my tableview
        let row = businessCards.index(of: businessCard)
        let reloadIndexPath = IndexPath(item: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: UITableViewRowAnimation.automatic)
    }
    
}
