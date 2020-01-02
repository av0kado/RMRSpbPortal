//
// ProjectsService
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 31 December 2019.
// Copyright (c) 2019 RedMadRobot. All rights reserved.
//

import Combine

protocol ProjectsService {
    func loadProjects() -> Future<[Project], Error>
}
