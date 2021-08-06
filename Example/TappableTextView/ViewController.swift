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
  var ipsum: String = """
The field of articulatory phonetics is a subfield of phonetics that studies articulation and ways that humans produce speech. Articulatory phoneticians explain how humans produce speech sounds via the interaction of different physiological structures. Generally, articulatory phonetics is concerned with the transformation of aerodynamic energy into acoustic energy. Aerodynamic energy refers to the airflow through the vocal tract. Its potential form is air pressure; its kinetic form is the actual dynamic airflow. Acoustic energy is variation in the air pressure that can be represented as sound waves, which are then perceived by the human auditory system as sound.[1]. Sound is produced simply by expelling air from the lungs. However, to vary the sound quality in a way useful for speaking, two speech organs normally move towards each other to contact each other to create an obstruction that shapes the air in a particular fashion. The point of maximum obstruction is called the place of articulation, and the way the obstruction forms and releases is the manner of articulation. For example, when making a p sound, the lips come together tightly, blocking the air momentarily and causing a buildup of air pressure. The lips then release suddenly, causing a burst of sound. The place of articulation of this sound is therefore called bilabial, and the manner is called stop (also known as a plosive).
"""
  override func viewDidLoad() {
    super.viewDidLoad()
    tappableTextView = TappableTextView(frame: view.frame, color: .white)
    tappableTextView.setDelegate(self);

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
  func wordViewUpdated(_ wordView: WordView) {
    guard let word = wordView.word else { return }

    word.getWordMeaning(word: word) { meanings in

      for meaning in meanings {
        DispatchQueue.main.async {
          wordView.wordMeaningsList.append(WordMeaning(decodable: meaning))
        }
      }
    };
  }

  func wordViewOpened(_ wordView: WordView) {
    guard let wordView = tappableTextView.wordView else { return }
    print(wordView)
  }

  func wordViewClosed(_ wordView: WordView) {
    return
  }
}

