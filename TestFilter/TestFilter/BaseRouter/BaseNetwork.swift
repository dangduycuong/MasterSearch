//
//  BaseNetwork.swift
//  TestFilter
//
//  Created by Đặng Duy Cường on 2/4/20.
//  Copyright © 2020 Ngô Bảo Châu. All rights reserved.
//

import UIKit

class BaseNetwork {
    static let shared: BaseNetwork = BaseNetwork()
    
    func getDataFromAPI<T: Codable>(url: URL, completion: @escaping(T)->()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
                
            guard let data = data else { return }
                
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                    
                DispatchQueue.main.async {
                    completion(data)
                    print("urlRequest: ", url)
    //                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
    //                        print("Response json:\n", dataString)
    //                    }
                }
            } catch let error {
                print("decode error: ", error)
            }
            }.resume()
    }
}

////
////  BaseURL.swift
////  GenericsAPI
////
////  Created by Đặng Duy Cường on 1/3/20.
////  Copyright © 2020 Ngô Bảo Châu. All rights reserved.
////
//

enum URLFactory: String {
    case login
    case chi_tiet
    case thiet_bi
    case diem_xung_yeu
    case search

    var URL: URL {
        func generalUrlComponent(host: String, port: Int?, path: String, queryItems: [URLQueryItem]) -> URL {
            var urlComponents = URLComponents()
            urlComponents.scheme = "http"
            urlComponents.host = host
            urlComponents.port = port
            urlComponents.path = path
            urlComponents.queryItems = queryItems

            return urlComponents.url!
        }

        //path of url
        switch self {
        case .chi_tiet:
            return generalUrlComponent(host: "10.240.232.79",
                                       port: 145,
                                       path: "",
                                       queryItems: [URLQueryItem(name: "", value: "")])
        case .thiet_bi:
            return generalUrlComponent(host: "", port: 8060, path: "", queryItems: [URLQueryItem(name: "", value: "")])
        case .diem_xung_yeu:
            return generalUrlComponent(host: "10.240.232.79", port: 8060, path: "/QLCTKT/rest/bts360Controller/getListCriticalPoint", queryItems: [
                URLQueryItem(name: "fromDate", value: "04/10/2019"),
                URLQueryItem(name: "toDate", value: "04/10/2019"),
                URLQueryItem(name: "pageIndex", value: "0"),
                URLQueryItem(name: "rowPage", value: "10")
                ])
        case .login:
            return generalUrlComponent(host: "10.240.232.68", port: 8060, path: "/QLCTKT/rest/authen/login", queryItems: [
                URLQueryItem(name: "username", value: "UserDefaults.standard.string(forKey: UserDefaultKeys.userName)"),
                URLQueryItem(name: "password", value: "UserDefaults.standard.string(forKey: UserDefaultKeys.password)"),
                URLQueryItem(name: "imeiMoblie", value: "IOS")
                ])
        case .search:
            return generalUrlComponent(host: "www.thecocktaildb.com", port: nil, path: "/api/json/v1/1/search.php", queryItems: [
                URLQueryItem(name: "rowPage", value: "10")
                ])
        }
    }
}
