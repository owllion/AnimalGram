//
//  ProfileView.swift
//  AnimalGram
//
//  Created by Zheng yu hsin on 2023/2/21.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var showSettings: Bool = false
    
    var isMyProfile: Bool
    //true => show the setting bar,otherwise do not show.
    
    var posts = PostArrayObject()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ProfileHeaderView()
            Divider()
            ImageGridView(data: posts)
        }.navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings.toggle()
                    } label: {
                        Image(systemName: "line.horizontal.3")
                    }.tint(colorScheme == .light ? Color.MyTheme.purple : Color.MyTheme.yellow)
                        .opacity(isMyProfile ? 1.0 : 0.0)

                }
            }.sheet(isPresented: $showSettings) {
                SettingsView().environmentObject(loginViewModel)
            }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(isMyProfile: true)
        }
        
        
    }
}
