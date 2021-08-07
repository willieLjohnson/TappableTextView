//
//  WordDetailsTableViewCell.swift
//  TappableTextView
//
//  Created by Willie Johnson on 8/5/21.
//

import UIKit

class WordDetailsTableViewCell: NibDesignableTableViewCell {
  public static let HEIGHT: CGFloat = 250.0

  @IBOutlet weak var innerView: UIView!
  @IBOutlet weak var partOfSpeechLabel: UILabel!
  @IBOutlet weak var wordDetailsTextView: UITextView!

  public var wordMeaning = WordMeaning() {
    willSet(wordMeaning) {
      updateViews()
    }

    didSet(wordMeaning) {
      updateViews()
    }
  }

  @IBInspectable public var color: UIColor = .white {
    willSet(color) {
      updateViews()
    }

    didSet(color) {
      updateViews()
    }
  }

  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  override func layoutSubviews() {
      super.layoutSubviews()
      //set the values for top,left,bottom,right margins
      let margins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
      contentView.frame = contentView.frame.inset(by: margins)
  }
}


// MARK: - Helper methods
@available(iOS 10.0, *)
private extension WordDetailsTableViewCell {
  func setupView() {
    wordDetailsTextView.textContainerInset = UIEdgeInsets(top: partOfSpeechLabel.frame.height + 10, left: 0, bottom: 0, right: 0)
    updateViews()
  }

  func updateViews() {
    backgroundColor = color
    innerView.backgroundColor = color
    wordDetailsTextView.backgroundColor = color
    wordDetailsTextView.textColor = color.contrastColor()
    wordDetailsTextView.tintColor = color.contrastColor()
    partOfSpeechLabel.textColor = color.contrastColor()
    partOfSpeechLabel.tintColor = color.contrastColor()
    layer.shadowColor = color.contrastColor().cgColor
    partOfSpeechLabel.text = wordMeaning.getPartOfSpeech()
    wordDetailsTextView.text = ""
    let textViewAttributedText = NSMutableAttributedString()
    
    for (count, definition) in wordMeaning.getDefintions().enumerated() {
      textViewAttributedText.append(NSMutableAttributedString()
                                      .semiBold("Definition \(count + 1): ")
                                      .normal("\(definition.getDefinition())\n"))

      if definition.getExample() != nil {
        textViewAttributedText.append(NSMutableAttributedString()
                                        .semiBold("\nExample: ")
                                        .normal("\"\(definition.getExample()!)\"\n\n"))
      }


      if definition.getSynonyms() != nil {
        textViewAttributedText.append(NSMutableAttributedString().semiBold("Synonyms: "))
        for synonym in definition.getSynonyms()! {
          textViewAttributedText.append(NSMutableAttributedString().normal("\(synonym), "))
        }

        textViewAttributedText.append(NSMutableAttributedString().normal("\n\n"))
      }
    }
    textViewAttributedText.append(NSMutableAttributedString().normal("\n"))
    wordDetailsTextView.attributedText = textViewAttributedText.withColor(color.contrastColor())

    let fixedWidth = wordDetailsTextView.frame.size.width
    let newSize = wordDetailsTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    wordDetailsTextView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
  }
}
