//
//  AppState.swift
//  iStory
//
//  Created by Nikola Stojanovic on 9.4.22..
//

struct AppState: Equatable {
    var authState: AuthenticationState

    static let production = Self(authState: .init())
}
