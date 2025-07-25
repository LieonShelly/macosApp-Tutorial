
import Foundation

enum FetchError: Error {
  case badURL
  case badResponse
  case badJSON
}

enum Networker {
  static func getDataForDay(month: Int, day: Int) async throws -> Day {
    let address = "https://today.zenquotes.io/api/\(month)/\(day)"
    guard let url = URL(string: address) else {
      throw FetchError.badURL
    }
    let request = URLRequest(url: url)

    let (data, response) = try await URLSession.shared.data(
      for: request)
    guard let response = response as? HTTPURLResponse, response.statusCode < 400
    else {
      throw FetchError.badResponse
    }

    guard let day = try? JSONDecoder().decode(
      Day.self,
      from: data)
    else {
      if let debugString = String(data: data, encoding: .utf8) {
        print(debugString)
      }

      throw FetchError.badJSON
    }
    return day
  }
}
