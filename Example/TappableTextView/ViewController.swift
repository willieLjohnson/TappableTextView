//
//  ViewController.swift
//  TappableTextView
//
//  Created by SlickJohnson on 05/18/2018.
//  Copyright (c) 2018 SlickJohnson. All rights reserved.
//

import UIKit
import TappableTextView

@available(iOS 10.0, *)
class ViewController: UIViewController {
  var tappableTextView: TappableTextView!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black

    tappableTextView = TappableTextView(frame: view.bounds)
    view.addSubview(tappableTextView)
    tappableTextView.constrain(to: view)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }}

