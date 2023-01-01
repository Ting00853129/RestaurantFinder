//
//  ItemRow.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2022/12/26.
//

import SwiftUI

struct ItemRow: View {
    let item: itemResults
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(item.name)
                Text(item.vicinity)
            }
            Spacer()
            if item.opening_hours?.open_now ?? false {
                Text("營業中")
                    .foregroundColor(.green)
            } else {
                Text("未營業")
                    .foregroundColor(.red)
            }
            VStack(alignment: .trailing){
                
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                if(item.rating >= 0.0){
                    Text(String(item.rating))
                }
            }
        }
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemRow(item: itemResults(name: "", place_id: "", rating: 0.0, vicinity: "",opening_hours: OpenState(open_now: Bool())))
    }
}
