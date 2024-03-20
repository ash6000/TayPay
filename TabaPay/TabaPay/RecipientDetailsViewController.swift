//
//  RecipientDetailsViewController.swift
//  TabaPay
//
//  Created by Ashton Watson on 3/20/24.
//

import UIKit


class RecipientDetailsViewController: UIViewController {
    
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // Properties
    var recipientName: String?
    let processingSDK = ProcessingSDK.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set recipient name label
        recipientNameLabel.text = recipientName ?? "Recipient Name"
        
        // Set placeholder text for description text view
        descriptionTextView.text = "Add description (required)"
        amountTextField.placeholder = "Enter amount in dollars"
        descriptionTextView.delegate = self
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.layer.cornerRadius = 8.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Action method to initiate payment process
    @IBAction func initiatePayment(_ sender: UIButton) {
        guard let recipientName = recipientName,
              let amountText = amountTextField.text,
              let amount = Double(amountText),
              !amountText.isEmpty,
              !descriptionTextView.text.isEmpty else {
            // Display alert if any required field is empty
            displayAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        
        
        // Call method to process transaction using ProcessingSDK
        processingSDK.processTransaction(amount: amount, recipient: recipientName) { [weak self] result in
            switch result {
            case .success(let transaction):
                // Payment successful
                self?.displayAlert(title: "Success", message: "Payment of \(transaction.amount) to \(transaction.recipient) was successful. Transaction ID: \(transaction.transactionID)")
            case .failure(let error):
                // Payment failed
                self?.displayAlert(title: "Error", message: "Payment failed with error: \(error.localizedDescription)")
            case .processing:
                // Payment is still processing
                self?.displayAlert(title: "Processing", message: "Payment is still processing. Please wait.")
            }
        }
    }
    
    
    // Method to display alert
    private func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @objc private func handleKeyboardNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            if let keyboardHeight = keyboardFrame?.height {
                let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
                descriptionTextView.contentInset = contentInset
                descriptionTextView.scrollIndicatorInsets = contentInset
            }
        } else {
            let contentInset = UIEdgeInsets.zero
            descriptionTextView.contentInset = contentInset
            descriptionTextView.scrollIndicatorInsets = contentInset
        }
    }
    
    deinit {
        // Remove observer
        NotificationCenter.default.removeObserver(self)
    }
}


extension RecipientDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add description (required)" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add description (required)"
            textView.textColor = UIColor.lightGray
        }
    }
}



