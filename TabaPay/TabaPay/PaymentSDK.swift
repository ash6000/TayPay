import Foundation
//  ProcessingSDK.swift
//  TabaPay
//
//  Created by Ashton Watson on 3/19/24.
//

class ProcessingSDK {
    static let shared = ProcessingSDK()
    
    private init() {}
    
    struct Transaction {
        let amount: Double
        let recipient: String
        let transactionID: String
    }
    
    struct PaymentMethod {
        let cardNumber: String
        let cardType: String
    }
    
    struct TransactionHistory {
        let amount: Double
        let recipient: String
        let transactionID: String
        let date: Date
    }
    
    enum TransactionResult {
        case success(transaction: Transaction)
        case failure(error: Error)
        case processing
    }
    
    var paymentMethods: [PaymentMethod] = []
    var successfulTransactions: [Transaction] = []
    
    // Method to initiate and process payment transactions
    func processTransaction(amount: Double, recipient: String, completion: @escaping (TransactionResult) -> Void) {
        // Simulate success, failure, or processing state based on some condition
        let randomValue = Int.random(in: 1...10)
        if randomValue <= 6 {
            // Simulate success
            let transaction = Transaction(amount: amount, recipient: recipient, transactionID: UUID().uuidString)
            // Save successful transaction
            successfulTransactions.append(transaction)
            completion(.success(transaction: transaction))
        } else if randomValue <= 8 {
            // Simulate processing
            completion(.processing)
        } else {
            // Simulate failure
            let error = NSError(domain: "TransactionErrorDomain", code: 100, userInfo: [NSLocalizedDescriptionKey: "Transaction failed"])
            completion(.failure(error: error))
        }
    }
    
    //Method to have a defeault traction when view first load
    func firstTransaction(){
        let transaction1 = Transaction(amount: 12.31, recipient: "Tim", transactionID: UUID().uuidString)
        let transaction2 = Transaction(amount: 5.00, recipient: "Eve", transactionID: UUID().uuidString)
        successfulTransactions.append(transaction1)
        successfulTransactions.append(transaction2)
    }
    
//    // Method to retrieve transaction history for a user
//    func retrieveTransactionHistory(forUser userID: String) -> [TransactionHistory] {
//        // Convert successful transactions to transaction history
//        let userTransactions = successfulTransactions.filter { $0.recipient == userID }
//            .map { TransactionHistory(amount: $0.amount, recipient: $0.recipient, transactionID: $0.transactionID, date: Date()) }
//
//        return userTransactions
//    }
    
    func retrieveAllTransactionHistory() -> [TransactionHistory] {
        // Convert all successful transactions to transaction history
        let allTransactions = successfulTransactions.map {
            TransactionHistory(amount: $0.amount, recipient: $0.recipient, transactionID: $0.transactionID, date: Date())
        }
        return allTransactions
    }

    
    // Method to add a payment method
    func addPaymentMethod(cardNumber: String, cardType: String) {
        let newPaymentMethod = PaymentMethod(cardNumber: cardNumber, cardType: cardType)
        paymentMethods.append(newPaymentMethod)
        print("Payment method added successfully: \(newPaymentMethod.cardType) ending with \(String(cardNumber.suffix(4)))")
    }
    
    // Method to remove a payment method
    func removePaymentMethod(at index: Int) {
        guard index >= 0 && index < paymentMethods.count else {
            print("Invalid index provided.")
            return
        }
        let removedMethod = paymentMethods.remove(at: index)
        print("Payment method removed successfully: \(removedMethod.cardType) ending with \(String(removedMethod.cardNumber.suffix(4)))")
    }
    
    // Method to list all payment methods
    func listPaymentMethods() {
        if paymentMethods.isEmpty {
            print("No payment methods added yet.")
        } else {
            print("List of Payment Methods:")
            for (index, method) in paymentMethods.enumerated() {
                print("\(index + 1). \(method.cardType) ending with \(String(method.cardNumber.suffix(4)))")
            }
        }
    }
}


// Example usage
//let processingSDK = ProcessingSDK.shared
//
//// Processing transaction
//let transactionResult = processingSDK.processTransaction(amount: 50.0, recipient: "John Doe")
//switch transactionResult {
//case .success(let transaction):
//    print("Transaction successful! ID: \(transaction.transactionID)")
//case .failure(let error):
//    print("Transaction failed with error: \(error)")
//case .processing:
//    print("Transaction is processing...")
//}
//
//// Adding payment methods
//processingSDK.addPaymentMethod(cardNumber: "1234567890123456", cardType: "Credit Card")
//processingSDK.addPaymentMethod(cardNumber: "9876543210987654", cardType: "Debit Card")
//
//// Listing payment methods
//processingSDK.listPaymentMethods()
//
//// Removing a payment method
//processingSDK.removePaymentMethod(at: 0)
//
//// Listing payment methods after removal
//processingSDK.listPaymentMethods()
//
//// Retrieving transaction history
//let userID = "Alice"
//let userTransactions = processingSDK.retrieveTransactionHistory(forUser: userID)
//print("Transaction History for User \(userID):")
//for transaction in userTransactions {
//    print("Amount: \(transaction.amount), Recipient: \(transaction.recipient), Transaction ID: \(transaction.transactionID), Date: \(transaction.date)")
//}
