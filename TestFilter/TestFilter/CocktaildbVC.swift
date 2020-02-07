//
//  CocktaildbVC.swift
//  TestFilter
//
//  Created by Đặng Duy Cường on 2/4/20.
//  Copyright © 2020 Ngô Bảo Châu. All rights reserved.
//

import UIKit

class CocktaildbVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var listCockTail: [Drinks]?
    override func viewDidLoad() {
        super.viewDidLoad()
        setParamURL()
    }
    
    func setParamURL() {
//        let link = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita")
//        var urlRequest = URLRequest(url: link!)
//        urlRequest.httpMethod = "GET"
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.thecocktaildb.com"
        urlComponents.path = "/api/json/v1/1/search.php"
        urlComponents.queryItems = [URLQueryItem(name: "s", value: "margarita")]
        
        
        let url = urlComponents.url!
        
        BaseNetwork.shared.getDataFromAPI(url: url) { (data: [Drinks]) in
            self.listCockTail = data
        }
    }

    
    func generalUrlComponent(host: String, path: String, queryItems: [URLQueryItem]) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        

        return urlComponents.url!
    }
    
//    var url1: URL {
//        func generalUrlComponent(host: String, path: String, queryItems: [URLQueryItem]) -> URL {
//            var urlComponents = URLComponents()
//            urlComponents.scheme = "https"
//            urlComponents.host = host
//            urlComponents.path = path
//            urlComponents.queryItems = queryItems
//
//            return urlComponents.url!
//        }
//
//        //path of url
//
//        return generalUrlComponent(host: "10.240.232.79",
//                                    path: "api/json/v1/1/search.php",
//                                    queryItems: [URLQueryItem(name: "s", value: "margarita")])
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    @IBAction func dismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension CocktaildbVC: UISearchBarDelegate {
    
}
