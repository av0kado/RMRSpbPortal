//
// Device
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 30 December 2019.
// Copyright (c) 2019 RedMadRobot. All rights reserved.
//

// TODO: Delete. No user service ATM.
struct User: Hashable {
    let id: String
    let name: String
}

struct Device: Hashable {
    /// Device usage status.
    enum Status: Hashable {
        /// Device is on dock and can be taken.
        case onStation
        /// Device is taken by provided user.
        case userTaken(User)
        /// Device is unavailable (e.g. in repair service).
        case unavailable
    }

    enum OperatingSystem: Hashable {
        /// Operating system version.
        ///
        /// Examples: `.iOS("13.3.2")`, `.android("9.0")`
        typealias Version = String

        case iOS(Version)
        case android(Version)
    }

    let id: String
    var name: String
    var description: String?
    var status: Status
    var operatingSystem: OperatingSystem
    /// Projects in which device participates and can be used to deploy and test.
    var projects: [Project]
}
