import Foundation

var me = Person(name: "Daniel", lastName: "Caldera")

let account = Acccount(amount: 10_000, name: "X bank")

me.account = account

print(me.account!)

let entertainment = Budget(category: .entertainment, budget: 100, name: "Entretenimiento")
let health = Budget(category: .health, budget: 300, name: "Salud")

account.add(budget: entertainment)
account.add(budget: health)

do {
    try me.account?.addTransaction(
        transaction: .debit(
            value: 20,
            name: "Cafe con amigos",
            category: DebitCategories.food,
            date: Date(year: 2018, month: 11, day: 14)
        )
    )
} catch {
    print("Cafe con amigos", error)
}

do {
    try me.account?.addTransaction(
        transaction: .debit(
            value: 100,
            name: "Juego PS4",
            category: .entertainment,
            date: Date(year: 2018, month: 11, day: 10)
        )
    )
} catch {
    print("Error in game PS4", error)
}

do {
    try me.account?.addTransaction(
        transaction: .debit(
            value: 500,
            name: "PS4",
            category: .entertainment,
            date: Date(year: 2018, month: 11, day: 10)
        )
    )
} catch {
    print("Error in PS4", error)
}

try me.account?.addTransaction(
    transaction: .gain(
        value: 1000,
        name: "Salario",
        date: Date(year: 2018, month: 11, day: 1)
    )
)

var salary = try me.account?.addTransaction(
    transaction: .gain(
        value: 1000,
        name: "Salario",
        date: Date(year: 2018, month: 11, day: 1)
    )
)

DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    salary?.invalidateTrantraction()
    print("Invalidated")
}

print(me.account!.amount)

print(me.account?.amount ?? 0)

print(me.account?.lifeTimeValue())

enum HttpMethods: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

print(HttpMethods.delete.rawValue)

func sum<N: Numeric>(a: N, b: N) -> N {
    return a + b
}

print(sum(a: 10, b: 12))

let array = [2, 21, 30, 5, 20, 11, 14, 10]
for element in array where element > 10 {
    print(element)
}
