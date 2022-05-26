//
//  StoryFeedViewModel.swift
//  iStory
//
//  Created by Nikola Stojanovic on 20.5.22..
//

import Foundation
import UserDefaultsClient

final class StoryFeedViewModel {
    // MARK: - Instance variables

    private(set) var feed: [StoryFeedItem] = .stub
    private let defaults: UserDefaultsClient
    private let authStatus: AuthenticationStatus

    var isAnonymous: Bool {
        authStatus == .anonymous
    }

    // MARK: - Initialization

    init(defaults: UserDefaultsClient = .production, authStatus: AuthenticationStatus) {
        self.defaults = defaults
        self.authStatus = authStatus
    }

    // MARK: - API

    func item(for id: UUID) -> StoryFeedItem? {
        feed.first(where: { $0.id == id })
    }
}
