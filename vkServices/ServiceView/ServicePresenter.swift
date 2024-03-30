//
//  ServicePresenter.swift
//  vkServices
//
//  Created by Medeu Pazylov on 30.03.2024.
//

import Foundation
import UIKit

protocol ServicePresenterProtocol {
  func loadServices()
  func getServiceCount() -> Int
  func getServiceAt(index: Int) -> Service?
  func getIconFor(index: Int) -> Data?
  func openLinkForService(index: Int)
}

protocol ServiceViewProtocol: NSObject {
  func updateServiceList()
}

final class ServicePresenter: ServicePresenterProtocol {
  private let networking: NetworkingService
  private var model: ServiceModel

  weak var view: ServiceViewProtocol?

  init(
    model: ServiceModel,
    networking: NetworkingService
  ) {
    self.model = model
    self.networking = networking
  }

  func loadServices() {
    guard let url = URL(string: model.urlString) else {
      return
    }
    networking.fetchData(from: url) { [unowned self] data in
      guard let services = self.decodeServices(data: data) else {
        return
      }
      DispatchQueue.main.async {
        self.model.services = services
        self.view?.updateServiceList()
      }
    }
  }

  func getServiceCount() -> Int {
    model.services.count
  }

  func getServiceAt(index: Int) -> Service? {
    guard index < model.services.count else {
      print("Error: No service at such index")
      return nil
    }
    return model.services[index]
  }

  func getIconFor(index: Int) -> Data? {
    guard index < model.services.count else {
      print("Error: No service at such index")
      return nil
    }
    if let iconData = model.icons[model.services[index].name] {
      return iconData
    }

    guard let url = URL(string: model.services[index].icon_url) else {
      return nil
    }

    networking.fetchData(from: url) { [unowned self] data in
      guard let data else { return }
      DispatchQueue.main.async {
        self.model.icons[self.model.services[index].name] = data
        self.view?.updateServiceList()
      }
    }
    return nil
  }

  func openLinkForService(index: Int) {
    guard index < model.services.count else {
      print("Error: No service at such index")
      return
    }
    guard let url = URL(string: model.services[index].link) else {
      return
    }
    UIApplication.shared.open(url)
  }

  private func decodeServices(data: Data?) -> [Service]? {
    do {
      guard let data = data,
            let jsonDictionary = try JSONSerialization.jsonObject(with: data) as? [String : Any],
            let body = jsonDictionary["body"] as? [String : Any],
            let services = body["services"]
      else {
        print("Error: Failed to decode data")
        return nil
      }

      let serviceData = try JSONSerialization.data(withJSONObject: services)
      let serviceList = try JSONDecoder().decode([Service].self, from: serviceData)
      return serviceList

    } catch {
      print("Error: \(error)")
      return nil
    }
  }

}
