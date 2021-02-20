//
//  CoinData.swift
//  ByteCoin
//
//  Created by Yick Ming Lee on 19/02/2021.
//  Copyright © 2021 The App Brewery. All rights reserved.
//


import Foundation

struct CoinData: Codable {
    let asset_id_base: String // from
    let asset_id_quote: String // to
    let rate: Double
}


