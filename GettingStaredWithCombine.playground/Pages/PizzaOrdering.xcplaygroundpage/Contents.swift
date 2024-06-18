//: [Previous](@previous)

import Foundation
import Combine

let pizzaOrder = Order()

let pizzaOrderPublisher = NotificationCenter.default.publisher(for: .didUpdateOrderStatus, object: pizzaOrder)

// sink, map은 비동기적으로 일어남
pizzaOrderPublisher.sink { Notification in
    Task {
        try? await Task.sleep(for: .seconds(2))
    }
    print("Notification start: \(Notification)")
    dump(pizzaOrder)
    print("Notification end")
}

pizzaOrderPublisher.map { Notification in
    return Notification.userInfo?["status"] as? OrderStatus ?? OrderStatus.placing
}
.sink { orderStatus in
    print("Order status [\(orderStatus)")
}

// 여기서 pizzaOrder의 status가 바뀜
/// status가 nil이 아닌 것만 status를 processing으로 바꿈
pizzaOrderPublisher.compactMap { notification in
    notification.userInfo?["status"] as? OrderStatus
}
.assign(to: \.status, on: pizzaOrder)

// NotificationCenter를 사용하여 특정 이벤트가 발생했음을 다른 부분에 알리는 기능 수행
/// 아직 pizzaOrder의 status는 바뀌지 않은 상태
NotificationCenter.default.post(name: .didUpdateOrderStatus, object: pizzaOrder, userInfo: ["status": OrderStatus.processing])

print("Order: \(pizzaOrder.status)")

//: [Next](@next)
