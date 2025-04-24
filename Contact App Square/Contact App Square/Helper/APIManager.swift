//
//  APIManager.swift
//  Contact-App
//
//  Created by RNF-Dev on 24/04/25.
//

import Foundation

class NetworkCall: NSObject {

    enum Services: String {
        case posts = "posts"
        case get = "get"
    }

    private var parameters: [String: Any]
    private var headers: [String: String]
    private var method: String
    private var urlString: String
    private var isJSONRequest: Bool

    init(data: [String: Any] = [:],
         headers: [String: String] = [:],
         url: String? = nil,
         service: Services? = nil,
         method: String = "POST",
         isJSONRequest: Bool = true) {

        self.parameters = data
        self.headers = headers
        self.method = method
        self.isJSONRequest = isJSONRequest

        if let customURL = url {
            self.urlString = customURL
        } else if let service = service {
            self.urlString = "https://jsonplaceholder.typicode.com/\(service.rawValue)"
        } else {
            self.urlString = ""
        }

        print("Service: \(service?.rawValue ?? self.urlString)\nData: \(parameters)")
    }

    func executeQuery<T: Codable>(completion: @escaping (Result<T, Error>) -> Void) {
        var requestURL = urlString

        // For GET: append query parameters to URL
        if method.uppercased() == "GET", !parameters.isEmpty {
            let queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: urlString)
            components?.queryItems = queryItems
            requestURL = components?.url?.absoluteString ?? urlString
        }

        guard let url = URL(string: requestURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method

        // Headers
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }

        // For non-GET methods: add body if needed
        if method.uppercased() != "GET" {
            if isJSONRequest {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                if !parameters.isEmpty {
                    do {
                        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    } catch {
                        completion(.failure(error))
                        return
                    }
                }
            } else {
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                let queryString = parameters.map { "\($0)=\($1)" }.joined(separator: "&")
                request.httpBody = queryString.data(using: .utf8)
            }
        }

        // URLSession Call
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                completion(.failure(err))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "No response", code: 500)))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 204)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch let decodingError {
                print(String(data: data, encoding: .utf8) ?? "Invalid data format")
                completion(.failure(decodingError))
            }
        }.resume()
    }

}
