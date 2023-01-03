//
//  ListResponse.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2022/12/24.
//

import Foundation

//第一層
struct ListResponse: Codable {
    let results: [itemResults]
    let status: String
    let next_page_token: String?
}

//第二層
struct itemResults: Codable, Equatable {
    let name: String                //地標名稱
    let place_id: String            //id （for 抓詳細資料使用）
    let rating: Double              //評分
    let vicinity: String            //地址
    let opening_hours : OpenState?  //是否營業
    
}

struct photoResults: Codable{
    let photo_reference: String
}

struct OpenState: Codable, Equatable {
    let open_now : Bool
}
