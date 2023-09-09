import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case invalidParameters
    
    case error(Error)
}

struct API {
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    let url: URL
    let method: Method
    let parameters: [String: Any]?
    
    func request<T: Decodable>() -> AnyPublisher<T, APIError> {
        var request =  URLRequest(url: url)
        
        if let parameters = parameters {
            switch method {
            case .get:
                if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) {
                    
                    var queryItems: [URLQueryItem] = []
                    for (key, value) in parameters {
                        if let string = value as? String {
                            queryItems.append(URLQueryItem(name: key, value: string))
                        } else if let number = value as? NSNumber {
                            queryItems.append(URLQueryItem(name: key, value: "\(number)"))
                        } else {
                            return Fail(error: .invalidParameters).eraseToAnyPublisher()
                        }
                    }
                    urlComponents.queryItems = queryItems
                    
                    if let _url = urlComponents.url {
                        request =  URLRequest(url: _url)
                    } else {
                        return Fail(error: .invalidURL).eraseToAnyPublisher()
                    }
                    
                } else {
                    return Fail(error: .invalidURL).eraseToAnyPublisher()
                }
                
            case .post:
                let jsonData: Data
                do {
                    jsonData = try JSONSerialization.data(withJSONObject: parameters)
                } catch {
                    return Fail(error: .error(error)).eraseToAnyPublisher()
                }
                
                request.httpBody = jsonData
            }
        }
        
        request.httpMethod = method.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .catch({ Fail(error: APIError.error($0)).eraseToAnyPublisher() })
                .eraseToAnyPublisher()
    }
}
