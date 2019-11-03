import Foundation

//enum DebitCategories : String {
//    case health
//    case food, rent, tax, transportation
//    case entertainment
//}

protocol Transaction {
    var value: Float { get }
    var name: String { get }
    var isValid: Bool { get }
    
    func invalidateTransaction()
}

enum DebitCategories : Int {
    case health
    case food, rent, tax, transportation
    case entertainment
}

enum TransactionType {
    case debit(_ value: Debit)
    case gain(_ value: Gain)
}

enum GainCategories{
    case job, trading, becaAMLO, crypto
}

class Debit: Transaction {
    var isValid: Bool = true
    var value: Float
    var name: String
    var category: DebitCategories

    init(value: Float, name: String, category: DebitCategories) {
        self.category = category
        self.value = value
        self.name = name
    }
    func invalidateTransaction() {
        isValid = false
    }
}

class Gain: Transaction {
    var isValid: Bool = true
    var value: Float
    var name: String
    var category: GainCategories
    
    init(value: Float, name: String, category: GainCategories) {
        self.category = category
        self.value = value
        self.name = name
    }
    func invalidateTransaction() {
        isValid = false
    }
}

class Acccount {
    var amount: Float = 0 {
        willSet {
            print("Vamos a cambiar el valor", amount, newValue)
        }
        didSet {
            print("Tenemos nuevo valor", amount)
        }
    }
    
    var name: String = ""
    var transactions: [Transaction] = []
    
    var debits: [Debit] = []
    var gains: [Gain] = []
    
    init(amount: Float, name: String) {
        self.amount = amount
        self.name = name
    }
    
    @discardableResult
    func addTransaction(transaction: TransactionType) -> Float {
        switch transaction {
        case .debit(let debit):
            if (amount - debit.value) < 0 {
                return 0
            }
            amount -= debit.value
            transactions.append(debit)
            debits.append(debit)
        case .gain(let gain):
            amount += gain.value
            transactions.append(gain)
            gains.append(gain)
        }
        return amount
    }
    
    func transactionsFor(category: DebitCategories) -> [Transaction] {
        return transactions.filter({ (transaction) -> Bool in
            guard let transaction = transaction as? Debit else {
                return false
            }
            
            return transaction.category == category
        })
    }
    func transactionsFor(category: GainCategories ) -> [Transaction] {
        return transactions.filter({ (transaction) -> Bool in
            guard let transaction = transaction as? Gain else {
                return false
            }
            return transaction.category == category
        })
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
            name = String(newValue.split(separator: " ").first ?? "")
            lastName = "\(newValue.split(separator: " ").last ?? "")"
        }
    }
    
    init(name: String, lastName: String) {
        self.name = name
        self.lastName = lastName
    }
}

var me = Person(name: "Andres", lastName: "Silva")

let account = Acccount(amount: 100_000, name: "X bank")

me.account = account

print(me.account!)

me.account?.addTransaction(
    transaction: .debit(Debit(
        value: 20,
        name: "Cafe con amigos",
        category: DebitCategories.food
    ))
)

me.account?.addTransaction(
    transaction: .debit(Debit(
        value: 100,
        name: "Juego PS4",
        category: .entertainment
    ))
)

me.account?.addTransaction(
    transaction: .debit(Debit(
        value: 500,
        name: "PS4",
        category: .entertainment
    ))
)

me.account?.addTransaction(
    transaction: .gain(Gain(
        value: 1000,
        name: "Salario",
        category: .job
    ))
)

me.account?.addTransaction(
    transaction: .gain(Gain(
        value: 2000,
        name: "Beca",
        category: .becaAMLO
    ))
)

print(me.account!.amount)

me.account = account

//Debit
me.account?.addTransaction(transaction: .debit(Debit(value: 80, name: "Sandwich", category: DebitCategories.food)))
me.account?.addTransaction(transaction: .debit(Debit(value: 100, name: "Pollo Cordon Bleu", category: DebitCategories.food)))

//Gain
me.account?.addTransaction(transaction: .gain(Gain(value: 500, name: "Trabajo", category: GainCategories.job)))
me.account?.addTransaction(transaction: .gain(Gain(value: 1000, name: "Bitcoin", category: .crypto)))

print(me.account!.amount)

let debitTransactions = me.account?.transactionsFor(category: DebitCategories.food) as? [Debit]
for transaction in debitTransactions ?? [] {
    // print(transaction.category.rawValue.capitalized) // Works w/ Raw String
    print(transaction.name, transaction.value, transaction.category.rawValue)
}

let gainTransactions = me.account?.transactionsFor(category: GainCategories.job) as? [Gain]
for transaction in gainTransactions ?? [] {
    print(transaction.name, transaction.value, transaction.category)
}
