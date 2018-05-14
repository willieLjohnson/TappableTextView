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
    tappableTextView.translatesAutoresizingMaskIntoConstraints = false
    tappableTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    tappableTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    tappableTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    tappableTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
