//
// Subject
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 05 January 2020.
// Copyright (c) 2020 RedMadRobot. All rights reserved.
//

import Combine

extension Subject {
    func anySubscriber() -> AnySubscriber<Output, Failure> {
        AnySubscriber(
            Subscribers.Sink(
                receiveCompletion: { [weak self] completion in
                    self?.send(completion: completion)
                },
                receiveValue: { [weak self] value in
                    self?.send(value)
                }
            )
        )
    }
}
