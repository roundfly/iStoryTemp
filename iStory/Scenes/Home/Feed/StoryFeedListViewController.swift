//
//  StoryFeedListViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 7.5.22..
//

import UIKit
import StyleSheet

final class StoryFeedViewModel {
    private(set) var feed: [StoryFeedItem] = .stub

    func item(for id: UUID) -> StoryFeedItem? {
        feed.first(where: { $0.id == id })
    }
}

final class StoryFeedListViewController: UIViewController {
    // MARK: - Utility types

    private typealias DataSource = UICollectionViewDiffableDataSource<FeedSection, StoryFeedItem.ID>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<FeedSection, StoryFeedItem.ID>
    private enum FeedSection: CaseIterable {
        case main
    }

    // MARK: - Instance variables

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    private lazy var dataSource: DataSource = {
        DataSource(collectionView: collectionView) { [viewModel] collectionView, indexPath, storyId in
            let cell = collectionView.dequeueReusableCell(for: indexPath) as StoryFeedCell
            guard let story = viewModel.item(for: storyId) else { return cell }
            cell.configureCell(with: story)
            return cell
        }
    }()

    private let viewModel = StoryFeedViewModel()

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        applySnapshot()
        view.backgroundColor = .white
    }

    // MARK: - Subview setup

    private func setupCollectionView() {
        view.addManagedSubview(collectionView)
        collectionView.pinEdgesToSuperview()
        collectionView.register(StoryFeedCell.self)
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = dataSource
        collectionView.alpha = 0.0
    }

    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(FeedSection.allCases)
        snapshot.appendItems(viewModel.feed.map(\.id))
        dataSource.apply(snapshot, animatingDifferences: true)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveLinear]) {
            self.collectionView.alpha = 1.0
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            let groupCount = 1
            let groupHeight = 2.0 / 3.0
            let padding: CGFloat = 10.0
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(groupHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: groupCount)
            let section = NSCollectionLayoutSection(group: group)
            return section
        })
    }
}
