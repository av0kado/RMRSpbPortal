//
// NetworkConfigurator
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 30 December 2019.
// Copyright (c) 2019 RedMadRobot. All rights reserved.
//

import Legacy

class NetworkConfigurator: Configurator {
    private var endpoint: URL

    init(endpoint: URL) {
        self.endpoint = endpoint
    }

    func build() -> DependencyInjectionContainer {
        fatalError("\(#file) not implemented.")
    }
}
