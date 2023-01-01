//
//  PlaceDetails.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2022/12/24.
//

import Foundation

struct DetailResponse: Codable {
    var result: InfoResults
    init(result: InfoResults) {
        self.result = result
    }
}

struct InfoResults: Codable {
    var name: String                //餐廳名稱
    var photos: [PhotosResults]     //照片
    var reviews: [Reviews]          //評論
    var website: String?            //餐廳網站
    var formatted_address: String
    var place_id : String
    init(name: String, photos: [PhotosResults], reviews: [Reviews], website: String, formatted_address: String, place_id: String) {
        self.name = name
        self.photos = photos
        self.reviews = reviews
        self.website = website
        self.formatted_address = formatted_address
        self.place_id = place_id
    }
}

struct PhotosResults: Codable{
    var photo_reference: String
}

struct Reviews: Codable{
    var author_name: String
    var profile_photo_url: String
    var relative_time_description: String
    var text: String
    var time: Date
    var rating: Double
}
