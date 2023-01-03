//
//  UserFunction.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2022/12/27.
//

import Foundation

struct UserBody: Codable {
    let records: [Record]
    
    struct Record: Codable {
        let fields: Fields
    }
    
    struct Fields: Codable {
        let email: String
        let password: String
    }
}

class UserFunction: ObservableObject{
    @Published var user = UserBody(records: [UserBody.Record]())
    @Published var email = ""
    @Published var showError = false
    @Published var Finding = true
    var error: Error? {
        willSet {
            DispatchQueue.main.async {
                self.showError = newValue != nil
            }
        }
    }
    
    enum FetchError: Error {
        case invalidURL
        case error_code
        case message
    }
    
    func creatUser(email: String, password: String){
        let userBody = UserBody(records: [.init(fields: .init(email: email, password: password))])
        let url = URL(string: "https://api.airtable.com/v0/appG9Gkugslnrxm94/User")!
        var request = URLRequest(url: url)
        request.setValue("Bearer keyjvPMclDkRbVc8f", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(userBody)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                print(content)
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode(UserBody.self, from: data)
                    print(createUserResponse)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func login(email: String){
        let url = URL(string: "https://api.airtable.com/v0/appG9Gkugslnrxm94/User?filterByFormula=(%7Bemail%7D%3D\(email))")!
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
                    let createUserResponse = try decoder.decode(UserBody.self, from: data)
                    DispatchQueue.main.async {
                        self.user = createUserResponse
                    }
                } catch {
                    print(error)
                }
            }
            DispatchQueue.main.async {
                self.Finding = false
            }
        }.resume()
    }
    
    func setEmail(email: String){
        self.email = email
    }
}
