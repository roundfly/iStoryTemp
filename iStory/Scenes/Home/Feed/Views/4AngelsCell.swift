//
//  4AngelsCell.swift
//  iStory
//
//  Created by Nikola Stojanovic on 21.5.22..
//

import Combine
import UIKit
import StyleSheet

final class FourAngelsCell: UICollectionViewCell {
    private let userImageView = UIImageView()
    private let userNameLabel = UILabel(), publishedAtLabel = UILabel()
    private let titleLabel = UILabel(), descLabel = UILabel()
    private let storyThumbnailImageView = UIImageView()
    private let gradient: GradientView = .backgroundNoise
    private let optionsButton = UIButton(configuration: .plain())
    private let playButton = UIButton(configuration: .plain())
    private var cancellable: AnyCancellable?
    var stylePublisher: AnyPublisher<LayoutStyle, Never>!

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        contentView.layer.cornerCurve = .continuous
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.1)

        setupStoryThumbnailImageView()
        setupUserImageView()
        setupUserNameLabel()
        setupPublishedAtLabel()
        setupOptionsButton()
        setupPlayButton()
        setupTitleWithDescLabel()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func subscribeToLayoutChanges(using publisher: AnyPublisher<LayoutStyle, Never>) {
        stylePublisher = publisher
        cancellable = stylePublisher.sink(receiveValue: handleChange)
    }

    private func setupStoryThumbnailImageView() {
        contentView.addManagedSubview(storyThumbnailImageView)
        storyThumbnailImageView.contentMode = .scaleAspectFill
        storyThumbnailImageView.clipsToBounds = true
        storyThumbnailImageView.image = UIImage(namedInStyleSheet: "food")
        storyThumbnailImageView.pinEdgesToSuperview()
        contentView.addManagedSubview(gradient)
        gradient.pinEdgesToSuperview()
    }

    private func setupUserImageView() {
        contentView.addManagedSubview(userImageView)
        userImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 15).activate()
        userImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 15).activate()
        userImageView.heightAnchor.constraint(equalToConstant: 40).activate()
        userImageView.widthAnchor.constraint(equalToConstant: 40).activate()
        userImageView.layer.cornerRadius = 20
        userImageView.layer.masksToBounds = true
        userImageView.layer.borderWidth = 4.0
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.image = UIImage(namedInStyleSheet: "4Angels")
    }

    private func setupUserNameLabel() {
        contentView.addManagedSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: userImageView.centerYAnchor, constant: -15).activate()
        userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10).activate()
        userNameLabel.textColor = .white
        userNameLabel.font = .preferredFont(forTextStyle: .headline)
        userNameLabel.text = "iStory Admin"
    }

    private func setupPublishedAtLabel() {
        contentView.addManagedSubview(publishedAtLabel)
        publishedAtLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).activate()
        publishedAtLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5).activate()
        publishedAtLabel.textColor = .white
        publishedAtLabel.font = .preferredFont(forTextStyle: .caption1)
        publishedAtLabel.text = Date.now.formatted(date: .omitted, time: .shortened)
    }

    private func setupOptionsButton() {
        contentView.addManagedSubview(optionsButton)
        optionsButton.configuration?.image = UIImage(systemName: "ellipsis")
        optionsButton.configuration?.baseForegroundColor = .white
        optionsButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -15).activate()
        optionsButton.heightAnchor.constraint(equalToConstant: 40).activate()
        optionsButton.widthAnchor.constraint(equalToConstant: 40).activate()
        optionsButton.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 20).activate()
        optionsButton.transform = CGAffineTransform(rotationAngle: 90.0 * .pi/180.0)
    }

    private func setupPlayButton() {
        contentView.addManagedSubview(playButton)
        playButton.configuration?.baseForegroundColor = .white
        playButton.configuration?.image = UIImage(systemName: "play")
        playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).activate()
        playButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).activate()
    }

    private func setupTitleWithDescLabel() {
        [titleLabel, descLabel].forEach(contentView.addManagedSubview)
        titleLabel.textColor = .white
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        descLabel.font = .preferredFont(forTextStyle: .caption1)
        descLabel.numberOfLines = 2
        descLabel.textColor = .white
        titleLabel.text = "Holiday cookies"
        descLabel.text = "Sed ut perspiciatis unde omnis iste natus error sit lorem lorem ipsum ... "
        descLabel.bottomAnchor.constraint(equalTo: playButton.topAnchor).activate()
        descLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 15).activate()
        descLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: 15).activate()

        titleLabel.bottomAnchor.constraint(equalTo: descLabel.topAnchor, constant: -10).activate()
        titleLabel.leadingAnchor.constraint(equalTo: descLabel.leadingAnchor).activate()
        titleLabel.trailingAnchor.constraint(equalTo: descLabel.trailingAnchor).activate()
    }

    private func handleChange(of style: LayoutStyle) {
        userNameLabel.isHidden = style != .feed
        publishedAtLabel.isHidden = style != .feed
        userImageView.isHidden = style != .feed
    }
}
