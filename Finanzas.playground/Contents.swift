import Foundation

class Person{
    var name:String
    var lastName:String
    
    init(name:String, lastName:String) {
        self.name = name
        self.lastName = lastName
    }
    
    func getFullName() -> String {
        return"\(name)\(lastName)"
    }
}

class Account{
    var person:Person
    var transactions:[Transaction]
    
    init(person:Person, transactions:[Transaction] = []) {
        self.person = person
        self.transactions = transactions;
    }
    
    func getPerson() -> Person {
        return person
    }
    
    func getMount() -> Float {
        if (transactions.count == 0) {
            return 0
        }
        
        let addTransactions:[Float] = transactions.filter( {$0.type == "add" }).map({ return $0.value })
        let sumAddTransactions:Float = addTransactions.map({$0}).reduce(0, +);
        
        let debitTransactions:[Float] = transactions.filter( {$0.type == "debit" }).map({ return $0.value })
        let sumDebitTransactions:Float = debitTransactions.map({$0}).reduce(0, +);
        
        return sumAddTransactions - sumDebitTransactions;
    }
    
    func addTransaction(transaction:Transaction) {
        let currentAccountMount = getMount();
        
        if(transaction.type == "debit" && (currentAccountMount - transaction.value) < 0){
            print("esta transaction no puede ser mayor al monto a \(currentAccountMount) ")
        } else {
            transactions.append(transaction)
        }
    }
    
    func getTransactions() -> [Transaction] {
        return transactions;
    }
}

class Transaction{
    var account:Account
    var value:Float;
    var description:String
    var type:String = "add"
    
    init(account:Account, value:Float, description:String) {
        self.account = account
        self.value = value
        self.description = description
    }
    
    func setAccount(account:Account) {
        self.account = account;
    }
    
    func setValue(value:Float) {
        self.value = value;
    }
    
    func setDescription(description:String) {
        self.description = description;
    }
    
    func setType(type:String) {
        self.type = type;
    }
    
    func getType() -> String {
        return type
    }
    
    func getValue() -> Float {
        return value
    }
}

class Debit: Transaction{
    override init(account: Account, value: Float, description: String) {
        super.init(account: account, value: value, description: description)
        setType(type: "debit")
    }
}

class Add: Transaction{
    override init(account: Account, value: Float, description: String) {
        super.init(account: account, value: value, description: description)
        setType(type: "add")
    }
}

let person:Person = Person(name:"Daniel", lastName:"Caldera")

let account:Account = Account(person: person);

account.addTransaction(transaction: Add(account: account, value: 2000, description: "Pago por freelance"))

account.addTransaction(transaction: Debit(account: account, value: 450, description: "Mercado para el mes"))

account.addTransaction(transaction: Debit(account: account, value: 500, description: "Pago alquiler mes junio"))

print(account.getPerson().getFullName(), "Tu saldo es \(account.getMount())")
