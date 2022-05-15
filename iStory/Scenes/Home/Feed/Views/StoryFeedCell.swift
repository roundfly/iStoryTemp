//
//  StoryFeedCell.swift
//  iStory
//
//  Created by Nikola Stojanovic on 7.5.22..
//

import UIKit
import Combine
import StyleSheet

final class StoryFeedCell: UICollectionViewCell {
    private let userImageView = UIImageView()
    private let userNameLabel = UILabel(), publishedAtLabel = UILabel()
    private let titleLabel = UILabel(), descLabel = UILabel()
    private let playButton = UIButton(configuration: .plain())
    private let commentsButton = UIButton(configuration: .plain())
    private let viewsButton = UIButton(configuration: .plain())
    private let optionsButton = UIButton(configuration: .plain())
    private let storyPlayButton = UIButton(configuration: .plain())
    private lazy var buttonHStackView = UIStackView(arrangedSubviews: [viewsButton, commentsButton, playButton])
    private var cancellable: AnyCancellable?
    private let storyThumbnailImageView = UIImageView()

    private var gridPublishedAtLabelBottomConstraint: NSLayoutConstraint!
    private var feedUserNameLabelTopAnchorConstraint: NSLayoutConstraint!
    private var feedUserNameLabelLeadingAnchorConstraint: NSLayoutConstraint!
    private var gridUserNameLabelBottomAnchor: NSLayoutConstraint!
    private var gridUserNameLabelLeadingAchorConstraint: NSLayoutConstraint!
    private var feedTitleLabelBottomAnchorConstraint: NSLayoutConstraint!
    private var gridTitleLabelBottomAnchorConstraint: NSLayoutConstraint!
    private var feedPublishedAtLabelTopAnchorConstraint: NSLayoutConstraint!
    private var gridPublishedAtLabelTopAnchorConstraint: NSLayoutConstraint!

    // workaround for layout changes not calling configureCell(with:using:)
    var stylePublisher: AnyPublisher<LayoutStyle, Never>!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configureCell(with item: StoryFeedItem, using style: LayoutStyle) {
        userImageView.image = item.user.profileImage
        userNameLabel.text = item.user.name
        publishedAtLabel.text = item.publishedAt.formatted()
        titleLabel.text = item.title
        descLabel.text = item.desc
        storyThumbnailImageView.image = item.thumbnail
        var commentsContainer = AttributeContainer(), viewsContainer = AttributeContainer()
        commentsContainer.font = .preferredFont(forTextStyle: .caption1)
        viewsContainer.font = .preferredFont(forTextStyle: .caption1)
        commentsButton.configuration?.attributedTitle = AttributedString(String(Int.random(in: 10...100)), attributes: commentsContainer)
        viewsButton.configuration?.attributedTitle = AttributedString(String(Int.random(in: 10...100)), attributes: viewsContainer)
        handleChange(of: style)
        cancellable = stylePublisher.sink(receiveValue: handleChange(of:))
    }

    private func setupSubviews() {
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        contentView.layer.cornerCurve = .continuous
        setupStoryThumbnailImageView()
        setupUserImageView()
        setupUserNameLabel()
        setupPublishedAtLabel()
        setupButtons()
        setupDescLabel()
        setupTitleLabel()
        setupOptionsButton()
        setupStoryPlayButton()
    }

    private func setupStoryThumbnailImageView() {
        contentView.addManagedSubview(storyThumbnailImageView)
        storyThumbnailImageView.contentMode = .scaleAspectFill
        storyThumbnailImageView.pinEdgesToSuperview()
    }

