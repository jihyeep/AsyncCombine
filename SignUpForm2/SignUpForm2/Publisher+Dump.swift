//
//  Publisher+Dump.swift
//  SignUpForm2
//
//  Created by 박지혜 on 6/20/24.
//

import Foundation
import Combine

extension Publisher {
    func dump() -> AnyPublisher<Self.Output, Self.Failure> {
        handleEvents(receiveSubscription: { value in
            Swift.dump(value)
//        }, receiveCompletion: { value in
//            Swift.print(">>")
//            Swift.dump(value)
        })
        .eraseToAnyPublisher()
    }
}
