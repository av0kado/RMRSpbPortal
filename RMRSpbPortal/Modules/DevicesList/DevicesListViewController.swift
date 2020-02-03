//
// DevicesListViewController
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 02 January 2020.
// Copyright (c) 2020 RedMadRobot. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa

class DevicesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let viewModel: DevicesListViewModel
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: DevicesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("\(#function) not implemented")
    }

    // MARK: - Views

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.registerReusableCell(DeviceCell.id)
        return tableView
    }()

    private let errorView: CommonErrorView = CommonErrorView()
    private let loadingView: CommonLoadingView = CommonLoadingView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    // MARK: - Private

    private var devices: [Device] = []

    // MARK: - Helpers

    private func setup() {
        setupViews()
        setupBindings()
        viewModel.reload()
    }

    private func setupViews() {
        navigationItem.title = "Devices list"
        view.backgroundColor = .systemBackground

        view.addSubview(tableView.forAutoLayout())
        tableView.constrainToFill(view)
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(errorView.forAutoLayout())
        errorView.constrainToFill(view)
        errorView.retryAction = { [weak self] in
            self?.viewModel.reload()
        }

        view.addSubview(loadingView.forAutoLayout())
        loadingView.constrainToFill(view)
    }

    private func setupBindings() {
        viewModel.devicesListStatePublisher
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.update(with: $0) }
            )
            .store(in: &cancellables)
    }

    private func update(with state: DevicesListState) {
        var tableViewHidden = true
        var loadingViewHidden = true
        var errorViewHidden = true
        switch state {
            case .devices(let devices):
                self.devices = devices
                tableView.reloadData()
                tableViewHidden = false
            case .error(let error):
                errorView.descriptionText = error.localizedDescription
                errorViewHidden = false
            case .loading:
                loadingViewHidden = false
        }
        tableView.isHidden = tableViewHidden
        loadingView.isHidden = loadingViewHidden
        errorView.isHidden = errorViewHidden
        if loadingViewHidden {
            loadingView.stop()
        } else {
            loadingView.start()
        }
    }

    // MARK: - Table view

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(DeviceCell.id)
        cell.set(device: devices[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.select(device: devices[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
