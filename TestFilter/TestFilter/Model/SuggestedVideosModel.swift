//
//  SuggestedVideosModel.swift
//  TestFilter
//
//  Created by Dang Duy Cuong on 3/11/21.
//  Copyright © 2021 Ngô Bảo Châu. All rights reserved.
//

import Foundation
import SwiftyJSON

class SuggestedVideosModel: BaseDataModel {
    var kind: String?
    var id: SuggestedVideosModelID?
    var snippet: SnippetModel?
    
    override func mapping(json: JSON) {
        kind = json["kind"].stringValue
        id = SuggestedVideosModelID(byJSON: json["id"])
        snippet = SnippetModel(byJSON: json["snippet"])
    }
}

class SuggestedVideosModelID: BaseDataModel {
    var kind: String?
    var videoId: String?
    
    override func mapping(json: JSON) {
        kind = json["kind"].stringValue
        videoId = json["videoId"].stringValue
    }
}

class SnippetModel: BaseDataModel {
    var publishedAt: String?
    var channelId: String?
    var title: String?
    var descriptionVideo: String?
    
    var thumbnails: ThumbnailsModel?
    
    override func mapping(json: JSON) {
        publishedAt = json["publishedAt"].stringValue
        channelId = json["channelId"].stringValue
        title = json["title"].stringValue
        descriptionVideo = json["description"].stringValue
        
        thumbnails = ThumbnailsModel(byJSON: json["thumbnails"])
    }
}

class ThumbnailsModel: BaseDataModel {
    var medium: MediumModel?
    var maxres: MaxresModel?
    
    override func mapping(json: JSON) {
        medium = MediumModel(byJSON: json["medium"])
        maxres = MaxresModel(byJSON: json["maxres"])
    }
}

class MediumModel: BaseDataModel {
    var url: String?
    var width: Int?
    var height: Int?
    
    override func mapping(json: JSON) {
        url = json["url"].stringValue
        width = json["width"].intValue
        height = json["height"].intValue
    }
}

class MaxresModel: BaseDataModel {
    var url: String?
    var width: Int?
    var height: Int?
    
    override func mapping(json: JSON) {
        url = json["url"].stringValue
        width = json["width"].intValue
        height = json["height"].intValue
    }
}
