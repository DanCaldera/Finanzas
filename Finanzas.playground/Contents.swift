import Foundation

class Transaction {
    var value: Float
    var name: String
    
    init(value: Float, name: String) {
        self.value = value
        self.name = name
    }
}

class Debit : Transaction {
    
}

class Gain : Transaction {
    
}

class Acccount {
    var amount: Float = 0 {
        willSet {
            print("Vamos a modificar esta variable", newValue)
        }
        didSet {
            print("Tenemos nuevo valor", amount)
        }
    }
    var name: String = ""
    var transactions: [Transaction] = []
    
    init(amount: Float, name: String) {
        self.amount = amount
        self.name = name
    }
    
    @discardableResult
    func addTransaction(transaction: Transaction) -> Float {
        if transaction is Gain {
            amount += transaction.value
        }
        if transaction is Debit {
            if (amount - transaction.value) < 0 {
                return 0
            }
            amount -= transaction.value
        }
        transactions.append(transaction)
        return amount
    }
    func debits() -> [Transaction] {
        return transactions.filter({ $0 is Debit })
    }
    func gains() -> [Transaction] {
        return transactions.filter({ $0 is Gain })
    }
}

class Person {
    var name: String = ""
    var lastName: String = ""
    var account: Acccount?
    
    var fullName: String {
        get {
            return "\(name) \(lastName)"
        }
        set {
            name = String((newValue.split(separator: " ").first) ?? "No tienes nombre")
            lastName = "\(newValue.split(separator: " ").last ?? "No tienes apellido")"
        }
    }
    
    init(name: String, lastName: String) {
        self.name = name
        self.lastName = lastName
    }
}

var me = Person(name: "Daniel", lastName: "Caldera")

var account = Acccount(amount: 100_000, name: "X bank")

me.account = account

print(me.account!)

me.account?.addTransaction(
    transaction: Debit(value: 20, name: "Chicle"))
me.account?.addTransaction(
    transaction: Debit(value: 100, name: "Celular nuevo"))
me.account?.addTransaction(
    transaction: Debit(value: 500, name: "Consola PS5"))
//account.addTransaction(value: 20)

me.account?.addTransaction(
    transaction: Gain(value: 1000, name: "Salario"))

print(me.account!.amount)
