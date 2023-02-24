//
//  OnboardingView.swift
//  AnimalGram
//
//  Created by Zheng yu hsin on 2023/2/22.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Environment(\.dismiss) var dismiss
    @State var showOnboardingTwo : Bool = false
    @State var showError : Bool = false
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
            
            Text("Welcome!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.MyTheme.purple)
            
            Text("AnimalGram is the #1 app for posting pictures of your animal and sharing them across the world.")
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.MyTheme.purple)
                .padding()
            
//            Button {
//                showOnboardingTwo.toggle()
//            } label: {
//                SignInWithAppleButtonCustom()
//                    .frame(height: 60)
//                    .frame(maxWidth: .infinity)
//            }
            
            Button {
                Task {
                    await loginViewModel.signIn()
                    showOnboardingTwo.toggle()
                }
                
            } label: {
                HStack {
                    Image("googleIcon")
                        .frame(maxWidth: 1,maxHeight: 1)
                        .padding(.trailing,5)
                        .padding(.leading,20)
                    
                    Text("Sign in with Google")
                    
                }.frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(9)
                    .font(.system(size: 23, weight: .medium, design: .default))
                    
            }.tint(.gray)
            
            Button {
                dismiss()
            } label: {
                Text("Continue as huest".uppercased())
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding()
            }.foregroundColor(.accentColor)


            
        }.padding(.all,20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.MyTheme.beige)
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(
                isPresented: $showOnboardingTwo,
                onDismiss: { self.dismiss()
                    //當註冊完成 on2 dismiss後 -> 回到這畫面 -> 他也會馬上被dismiss
            },content: {
                OnboardingView_2()
            })
            .alert(isPresented: $loginViewModel.showError) {
                return Alert(title: Text(loginViewModel.errorMessage))
            }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
