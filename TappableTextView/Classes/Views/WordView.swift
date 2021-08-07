//
//  WordView.swift
//  TappableTextView
//
//  Created by Willie Johnson on 5/17/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit

protocol WordViewDelegate: AnyObject {
  func closeButtonPressed()
  func wordViewUpdated(_ wordView: WordView)
}

@available(iOS 10.0, *)
public class WordView: NibDesignable {
  @IBOutlet private weak var closeButton: UIButton!
  @IBOutlet private weak var wordLabel: UILabel!
  @IBOutlet private weak var wordImageView: UIImageView!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet private weak var wordDetailsTableView: UITableView!
  @IBInspectable public var color: UIColor = .white {
    willSet {
      updateViews()
    }
  }
  @IBInspectable public var wordText: String? {
    willSet {
      wordLabel?.text = wordText
    }
  }

  public var word: Word? {
    willSet(word) {
      wordText = word?.text
    }
  }

  public var wordMeaningsList = [WordMeaning]() {
    didSet {
      DispatchQueue.main.async {
        self.wordDetailsTableView.reloadData()
      }
    }
  }

  let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

  weak var delegate: WordViewDelegate? {
    didSet {
      guard let delegate = delegate else { return }
      delegate.wordViewUpdated(self)
    }
  }
  weak var highlightView: HighlightView?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  convenience init(highlightView: HighlightView) {
    self.init(frame: highlightView.frame)
    self.highlightView = highlightView
    self.word = highlightView.word
    wordLabel.text = word!.text
    highlightView.tapped = true
    color = highlightView.color
    updateViews()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  @IBAction func closeButtonPressed(_ sender: Any) {
    guard let delegate = delegate else { return }
    delegate.closeButtonPressed()
    dismissAnimation()
  }

  public func getWordText() -> String? {
    return wordText
  }
}

// MARK: Animations
@available(iOS 10.0, *)
extension WordView {
  func expandToSuperview() {
    guard let superview = superview else { return }
    guard let word = word else { return }
    // Prepare view
    frame = CGRect(x: 0, y: 0, width: superview.frame.width, height: superview.frame.height).insetBy(dx: 10, dy: 25)
    center = CGPoint(x: word.rect.midX, y: word.rect.midY)
    transform = .init(scaleX: word.rect.width / frame.width, y: word.rect.height / frame.height)
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.25)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
    // Corner animation
    let cornerAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
    cornerAnimation.fromValue = superview.frame.height / 4
    cornerAnimation.toValue = 8
    layer.cornerRadius = 8
    wordImageView.layer.cornerRadius = 8
    layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))
    wordImageView.layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius))
    // Expand animation
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
      self.impactFeedbackGenerator.impactOccurred()
      self.transform = .identity
      self.center = CGPoint(x: superview.bounds.midX, y: superview.bounds.midY)
    })
    CATransaction.commit()
  }

  func dismissAnimation() {
    guard let superview = superview else { return }
    guard let word = word else { return }
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
      self.transform = .init(scaleX: word.rect.width / self.frame.width, y: word.rect.height / self.frame.height)
      self.center = CGPoint(x: word.rect.midX, y: word.rect.midY)
    }, completion: ({ _ in
      self.removeFromSuperview()
      guard let highlightView = self.highlightView else { return }
      highlightView.dismissAnimation()
    }))
    CATransaction.commit()
  }
}

// MARK: Helper methods
@available(iOS 10.0, *)
private extension WordView {
  func setupView() {
    clipsToBounds = true
    layer.masksToBounds = false
    layer.shadowOpacity = 0.5
    layer.shadowRadius = 4
    layer.shadowOffset = CGSize(width: 2, height: 2)

    wordDetailsTableView.dataSource = self
    wordDetailsTableView.delegate = self
    wordDetailsTableView.estimatedRowHeight = WordDetailsTableViewCell.HEIGHT
    wordDetailsTableView.rowHeight = UITableView.automaticDimension

    wordDetailsTableView.register(WordDetailsTableViewCell.self, forCellReuseIdentifier: "wordCell")

    updateViews()
  }

  func updateViews() {
    wordDetailsTableView.layer.cornerRadius = 10;
    backgroundColor = color
    wordDetailsTableView.backgroundColor = color.darken(0.95)
    wordDetailsTableView.tintColor = color.contrastColor()
    wordDetailsTableView.separatorColor = color.contrastColor()
    wordDetailsTableView.separatorInset = UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 10)

    wordLabel.textColor = color.contrastColor()
    closeButton.backgroundColor = color
    closeButton.setTitleColor(color.opposite(), for: .normal)
    closeButton.layer.cornerRadius = addButton.frame.height / 6
    addButton.backgroundColor = color.opposite()
    addButton.setTitleColor(color, for: .normal)
    addButton.layer.cornerRadius = addButton.frame.height / 6
  }
}

// MARK: UITableViewDataSource
extension WordView: UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return wordMeaningsList.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell") as? WordDetailsTableViewCell else {
      return UITableViewCell()
    }

    cell.wordMeaning = wordMeaningsList[indexPath.row]
    cell.color = color

    return cell
  }
}


// MARK: TableViewDelegate
extension WordView: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let cell = tableView.cellForRow(at: indexPath) as? WordDetailsTableViewCell else { return }
      cell.innerView.animateTap()
  }

  public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
      return true
  }

  public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    UIView.animate(withDuration: 0.2) {
      if let cell = tableView.cellForRow(at: indexPath) as? WordDetailsTableViewCell {
        cell.innerView.animateHighlight(transform: .init(scaleX: 0.95, y: 0.95), offset: 3.5)
      }
    }
  }

  public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
      if let cell = tableView.cellForRow(at: indexPath) as? WordDetailsTableViewCell {
        cell.innerView.animateHighlight(transform: .identity, offset: 4, duration: 0.15)
      }
  }

}
