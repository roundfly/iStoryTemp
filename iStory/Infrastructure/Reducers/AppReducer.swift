//
//  AppReducer.swift
//  iStory
//
//  Created by Nikola Stojanovic on 9.4.22..
//

import Combine

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> AnyPublisher<Action, Never>

typealias AppReducer = Reducer<AppState, AppAction, AppEnvironment>

let appReducer: AppReducer = { state, action, environment in
    switch action {
    case .authentication(let authAction):
        return authReducer(&state.authState, authAction, environment.authentication)
            .map(AppAction.authentication)
            .eraseToAnyPublisher()
    }
}
