import Foundation

public class Person {
    public var name: String = ""
    public var lastName: String = ""
    public var account: Acccount?
    
    public init(name: String, lastName: String) {
        self.name = name
        self.lastName = lastName
    }
}
