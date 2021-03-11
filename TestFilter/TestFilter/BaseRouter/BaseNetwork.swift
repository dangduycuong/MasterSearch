//
//  BaseNetwork.swift
//  TestFilter
//
//  Created by Đặng Duy Cường on 2/4/20.
//  Copyright © 2020 Ngô Bảo Châu. All rights reserved.
//

import UIKit
import SwiftyJSON

enum HTTPMethod {
    case get
    case post
    case put
    
    var value: String {
        get {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .put:
                return "PUT"
            }
        }
    }
}

enum ServerAPI: NSInteger {
    case Youtube_v3_API //https://rapidapi.com/ytdlfree/api/youtube-v31/endpoints
    case VivaCityDocumentationAPIDocumentation //https://rapidapi.com/din-dins-club-limited-din-dins-club-limited-default/api/viva-city-documentation
}

enum Result<Success, Error: Swift.Error> {
    case success(Success)
    case failure(Error)
}

// override the Result.get() method
extension Result {
    func get() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

// use generics - this is where you can decode your data
extension Result where Success == Data {
    func decoded<T: Decodable>(using decoder: JSONDecoder = .init()) throws -> T {
        let data = try get()
        return try decoder.decode(T.self, from: data)
    }
}

class BaseNetwork {
//    static let shared: BaseNetwork = BaseNetwork()
    
    static var SERVER: ServerAPI = ServerAPI.Youtube_v3_API
    
    var fullURL: URL {
        switch (BaseNetwork.SERVER) {
        case .Youtube_v3_API:
            return  URL.init(string: "\(baseURLString)\(contextPathString)\(path)")!
        case .VivaCityDocumentationAPIDocumentation:
            return  URL.init(string: "\(baseURLString)\(contextPathString)\(path)")!
        }
    }
    
    var fullStringURL: String {
        switch (BaseNetwork.SERVER) {
        case .Youtube_v3_API:
            return  "\(baseURLString)\(contextPathString)\(path)"
        case .VivaCityDocumentationAPIDocumentation:
            return  "\(baseURLString)\(contextPathString)\(path)"
        }
    }
    
    var serverURL: URL {
        switch (BaseNetwork.SERVER) {
        case .Youtube_v3_API:
            return  URL.init(string: "\(baseURLString)\(contextPathString)")!
        case .VivaCityDocumentationAPIDocumentation:
            return  URL.init(string: "\(baseURLString)\(contextPathString)")!
        }
    }
    
    var baseURLString: String {
        switch (BaseNetwork.SERVER) {
        case .Youtube_v3_API:
            return "https://youtube-v31.p.rapidapi.com" //https://viva-city-documentation.p.rapidapi.com
        case .VivaCityDocumentationAPIDocumentation:
            return "https://viva-city-documentation.p.rapidapi.com"
        }
    }
    
    var contextPathString: String {
        switch (BaseNetwork.SERVER) {
        case .Youtube_v3_API:
            return ""
        case .VivaCityDocumentationAPIDocumentation:
            return "/venue-i18n/"
        }
    }
    
    var basePORTString: UInt16 {
        switch (BaseNetwork.SERVER) {
        case .Youtube_v3_API:
            return 8761
        case .VivaCityDocumentationAPIDocumentation:
            return 9898
        }
    }
    
