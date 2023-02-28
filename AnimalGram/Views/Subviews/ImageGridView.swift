//
//  ImageGridView.swift
//  AnimalGram
//
//  Created by Zheng yu hsin on 2023/2/20.
//

import SwiftUI

struct ImageGridView: View {
    
    @ObservedObject var feedViewModel =  FeedViewModel()
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            alignment: .center,
            spacing: nil,
            pinnedViews: []) {
                ForEach(feedViewModel.posts, id: \.self) {
                    post in
                    NavigationLink {
                        FeedView(title: "post")
                    } label: {
                        PostView(post: post, showHeaderAndFooter: false)
                    }
                }

            }.onAppear {
                feedViewModel.getPosts()
            }
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView().previewLayout(.sizeThatFits)
    }
}
