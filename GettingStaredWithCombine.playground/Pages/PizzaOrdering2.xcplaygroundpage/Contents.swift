import Foundation
import Combine

let margheritaOrder = Order(toppings: [
  Topping("tomatoes", isVegan: true),
  Topping("vegan mozzarella", isVegan: true),
  Topping("basil", isVegan: true)
])

let orderStatusPublisher = NotificationCenter.default.publisher(for: .didUpdateOrderStatus, object: margheritaOrder)
      .compactMap { notification in
        notification.userInfo?["status"] as? OrderStatus
      }
      .print()
        // 구체적인 퍼블리셔 타입을 숨기고 AnyPublisher 타입으로 변환
        /// 이를 통해 퍼블리셔의 내부 구현을 감추고, 더 유연한 코드 작성이 가능
      .eraseToAnyPublisher()

let shippingAddressValidPublisher = NotificationCenter.default.publisher(for: .didValidateAddress, object: margheritaOrder)
  .compactMap { notification in
    notification.userInfo?["addressStatus"] as? AddressStatus
  }
  .print()
  .eraseToAnyPublisher()

// 퍼블리셔를 결합하여 하나의 퍼블리셔로 만드는 데 사용
/// 각각의 퍼블리셔로부터 값을 수신할 때마다 가장 최근의 값을 결합하여 새로 생성된 퍼블리셔로 방출
let readyToProducePublisher = Publishers.CombineLatest(orderStatusPublisher, shippingAddressValidPublisher)
readyToProducePublisher
  .print() /// 퍼블리셔의 모든 이벤트를 디버깅 목적으로 출력
  .map { (orderStatus, addressStatus) in
    orderStatus == .placed && addressStatus == .valid
  }
  .sink {
    print("Ready to ship order: \($0)")
  }

NotificationCenter.default.post(name: .didValidateAddress, object: margheritaOrder, userInfo: ["addressStatus": AddressStatus.invalid])
NotificationCenter.default.post(name: .didUpdateOrderStatus, object: margheritaOrder, userInfo: ["status": OrderStatus.placed])
NotificationCenter.default.post(name: .didValidateAddress, object: margheritaOrder, userInfo: ["addressStatus": AddressStatus.valid])

