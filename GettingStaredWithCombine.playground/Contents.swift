import Foundation
import Combine

Just(42)
    .sink { value in
        print("Received \(value)")
    }

["Pepperoni", "Mushrooms", "Onions"].publisher
    .sink { topping in
        print("\(topping) is a favorite topping for pizza")
    }

//"Combine".publisher
Just("Combine")
    .sink { value in
        print("Hello, \(value)")}
