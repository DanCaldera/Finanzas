//Este es mi codigo del reto
protocol checkVality {
    func checkVality(value: Transaction) -> Float
}
protocol invalidateTransaction {
    func invalidateTransaction(transaction: Transaction)
}

protocol Transaction {
    var transValue: Float { get }
    var transDescription: String { get }
    var isValid: Bool { get set }
    var delgate: checkVality? { get set }
}

class USUARIO {
    var nombreUsuario: String
    var apellidoUsuario: String
    var cuentaUsuario: CUENTA?
    
    init(nombreUsuario: String, apellidoUsuario: String) {
        self.nombreUsuario = nombreUsuario
        self.apellidoUsuario = apellidoUsuario
    }
}

class CUENTA {
    var bancoCuenta: String
    var saldoCuenta: Float {
        willSet {
            print("INICIAL:", saldoCuenta)
        } didSet {
            print("FINAL:", saldoCuenta)
        }
    }
    
    //TRANSACTIONS
    var debits: [DEBIT] = []
    var gains: [GAIN] = []
    
    init(bancoCuenta: String, saldoCuenta: Float) {
        self.bancoCuenta = bancoCuenta
        self.saldoCuenta = saldoCuenta
    }
    
    @discardableResult
    func addTransaction(transaction: transactionType) -> Transaction? {
        switch transaction {
        case .debit(let dValue, let dDescription, let dType):
            
            let debit = DEBIT(
                transValue: dValue,
                transDescription: dDescription,
                isValid: dType
            )
            debit.delgate = self
            
            if (saldoCuenta - dValue) < 0 {
                return nil
            } else {
                debits.append(debit)
                saldoCuenta -= dValue
                return debit
            }
            
        case .gain(let gValue, let gDescription, let gType):
            
            let gain = GAIN(
                transValue: gValue,
                transDescription: gDescription,
                isValid: gType
            )
            gain.delgate = self
            
            gains.append(gain)
            saldoCuenta += gValue
            return gain
        }
    }
}

class DEBIT : Transaction {
    var transValue: Float
    var transDescription: String
    var isValid: Bool
    var delgate: checkVality?
    
    init(transValue: Float, transDescription: String, isValid: Bool) {
        self.transValue = transValue
        self.transDescription = transDescription
        self.isValid = isValid
    }
}

class GAIN : Transaction {
    var transValue: Float
    var transDescription: String
    var isValid: Bool
    var delgate: checkVality?
    
    init(transValue: Float, transDescription: String, isValid: Bool) {
        self.transValue = transValue
        self.transDescription = transDescription
        self.isValid = isValid
    }
}

enum debitCategories : String {
    case work = "Inversión en trabajo"
    case entertainment = "Ocio"
    case food = "Víveres"
}

enum gainCategories : String {
    case work = "Sueldo"
    case webSite = "Sitio Web"
}

enum transactionType {
    case debit(
        dValue: Float,
        dDescription: String,
        dValid: Bool
    )
    case gain(
        gValue: Float,
        gDescription: String,
        gValid: Bool
    )
}

extension Transaction {
    mutating func invalidateTransaction() {
        isValid = false
    }
}

extension Transaction {
    mutating func checkVality(value: Transaction) -> Float {
        if value.isValid {
            return value.transValue
        } else {
            return 0
        }
    }
}

extension CUENTA : invalidateTransaction {
    func invalidateTransaction(transaction: Transaction) {
        if transaction.isValid {
            print("Succes")
        } else {
            print("Denied")
            if transaction is DEBIT {
                saldoCuenta += transaction.transValue
            } else if transaction is GAIN {
                saldoCuenta -= transaction.transValue
            }
        }
    }
}

extension CUENTA : checkVality {
    func checkVality(value: Transaction) -> Float {
        if value.isValid == true {
            print("FINE!")
            print(saldoCuenta)
        } else {
            print("Something is wrong!")
            if value is DEBIT {
                saldoCuenta += value.transValue
                print(saldoCuenta)
            } else if value is GAIN {
                saldoCuenta -= value.transValue
                print(saldoCuenta)
            }
        }
        return value.transValue
    }
}

var me = USUARIO(nombreUsuario: "Daniel", apellidoUsuario: "Caldera")

me.cuentaUsuario = CUENTA(bancoCuenta: "Bancomer", saldoCuenta: 1_500_000)

me.cuentaUsuario?.addTransaction(
    transaction: .debit(
        dValue: 10_000,
        dDescription: "Un perro",
        dValid: Bool.random()
        )
    )

for debit in me.cuentaUsuario?.debits ?? [] {
    print(debit.transValue, debit.transDescription, debit.isValid)
}

print(me.cuentaUsuario!.saldoCuenta)

var salary =
    me.cuentaUsuario?.addTransaction (
        transaction: .gain (
            gValue: 60_000,
            gDescription: "Sueldo en Apple",
            gValid: Bool.random()
        )
)

var work =
    me.cuentaUsuario?.addTransaction(
        transaction: .debit(
            dValue: 500_000,
            dDescription: "Me compré una iMac",
            dValid: false
        )
)

print(me.cuentaUsuario?.checkVality(value: salary!) ?? "Oh no!")
print(me.cuentaUsuario?.checkVality(value: work!) ?? "Oh no!")
