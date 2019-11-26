//
//  ViewController.swift
//  TodoReactive
//
//  Created by Saravanakumar Selladurai on 26/11/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import UIKit
import ReactiveSwift

class ViewController: BaseViewController<TodoViewModel> {
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func refresh(_ state: TodoViewModel.State) {
        label.isHidden = state.shouldHideLabel
    }
    
    @IBAction func testTapped() {
        send?(.buttonTapped)
    }
}

protocol View {
    associatedtype State
    associatedtype Action

    func refresh(_ state: State)
}

class BaseViewController<ViewModel: BaseViewModel>: UIViewController, View {
    typealias State = ViewModel.State
    typealias Action = ViewModel.Action

    var viewModel: ViewModel?
    var send: ((Action) -> Void)?

    func refresh(_ state: ViewModel.State) {}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let state = viewModel?.state else { return }

        send = { [weak viewModel] in viewModel?.send(action: $0) }

        SignalProducer(state)
            .observe(on: UIScheduler())
            .startWithValues { [weak self](state) in
                guard let self = self else { return }
                self.refresh(state)
        }
    }
}
