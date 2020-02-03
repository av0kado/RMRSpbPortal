//
// DeviceDetailsViewController
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 01 February 2020.
// Copyright (c) 2020 RedMadRobot. All rights reserved.
//

import UIKit
import Combine

class DeviceDetailsViewController: UIViewController {
    let viewModel: DeviceDetailsViewModel
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle

    init(viewModel: DeviceDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("\(#function) not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    // MARK: - Views

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let errorView: CommonErrorView = CommonErrorView()
    private let loadingView: CommonLoadingView = CommonLoadingView()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private let osLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    private let projectsTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = "Projects"
        return label
    }()

    private let projectsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private let takeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemFill
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Take", for: .normal)
        return button
    }()

    private let returnButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemFill
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Return", for: .normal)
        return button
    }()

    // MARK: - Setup

    private func setup() {
        setupViews()
        setupActions()
        setupBindings()
        viewModel.reload()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        setupContentView()
        view.addSubview(contentView.forAutoLayout())
        contentView.constrainToFill(view)
        view.addSubview(errorView.forAutoLayout())
        errorView.constrainToFill(view)
        view.addSubview(loadingView.forAutoLayout())
        loadingView.constrainToFill(view)
    }

    private func setupActions() {
        takeButton.addTarget(self, action: #selector(takeTap), for: .touchUpInside)
        returnButton.addTarget(self, action: #selector(returnTap), for: .touchUpInside)
        errorView.retryAction = { [weak self] in self?.viewModel.reload() }
    }

    private func setupBindings() {
        viewModel.canReturn.sink(receiveValue: { [weak self] canReturn in
            self?.returnButton.isEnabled = canReturn
        }).store(in: &cancellables)

        viewModel.canTake.sink(receiveValue: { [weak self] canTake in
            self?.takeButton.isEnabled = canTake
        }).store(in: &cancellables)

        viewModel.state.sink(receiveValue: { [weak self] state in
            self?.update(with: state)
        }).store(in: &cancellables)
    }

    // MARK: - Update

    private func update(with state: DeviceDetailsState) {
        loadingView.stop()
        var hideContentView = true
        var hideLoadingView = true
        var hideErrorView = true
        switch state {
            case .device(let device):
                hideContentView = false
                updateViews(with: device)
            case .loading:
                hideLoadingView = false
            case .error(let error):
                hideErrorView = false
                errorView.descriptionText = error.localizedDescription
        }
        contentView.isHidden = hideContentView
        loadingView.isHidden = hideLoadingView
        errorView.isHidden = hideErrorView
        if hideLoadingView {
            loadingView.stop()
        } else {
            loadingView.start()
        }
    }

    private func updateViews(with device: Device) {
        nameLabel.text = device.name
        osLabel.text = "\(device.operatingSystem)"
        descriptionLabel.text = device.description
        descriptionLabel.isHidden = device.description == nil
        if let firstProject = device.projects.first {
            projectsLabel.text = device.projects.dropFirst().reduce(firstProject.name) { $0 + ", " + $1.name }
        } else {
            projectsLabel.text = "Nothing here"
        }
        statusLabel.text = "\(device.status)"
    }

    // MARK: - Helpers

    private func setupContentView() {
        let stackView = UIStackView(arrangedSubviews: [
            infoSectionView(),
            projectsSectionView(),
            statusSectionView()
        ])
        for i in 0...1 {
            let separator = separatorView()
            stackView.insertArrangedSubview(separator.forAutoLayout(), at: i * 2 + 1)
            separator.heightAnchor.constrain(to: 0.5)
        }
        stackView.axis = .vertical
        stackView.spacing = 16
        contentView.addSubview(stackView.forAutoLayout())
        stackView.constrainToFill(contentView, top: 20, bottom: nil, leading: 16, trailing: 16)
        contentView.backgroundColor = .systemBackground
    }

    private func infoSectionView() -> UIView {
        let stackView = UIStackView(arrangedSubviews: [ nameLabel, osLabel, descriptionLabel ])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }

    private func projectsSectionView() -> UIView {
        let stackView = UIStackView(arrangedSubviews: [ projectsTitleLabel, projectsLabel ])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }

    private func statusSectionView() -> UIView {
        let buttonsView = statusButtonsView()
        let stackView = UIStackView(arrangedSubviews: [ statusLabel, buttonsView.forAutoLayout() ])
        buttonsView.heightAnchor.constrain(to: 60)
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }

    private func statusButtonsView() -> UIView {
        let stackView = UIStackView(arrangedSubviews: [ takeButton, returnButton ])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }

    private func separatorView() -> UIView {
        let separatorView = UIView()
        separatorView.backgroundColor = .systemGray4
        return separatorView
    }

    // MARK: - Actions

    @objc private func takeTap() {
        viewModel.take()
    }

    @objc private func returnTap() {
        viewModel.return()
    }
}
