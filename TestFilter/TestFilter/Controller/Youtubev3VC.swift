//
//  Youtubev3VC.swift
//  TestFilter
//
//  Created by Đặng Duy Cường on 2/4/20.
//  Copyright © 2020 Ngô Bảo Châu. All rights reserved.
//

import UIKit
import SwiftyJSON

enum Youtubev3APIType {
    case suggestedVideos
    case search
}

class Youtubev3VC: BaseViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var listSuggestVideo = [SuggestedVideosModel]()
    var listVideo = [SuggestedVideosModel]()
    var params = [URLQueryItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SearchYoutubeCell.nib(), forCellReuseIdentifier: SearchYoutubeCell.identifier())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        callAPI(apiType: .suggestedVideos)
        
    }
    
    func validateParams(apiType: Youtubev3APIType) {
        params.removeAll()
        switch apiType {
        case .suggestedVideos:
            params = [
                //Required Parameters
                URLQueryItem(name: "relatedToVideoId", value: "7ghhRHRP6t4"),
                URLQueryItem(name: "part", value: "id,snippet"),
                URLQueryItem(name: "type", value: "video"),
                //Optional Parameters
                URLQueryItem(name: "maxResults", value: "50"),
            ]
        case .search:
            let q = searchBar.text
            params = [
                //Required Parameters
            
                URLQueryItem(name: "q", value: q),
                URLQueryItem(name: "part", value: "snippet,id"),
                //Optional Parameters
                URLQueryItem(name: "regionCode", value: "US"),
                URLQueryItem(name: "maxResults", value: "50"),
                URLQueryItem(name: "order", value: "date")
            ]
        }
        
    }
    
    func callAPI(apiType: Youtubev3APIType) {
        validateParams(apiType: apiType)
        switch apiType {
        case .suggestedVideos:
            suggestedVideos()
        case .search:
            search()
        }
    }
    
    func suggestedVideos() {
        showLoading()
        // all properties params is OPTIONAL
        let params: [URLQueryItem] = [
            //Required Parameters
            URLQueryItem(name: "relatedToVideoId", value: "7ghhRHRP6t4"),
            URLQueryItem(name: "part", value: "id,snippet"),
            URLQueryItem(name: "type", value: "video"),
            //Optional Parameters
            URLQueryItem(name: "maxResults", value: "50"),
        ]
        
        Youtubev3Router.init(endpoint: .suggestedVideos(params: params)).getData(completion: { [weak self] result in
            self?.hideLoading()
            switch result {
            case .success(let data):
                if let json = try? JSON(data: data) {
                    let array = [SuggestedVideosModel](byJSON: json["items"])
                    self?.listSuggestVideo = array
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            default:
                print("tram cam")
            }
        })
    }
    
    func search() {
        showLoading()
        Youtubev3Router.init(endpoint: .search(params: params)).getData(completion: { [weak self] result in
            self?.hideLoading()
            switch result {
            case .success(let data):
                if let json = try? JSON(data: data) {
                    let items = [SuggestedVideosModel](byJSON: json["items"])
                    self?.listVideo = items
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            default:
                break
            }
        })
    }
    
    func generalUrlComponent(host: String, path: String, queryItems: [URLQueryItem]) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        
        return urlComponents.url!
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        //        dismiss(animated: true, completion: nil)
    }
}

extension Youtubev3VC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listVideo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchYoutubeCell.identifier(), for: indexPath) as! SearchYoutubeCell
        let data = listVideo[indexPath.row]
        cell.titleTextView.text = data.snippet?.title
        cell.descriptionTextView.text = data.snippet?.descriptionVideo
        if let link = data.snippet?.thumbnails?.medium?.url {
            cell.thumbnailsImageView.dowloadFromServer(link: link)
        }
        
        return cell
    }
    
}

extension Youtubev3VC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        title = ""
        let vc = Storyboard.Main.youtubeSuggestViewController()
        vc.data = listVideo[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension Youtubev3VC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        callAPI(apiType: .search)
    }
}
