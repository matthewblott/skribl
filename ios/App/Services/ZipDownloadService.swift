import UIKit

final class ZipDownloadService {
  enum DownloadError: Error {
    case invalidResponse
    case serverError(statusCode: Int)
    case fileSystemError(Error)
  }
  
  private let session: URLSession
  
  init(cookieStorage: HTTPCookieStorage = .shared) {
    let config = URLSessionConfiguration.default
    config.httpCookieStorage = cookieStorage
    config.httpShouldSetCookies = true
    config.httpCookieAcceptPolicy = .always
    self.session = URLSession(configuration: config)
  }
  
  func downloadZip(csrfToken: String, filename: String) async throws -> URL {
    guard let baseURL = Endpoint.baseURL else {
      throw DownloadError.invalidResponse
    }
   
    let userId = Settings.userId
    var request = URLRequest(url: baseURL.appending(path: "\(userId)/account/download"))
    request.httpMethod = "POST"
    request.httpBody = "authenticity_token=\(csrfToken)".data(using: .utf8)
    request.setValue(csrfToken, forHTTPHeaderField: "X-CSRF-Token")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let (tempURL, response) = try await session.download(for: request)
    
    guard let http = response as? HTTPURLResponse else {
      throw DownloadError.invalidResponse
    }
    guard http.statusCode == 200 else {
      throw DownloadError.serverError(statusCode: http.statusCode)
    }
    
    do {
      let documents = try FileManager.default.url(
        for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false
      )
      let destination = documents.appendingPathComponent(filename)
      
      if FileManager.default.fileExists(atPath: destination.path) {
        try FileManager.default.removeItem(at: destination)
      }
      try FileManager.default.moveItem(at: tempURL, to: destination)
      return destination
    } catch {
      throw DownloadError.fileSystemError(error)
    }
  }
}
