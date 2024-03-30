//
//  NetworkingService.swift
//  vkServices
//
//  Created by Medeu Pazylov on 30.03.2024.
//

import Foundation

final class NetworkingService {
  func fetchData(from url: URL, completion: @escaping(Data?) -> Void) {
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { data, response, error in
        if let error = error {
          print("Error: \(error)")
          completion(nil)
          return
        }
        guard let data = data else {
          print("Error: Unable to get data")
          completion(nil)
          return
        }
        completion(data)
      }
      task.resume()
  }
}
