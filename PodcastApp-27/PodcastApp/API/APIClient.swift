//
//  APIClient.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 4/25/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import Foundation

protocol APIClient {
    var session: URLSession { get }
}

extension APIClient {
    func parseDecodable<T : Decodable>(completion: @escaping (Result<T, APIError>) -> Void) -> (Result<Data, APIError>) -> Void {
        return { result in
            switch result {
            case .success(let data):

                do {
                    let jsonDecoder = JSONDecoder()
                    let object = try jsonDecoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(object))
                    }
                } catch let decodingError as DecodingError {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError(decodingError)))
                    }
                }
                catch {
                    fatalError("Unhandled error raised.")
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    @discardableResult
    func perform(request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error as NSError? {
                if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
                    return
                }

                completion(.failure(.networkingError(error)))
                return
            }

            guard let http = response as? HTTPURLResponse, let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            switch http.statusCode {
            case 200:
                completion(.success(data))

            case 400...499:
                let body = String(data: data, encoding: .utf8)
                completion(.failure(.requestError(http.statusCode, body ?? "<no body>")))

            case 500...599:
                completion(.failure(.serverError))

            default:
                fatalError("Unhandled HTTP status code: \(http.statusCode)")
            }
        }
        task.resume()
        return task
    }
}

enum APIError : Error {
    case networkingError(Error)
    case serverError // HTTP 5xx
    case requestError(Int, String) // HTTP 4xx
    case invalidResponse
    case decodingError(DecodingError)

    var localizedDescription: String {
        switch self {
        case .networkingError(let error): return "Error sending request: \(error.localizedDescription)"
        case .serverError: return "HTTP 500 Server Error"
        case .requestError(let status, let body): return "HTTP \(status)\n\(body)"
        case .invalidResponse: return "Invalid Response"
        case .decodingError(let error):

            return "Decoding error: \(error.localizedDescription)"

        }
    }
}
