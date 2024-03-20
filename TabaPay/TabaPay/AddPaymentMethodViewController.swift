//
//  AddPaymentMethodViewController.swift
//  TabaPay
//
//  Created by Ashton Watson on 3/20/24.
//

import UIKit



class AddPaymentMethodViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardTypeSegmentedControl: UISegmentedControl!
    
    let processingSDK = ProcessingSDK.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set placeholder text for card number text field
        cardNumberTextField.placeholder = "Enter credit card number"
        // Set the delegate to self
        cardNumberTextField.delegate = self
        // Set the keyboard type to number pad
        cardNumberTextField.keyboardType = .numberPad
    }
    
    @IBAction func savePaymentMethod(_ sender: UIButton) {
        guard let cardNumber = cardNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !cardNumber.isEmpty else {
            // Show alert if card number is empty
            showAlert(title: "Error", message: "Please enter a valid card number.")
            return
        }
        
        let cardTypeIndex = cardTypeSegmentedControl.selectedSegmentIndex
        let cardType = cardTypeIndex == 0 ? "Credit Card" : "Debit Card"
        
        // Add payment method using ProcessingSDK
        processingSDK.addPaymentMethod(cardNumber: cardNumber, cardType: cardType)
        
        // Show success message
        showAlertAndDismiss(title: "Success", message: "Payment method added successfully.")
        
        // Clear text field after saving
        cardNumberTextField.text = ""
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove payment method at the selected index
            let removedMethod = processingSDK.paymentMethods.remove(at: indexPath.row)
            print("Payment method removed successfully: \(removedMethod.cardType) ending with \(String(removedMethod.cardNumber.suffix(4)))")
            // Reload table view after deletion
            tableView.reloadData()
        }
    }
    
    func showAlertAndDismiss(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Dismiss the view controller when OK is tapped
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