    var path: String {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    var method: HTTPMethod {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    var parameters: [URLQueryItem]? {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    var headerFields: [String: String]? {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    func getData(completion: @escaping(Result<Data, Error>) -> Void) {
        var builder = URLComponents(string: fullStringURL)
        builder?.queryItems = parameters
        guard let url = builder?.url else { return }
        var request  = URLRequest(url: url)
        request.httpMethod = method.value
        //        let boundary = "Boundary-\(UUID().uuidString)"
        //    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 30
        
        request.allHTTPHeaderFields = headerFields
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            print("fullURL: ", self.fullStringURL)
            print("params: ", url.queryDictionary as Any)
            print("header: ", self.headerFields as Any)
            print("json: ")
            if let error = error {
                completion(.failure(error))
                return
            }
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                let status = httpResponse.statusCode
                
                switch status {
                case 200:
                break //print("Thanh cong")
                default:
                    break
                }
                
                if !(200...299).contains(httpResponse.statusCode) && !(httpResponse.statusCode == 304) {
                    if let httpError = error {// ... convert httpResponse.statusCode into a more readable error
                        //                        completion(.failure(httpError as! Error))
                        completion(.failure(httpError))
                    }
                }
                
                if let data = data {
                    completion(.success(data))
                    if let json = try? JSON(data: data) {
                        print(json as Any)
                    }
                }
            }
        })
        dataTask.resume()
    }
}




//class BaseNetwork {
//    static let shared: BaseNetwork = BaseNetwork()
//
//    func getDataFromAPI<T: Codable>(url: URL, completion: @escaping(T)->()) {
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if error != nil {
//                print(error as Any)
//                return
//            }
//
//            guard let data = data else { return }
//
//            do {
//                let data = try JSONDecoder().decode(T.self, from: data)
//
//                DispatchQueue.main.async {
//                    completion(data)
//                    print("urlRequest: ", url)
//    //                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
//    //                        print("Response json:\n", dataString)
//    //                    }
//                }
//            } catch let error {
//                print("decode error: ", error)
//            }
//            }.resume()
//    }
//}
//
//////
//////  BaseURL.swift
//////  GenericsAPI
//////
//////  Created by Đặng Duy Cường on 1/3/20.
//////  Copyright © 2020 Ngô Bảo Châu. All rights reserved.
//////
////
//
//enum URLFactory: String {
//    case login
//    case chi_tiet
//    case thiet_bi
//    case diem_xung_yeu
//    case search
//
//    var URL: URL {
//        func generalUrlComponent(host: String, port: Int?, path: String, queryItems: [URLQueryItem]) -> URL {
//            var urlComponents = URLComponents()
//            urlComponents.scheme = "http"
//            urlComponents.host = host
//            urlComponents.port = port
//            urlComponents.path = path
//            urlComponents.queryItems = queryItems
//
//            return urlComponents.url!
//        }
//
//        //path of url
//        switch self {
//        case .chi_tiet:
//            return generalUrlComponent(host: "10.240.232.79",
//                                       port: 145,
//                                       path: "",
//                                       queryItems: [URLQueryItem(name: "", value: "")])
//        case .thiet_bi:
//            return generalUrlComponent(host: "", port: 8060, path: "", queryItems: [URLQueryItem(name: "", value: "")])
//        case .diem_xung_yeu:
//            return generalUrlComponent(host: "10.240.232.79", port: 8060, path: "/QLCTKT/rest/bts360Controller/getListCriticalPoint", queryItems: [
//                URLQueryItem(name: "fromDate", value: "04/10/2019"),
//                URLQueryItem(name: "toDate", value: "04/10/2019"),
//                URLQueryItem(name: "pageIndex", value: "0"),
//                URLQueryItem(name: "rowPage", value: "10")
//                ])
//        case .login:
//            return generalUrlComponent(host: "10.240.232.68", port: 8060, path: "/QLCTKT/rest/authen/login", queryItems: [
//                URLQueryItem(name: "username", value: "UserDefaults.standard.string(forKey: UserDefaultKeys.userName)"),
//                URLQueryItem(name: "password", value: "UserDefaults.standard.string(forKey: UserDefaultKeys.password)"),
//                URLQueryItem(name: "imeiMoblie", value: "IOS")
//                ])
//        case .search:
//            return generalUrlComponent(host: "www.thecocktaildb.com", port: nil, path: "/api/json/v1/1/search.php", queryItems: [
//                URLQueryItem(name: "rowPage", value: "10")
//                ])
//        }
//    }
//}
