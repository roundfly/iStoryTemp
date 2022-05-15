//
//  StoryFeedItem.swift
//  iStory
//
//  Created by Nikola Stojanovic on 7.5.22..
//

import UIKit
import StyleSheet

struct StoryFeedItem: Identifiable {
    struct User {
        var name: String
        var profileImage: UIImage?
    }
    var id = UUID()
    var title: String
    var publishedAt: Date
    var desc: String
    var thumbnail: UIImage?
    var user: User
}

extension Array where Element == StoryFeedItem {
    static var stub: [StoryFeedItem] {
        [
            StoryFeedItem(title: "Awesome story",
                          publishedAt: .now,
                          desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent aliquet dictum aliquet. Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi tempus lacus et odio blandit, eget viverra quam interdum. Proin consequat, nisi id blandit sollicitudin, dolor mauris ullamcorper justo, quis efficitur nunc arcu sed velit.",
                       thumbnail: UIImage(namedInStyleSheet: "dinner"),
                       user: .init(name: "John Doe", profileImage: UIImage(systemName: "person"))),
            StoryFeedItem(title: "Awesome story",
                          publishedAt: .now,
                          desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent aliquet dictum aliquet. Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi tempus lacus et odio blandit, eget viverra quam interdum. Proin consequat, nisi id blandit sollicitudin, dolor mauris ullamcorper justo, quis efficitur nunc arcu sed velit.",
                       thumbnail: UIImage(namedInStyleSheet: "dinner"),
                       user: .init(name: "John Doe", profileImage: UIImage(systemName: "person"))),
            StoryFeedItem(title: "Awesome story",
                          publishedAt: .now,
                          desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent aliquet dictum aliquet. Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi tempus lacus et odio blandit, eget viverra quam interdum. Proin consequat, nisi id blandit sollicitudin, dolor mauris ullamcorper justo, quis efficitur nunc arcu sed velit.",
                       thumbnail: UIImage(namedInStyleSheet: "dinner"),
                       user: .init(name: "John Doe", profileImage: UIImage(systemName: "person"))),
            StoryFeedItem(title: "Awesome story",
                          publishedAt: .now,
                          desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent aliquet dictum aliquet. Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi tempus lacus et odio blandit, eget viverra quam interdum. Proin consequat, nisi id blandit sollicitudin, dolor mauris ullamcorper justo, quis efficitur nunc arcu sed velit.",
                       thumbnail: UIImage(namedInStyleSheet: "dinner"),
                       user: .init(name: "John Doe", profileImage: UIImage(systemName: "person"))),
            StoryFeedItem(title: "Awesome story",
                          publishedAt: .now,
                          desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent aliquet dictum aliquet. Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi tempus lacus et odio blandit, eget viverra quam interdum. Proin consequat, nisi id blandit sollicitudin, dolor mauris ullamcorper justo, quis efficitur nunc arcu sed velit.",
                       thumbnail: UIImage(namedInStyleSheet: "dinner"),
                       user: .init(name: "John Doe", profileImage: UIImage(systemName: "person"))),
            StoryFeedItem(title: "Awesome story",
                          publishedAt: .now,
                          desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent aliquet dictum aliquet. Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi tempus lacus et odio blandit, eget viverra quam interdum. Proin consequat, nisi id blandit sollicitudin, dolor mauris ullamcorper justo, quis efficitur nunc arcu sed velit.",
                       thumbnail: UIImage(namedInStyleSheet: "dinner"),
                       user: .init(name: "John Doe", profileImage: UIImage(systemName: "person"))),
        ]
    }
}
