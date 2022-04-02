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

struct AuthSocialViewModel {
    var title: String
    var primaryButtonTitle: String
    var disclaimerButtonTitle: String
    var onGoogleRequest: () -> Void
    var onAmazonRequest: () -> Void
    var onIstoryRequest: () -> Void
    var onAppleRequest: (ASAuthorizationAppleIDRequest) -> Void
    var onAppleCompletion: (Result<ASAuthorization, Error>) -> Void
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

    private var disclaimerButton: some View {
        Button(action: {}) {
            Text(viewModel.disclaimerButtonTitle)
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
