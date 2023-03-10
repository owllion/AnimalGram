//
//  ContentView.swift
//  AnimalGram
//
//  Created by Zheng yu hsin on 2023/2/20.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var test: Bool = true
    var body: some View {
        ZStack {
            switch authViewModel.state {
            case .signedOut:
                NavigationView { SignUpView() }
            case .signedIn:
                MainTabView()
                if authViewModel.isLoading {
                    CustomProgressView()
                }
                
            }
                
            }     
        }
       
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                ContentView()
                ContentView()
                    .environment(\.colorScheme, .dark)
            }
            
        }
    }
