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
    view.constrain(to: tappableTextView)
    tappableTextView.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension ViewController: TappableTextViewDelegate {
  func highlightViewTapped(view: HighlightView) {
    let wordViewController = HighlightViewController(nibName: nil, bundle: nil)
//    wordViewController.modalPresentationStyle = .
//    wordViewController.providesPresentationContextTransitionStyle = true
//    wordViewController.definesPresentationContext = true
//    wordViewController.modalPresentationStyle = .overCurrentContext
//    wordViewController.modalTransitionStyle = .crossDissolve
    present(wordViewController, animated: true, completion: nil)
  }
}
