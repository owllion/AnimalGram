//
//  ProfileView.swift
//  AnimalGram
//
//  Created by Zheng yu hsin on 2023/2/21.
//

import SwiftUI

struct ProfileView: View {
    var isMyProfile: Bool
    //true => show the setting bar,toehrwise do not show.
    
    @State var profileDisplayName: String
    //Make it State is bacause there are instances where the profile display name might change.例如去編輯名稱之後這裡的名稱也應該要跟著一起變
    
    var profileUserID: String
    //not change,so no need to use state
    
    var posts = PostArrayObject()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ProfileHeaderView( profileDisplayName: $profileDisplayName)
            Divider()
            ImageGridView(data: posts)
        }.navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("f")
                    } label: {
                        Image(systemName: "line.horizontal.3")
                    }.tint(Color.MyTheme.purple)
                        .opacity(isMyProfile ? 1.0 : 0.0)

                }
            }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(isMyProfile: true, profileDisplayName: "Anng", profileUserID: "123456")
        }
        
        
    }
}
