//
//  PaymentMethodsViewController.swift
//  TabaPay
//
//  Created by Ashton Watson on 3/20/24.
//

import UIKit



class PaymentMethodsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let processingSDK = ProcessingSDK.shared
    
    var paymentMethods: [ProcessingSDK.PaymentMethod] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPaymentsMethod()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PaymentMethodCell") // Register cell
        
        // Retrieve payment methods
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        retrievePaymentMethods()
    }
    
    @objc func addButtonTapped() {
        
        performSegue(withIdentifier: "AddPaymentSegue", sender: nil)
    }
    
    func addPaymentsMethod(){
        processingSDK.addPaymentMethod(cardNumber: "123456789", cardType: "Debit")
    }
    
    func retrievePaymentMethods() {
        paymentMethods = processingSDK.paymentMethods
        
        // Reload table view
        tableView.reloadData()
    }
}

extension PaymentMethodsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell", for: indexPath)
        
        let paymentMethod = paymentMethods[indexPath.row]
        
        cell.textLabel?.text = "\(paymentMethod.cardType) ending with \(String(paymentMethod.cardNumber.suffix(4)))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the payment method from the array
            processingSDK.removePaymentMethod(at: indexPath.row)
            let removedMethod = paymentMethods.remove(at: indexPath.row)
            // Update the data source and UI
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            print("Payment method removed successfully: \(removedMethod.cardType) ending with \(String(removedMethod.cardNumber.suffix(4)))")
        }
    }
}


