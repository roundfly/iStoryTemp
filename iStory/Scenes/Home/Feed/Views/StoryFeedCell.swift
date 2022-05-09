//
//  StoryFeedCell.swift
//  iStory
//
//  Created by Nikola Stojanovic on 7.5.22..
//

import UIKit
import StyleSheet

final class StoryFeedCell: UICollectionViewCell {
    private let userImageView = UIImageView()
    private let userNameLabel = UILabel(), publishedAtLabel = UILabel()
    private let titleLabel = UILabel(), descLabel = UILabel()
    private let playButton = UIButton(configuration: .plain())
    private let commentsButton = UIButton(configuration: .plain())
    private let viewsButton = UIButton(configuration: .plain())
    private let optionsButton = UIButton(configuration: .plain())
    private lazy var buttonHStackView = UIStackView(arrangedSubviews: [viewsButton, commentsButton, playButton])

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        contentView.backgroundColor = .systemPurple
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configureCell(with item: StoryFeedItem) {
        userImageView.image = item.user.profileImage
        userNameLabel.text = item.user.name
        publishedAtLabel.text = item.publishedAt.formatted()
        titleLabel.text = item.title
        descLabel.text = item.desc
        var commentsContainer = AttributeContainer(), viewsContainer = AttributeContainer()
        commentsContainer.font = .preferredFont(forTextStyle: .caption1)
        viewsContainer.font = .preferredFont(forTextStyle: .caption1)
        commentsButton.configuration?.attributedTitle = AttributedString(String(Int.random(in: 10...100)), attributes: commentsContainer)
        viewsButton.configuration?.attributedTitle = AttributedString(String(Int.random(in: 10...100)), attributes: viewsContainer)
    }

    private func setupSubviews() {
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        contentView.layer.cornerCurve = .continuous
        setupUserImageView()
        setupUserNameLabel()
        setupPublishedAtLabel()
        setupButtons()
        setupDescLabel()
        setupTitleLabel()
        setupOptionsButton()
    }

    private func setupUserImageView() {
        contentView.addManagedSubview(userImageView)
        userImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 20).activate()
        userImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 20).activate()
        userImageView.heightAnchor.constraint(equalToConstant: 60).activate()
        userImageView.widthAnchor.constraint(equalToConstant: 60).activate()
        userImageView.layer.cornerRadius = 30
        userImageView.layer.masksToBounds = true
        userImageView.backgroundColor = .systemYellow
        userImageView.layer.borderWidth = 4.0
        userImageView.layer.borderColor = UIColor.white.cgColor
    }

    private func setupUserNameLabel() {
        contentView.addManagedSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: userImageView.centerYAnchor, constant: -15).activate()
        userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10).activate()
        userNameLabel.textColor = .white
        userNameLabel.font = .preferredFont(forTextStyle: .headline)
    }

    private func setupPublishedAtLabel() {
        contentView.addManagedSubview(publishedAtLabel)
        publishedAtLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).activate()
        publishedAtLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5).activate()
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
        buttonHStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -20).activate()
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
        descLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 20).activate()
        descLabel.numberOfLines = 2
    }

    private func setupTitleLabel() {
        contentView.addManagedSubview(titleLabel)
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .white
        titleLabel.bottomAnchor.constraint(equalTo: descLabel.topAnchor, constant: -20).activate()
        titleLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: -30).activate()
        titleLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 20).activate()
        titleLabel.numberOfLines = 1
    }

    private func setupOptionsButton() {
        contentView.addManagedSubview(optionsButton)
        optionsButton.configuration?.image = UIImage(systemName: "text.justify")
        optionsButton.configuration?.baseForegroundColor = .white
        optionsButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -20).activate()
        optionsButton.heightAnchor.constraint(equalToConstant: 40).activate()
        optionsButton.widthAnchor.constraint(equalToConstant: 40).activate()
        optionsButton.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 20).activate()
    }
}
