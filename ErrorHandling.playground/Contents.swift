import UIKit

// Swift provides first-class support for throwing, catching, propagating, and manipulating recoverable errors at runtime.

// Representing and Throwing Errors

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFund(coinsNeeded: Int)
    case outOfStock
}

throw VendingMachineError.insufficientFund(coinsNeeded: 5)

// Handling errors

/*
 There are four ways to handle error in swift -
 1. You can propagate the error from the function to the code that calls the function
 2. Handle the error using do-catch statement.
 3. handle an error as optional
 4. asserts that error will not occur.
 */

// Propagating Errors using throwing functions

/*
// throughing function
func canThrowErrors() throws -> String
func cannotThrowErrors() -> String
*/

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var invertory = ["Candy Bar": Item(price: 12, count: 7), "Chips": Item(price: 10, count: 4), "Pretzels": Item(price: 7, count: 11)]
    var coinsDeposited = 0
    
    func vend(itemNamed name: String) throws {
        guard let item = invertory[name] else {
            throw VendingMachineError.invalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        
        guard item.price <= coinsDeposited  else {
            throw VendingMachineError.insufficientFund(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        var newItem = item
        newItem.count -= 1
        invertory[name] = newItem
        print("Dispensing \(name)")
        
    }
}

let favoriteSnacks = ["Alice": "Chips", "Bob": "Licorice", "Eve": "Pretzels"]

func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy bar"
    try vendingMachine.vend(itemNamed: snackName)
}

struct PurchasedSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}

// Handling Errors using Do-Catch

/*
 do {
    try expression
    statements
 } catch pattern1 {
    statements
 } catch pattern2 where condition {
    statements
 }  catch pattern3, pattern4 where condition {
    statement
 } catch {
    statement
 }
 */

var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8

do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection")
} catch VendingMachineError.outOfStock {
    print("Out of stock")
} catch VendingMachineError.insufficientFund(coinsNeeded: let coinNeeded) {
    print("Insufficient funds. Please insert an additional \(coinNeeded) coins.")
} catch {
    print("Unexpected error: \(error)")
}

func nourish(with item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch is VendingMachineError {
        print("Couldn't buy this from vending machine.")
    }
}

do {
    try nourish(with: "Beet-flavored chips")
} catch {
    print("Unexpected non-vending-machine-related error: \(error)")
}

//func eat(item: String) throws {
//    do {
//        try vendingMachine.vend(itemNamed: item)
//    } catch VendingMachineError.invalidSelection, VendingMachineError.insufficientFunds, VendingMachineError.outOfStock {
//        print("Invalid selection, out of stock, or not enough money.")
//    }
//}

// Converting Errors to optional values


/*
func someThrowingFunction() throws -> Int {
    // ...
}

let x = try? someThrowingFunction()
let y: Int?
do {
    y = try someThrowingFunction()
} catch {
    y = nil
}
*/

/*
func fetchData() -> Data? {
    if let data = try? fetchDataFromDisk() { return data }
    if let data = try? fetchDataFromServer() { return data }
    return nil
}
*/

// Disabling Error Propagation


//let photo = try! loadImage(atpath: "...//")


// Specifying clean up Actions

//func processFile(fileName: String) throws {
//    if exists(fileName) {
//        let file = open(fileName)
//        defer {
//            closer(file)
//        }
//        while let line = try file.readline() {
//            // work with the file
//        }
//        // close(file) is called here, at the end of the scope
//    }
//}
