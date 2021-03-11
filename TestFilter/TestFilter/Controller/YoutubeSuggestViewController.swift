//
//  YoutubeSuggestViewController.swift
//  TestFilter
//
//  Created by Dang Duy Cuong on 3/11/21.
//  Copyright © 2021 Ngô Bảo Châu. All rights reserved.
//

import UIKit
import SwiftyJSON

class YoutubeSuggestViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listSuggestVideo = [SuggestedVideosModel]()
    var params = [URLQueryItem]()
    var data = SuggestedVideosModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SuggestedVideosCell.nib(), forCellReuseIdentifier: SuggestedVideosCell.identifier())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        callAPI(apiType: .suggestedVideos)
    }
    
    func validateParams(apiType: Youtubev3APIType) {
        params.removeAll()
        switch apiType {
        case .suggestedVideos:
            let relatedToVideoId = data.id?.videoId
            params = [
                //Required Parameters
                URLQueryItem(name: "relatedToVideoId", value: relatedToVideoId),
                URLQueryItem(name: "part", value: "id,snippet"),
                URLQueryItem(name: "type", value: "video"),
                //Optional Parameters
                URLQueryItem(name: "maxResults", value: "50"),
            ]
        default:
            break
        }
        
    }
    
    func callAPI(apiType: Youtubev3APIType) {
        validateParams(apiType: apiType)
        switch apiType {
        case .suggestedVideos:
            suggestedVideos()
        case .search:
            break
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
    
}

extension YoutubeSuggestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSuggestVideo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestedVideosCell.identifier(), for: indexPath) as! SuggestedVideosCell
        cell.data = listSuggestVideo[indexPath.row]
        cell.fillData()
        
        return cell
    }
    
}

extension YoutubeSuggestViewController: UITableViewDelegate {
    
}
