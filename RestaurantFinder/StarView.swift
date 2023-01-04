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
    @State var ready = false
    @State var insert = true
    var body: some View {
        VStack {
            Text("\(userEmail)的收藏🔥🔥🔥")
            NavigationView {
                List{
                    ForEach(fetcher.favorite, id: \.place_id) { results in
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
                    fetcher.favorite.removeAll()
                    place.findUserFavoritePlace(email: userEmail)
                    for i in 0..<place.place.records.count {
                        fetcher.fetchPlaceDetail(place_id: place.place.records[i].fields.place_id)
                    }
                }
                .onAppear{
                    fetcher.favorite.removeAll()
                    place.findUserFavoritePlace(email: userEmail)
//                    for i in 0..<place.place.records.count {
//                        fetcher.fetchPlaceDetail(place_id: place.place.records[i].fields.place_id)
//                    }
                }
            }
            .onAppear{
                fetcher.favorite.removeAll()
                place.findUserFavoritePlace(email: userEmail)
            }
            Button {
                login = false
                userEmail = ""
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
