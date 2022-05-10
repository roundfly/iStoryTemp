//
//  HomeViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 30.4.22..
//

import UIKit
import StyleSheet

final class HomeViewController: UIViewController {
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

    private let theme = ThemeDefault()
    private let navigationBar = NavigationBar(type: .feed, frame: .zero)
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let bellImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let searchBar = SearchBar(type: .withFilterButton, frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupUI()
        applySnapshot()
    }
    
    private func setupScrollView() {
        view.backgroundColor = .white
        view.addManagedSubview(scrollView)
        scrollView.setConstraintsEqualToSuperView()
                
        scrollView.addManagedSubview(contentView)
        scrollView.delegate = self
        contentView.setConstraintsEqualToSuperView()

        let contentViewCenterY = contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        contentViewCenterY.priority = .defaultLow

        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: contentView.heightAnchor)
        contentViewHeight.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentViewCenterY,
            contentViewHeight
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didEndSearch))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func didEndSearch() {
        searchBar.didEndSearch()
    }
    
    private func setupUI() {        
        view.addManagedSubview(navigationBar)
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).activate()
        navigationBar.setConstraintsRelativeToSuperView(leading: 0, trailing: 0)
                
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        view.addManagedSubview(whiteView)
        whiteView.setConstraintsRelativeToSuperView(top: 0, leading: 0, trailing: 0)
        whiteView.bottomAnchor.constraint(equalTo: navigationBar.topAnchor).activate()
        
        contentView.addManagedSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 45).activate()
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26).activate()
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 26).activate()
        titleLabel.font = theme.fontBold.withSize(26)
        titleLabel.text = "Hello"
        
        contentView.addManagedSubview(subtitleLabel)
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).activate()
        subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26).activate()
        subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 26).activate()
        subtitleLabel.numberOfLines = 2
        subtitleLabel.font = theme.fontBold.withSize(18)
        subtitleLabel.textColor = AppColor.textFieldTextColor.uiColor
        subtitleLabel.text = "Let’s Explore activities \nof your friends"
        
        contentView.addManagedSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 25).activate()
        searchBar.setConstraintsRelativeToSuperView(leading: 26, trailing: 26)
        searchBar.setHeightConstraint(equalToConstant: 30)
        
        contentView.addManagedSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 50).activate()
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).activate()
        collectionView.setConstraintsRelativeToSuperView(leading: 0, bottom: 0, trailing: 0)
        collectionView.setSizeConstraints(height: 1600)
        collectionView.register(StoryFeedCell.self)
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = dataSource
        collectionView.alpha = 0.0
        collectionView.isScrollEnabled = false
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

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        print("Offset \(offset)")
        if offset > 72 {
            navigationBar.isRightButtonHidden = false
            navigationBar.isSearchBarHidden = false
        } else {
            navigationBar.isRightButtonHidden = true
            navigationBar.isSearchBarHidden = true
        }
    }
}

