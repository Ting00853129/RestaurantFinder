//
//  VIPView.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2022/12/27.
//

import SwiftUI
import Foundation

struct VIPView: View {
    @EnvironmentObject var user : UserFunction
    @State private var userEmail = ""
    @Binding var login: Bool
    @State private var grader = "男"
    var body: some View {
        if !login {
            LoginView(userEmail: $userEmail ,login: $login)
        } else {
            StarView(userEmail: $userEmail, login: $login)
        }
    }
}



struct VIPView_Previews: PreviewProvider {
    static var previews: some View {
        VIPView(login: .constant(Bool()))
            .environmentObject(UserFunction())
            .environmentObject(GoogleRestaurantDataFetcher())
            .environmentObject(FavoriteFinder())
    }
}
