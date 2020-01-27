//
//  ModuleFactory.swift
//  RMRSpbPortal
//
//  Created by Amir Zigangaraev on 26.01.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

protocol ModuleFactory {
    func devicesList() -> (DevicesListModule, UIViewController)
}
