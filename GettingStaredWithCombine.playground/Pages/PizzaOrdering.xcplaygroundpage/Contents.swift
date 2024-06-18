//: [Previous](@previous)

import Foundation
import Combine

let pizzaOrder = Order()

let pizzaOrderPublisher = NotificationCenter.default.publisher(for: .didUpdateOrderStatus, object: pizzaOrder)

pizzaOrderPublisher.sink { Notification in
    print(Notification)
    dump(Notification)
}

pizzaOrderPublisher.map { Notification in
    Notification.userInfo?["status"] as? OrderStatus ?? OrderStatus.placing
}
.sink { orderStatus in
    print("Order status [\(orderStatus)")
}

// NotificationCenter를 사용하여 특정 이벤트가 발생했음을 다른 부분에 알리는 기능 수행
NotificationCenter.default.post(name: .didUpdateOrderStatus, object: pizzaOrder, userInfo: ["status": OrderStatus.processing])

print("Order: \(pizzaOrder.status)")

//: [Next](@next)
