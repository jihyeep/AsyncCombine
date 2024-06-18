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

// 숫자
123.words.publisher.sink { print($0) }
123.description.publisher.sink { print($0) }
