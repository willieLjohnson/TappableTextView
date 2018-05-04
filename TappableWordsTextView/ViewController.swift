//
//  ViewController.swift
//  TappableWordsTextView
//
//  Created by Willie Johnson on 5/4/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var tappableTextView: TappableWordsTextView!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black

    tappableTextView = TappableWordsTextView(frame: view.bounds.insetBy(dx: 50, dy: 50))
    tappableTextView.backgroundColor = .gray
    view.addSubview(tappableTextView)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
