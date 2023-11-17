//
//  HTTPUtility.swift
//  CrytocurrencyApp
//
//  Created by Najran Emarah on 02/05/1445 AH.
//

import Foundation

private let apiKey = "8ac49ef0-481c-4914-8352-9b314b3d3f79"

private let baseAPIURL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency"

enum APIDataError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    case emptyString
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        case .emptyString: return "Search string is empty"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}

final class HttpUtility {

    static let shared: HttpUtility = HttpUtility()
    private let urlSession = URLSession.shared
  
  
    private init() {
       
    }
    
    func getLatestCryptographyDats( completion: @escaping (Result<LatestListing, APIDataError>) -> ()) {
     
        guard let url = URL(string: "\(baseAPIURL)/listings/latest?CMC_PRO_API_KEY=\(apiKey)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url,  completion: completion)
    }
    
    private func loadURLAndDecode(url: URL, completion: @escaping (Result<LatestListing, APIDataError>) -> ()) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let str = String(decoding: data, as: UTF8.self)
                print("Data is")
                print(str)
                print("Data done")
                let decodedResponse =  try JSONDecoder().decode(LatestListing.self, from: data)
               
                self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
    }
    
    private func executeCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, APIDataError>, completion: @escaping (Result<D, APIDataError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
}
