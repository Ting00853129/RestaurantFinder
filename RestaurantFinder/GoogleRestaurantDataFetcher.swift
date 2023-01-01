//
//  GoogleRestaurantDataFetcher.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2022/12/26.
//

import Foundation

class GoogleRestaurantDataFetcher: ObservableObject {
    @Published var items = [itemResults] ()
    @Published var showError = false
    @Published var placeDetail = InfoResults(name: "", photos: [], reviews: [],website: "",formatted_address: "",place_id: "")
    @Published var nextPage :String? = ""
    var error: Error? {
        willSet {
            DispatchQueue.main.async {
                self.showError = newValue != nil
            }
        }
    }
    
    enum FetchError: Error {
        case invalidURL
    }
    
    func fetchNearbySearch(latitude: Double, longitude: Double,searchText: String) {
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=1000&type=restaurant&keyword=\(searchText)&language=zh-TW&key=AIzaSyBDGokR0BcAUQNR4qB-Ys5Czq5eqTe-zx0"
        
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else{
            error = FetchError.invalidURL
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data{
                do {
                    let searchResponse = try JSONDecoder().decode(ListResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.items = searchResponse.results
                        self.error = nil
                        self.nextPage = searchResponse.next_page_token
//                        print("fun",self.nextPage)
//                        print(searchResponse.results)
                    }
                } catch {
                    self.error = error
                }
            } else if let error {
                self.error = error
            }
        }.resume()
    }
    
    func fetchPlaceDetail(place_id: String) {
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(place_id)&language=zh-TW&key=AIzaSyBDGokR0BcAUQNR4qB-Ys5Czq5eqTe-zx0"
        
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else{
            error = FetchError.invalidURL
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data{
                do {
                    let searchResponse = try JSONDecoder().decode(DetailResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.placeDetail = searchResponse.result
                        self.error = nil
                    }
                } catch {
                    self.error = error
                }
            } else if let error {
                self.error = error
            }
        }.resume()
    }
    
    func fetchNearbySearchNextPage(latitude: Double, longitude: Double,searchText: String, nextPage: String) {
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=1000&type=restaurant&keyword=\(searchText)&language=zh-TW&pagetoken=\(nextPage)&key=AIzaSyBDGokR0BcAUQNR4qB-Ys5Czq5eqTe-zx0"
        
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else{
            error = FetchError.invalidURL
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data{
                do {
                    let searchResponse = try JSONDecoder().decode(ListResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.nextPage = searchResponse.next_page_token
                        self.items += searchResponse.results
                        self.error = nil
                        print(searchResponse.results)
                        print("search next token",searchResponse.next_page_token)
                    }
                } catch {
                    self.error = error
                }
            } else if let error {
                self.error = error
            }
        }.resume()
    }
}
