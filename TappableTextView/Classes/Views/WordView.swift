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

  public var images: Images?
  public var currentImage = Image()

  @available(iOS 13.0, *)
  lazy var impactFeedbackGeneratoriOS13 = UIImpactFeedbackGenerator(style: .soft)

  var impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)


  var activityView: UIActivityIndicatorView!
  var nextImageIndex = 0
  var currentImageIndex: Int {
    if self.nextImageIndex == 0 {
      return 0
    }
    return self.nextImageIndex - 1
  }

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
  func openAnimation() {
    guard let word = word else { return }
    expandToSuperview(from: word.rect) {
      if #available(iOS 13.0, *) {
        self.impactFeedbackGenerator.impactOccurred()
      } else {
        // Fallback on earlier versions
      }
    }
  }

  func dismissAnimation() {
    guard let word = word else { return }
    shrinkFromSuperview(to: word.rect) {
      self.removeFromSuperview()
      guard let highlightView = self.highlightView else { return }
      highlightView.dismissAnimation()
    }
  }
}

// MARK: Helper methods - Setup
@available(iOS 10.0, *)
private extension WordView {
  func setupView() {
    clipsToBounds = true
    layer.masksToBounds = false
    layer.shadowOpacity = 0.5
    layer.shadowRadius = 4
    layer.shadowOffset = CGSize(width: 2, height: 2)

    wordLabel.font = Style.boldFont.withSize(20)
    addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)

    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    wordImageView.isUserInteractionEnabled = true
    wordImageView.addGestureRecognizer(tapGestureRecognizer)

    wordImageView.clipsToBounds = true
    activityView = UIActivityIndicatorView(style: .whiteLarge)

    wordDetailsTableView.dataSource = self
    wordDetailsTableView.delegate = self
    wordDetailsTableView.estimatedRowHeight = WordDetailsTableViewCell.HEIGHT
    wordDetailsTableView.rowHeight = UITableView.automaticDimension

    wordDetailsTableView.register(WordDetailsTableViewCell.self, forCellReuseIdentifier: "wordCell")


    self.updateViews()
  }

  func updateViews() {
    wordDetailsTableView.layer.cornerRadius = 10;
    backgroundColor = color
    wordDetailsTableView.backgroundColor = color.darken(0.95)
    wordDetailsTableView.tintColor = color.contrastColor()
    wordDetailsTableView.separatorColor = color.darken(0.8)
    wordDetailsTableView.separatorInset = UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 10)

    wordLabel.textColor = color.contrastColor()
    closeButton.backgroundColor = color
    closeButton.setTitleColor(color.opposite(), for: .normal)
    closeButton.layer.cornerRadius = addButton.frame.height / 6
    addButton.backgroundColor = color.opposite()
    addButton.setTitleColor(color, for: .normal)
    addButton.layer.cornerRadius = addButton.frame.height / 6

    updateImageView()
  }

  @objc private func addButtonPressed() {
    addButton.animateTap(duration: 0.25)
  }

  @objc private func imageTapped() {
    updateImageView()
  }
}

// MARK: Word Image
private extension WordView {
  func updateImageView() {
    startLoadingAnimation()

    if images != nil {
      self.loadNextImage(from: images!)
    } else {
      self.word?.getWordImages(completion: { imagesResult in
        switch imagesResult {
        case let .success(images):
          self.images = images
          self.loadNextImage(from: images)
          self.cacheImages()
        case let .failure(error):
          DispatchQueue.main.async {
            self.stopLoadingAnimation()
            self.wordImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            print(error)
          }
        }
      })
    }

  }

  func startLoadingAnimation() {
    wordImageView.addSubview(activityView)
    activityView.frame = wordImageView.bounds
    activityView.translatesAutoresizingMaskIntoConstraints = false
    activityView.centerXAnchor.constraint(equalTo: wordImageView.centerXAnchor).isActive = true
    activityView.centerYAnchor.constraint(equalTo: wordImageView.centerYAnchor).isActive = true
    activityView.heightAnchor.constraint(equalTo: wordImageView.heightAnchor).isActive = true
    activityView.widthAnchor.constraint(equalTo: wordImageView.widthAnchor).isActive = true
    activityView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.5)

    activityView.startAnimating()
  }

  func stopLoadingAnimation() {
    self.activityView.stopAnimating()
    self.activityView.removeFromSuperview()
  }

  func loadNextImage(from images: Images) {
    if images.results.count == 0 {
      DispatchQueue.main.async {
        self.stopLoadingAnimation()
        self.wordImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
      }
      return
    }
    let nextImage = images.results[nextImageIndex]
    currentImage = nextImage
    nextImageIndex = (nextImageIndex + 1) % images.results.count
    self.wordImageView.loadImage(fromURL: nextImage.urls.regular) { _ in
      self.stopLoadingAnimation()
      self.wordImageView.expandToSuperview(from: self.wordImageView.frame) {
        if #available(iOS 13.0, *) {
          self.impactFeedbackGeneratoriOS13.impactOccurred()
        } else {
          self.impactFeedbackGenerator.impactOccurred()
        }
      }
    }
  }

  func cacheImages() {
    guard let images = images else { return }
    for image in images.results {
      guard let url = URL(string: image.urls.regular) else {
        continue
      }
      UIImage().fromURL(url) { _ in }
    }
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
