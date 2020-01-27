//
//  LoadingView.swift
//  RMRSpbPortal
//
//  Created by Amir Zigangaraev on 25.01.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("\(#function) not implemented")
    }

    func start() {
        activityIndicator.startAnimating()
        self.isHidden = false
    }

    func stop() {
        activityIndicator.startAnimating()
        self.isHidden = true
    }

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.color = .label
        return view
    }()

    private func setup() {
        backgroundColor = UIColor.systemGray.withAlphaComponent(0.7)
        addSubview(activityIndicator.forAutoLayout())
        activityIndicator.constrainToCenter(in: self)
    }
}
