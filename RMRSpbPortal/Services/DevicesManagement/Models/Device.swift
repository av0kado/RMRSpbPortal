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

struct Device: Hashable, Identifiable {
    /// Device usage status.
    enum Status: Hashable, CustomStringConvertible {
        /// Device is on dock and can be taken.
        case onStation
        /// Device is taken by provided user.
        case userTaken(User)
        /// Device is unavailable (e.g. in repair service).
        case unavailable

        var description: String {
            switch self {
                case .onStation:
                    return "On station"
                case .unavailable:
                    return "Unavailable"
                case .userTaken(let user):
                    return "Taken by \(user.name)"
            }
        }
    }

    enum OperatingSystem: Hashable, CustomStringConvertible {
        /// Operating system version.
        ///
        /// Examples: `.iOS("13.3.2")`, `.android("9.0")`
        typealias Version = String

        case iOS(Version)
        case android(Version)

        var description: String {
            switch self {
                case .iOS(let version):
                    return "iOS \(version)"
                case .android(let version):
                    return "Android \(version)"
            }
        }
    }

    let id: String
    var name: String
    var description: String?
    var status: Status
    var operatingSystem: OperatingSystem
    /// Projects in which device participates and can be used to deploy and test.
    var projects: [Project]
}

extension Device.OperatingSystem: Comparable {
    static func < (lhs: Device.OperatingSystem, rhs: Device.OperatingSystem) -> Bool {
        switch (lhs, rhs) {
            case (.iOS(let lhsVersion), .iOS(let rhsVersion)), (.android(let lhsVersion), .android(let rhsVersion)):
                return smaller(lhs: lhsVersion, rhs: rhsVersion)
            default:
                return false
        }
    }

    static func == (lhs: Device.OperatingSystem, rhs: Device.OperatingSystem) -> Bool {
        switch (lhs, rhs) {
            case (.iOS(let lhsVersion), .iOS(let rhsVersion)), (.android(let lhsVersion), .android(let rhsVersion)):
                return equal(lhs: lhsVersion, rhs: rhsVersion)
            default:
                return false
        }
    }

    private static func smaller(lhs: String, rhs: String) -> Bool {
        let (lhsComponents, rhsComponents) = components(lhs: lhs, rhs: rhs)
        return zip(lhsComponents, rhsComponents).first(where: { $0 < $1 }) != nil ? true : false
    }

    private static func equal(lhs: String, rhs: String) -> Bool {
        let (lhsComponents, rhsComponents) = components(lhs: lhs, rhs: rhs)
        return zip(lhsComponents, rhsComponents).first(where: { $0 != $1 }) != nil ? true : false
    }

    private static func components(lhs: String, rhs: String) -> ([Int], [Int]) {
        var lhsComponents = lhs.components(separatedBy: ".").compactMap { Int($0) }
        var rhsComponents = rhs.components(separatedBy: ".").compactMap { Int($0) }
        while lhsComponents.count < rhsComponents.count {
            lhsComponents.append(0)
        }
        while rhsComponents.count < lhsComponents.count {
            rhsComponents.append(0)
        }
        return (lhsComponents, rhsComponents)
    }
}
