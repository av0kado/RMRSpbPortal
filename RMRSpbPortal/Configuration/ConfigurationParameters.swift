//
//  ConfigurationParameters.swift
//  RMRSpbPortal
//
//  Created by Vladislav Maltsev on 02.11.2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import UIKit

struct ConfigurationParameters {
    private let bundle: Bundle

    init(bundle: Bundle) {
        self.bundle = bundle
    }

    var endpoint: URL? {
        guard let endpoint = bundle.infoDictionary?["Endpoint"] as? String else { return nil }
        let cleanedEndpoint = unescape(string: endpoint)
        return URL(string: cleanedEndpoint)
    }

    private func unescape(string: String) -> String {
        return string.replacingOccurrences(of: "\\/", with: "/")
    }
}

extension Bundle {
    var configurationParameters: ConfigurationParameters {
        return ConfigurationParameters(bundle: self)
    }
}
