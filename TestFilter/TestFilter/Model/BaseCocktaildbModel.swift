//
//  BaseCocktaildbModel.swift
//  TestFilter
//
//  Created by Đặng Duy Cường on 2/4/20.
//  Copyright © 2020 Ngô Bảo Châu. All rights reserved.
//

import UIKit

struct BaseCocktaildbModel: Codable {
    var drinks: [Drinks]
}

struct Drinks: Codable {
    var strDrink: String?
}
