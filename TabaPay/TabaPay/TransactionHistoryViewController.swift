//
//  TransactionHistoryViewController.swift
//  TabaPay
//
//  Created by Ashton Watson on 3/20/24.
//

import UIKit

class TransactionHistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let processingSDK = ProcessingSDK.shared
    
    var transactionHistory: [ProcessingSDK.TransactionHistory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        processingSDK.firstTransaction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set up table view
        tableView.dataSource = self
        tableView.delegate = self
        
        // Retrieve all transaction history
        transactionHistory = processingSDK.retrieveAllTransactionHistory()
        
        // Reload table view
        tableView.reloadData()
    }
}

extension TransactionHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        
        let transaction = transactionHistory[indexPath.row]
        
        cell.textLabel?.text = "\(transaction.amount) to \(transaction.recipient)"
        cell.detailTextLabel?.text = "Transaction ID: \(transaction.transactionID)"
        
        return cell
    }
}


