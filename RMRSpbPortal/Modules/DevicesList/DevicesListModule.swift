//
// DevicesListModule
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 02 January 2020.
// Copyright (c) 2020 RedMadRobot. All rights reserved.
//

protocol DevicesListModule {
    var didSelectDevice: ((Device.ID) -> Void)? { get set }
}
