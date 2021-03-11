//
//  Storyboard.swift
//  TestFilter
//
//  Created by Dang Duy Cuong on 3/11/21.
//  Copyright © 2021 Ngô Bảo Châu. All rights reserved.
//

import UIKit

struct Storyboard {
    
}

extension Storyboard {
    
    struct Main {
        static let manager = UIStoryboard(name: "Main", bundle: nil)
        
        static func youtubeSuggestViewController() -> YoutubeSuggestViewController {
            return manager.instantiateViewController(withIdentifier: "YoutubeSuggestViewController") as! YoutubeSuggestViewController
        }
        
    }
}
