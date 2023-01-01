//
//  StarView.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2022/12/28.
//

import SwiftUI

struct StarView: View {
    @EnvironmentObject var fetcher : GoogleRestaurantDataFetcher
    @EnvironmentObject var user : UserFunction
    @Binding var userEmail : String
    @EnvironmentObject var place : FavoriteFinder
    @Binding var login: Bool
    @State var favorite_place_fetcher : [InfoResults] = []
    @State var num = 0
    @State var ready = false
    @State var insert = true
    var body: some View {
        VStack {
            Text("\(userEmail)的收藏🔥🔥🔥")
            NavigationView {
                List{
                    ForEach(self.favorite_place_fetcher, id: \.place_id) { results in
                        if results.place_id != "" {
                            NavigationLink {
                                ItemDetail(place_id: results.place_id, login: $login)
                            } label: {
                                FavoritePlaceRowView(name: results.name, place_id: results.place_id, address: results.formatted_address)
                            }
                        }
                    }
                }
                .refreshable {
                    for i in 0..<place.place.records.count {
                        if place.place.records[i].fields.email == userEmail {
                            self.num = num + 1
                            fetcher.fetchPlaceDetail(place_id: place.place.records[i].fields.place_id)
                            insert = true
                            
                            for j in 0..<favorite_place_fetcher.count {
                                if favorite_place_fetcher[j].place_id == fetcher.placeDetail.place_id {
                                    insert = false
                                }
                            }
                            if insert {
                                if favorite_place_fetcher.count == 0 {
                                    self.favorite_place_fetcher.insert(fetcher.placeDetail, at: 0)
                                } else{
                                    self.favorite_place_fetcher.append(fetcher.placeDetail)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear{
                self.favorite_place_fetcher = []
                place.findAllFavoritePlace()
            }
            Button {
                login = false
                
            } label: {
                Text("Log out")
                    .padding(.bottom)
            }
        }
    }
}

struct StarView_Previews: PreviewProvider {
    static var previews: some View {
        StarView(userEmail: .constant(String()) ,login: .constant(Bool()))
            .environmentObject(UserFunction())
            .environmentObject(GoogleRestaurantDataFetcher())
            .environmentObject(FavoriteFinder())
    }
}
