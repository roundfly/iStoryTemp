//
//  AuthenticationSignUpDatePickerViewController.swift
//  iStory
//
//  Created by Nikola Stojanovic on 15.4.22..
//

import Combine
import UIKit
import StyleSheet

final class AuthenticationSignUpDatePickerViewController: UIViewController {
    // MARK: - Instance variables

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logoImageView = UIImageView()
    private let datePicker = UIDatePicker()
    var dateCompletePublisher: AnyPublisher<Void, Never> {
        dateCompleteSubject.eraseToAnyPublisher()
    }
    private let dateCompleteSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let store: AuthenticationStore

    init(store: AuthenticationStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        store.$state.sink { [dateCompleteSubject] state in
            if let _ = state.authFailure {
                // prsent error
            } else if let _ = state.userBirthday {
                dateCompleteSubject.send()
            }
        }.store(in: &cancellables)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        applyAuthenticationStyle(to: view)
        setupSubviews()
    }

    // MARK: - Subview setup

    private func setupSubviews() {
        navigationItem.hidesBackButton = true
        setupLogoImageView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupInputStackView()
        setupDatePicker()
    }

    private func setupLogoImageView() {
        logoImageView.image = .logo
        logoImageView.contentMode = .scaleAspectFill
        view.addManagedSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).activate()
        logoImageView.heightAnchor.constraint(equalToConstant: 130).activate()
        logoImageView.widthAnchor.constraint(equalToConstant: 90).activate()
    }

    private func setupTitleLabel() {
        titleLabel.text = String(localized: "splash.auth.signup.title")
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        view.addManagedSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        titleLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).activate()
        titleLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).activate()
        titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20).activate()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
    }

    private func setupDescriptionLabel() {
        view.addManagedSubview(descriptionLabel)
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = String(localized: "auth.date.picker.description")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .preferredFont(forTextStyle: .title2)
        descriptionLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).activate()
        descriptionLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).activate()
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).activate()
        descriptionLabel.setContentHuggingPriority(.required, for: .vertical)
    }

    private func setupInputStackView() {
        var dateConfig = UIButton.Configuration.filled(), submitConfig = UIButton.Configuration.filled()
        dateConfig.baseBackgroundColor = .white
        dateConfig.baseForegroundColor = .black
        dateConfig.title = String(localized: "auth.date.picker.placeholder")
        submitConfig.baseBackgroundColor = AppColor.blue.uiColor
        submitConfig.baseForegroundColor = .black
        submitConfig.title = String(localized: "auth.button.submit.title")
        let dateLabel = UILabel()
        dateLabel.text = String(localized: "auth.date.picker.heading")
        dateLabel.font = .preferredFont(forTextStyle: .body)
        let datePickerContainer = UIView()
        datePickerContainer.addManagedSubview(datePicker)
        setupDateContainer(datePickerContainer)
        datePicker.centerXAnchor.constraint(equalTo: datePickerContainer.centerXAnchor).activate()
        datePicker.centerYAnchor.constraint(equalTo: datePickerContainer.centerYAnchor).activate()
        let submitButton = UIButton(configuration: submitConfig, primaryAction: UIAction { [store, datePicker] _ in
            store.dispatch(.submitBirthday(date: datePicker.date))
        })
        let stackView = UIStackView(arrangedSubviews: [dateLabel, datePickerContainer, submitButton])
        view.addManagedSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
        submitButton.heightAnchor.constraint(equalToConstant: 44.0).activate()
        stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 80.0).activate()
        stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).activate()
        stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).activate()
    }

    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = .now
        datePicker.tintColor = .black
        var components = DateComponents()
        components.year = 1900
        components.month = 9
        components.day = 9
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.locale = .autoupdatingCurrent
        datePicker.calendar = .autoupdatingCurrent
        components.timeZone = datePicker.timeZone
        components.calendar = datePicker.calendar
        datePicker.date = Calendar.autoupdatingCurrent.date(from: components) ?? .now
        setDatePickerBackgrond()
        datePicker.addTarget(self, action: #selector(selectDate(_:)), for: .valueChanged)
    }

    private func setupDateContainer(_ datePickerContainer: UIView) {
        datePickerContainer.backgroundColor = .white
        datePickerContainer.layer.cornerCurve = .continuous
        datePickerContainer.layer.cornerRadius = 5.0
        datePickerContainer.layer.masksToBounds = true
    }

    @objc
    private func selectDate(_ datePicker: UIDatePicker) {
        setDatePickerBackgrond()
    }

    private func setDatePickerBackgrond() {
        datePicker.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .white
    }
}
