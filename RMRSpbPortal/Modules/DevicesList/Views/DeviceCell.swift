//
//  DeviceCell.swift
//  RMRSpbPortal
//
//  Created by Amir Zigangaraev on 25.01.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import Legacy

class DeviceCell: UITableViewCell {
    static let id: Reusable<DeviceCell> = .fromClass()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("\(#function) not implemented")
    }

    func set(device: Device) {
        titleLabel.text = device.name
        osLabel.text = "\(device.operatingSystem)"
        statusLabel.text = "\(device.status)"
    }

    // MARK: - Views

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let osLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tertiaryLabel
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tertiaryLabel
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()

    // MARK: - Helpers

    private func setup() {
        let mainInfoStackView = UIStackView(arrangedSubviews: [ titleLabel, osLabel ])
        mainInfoStackView.alignment = .leading
        mainInfoStackView.axis = .vertical

        let stackView = UIStackView(arrangedSubviews: [ mainInfoStackView, statusLabel ])
        contentView.addSubview(stackView.forAutoLayout())
        stackView.constrainToFill(self, with: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }
}
