//
//  FavoriteFinder.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2022/12/28.
//

import Foundation

struct FavoriteBody: Codable {
    var records: [Record]
    
    struct Record: Codable {
        let id: String
        let fields: Fields
    }
    
    struct Fields: Codable {
        let email: String
        let place_id: String
    }
}

struct FavoriteRequestBody: Codable {
    let records: [Record]
    
    struct Record: Codable {
        let fields: Fields
    }
    
    struct Fields: Codable {
        let email: String
        let place_id: String
    }
}

struct DeleteRequestBody: Codable {
    let records: [Record]
    
    struct Record: Codable {
        let id: String
        let deleted: Bool
    }
}
//https://api.airtable.com/v0/appS290elbkBMjgvV/Table%25201?filterByFormula=(%7Bemail%7D%3D'')
class FavoriteFinder: ObservableObject{
    @Published var place = FavoriteBody(records: [FavoriteBody.Record]())
    
    func findUserFavoritePlace(email: String){
        let url = URL(string: "https://api.airtable.com/v0/appS290elbkBMjgvV/Table%201?filterByFormula=(%7Bemail%7D%3D'\(email)')")!
        var request = URLRequest(url: url)
        request.setValue("Bearer keyjvPMclDkRbVc8f", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                print(content)
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode(FavoriteBody.self, from: data)
                    DispatchQueue.main.async {
                        if !createUserResponse.records.isEmpty {
                            self.place = createUserResponse
                        } else {
                            self.place.records.removeAll()
                        }
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        self.place.records.removeAll()
                    }
                }
            }
        }.resume()
    }
    
        func findAllFavoritePlace(){
            let url = URL(string: "https://api.airtable.com/v0/appS290elbkBMjgvV/Table%201")!
            var request = URLRequest(url: url)
            request.setValue("Bearer keyjvPMclDkRbVc8f", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data,
                   let content = String(data: data, encoding: .utf8) {
                    print(content)
                }
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let createUserResponse = try decoder.decode(FavoriteBody.self, from: data)
                        self.place = createUserResponse
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    
    func addFavorite (email: String, place_id: String){
        let favoriteBody = FavoriteRequestBody(records: [.init(fields: .init(email: email, place_id: place_id))])
        let url = URL(string: "https://api.airtable.com/v0/appS290elbkBMjgvV/Table%201")!
        var request = URLRequest(url: url)
        request.setValue("Bearer keyjvPMclDkRbVc8f", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(favoriteBody)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                print(content)
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode(UserBody.self, from: data)
                    DispatchQueue.main.async {
                        print(createUserResponse)
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func deleteFavorite (id: String){
        //        let deleteBody = DeleteRequestBody(records: [.init(id: id, deleted: true)])
        let url = URL(string: "https://api.airtable.com/v0/appS290elbkBMjgvV/Table%201/\(id)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer keyjvPMclDkRbVc8f", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        let encoder = JSONEncoder()
        //        request.httpBody = try? encoder.encode(deleteBody)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                print(content)
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode(DeleteRequestBody.Record.self, from: data)
                    DispatchQueue.main.async {
                        print(createUserResponse)
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}

