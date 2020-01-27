//
//  DevicesListErrorView.swift
//  RMRSpbPortal
//
//  Created by Amir Zigangaraev on 07.01.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

class DevicesListErrorView: UIView {
    var descriptionText: String? {
        get { descriptionLabel.text }
        set { descriptionLabel.text = newValue }
    }
    var didTapRefresh: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("\(#function) not implemented")
    }

    // MARK: - Views

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.label
        label.numberOfLines = 0
        return label
    }()

    private let refreshButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()

    // MARK: - Helpers

    private func setup() {
        backgroundColor = .systemBackground

        addSubview(descriptionLabel.forAutoLayout())
        descriptionLabel.constrainToCenter(in: self)
        descriptionLabel.constrainToFill(self, top: nil, bottom: nil, leading: 20, trailing: 20)
        addSubview(refreshButton.forAutoLayout())
        refreshButton.constrainToCenter(in: self, yOffset: nil)
        refreshButton.topAnchor.constrain(to: descriptionLabel.bottomAnchor, constant: 20)

        refreshButton.addTarget(self, action: #selector(refreshTap), for: .touchUpInside)
    }

    @objc private func refreshTap() {
        didTapRefresh?()
    }
}
