//
//  ViewController.swift
//  TappableTextView
//
//  Created by Willie Johnson on 5/4/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit

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
  }
}
