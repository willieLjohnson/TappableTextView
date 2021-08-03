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
  /// Demo paragraph string. 
  var ipsum: String = "\nLorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.\n"
  override func viewDidLoad() {
    super.viewDidLoad()
    tappableTextView = TappableTextView(frame: view.frame, color: .black)
    tappableTextView.delegate = self;

    tappableTextView.text = ""
    for _ in 0..<10 {
      tappableTextView.text?.append(ipsum)
    }
    view.addSubview(tappableTextView)
    tappableTextView.constrainToSafeArea(of: view)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

@available(iOS 10.0, *)
extension ViewController: TappableTextViewDelegate {
  func wordViewOpened()
  func wordViewClosed()
}

