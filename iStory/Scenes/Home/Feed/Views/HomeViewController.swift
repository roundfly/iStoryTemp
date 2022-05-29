//
//  HomeViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 30.4.22..
//

import Combine
import UIKit
import StyleSheet

enum AuthenticationStatus: Equatable {
    case anonymous
    case loggedIn(User)
}

final class HomeViewController: UIViewController {
    // MARK: - Utility types

    private typealias DataSource = UICollectionViewDiffableDataSource<FeedSection, StoryFeedItem.ID>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<FeedSection, StoryFeedItem.ID>
    private enum FeedSection: Int, CaseIterable {
        case fourAngels
        case main
    }

    // MARK: - Instance variables

    var anonymousUserInteractionPublisher: AnyPublisher<Void, Never> {
        anonymousUserInteractionSubject.eraseToAnyPublisher()
    }
    private let anonymousUserInteractionSubject = PassthroughSubject<Void, Never>()

    private let collectionView: UICollectionView
    private var style: LayoutStyle {
        didSet {
            let layout = LayoutProvider.createLayout(style: style)
            update(layout: layout)
        }
    }
    private let styleSubject = PassthroughSubject<LayoutStyle, Never>()

    private lazy var dataSource: DataSource = {
        DataSource(collectionView: collectionView, cellProvider: configureCell(collectionView:indexPath:storyId:))
    }()

    private let viewModel: StoryFeedViewModel

    private let theme = ThemeDefault()
    private let navigationBar = NavigationBar(type: .feed, frame: .zero)
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let searchBar = SearchBar(type: .withFilterButton, frame: .zero)

    private var labelContentViewHeightAnchor: NSLayoutConstraint!
    private var collectionViewTopConstraint: NSLayoutConstraint!

    init(authStatus: AuthenticationStatus) {
        self.viewModel = StoryFeedViewModel(authStatus: authStatus)
        let layout = LayoutProvider.createLayout(style: .feed)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.style = .feed
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isSearchBarHidden = true
        setupUI()
        applySnapshot()
        hideKeyboardWhenTappedAround()
        setupLeadingNavbarButtonAction()
    }

    private func configureCell(collectionView: UICollectionView, indexPath: IndexPath, storyId: StoryFeedItem.ID) -> UICollectionViewCell {
        guard let section = FeedSection(rawValue: indexPath.section) else { preconditionFailure() }
        switch section {
        case .fourAngels:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as FourAngelsCell
            cell.subscribeToLayoutChanges(using: styleSubject.eraseToAnyPublisher())
            return cell
        case .main:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as StoryFeedCell
            guard let story = viewModel.item(for: storyId) else { return cell }
            cell.stylePublisher = styleSubject.eraseToAnyPublisher()
            cell.configureCell(with: story, using: style)
            return cell
        }
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
        collectionView.register(FourAngelsCell.self)
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.alpha = 0.0
        
        let action = UIAction { [weak self] action in
            let nc = UINavigationController(rootViewController: FilterViewController())
            primarySheet(for: nc)
            self?.present(nc, animated: true)
        }
        searchBar.addFilter(action: action)
        navigationBar.addActionTo(rightButton: action)
    }

    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(FeedSection.allCases)
        for section in FeedSection.allCases {
            switch section {
            case .fourAngels:
                snapshot.appendItems([UUID()], toSection: .fourAngels)
            case .main:
                snapshot.appendItems(viewModel.feed.map(\.id), toSection: .main)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: true)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveLinear]) {
            self.collectionView.alpha = 1.0
        }
    }

    private func update(layout: UICollectionViewLayout, animated: Bool = true) {
        if style == .list {
            UIView.animate(withDuration: 0.2, animations: {
                self.collectionView.alpha = 0.0
            }, completion: { _ in
                self.collectionView.setCollectionViewLayout(layout, animated: false)
                self.styleSubject.send(self.style)
                UIView.animate(withDuration: 0.2) {
                    self.collectionView.alpha = 1.0
                }
            })
        } else {
            collectionView.setCollectionViewLayout(layout, animated: style != .list)
            styleSubject.send(style)
        }
    }

    private func setupLeadingNavbarButtonAction() {
        navigationBar.leadingButtonAction = UIAction { [weak self] _ in
            self?.style.toggle()
        }
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !viewModel.isAnonymous else {
            anonymousUserInteractionSubject.send()
            return
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
