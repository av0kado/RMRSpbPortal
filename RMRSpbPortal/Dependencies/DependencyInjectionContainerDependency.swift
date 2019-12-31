//
//  DependencyInjectionContainerDependency.swift
//  RMRSpbPortal
//
//  Created by Amir Zigangaraev on 30.12.2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import Legacy

protocol DependencyInjectionContainerDependency {
    var container: DependencyInjectionContainer? { get set }
}
