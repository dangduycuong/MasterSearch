//
//  Youtubev3.swift
//  TestFilter
//
//  Created by Dang Duy Cuong on 3/11/21.
//  Copyright © 2021 Ngô Bảo Châu. All rights reserved.
//

import SwiftyJSON
import Foundation

enum Youtubev3APIEndpoint {
    case suggestedVideos(params: [URLQueryItem])
    case search(params: [URLQueryItem])
}

class Youtubev3Router: BaseNetwork {
    var endpoint: Youtubev3APIEndpoint
    
    init(endpoint: Youtubev3APIEndpoint) {
        self.endpoint = endpoint
    }
    
    override var path: String {
        switch endpoint {
        case .suggestedVideos(_):
            return "/search"
        case .search(_):
            return "/search"
        }
    }
    
    override var method: HTTPMethod {
        switch endpoint {
        default:
            return .get
        }
    }
    
    override var parameters: [URLQueryItem]? {
        var params: [URLQueryItem]?
        switch endpoint {
        case .suggestedVideos(let addParams):
            params = addParams
        case .search(let addParams):
            params = addParams
        }
        return params
    }
    
    override var headerFields: [String : String]? {
        var headers: [String: String]?
        switch endpoint {
        case .suggestedVideos(_):
            headers = [
                "x-rapidapi-key": "b266514becmsh63278b22c117acfp12ef2cjsn7a142a5dffa4",
                "x-rapidapi-host": "youtube-v31.p.rapidapi.com"
            ]
        default:
            headers = [
                "x-rapidapi-key": "b266514becmsh63278b22c117acfp12ef2cjsn7a142a5dffa4",
                "x-rapidapi-host": "youtube-v31.p.rapidapi.com"
            ]
        }
        return headers
    }
}
