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
  /// Constrains the current UIView to the given view with provided padding.
  ///
  /// Parameters:
  ///   - baseView: The view that acts as the container.
  ///   - padding: The amount of padding to surround the view with.
  public func constrain<U: UIView>(to baseView: U, padding: UIEdgeInsets = .zero) {
    anchor(top: baseView.topAnchor, leading: baseView.leadingAnchor, bottom: baseView.bottomAnchor, trailing: baseView.trailingAnchor, padding: padding)
  }

  /// Constrains the current UIView to the given view's safe area with the given padding.
  ///
  /// Parameters:
  ///   - baseView: The view that acts as the container.
  ///   - padding: The amount of padding to surround the view with.
  public func constrainToSafeArea<U: UIView>(of baseView: U, padding: UIEdgeInsets = .zero) {
    anchor(top: baseView.safeAreaLayoutGuide.topAnchor, leading: baseView.safeAreaLayoutGuide.leadingAnchor, bottom: baseView.safeAreaLayoutGuide.bottomAnchor, trailing: baseView.safeAreaLayoutGuide.trailingAnchor, padding: padding)
  }

  /// Constrains the current UIView to the provided layout anchors.
  ///
  /// Parameters:
  ///   - top: The Y axis anchor that this view's top anchor will be constrained to.
  ///   - leading: The X axis anchor that this view's leading anchor will be constrained to.
  ///   - bottom: The Y axis anchor that this view's bottom anchor will be constrained to.
  ///   - trailing: The X axis anchor that this view's trailing anchor will be constrained to.
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


// MARK: Tap to dismiss keyboard gesture
extension UIView {
  /// Add the tap to dismiss gesture to the current view
  func addTapToDismissKeyboardGesture() {
    let tapToDismissGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing(_:)))
    addGestureRecognizer(tapToDismissGesture)
  }

  /// Adds a shadow beneath the view
  func addDropShadow() {
    layer.shadowColor = Style.shadowColor
    layer.shadowOpacity = 1
    layer.shadowRadius = 4
    layer.shadowOffset = CGSize(width: 0, height: 4)
    layer.masksToBounds = false
  }

  /// The animation used for all tapable views.
  func animateTap(duration: TimeInterval = 0.1) {
    UIView.animate(withDuration: duration * 0.25, animations: {
      self.transform = .init(scaleX: 0.9, y: 0.9)
      self.layer.shadowOffset = CGSize(width: 0, height: 2)
      self.layer.shadowRadius = 2
    }) { _ in
      UIView.animate(withDuration: duration * 0.75, animations: {
        self.transform = .init(scaleX: 1.05, y: 1.05)
        self.layer.shadowOffset = CGSize(width: 0, height: 6)
        self.layer.shadowRadius = 6
      }) { _ in
        UIView.animate(withDuration: duration * 0.6, animations: {
          self.transform = .identity
          self.layer.shadowOffset = CGSize(width: 0, height: 4)
          self.layer.shadowRadius = 4
        })
      }

    }
  }

  func animateDoneLoading(duration: TimeInterval = 0.1) {
    UIView.animate(withDuration: duration * 0.25, animations: {
      self.transform = .init(scaleX: 0.95, y: 0.95)
      self.layer.shadowOffset = CGSize(width: 0, height: 2)
      self.layer.shadowRadius = 2
    }) { _ in
      UIView.animate(withDuration: duration * 0.75, animations: {
        self.transform = .init(scaleX: 1.02, y: 1.02)
        self.layer.shadowOffset = CGSize(width: 0, height: 6)
        self.layer.shadowRadius = 6
      }) { _ in
        UIView.animate(withDuration: duration * 0.6, animations: {
          self.transform = .identity
          self.layer.shadowOffset = CGSize(width: 0, height: 4)
          self.layer.shadowRadius = 4
        })
      }

    }
  }

  /// The highlight animation used for all highlitable views.
  func animateHighlight(transform: CGAffineTransform, offset: CGFloat, duration: TimeInterval = 0.1) {
    UIView.animate(withDuration: duration) {
      self.transform = transform
      self.layer.shadowOffset = CGSize(width: 0, height: offset)
      self.layer.shadowRadius = offset
    }
  }

  func expandToSuperview(from fromRect: CGRect, completion: @escaping () -> ()) {
    guard let superview = superview else { return }
    // Prepare view
    frame = CGRect(x: 0, y: 0, width: superview.frame.width, height: superview.frame.height).insetBy(dx: 10, dy: 5)
    center = CGPoint(x: fromRect.midX, y: fromRect.midY)
    transform = .init(scaleX: fromRect.width / frame.width, y: fromRect.height / frame.height)
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.25)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
    // Corner animation
    let cornerAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
    cornerAnimation.fromValue = superview.frame.height / 4
    cornerAnimation.toValue = 8
    layer.cornerRadius = 8
    self.layer.cornerRadius = 8
    layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))
    self.layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))
    // Expand animation
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
      self.transform = .identity
      self.center = CGPoint(x: superview.bounds.midX, y: superview.bounds.midY)
      completion()
    })
    CATransaction.commit()
  }

  func expandToView(view: UIView, from fromRect: CGRect, completion: @escaping () -> ()) {
    // Prepare view
    view.addSubview(self)
    frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height).insetBy(dx: 10, dy: 5)
    center = CGPoint(x: fromRect.midX, y: fromRect.midY)
    transform = .init(scaleX: fromRect.width / frame.width, y: fromRect.height / frame.height)
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.25)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
    // Corner animation
    let cornerAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
    cornerAnimation.fromValue = view.frame.height / 4
    cornerAnimation.toValue = 8
    layer.cornerRadius = 8
    self.layer.cornerRadius = 8
    layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))
    self.layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))
    // Expand animation
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
      self.transform = .identity
      self.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
      completion()
    })
    CATransaction.commit()
  }




  func shrinkFromSuperview(to toRect: CGRect, completion: @escaping () -> ()) {
    guard let superview = superview else { return }

    superview.sendSubviewToBack(self)
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.2)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))

    // Layer animations
    let cornerAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
    cornerAnimation.fromValue = layer.cornerRadius
    cornerAnimation.toValue = frame.height / 2
    layer.cornerRadius = frame.height / 2
    layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
      self.transform = .init(scaleX: toRect.width / self.frame.width, y: toRect.height / self.frame.height)
      self.center = CGPoint(x: toRect.midX, y: toRect.midY)
    }, completion: ({ _ in
      completion()
    }))
    CATransaction.commit()
  }
}
