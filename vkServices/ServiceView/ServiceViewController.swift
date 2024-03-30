//
//  ViewController.swift
//  vkServices
//
//  Created by Medeu Pazylov on 30.03.2024.
//

import UIKit

final class ServiceViewController: UIViewController {

  private let presenter: ServicePresenterProtocol

  init(presenter: ServicePresenterProtocol) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupLayout()
    setupNavigationBar()
    tableView.delegate = self
    tableView.dataSource = self
    presenter.loadServices()
  }

  private func setupView() {
    view.backgroundColor = .black
    view.addSubview(tableView)
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  private func setupNavigationBar() {
    let title = UILabel()
    title.text = "Сервисы"
    title.textColor = .white
    navigationItem.titleView = title
    navigationController?.navigationBar.barTintColor = .clear
  }

  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .clear
    tableView.register(ServiceTableViewCell.self, forCellReuseIdentifier: ServiceTableViewCell.identifier)
    return tableView
  } ()

}

extension ServiceViewController: ServiceViewProtocol {
  func updateServiceList() {
    tableView.reloadData()
  }
}

extension ServiceViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.getServiceCount()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}

extension ServiceViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceTableViewCell.identifier) as? ServiceTableViewCell else {
      return UITableViewCell()
    }
    cell.service = presenter.getServiceAt(index: indexPath.row)
    cell.iconData = presenter.getIconFor(index: indexPath.row)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    presenter.openLinkForService(index: indexPath.row)
  }
}

