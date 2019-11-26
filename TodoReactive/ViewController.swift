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


