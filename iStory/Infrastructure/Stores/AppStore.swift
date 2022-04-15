//
//  AppStore.swift
//  iStory
//
//  Created by Nikola Stojanovic on 9.4.22..
//

import Foundation
import Combine

final class Store<State, Action, Environment>: ObservableObject {

    @Published private(set) var state: State
    private let environment: Environment
    private let reducer: Reducer<State, Action, Environment>
    private var cancellables: Set<AnyCancellable> = []

    init(initialState: State, environment: Environment, reducer: @escaping Reducer<State, Action, Environment>) {
        self.state = initialState
        self.environment = environment
        self.reducer = reducer
    }

    func dispatch(_ action: Action) {
        let sideEffect = reducer(&state, action, environment)
        sideEffect
        // TODO: - Remove dependency on main queue singleton
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: dispatch)
            .store(in: &cancellables)
    }

    func derived<DerivedState: Equatable, ExtractedAction, DerivedEnvironment>(
        deriveState: @escaping (State) -> DerivedState,
        embedAction: @escaping (ExtractedAction) -> Action,
        deriveEnvironment: @escaping (Environment) -> DerivedEnvironment
    ) -> Store<DerivedState, ExtractedAction, DerivedEnvironment> {
        let store = Store<DerivedState, ExtractedAction, DerivedEnvironment>(
            initialState: deriveState(state),
            environment: deriveEnvironment(environment),
            reducer: { _, action, _ in
                self.dispatch(embedAction(action))
                return Empty().eraseToAnyPublisher()
            }
        )
        $state
            .map(deriveState)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &store.$state)
        return store
    }
}
