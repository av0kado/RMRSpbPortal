//
//  CommonErrorView.swift
//  RMRSpbPortal
//
//  Created by Amir Zigangaraev on 07.01.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

class CommonErrorView: UIView {
    var descriptionText: String? {
        get { descriptionLabel.text }
        set { descriptionLabel.text = newValue }
    }
    var retryAction: (() -> Void)?

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

    private let retryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitle("Retry", for: .normal)
        return button
    }()

    // MARK: - Helpers

    private func setup() {
        backgroundColor = .systemBackground

        addSubview(descriptionLabel.forAutoLayout())
        descriptionLabel.constrainToCenter(in: self)
        descriptionLabel.constrainToFill(self, top: nil, bottom: nil, leading: 20, trailing: 20)
        addSubview(retryButton.forAutoLayout())
        retryButton.constrainToCenter(in: self, yOffset: nil)
        retryButton.topAnchor.constrain(to: descriptionLabel.bottomAnchor, constant: 20)

        retryButton.addTarget(self, action: #selector(retryTap), for: .touchUpInside)
    }

    @objc private func retryTap() {
        retryAction?()
    }
}
