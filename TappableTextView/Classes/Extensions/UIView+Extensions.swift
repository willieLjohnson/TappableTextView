//
//  UIView+Extensions.swift
//  TappableTextView
//
//  Created by Willie Johnson on 5/4/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 10.0, *)
extension UIView {
  public func constrain<U: UIView>(to baseView: U, padding: UIEdgeInsets = .zero) {
    anchor(top: baseView.topAnchor, leading: baseView.leadingAnchor, bottom: baseView.bottomAnchor, trailing: baseView.trailingAnchor, padding: padding)
  }

  public func constrainToSafeArea<U: UIView>(of baseView: U) {
    anchor(top: baseView.safeAreaLayoutGuide.topAnchor, leading: baseView.safeAreaLayoutGuide.leadingAnchor, bottom: baseView.safeAreaLayoutGuide.bottomAnchor, trailing: baseView.safeAreaLayoutGuide.trailingAnchor)
  }

  public func anchor(top: NSLayoutYAxisAnchor, leading: NSLayoutXAxisAnchor, bottom: NSLayoutYAxisAnchor, trailing: NSLayoutXAxisAnchor, padding: UIEdgeInsets = .zero) {
    translatesAutoresizingMaskIntoConstraints = false

    topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
    leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
    bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
    trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
  }

  func loadNib<T: UIView>(viewType: T.Type) -> T {
    let selfDescription = String(describing: type(of: self))
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: selfDescription, bundle: bundle)
    let nibView = nib.instantiate(
      withOwner: self,
      options: nil
      ).first as! T
    return nibView
  }

  // Load Xib Components
  func setupXib() {
    // Load Nib from Bundle
    let bundle = Bundle(for: type(of: self))
    bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
  }
}