    private func setupUserImageView() {
        contentView.addManagedSubview(userImageView)
        userImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 15).activate()
        userImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 15).activate()
        userImageView.heightAnchor.constraint(equalToConstant: 40).activate()
        userImageView.widthAnchor.constraint(equalToConstant: 40).activate()
        userImageView.layer.cornerRadius = 20
        userImageView.layer.masksToBounds = true
        userImageView.backgroundColor = .systemMint
        userImageView.layer.borderWidth = 4.0
        userImageView.layer.borderColor = UIColor.white.cgColor
    }

    private func setupUserNameLabel() {
        contentView.addManagedSubview(userNameLabel)
        feedUserNameLabelTopAnchorConstraint = userNameLabel.topAnchor.constraint(equalTo: userImageView.centerYAnchor, constant: -15)
        feedUserNameLabelTopAnchorConstraint.activate()
        feedUserNameLabelLeadingAnchorConstraint = userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10)
        feedUserNameLabelLeadingAnchorConstraint.activate()
        gridUserNameLabelLeadingAchorConstraint = userNameLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 15)
        gridUserNameLabelBottomAnchor = userNameLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10)
        userNameLabel.textColor = .white
        userNameLabel.font = .preferredFont(forTextStyle: .headline)
    }

    private func setupPublishedAtLabel() {
        contentView.addManagedSubview(publishedAtLabel)
        publishedAtLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).activate()
        feedPublishedAtLabelTopAnchorConstraint = publishedAtLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5)
        feedPublishedAtLabelTopAnchorConstraint.activate()
        gridPublishedAtLabelTopAnchorConstraint = publishedAtLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        gridPublishedAtLabelBottomConstraint = publishedAtLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        publishedAtLabel.textColor = .white
        publishedAtLabel.font = .preferredFont(forTextStyle: .caption1)
    }

    private func setupButtons() {
        playButton.configuration?.baseForegroundColor = .white
        playButton.configuration?.image = UIImage(systemName: "play")
        viewsButton.configuration?.baseForegroundColor = .white
        viewsButton.configuration?.image = UIImage(systemName: "eye")
        viewsButton.configuration?.imagePlacement = .leading
        viewsButton.configuration?.imagePadding = 5.0
        commentsButton.configuration?.baseForegroundColor = .white
        commentsButton.configuration?.image = UIImage(systemName: "message")
        commentsButton.configuration?.imagePlacement = .leading
        commentsButton.configuration?.imagePadding = 5.0
        contentView.addManagedSubview(buttonHStackView)
        buttonHStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -15).activate()
        buttonHStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -50).activate()
        buttonHStackView.heightAnchor.constraint(equalToConstant: 40.0).activate()
        buttonHStackView.axis = .horizontal
        buttonHStackView.distribution = .fillEqually
    }

    private func setupDescLabel() {
        contentView.addManagedSubview(descLabel)
        descLabel.textColor = .white
        descLabel.font = .preferredFont(forTextStyle: .caption1)
        descLabel.bottomAnchor.constraint(equalTo: buttonHStackView.topAnchor, constant: -20).activate()
        descLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: -60).activate()
        descLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 15).activate()
        descLabel.numberOfLines = 2
    }

    private func setupTitleLabel() {
        contentView.addManagedSubview(titleLabel)
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .white
        feedTitleLabelBottomAnchorConstraint = titleLabel.bottomAnchor.constraint(equalTo: descLabel.topAnchor, constant: -20)
        feedTitleLabelBottomAnchorConstraint.activate()
        gridTitleLabelBottomAnchorConstraint = titleLabel.bottomAnchor.constraint(equalTo: publishedAtLabel.topAnchor, constant: -10)
        titleLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: -30).activate()
        titleLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 15).activate()
        titleLabel.numberOfLines = 1
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

    private func setupStoryPlayButton() {
        contentView.addManagedSubview(storyPlayButton)
        storyPlayButton.heightAnchor.constraint(equalToConstant: 80).activate()
        storyPlayButton.widthAnchor.constraint(equalToConstant: 80).activate()
        storyPlayButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).activate()
        storyPlayButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).activate()
        storyPlayButton.configuration?.image = UIImage(namedInStyleSheet: "play")
        storyPlayButton.configuration?.baseForegroundColor = .white
    }

    private func handleChange(of style: LayoutStyle) {
        buttonHStackView.isHidden = style != .feed
        playButton.isHidden = style != .feed
        viewsButton.isHidden = style != .feed
        commentsButton.isHidden = style != .feed
        storyPlayButton.isHidden = style != .feed
        descLabel.isHidden = style != .feed
        switch style {
        case .feed:
            gridPublishedAtLabelBottomConstraint.isActive = false
            feedUserNameLabelTopAnchorConstraint.activate()
            gridUserNameLabelLeadingAchorConstraint.isActive = false
            feedUserNameLabelLeadingAnchorConstraint.activate()
            feedTitleLabelBottomAnchorConstraint.activate()
            gridTitleLabelBottomAnchorConstraint.isActive = false
            gridUserNameLabelBottomAnchor.isActive = false
            feedPublishedAtLabelTopAnchorConstraint.activate()
            gridPublishedAtLabelTopAnchorConstraint.isActive = false
        case .grid:
            feedUserNameLabelLeadingAnchorConstraint.isActive = false
            gridUserNameLabelLeadingAchorConstraint.activate()
            gridPublishedAtLabelBottomConstraint.activate()
            feedUserNameLabelTopAnchorConstraint.isActive = false
            feedTitleLabelBottomAnchorConstraint.isActive = false
            gridTitleLabelBottomAnchorConstraint.activate()
            gridUserNameLabelBottomAnchor.activate()
            feedPublishedAtLabelTopAnchorConstraint.isActive = false
            gridPublishedAtLabelTopAnchorConstraint.activate()
        }
    }
}
