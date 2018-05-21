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
    view.backgroundColor = .white
    tappableTextView = TappableTextView(frame: view.bounds, color: .white)
    view.addSubview(tappableTextView)
    tappableTextView.constrainToSafeArea(of: view)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }}

