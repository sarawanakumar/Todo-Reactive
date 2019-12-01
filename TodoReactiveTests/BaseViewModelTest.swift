//
//  TodoReactiveTests.swift
//  TodoReactiveTests
//
//  Created by Saravanakumar Selladurai on 26/11/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import XCTest
@testable import TodoReactive
import ReactiveSwift

class BaseViewModelTest: XCTestCase {

    func perform<ViewModel: BaseViewModel>(
        stub: (TestScheduler) -> ViewModel,
        when: (ViewModel, TestScheduler) -> Void,
        assert: ([ViewModel.State]) -> Void
    ) {
        let scheduler = TestScheduler()
        let viewModel = stub(scheduler)
        var states = [ViewModel.State]()

        viewModel.state.producer.startWithValues { (state) in
            states.append(state)
        }
        when(viewModel, scheduler)
        assert(states)
    }

}
