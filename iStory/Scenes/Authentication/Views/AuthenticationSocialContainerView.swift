//
//  AuthenticationSocialView.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import UIKit
import StyleSheet
import SwiftUI
import AuthenticationServices
import GoogleSignInService

enum AuthIntent {
    case logIn
    case signUp
}

struct AuthSocialViewModel {
    var title: String
    var primaryButtonTitle: String
    var authIntent: AuthIntent
    var onGoogleRequest: () -> Void
    var onAmazonRequest: () -> Void
    var onIstoryRequest: () -> Void
    var onAppleRequest: (ASAuthorizationAppleIDRequest) -> Void
    var onAppleCompletion: (Result<ASAuthorization, Error>) -> Void
    var tryApp: () -> Void
    var googleTitle: String {
        String(localized: "auth.social.google.title")
    }
    var amazonTitle: String {
        String(localized: "auth.social.amazon.title")
    }
}

struct AuthSocialContainerView: View {

    var viewModel: AuthSocialViewModel

    var body: some View {
        VStack {
            AuthSocialHeaderView(title: viewModel.title)
            Spacer()
            socialButtonGroup
            disclaimerButton
        }
        .background(background)
    }

    private var socialButtonGroup: some View {
        Group {
            AuthSocialButton(title: viewModel.amazonTitle, onSocialAction: viewModel.onAmazonRequest)
            SignInWithAppleButton(.continue, onRequest: viewModel.onAppleRequest, onCompletion: viewModel.onAppleCompletion)
            AuthSocialButton(title: viewModel.googleTitle, onSocialAction: viewModel.onGoogleRequest)
            AuthSocialButton(title: viewModel.primaryButtonTitle, onSocialAction: viewModel.onIstoryRequest)
        }
        .signInWithAppleButtonStyle(.white)
        .foregroundColor(.black)
        .frame(height: 44)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .offset(x: 0, y: -110)
    }

    @ViewBuilder
    private var disclaimerButton: some View {
        switch viewModel.authIntent {
        case .logIn:
            HStack {
                Button(action: viewModel.tryApp) {
                    Text("Skip").bold() + Text(" and check the app?")
                }
                Button(action: {}) {
                    Text("No account? ") + Text("Create one!").bold()
                }
            }
            .font(.footnote)
            .foregroundColor(.black)
            .offset(x: 0, y: -20)
        case .signUp:
            VStack(spacing: 0) {
                HStack {
                    Button(action: viewModel.tryApp) {
                        Text("Skip").bold() + Text(" and check the app?")
                    }
                    Button(action: {}) {
                        Text("Have account? ") + Text("Login!").bold()
                    }
                }
                Button(action: {}) {
                    Text("By signing up, you agree to our ") + Text("Terms of Service").bold() + Text(" and ") +  Text("Privacy Policy.").bold()
                }
                .padding()
            }
            .font(.footnote)
            .foregroundColor(.black)
            .offset(x: 0, y: -20)
        }
    }

    private var bottomAsset: some View {
        Image(uiImage: UIImage(namedInStyleSheet: "onboarding-background")!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .background(AppColor.yellow.ignoresSafeArea())
    }

    private var background: some View {
        VStack(spacing: 0) {
            AppColor.yellow.ignoresSafeArea()
            bottomAsset
        }
    }
}
