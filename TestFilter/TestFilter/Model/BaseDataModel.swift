//
//  BaseDataModel.swift
//  TestFilter
//
//  Created by Dang Duy Cuong on 3/11/21.
//  Copyright © 2021 Ngô Bảo Châu. All rights reserved.
//

import Foundation
import SwiftyJSON

class BaseDataModel: NSObject, SwiftyJSONMappable {
    
    var message: String?
    
    override init() {
        super.init()
    }
    
    required init?(byJSON json: JSON) {
        super.init()
        mapping(json: json)
    }
    
    required init?(byString string: String, key: String = "") {
        super.init()
        var json = string.toJSON()
        if !key.isEmpty { json = json[key] }
        mapping(json: json)
    }
    
    func mapping(json: JSON) {
        if json.type == .null {
            return
        }
        
        if json["message"].exists() {
            message = json["message"].stringValue
        }
    }
}

protocol SwiftyJSONMappable {
    init?(byJSON json: JSON)
    //    init?(byString string: String, key: String)
}

extension Array where Element: SwiftyJSONMappable {
    
    init(byJSON json: JSON) {
        self.init()
        if json.type == .null { return }
        
        for item in json.arrayValue {
            if let object = Element.init(byJSON: item) {
                self.append(object)
            }
        }
    }
    
    init(byString string: String, key: String = "") {
        self.init()
        var json = string.toJSON()
        if !key.isEmpty { json = json[key] }
        if json.type == .null { return }
        
        for item in json.arrayValue {
            if let object = Element.init(byJSON: item) {
                self.append(object)
            }
        }
    }
}

extension String {
    
    //    func toJSON() -> JSON {
    //        return self.data(using: String.Encoding.utf8).flatMap({ JSON(data: $0) }) ?? JSON(NSNull())
    //    }
    
    func toJSON() -> JSON {
        let json = self.data(using: String.Encoding.utf8).flatMap({try? JSON(data: $0)}) ?? JSON(NSNull())
        return json
    }
}


