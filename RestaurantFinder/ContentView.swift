//
//  ContentView.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2022/12/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var fetcher : GoogleRestaurantDataFetcher
    @State private var login = false
    @StateObject var locationViewModel = LocationVieModel()
    var body: some View {
        TabView{
            VStack {
                Image(systemName: "fork.knife")
                    .resizable()
                    .foregroundColor(.accentColor)
                    .frame(width: 100.0, height: 120.0)
                Text("Restaurant Finder")
            }
            .padding()
            .tabItem {
                Label("Home", systemImage: "house")
            }
            NavigationView {
                SearchNearbyView(login: $login)
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            NavigationView {
                VIPView(login: $login)
            }
            .tabItem {
                Label("VIP", systemImage: "person.fill")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GoogleRestaurantDataFetcher())
            .environmentObject(UserFunction())
            .environmentObject(FavoriteFinder())
    }
}

struct ErrorView: View {
    var errorText: String
    @EnvironmentObject var locationViewModel : LocationVieModel
    
    var body: some View{
        VStack{
            Image(systemName: "xmark.octagon")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Button(action: {
                locationViewModel.requestPermission()
            }, label: {
                Label("Allow tracking", systemImage: "location")
            })
            .padding(10)
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Text(errorText)
        }
        .padding()
        .foregroundColor(.white)
        .background(.red)
    }
}

