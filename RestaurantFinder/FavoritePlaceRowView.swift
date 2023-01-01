//
//  FavoritePlaceRowView.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2022/12/28.
//

import SwiftUI

struct FavoritePlaceRowView: View {
    let name: String
    let place_id : String
    let address: String
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(name)
                Text(address)
            }
            Spacer()
            VStack(alignment: .trailing){
                Image(systemName: "heart.fill")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 20.0, height: 20.0)
            }
        }
    }
}

struct FavoritePlaceRowView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritePlaceRowView(name: "", place_id: "", address: "")
    }
}
