import Foundation

fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String,Error>) -> Void) {
        let request = makeRequest(code: code)
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func makeRequest(code: String) -> URLRequest {
        makeRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
    
    private struct OAuthTokenResponseBody: Codable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
}
// MARK: - Request Factory
extension OAuth2Service {
    private func makeRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL) -> URLRequest {
            var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
            request.httpMethod = httpMethod
            return request
        }
}


// MARK: - Network Client

extension OAuth2Service {
    private func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        let task = urlSession.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }

    private func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
}

































//fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
//private enum NetworkError: Error {
//    case codeError
//}
//func fetchAuthToken(_ code: String?, complition: @escaping (Swift.Result<String, Error>) -> Void) {
//    var urlComponents = URLComponents (string: UnsplashAuthorizeURLString)!
//    urlComponents.queryItems = [
//    URLQueryItem(name: "client_id", value: AccessKey),
//    URLQueryItem(name: "client_secret", value: SecretKey),
//    URLQueryItem(name: "redirect_uri", value: RedirectURI),
//    URLQueryItem(name: "code", value: code),
//    URLQueryItem(name: "grant_type", value: "authorization_code")
//    ]
//    let requestURL = urlComponents.url!
//    print(requestURL)
//    var request = URLRequest(url: requestURL)
//    request.httpMethod = "POST"
//    let task = URLSession.shared.dataTask(with: request) { data, response, erorr in
//        if let erorr = erorr {
//            complition(.failure(erorr))
//        }
//
//        if let response = response as? HTTPURLResponse,
//           response.statusCode < 200 || response.statusCode >= 300 {
//            complition(.failure(NetworkError.codeError))
//        }
//        if let data = data {
//            print(String(data: data, encoding: .utf8))
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
//                DispatchQueue.main.async {
//                    complition(.success(response.accessToken))
//                }
//            } catch let error {
//                print("token error")
//                complition(.failure(error))
//            }
//        }
//    }
//    task.resume()
//}
//
//private struct OAuthTokenResponseBody: Codable {
//    let accessToken: String
//    let tokenType: String
//    let scope: String
//    let createdAt: Int
//
//    enum CodingKeys: String, CodingKey {
//        case accessToken = "access_token"
//        case tokenType = "token_type"
//        case scope
//        case createdAt = "created_at"
//    }
//}
