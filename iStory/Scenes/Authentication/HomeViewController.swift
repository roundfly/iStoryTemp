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
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let searchBar = SearchBar(type: .withFilterButton, frame: .zero)

    private var labelContentViewHeightAnchor: NSLayoutConstraint!
    private var collectionViewTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isSearchBarHidden = true
        setupUI()
        applySnapshot()
        hideKeyboardWhenTappedAround()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addManagedSubview(navigationBar)
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).activate()
        navigationBar.setConstraintsRelativeToSuperView(leading: 0, trailing: 0)
        navigationBar.delegate = self

        let labelContentView = UIView()
        view.addManagedSubview(labelContentView)
        labelContentView.addManagedSubview(titleLabel)
        labelContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
        labelContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).activate()
        labelContentView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).activate()
        labelContentViewHeightAnchor = labelContentView.heightAnchor.constraint(equalToConstant: 70)
        labelContentViewHeightAnchor.activate()

        titleLabel.topAnchor.constraint(equalTo: labelContentView.topAnchor).activate()
        titleLabel.leadingAnchor.constraint(equalTo: labelContentView.leadingAnchor, constant: 26).activate()
        titleLabel.trailingAnchor.constraint(equalTo: labelContentView.trailingAnchor, constant: 26).activate()
        titleLabel.font = theme.fontBold.withSize(26)
        titleLabel.text = "Hello"
        titleLabel.numberOfLines = 0
        
        labelContentView.addManagedSubview(subtitleLabel)
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).activate()
        subtitleLabel.leadingAnchor.constraint(equalTo: labelContentView.leadingAnchor, constant: 26).activate()
        subtitleLabel.trailingAnchor.constraint(equalTo: labelContentView.trailingAnchor, constant: 26).activate()
        subtitleLabel.bottomAnchor.constraint(equalTo: labelContentView.bottomAnchor).activate()
        subtitleLabel.numberOfLines = 2
        subtitleLabel.font = theme.fontBold.withSize(18)
        subtitleLabel.textColor = AppColor.textFieldTextColor.uiColor
        subtitleLabel.text = "Let’s Explore activities \nof your friends"
        
        view.addManagedSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: labelContentView.bottomAnchor, constant: 25).activate()
        searchBar.setConstraintsRelativeToSuperView(leading: 26, trailing: 26)
        searchBar.setHeightConstraint(equalToConstant: 30)
        searchBar.delegate = self
        
        view.addManagedSubview(collectionView)
        collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10)
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).activate()
        collectionViewTopConstraint.activate()
        collectionView.register(StoryFeedCell.self)
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = dataSource
        collectionView.delegate = self
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

extension HomeViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset > 5 {
            collectionViewTopConstraint.constant -= 10
            if collectionViewTopConstraint.constant <= -30 {
                collectionViewTopConstraint.constant = -30
            }
            labelContentViewHeightAnchor.constant -= 10
            if labelContentViewHeightAnchor.constant < 0 {
                labelContentViewHeightAnchor.constant = 0.0
            }
        } else {
            collectionViewTopConstraint.constant += 10
            if collectionViewTopConstraint.constant >= 10 {
                collectionViewTopConstraint.constant = 10
            }
            guard labelContentViewHeightAnchor.constant <= 60 else { return }
            labelContentViewHeightAnchor.constant += 10
        }
        if offset > 72 {
            searchBar.isHidden = true
            navigationBar.isRightButtonHidden = false
            navigationBar.isSearchBarHidden = false
        } else {
            navigationBar.isRightButtonHidden = true
            navigationBar.isSearchBarHidden = true
            searchBar.isHidden = false
        }
    }
}

extension HomeViewController: SearchBarDelegate {
    func didEnterSearch(query: String) {
        navigationBar.updateSearchBar(with: query)
    }
}

extension HomeViewController: NavigationBarDelegate {
    func didEnterNavigationSearch(query: String) {
        searchBar.update(search: query)
    }
}
