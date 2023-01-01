//
//  ItemDetail.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2022/12/26.
//

import SwiftUI
import RefreshableScrollView

@Sendable func dummyRefreshTask() async {
    print("refresing")
    try? await Task.sleep(nanoseconds: 5000000000)
    print("done")
}

struct ItemDetail: View {
    let place_id : String
    @EnvironmentObject var fetcher : GoogleRestaurantDataFetcher
    @EnvironmentObject var place : FavoriteFinder
    @EnvironmentObject var user: UserFunction
    @Binding var login: Bool
    @State private var r = 0.0
    @State private var g = 0.0
    @State private var b = 0.0
    var body: some View {
        VStack{
            HStack{
                Text(fetcher.placeDetail.name)
                    .multilineTextAlignment(.leading)
                Spacer()
                VStack{
                    if login {     //是否登入
                        Button {
                            //收藏或移除
                            if r == 0 { // unlike -> like
                                place.addFavorite(email: user.email, place_id: place_id)
                                r = 255
                            } else {
                                for i in 0..<place.place.records.count {
                                    if (place.place.records[i].fields.email == user.email) && (place.place.records[i].fields.place_id == place_id) {
                                        place.deleteFavorite(id: place.place.records[i].id)
                                    }
                                }
                                r = 0
                            }
                        } label: { //點選按鈕修改圖案顏色 ＆ 新增或是刪除
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color(red: r/255, green: g/255, blue: b/255))
                        }
                    }
                    if !(fetcher.placeDetail.website?.isEmpty ?? true) {
                        ShareLink(item: fetcher.placeDetail.website ?? "")
                    }
                }
                
            }.padding(.horizontal)
            ScrollView(.horizontal){
                HStack{
                    ForEach(fetcher.placeDetail.photos, id: \.photo_reference) { photoref in
                        AsyncImage(url: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoref.photo_reference)&key=AIzaSyBDGokR0BcAUQNR4qB-Ys5Czq5eqTe-zx0")) { image in
                            image
                                .resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .scaledToFill()
                        .frame(width: 150.0, height: 150.0)
                    }
                }
            }.padding(.horizontal)
            RefreshableScrollView{
                ForEach(fetcher.placeDetail.reviews, id: \.author_name) { review in
                    VStack(alignment: .leading){
                        HStack(alignment: .center) {
                            VStack{
                                AsyncImage(url: URL(string: review.profile_photo_url)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .scaledToFill()
                                .frame(width: 80.0 , height: 80.0)
                            }
                            .padding(.trailing)
                            VStack(alignment: .leading){
                                Text(review.author_name)
                                Text(review.relative_time_description)
                                HStack{
                                    Text(String(review.rating))
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                            Spacer()
                        }
                        Text(review.text)
                    }
                }
            }
            .padding(.horizontal)
            .refreshable {
                fetcher.fetchPlaceDetail(place_id: place_id)
                place.findAllFavoritePlace()
                for i in 0..<place.place.records.count {
                    if place_id == place.place.records[i].fields.place_id{
                        self.r = 255
                        self.g = 0
                        self.b = 0
                    }
                }
            }
//            List{
//                ForEach(fetcher.placeDetail.reviews, id: \.author_name) { review in
//                    VStack(alignment: .leading){
//                        HStack(alignment: .center) {
//                            VStack{
//                                AsyncImage(url: URL(string: review.profile_photo_url)) { image in
//                                    image.resizable()
//                                } placeholder: {
//                                    Color.gray
//                                }
//                                .scaledToFill()
//                                .frame(width: 100.0 , height: 100.0)
//                            }
//                            .padding(.trailing)
//                            VStack(alignment: .leading){
//                                Text(review.author_name)
//                                Text(review.relative_time_description)
//                                HStack{
//                                    Text(String(review.rating))
//                                    Image(systemName: "star.fill")
//                                        .foregroundColor(.yellow)
//                                }
//                            }
//                            Spacer()
//                        }
//                        Text(review.text)
//                    }
//                }
//            }
//            .refreshable {
//                fetcher.fetchPlaceDetail(place_id: place_id)
//                place.findAllFavoritePlace()
//                for i in 0..<place.place.records.count {
//                    if place_id == place.place.records[i].fields.place_id{
//                        self.r = 255
//                        self.g = 0
//                        self.b = 0
//                    }
//                }
//            }
        }.onAppear{
            fetcher.fetchPlaceDetail(place_id: place_id)
            for i in 0..<place.place.records.count {
                if place_id == place.place.records[i].fields.place_id{
                    self.r = 255
                    self.g = 0
                    self.b = 0
                }
            }
        }
    }
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetail(place_id: "",login: .constant(Bool()))
            .environmentObject(GoogleRestaurantDataFetcher())
            .environmentObject(FavoriteFinder())
    }
}
