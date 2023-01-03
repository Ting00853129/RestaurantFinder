//
//  SearchNearByView.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2022/12/24.
//

import SwiftUI
import CoreLocation

struct SearchNearbyView: View {
    @EnvironmentObject var fetcher : GoogleRestaurantDataFetcher
    @EnvironmentObject var user : UserFunction
    @Binding var login : Bool
    @StateObject var locationViewModel = LocationVieModel()
    
    var body: some View {
        VStack{
            switch locationViewModel.authorizationStatus {
            case.restricted, .denied:
                ErrorView(errorText: "偶需要權限霸脫🙏")
                    .environmentObject(locationViewModel)
            case.authorizedAlways, .authorizedWhenInUse:
                TrackingView(login: $login)
                    .environmentObject(locationViewModel)
            default:
                Text("")
            }
        }
        .onAppear{
            locationViewModel.requestPermission()
        }
    }
}

struct SearchNearByView_Previews: PreviewProvider {
    static var previews: some View {
        SearchNearbyView(login: .constant(Bool()))
            .environmentObject(GoogleRestaurantDataFetcher())
            .environmentObject(UserFunction())
    }
}

struct TrackingView: View{
    @EnvironmentObject var locationViewModel: LocationVieModel
    @EnvironmentObject var fetcher : GoogleRestaurantDataFetcher
    @EnvironmentObject var user : UserFunction
    @Binding var login : Bool
    @State private var searchText = ""
    @State private var oldData = 0
    var coordinate: CLLocationCoordinate2D? {
        locationViewModel.lastSeenLocation?.coordinate
    }
    
    var body: some View{
        NavigationView {
            if fetcher.items.isEmpty {
                ProgressView()
                    .onAppear{
                        fetcher.fetchNearbySearch(latitude: coordinate?.latitude ?? 0, longitude: coordinate?.longitude ?? 0, searchText: "")
                    }
            } else {
                List{
                    ForEach(fetcher.items, id: \.place_id) { item in
                        NavigationLink {
                            ItemDetail(place_id: item.place_id, login: $login)
                        } label: {
                            ItemRow(item: item)
                        }
                    }
                    if fetcher.items.count == oldData {
                        HStack{
                            Spacer()
                            Button {
                                print("touch")
                            } label: {
                                Image(systemName: "rays")
                            }
                            .onAppear {
                                DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 10)) {
                                    fetcher.fetchNearbySearchNextPage(latitude: coordinate?.latitude ?? 0, longitude: coordinate?.longitude ?? 0, searchText: "", nextPage: fetcher.nextPage ?? "")
                                }
                                oldData = fetcher.items.count
                            }
                            Spacer()
                        }
                    }
                }
                .searchable(text: $searchText)
                .onSubmit(of: .search){
                    fetcher.fetchNearbySearch(latitude: coordinate?.latitude ?? 0, longitude: coordinate?.longitude ?? 0, searchText: searchText)
                }
                .refreshable {
                    fetcher.fetchNearbySearch(latitude: coordinate?.latitude ?? 0, longitude: coordinate?.longitude ?? 0, searchText: "")
                }
                .onAppear{
                    oldData = fetcher.items.count
                }
            }
        }
        .alert(fetcher.error?.localizedDescription ?? "", isPresented:
                $fetcher.showError, actions: {
        })
        .onAppear{
            if fetcher.items.isEmpty {
                fetcher.fetchNearbySearch(latitude: 24.848720, longitude: 120.929257, searchText: "")
                oldData = fetcher.items.count
                print(oldData)
            }
        }
    }
}
//        let latitude = 24.848720
//        let longitude = 120.929257
