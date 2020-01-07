//
// MockProjectsService
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 07 January 2020.
// Copyright (c) 2020 RedMadRobot. All rights reserved.
//

import Combine
import Foundation

class MockProjectsService: ProjectsService {
    private lazy var mockProjects: [Project] = [
        Project(id: UUID().uuidString, name: "Project one"),
        Project(id: UUID().uuidString, name: "Project two"),
        Project(id: UUID().uuidString, name: "Project three"),
        Project(id: UUID().uuidString, name: "Project four"),
        Project(id: UUID().uuidString, name: "Project five"),
        Project(id: UUID().uuidString, name: "Project six"),
        Project(id: UUID().uuidString, name: "Project seven"),
        Project(id: UUID().uuidString, name: "Project eight"),
        Project(id: UUID().uuidString, name: "Project nine"),
        Project(id: UUID().uuidString, name: "Project ten"),
        Project(id: UUID().uuidString, name: "Project eleven"),
        Project(id: UUID().uuidString, name: "Project twelve")
    ]

    func loadProjects() -> Future<[Project], Error> {
        Future { completion in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                completion(.success(self.mockProjects))
            }
        }
    }
}
