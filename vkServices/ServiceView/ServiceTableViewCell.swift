//
//  ServiceTableViewCell.swift
//  vkServices
//
//  Created by Medeu Pazylov on 30.03.2024.
//

import UIKit

final class ServiceTableViewCell: UITableViewCell {

  static let identifier = "serviceTableViewCell"

  var service: Service? {
    didSet {
      guard let service else { return }
      title.text = service.name
      subTitle.text = service.description
    }
  }

  var iconData: Data? {
    didSet {
      guard let iconData,
            let image = UIImage(data: iconData) else { return }
      iconView.image = image
    }
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
    setupLayout()
    self.backgroundColor = .clear
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView() {
    contentView.addSubview(iconView)
    contentView.addSubview(mainContentView)
    mainContentView.addArrangedSubview(title)
    mainContentView.addArrangedSubview(subTitle)
    contentView.addSubview(chevron)
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      iconView.heightAnchor.constraint(equalToConstant: 64),
      iconView.widthAnchor.constraint(equalToConstant: 64),
      iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

      mainContentView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
      mainContentView.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -16),
      mainContentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

      chevron.heightAnchor.constraint(equalToConstant: 16),
      chevron.widthAnchor.constraint(equalToConstant: 16),
      chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }

  private let iconView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .gray
    view.layer.cornerRadius = 24.0
    return view
  } ()

  private let mainContentView: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.distribution = .equalSpacing
    view.translatesAutoresizingMaskIntoConstraints = false
    view.alignment = .leading
    return view
  } ()

  private let title: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    label.textColor = .white
    return label
  } ()

  private let subTitle: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 12)
    label.textColor = .white
    label.numberOfLines = 3
    return label
  } ()

  private let chevron: UIImageView = {
    let chevron = UIImage(systemName: "chevron.right")
    let view = UIImageView(image: chevron)
    view.contentMode = .scaleAspectFit
    view.tintColor = .gray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  } ()
}
