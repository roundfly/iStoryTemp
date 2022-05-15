//
//  LayoutProvider.swift
//  iStory
//
//  Created by Nikola Stojanovic on 15.5.22..
//

import UIKit

public enum LayoutStyle {
    case feed
    case grid

    mutating func toggle() {
        switch self {
        case .feed:
            self = .grid
        case .grid:
            self = .feed
        }
    }
}

/// A type which constructs a UICollectionViewCompositionalLayout given a dedicated style
enum LayoutProvider {
    // MARK: - Layout creation API

    static func createLayout(style: LayoutStyle) -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let predicate = style == .feed
            let groupCount = predicate ? 1 : 2
            let groupHeight = predicate ? 2.0 / 3.0 : 2.0 / 5.0
            let padding: CGFloat = 10.0
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(groupHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: groupCount)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}
