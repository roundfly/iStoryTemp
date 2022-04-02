//
//  AuthenticationSocialViews.swift
//  iStory
//
//  Created by Nikola Stojanovic on 2.4.22..
//

import UIKit
import StyleSheet
import SwiftUI

struct AuthSocialHeaderView: View {
    var title: String

    var body: some View {
        Image(uiImage: .logo)
            .resizable()
            .frame(width: 90, height: 130)
        Text(title)
            .font(.largeTitle)
    }
}

struct AuthSocialButton: View {
    var title: String
    var onSocialAction: () -> Void

    var body: some View {
        Button(action: onSocialAction) {
            Text(title)
                .bold()
                .frame(maxWidth: .infinity)
                .frame(height: 44.0)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
}
