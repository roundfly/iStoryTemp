//
//  SavedFiltersView.swift
//  iStory
//
//  Created by Bratislav Baljak on 5/21/22.
//

import Foundation
import UIKit
import StyleSheet

struct SavedFiltersViewModel: Identifiable, Hashable {
    var id = UUID()
    let image: UIImage
    let text: String
}

final class SavedFiltersView: UIView {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<SavedFiltersViewSection, SavedFiltersViewModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SavedFiltersViewSection, SavedFiltersViewModel>
    private enum SavedFiltersViewSection: CaseIterable {
        case main
    }
    
    private let titleLabel = UILabel()
    private var collectionView: UICollectionView!
    private var peopleImageViews: [UIImageView] = []
    private var peopleImages: [UIImage] = []
    
    private let theme = ThemeDefault()
    
    private var items: [SavedFiltersViewModel] = [SavedFiltersViewModel(image: UIImage(namedInStyleSheet: "bookmark")!, text: "sdf")]

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(peopleImages: [UIImage]) {
        self.init(frame: .zero)
        self.peopleImages = peopleImages
        
        setupUI()
    }

    private lazy var dataSource: DataSource = {
        .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(for: indexPath) as ImageWithTitleCell
            return cell
        }
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: createLayout())
        
        addManagedSubview(titleLabel)
        titleLabel.setConstraintsRelativeToSuperView(top: 0, leading: 0, trailing: 50)
        titleLabel.font = theme.fontBold.withSize(16)
        titleLabel.text = "Saved Filters"

        addManagedSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).activate()
        collectionView.setConstraintsRelativeToSuperView(leading: 0, bottom: 0, trailing: 0)
        collectionView.register(ImageWithTitleCell.self)
        collectionView.dataSource = dataSource
        
        reloadCollectionView()
    }
    
    func reloadCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<SavedFiltersViewSection, SavedFiltersViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50),
                                              heightDimension: .estimated(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
                
        return UICollectionViewCompositionalLayout(section: section, configuration: config)
    }
    
    private func configureCell(collectionView: UICollectionView, indexPath: IndexPath, filterId: SavedFiltersViewModel.ID) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as ImageWithTitleCell
        return cell
    }
}

final class ImageWithTitleCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addManagedSubview(imageView)
        imageView.setConstraintsRelativeToSuperView(top: 0, leading: 0, trailing: 0)
        imageView.setSizeConstraints(width: 35, height: 35)
        imageView.layer.cornerRadius = 6
        imageView.image = UIImage(namedInStyleSheet: "bookmark")
        
        addManagedSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 3).activate()
        titleLabel.setConstraintsRelativeToSuperView(leading: 0, bottom: 0, trailing: 0)
        titleLabel.text = "Tom"
    }
}
