//
//  ViewController.swift
//  Twittermenti
//
//  Created by Nishant Taneja on 13/09/20.
//  Copyright © 2020 Nishant Taneja. All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {
    //MARK:- IBOutlets|IBAction
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBAction func predictButtonPressed(_ sender: UIButton) {fetchTweets()}
    //MARK:- Initialise
    let sentimentClassifier = TweetSentimentClassifier()
    let swifter = Swifter(consumerKey: PrivateData.apiKey, consumerSecret: PrivateData.apkiKeySecret)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }
    
    //MARK:- Fetch Tweets
    /// This method fetches 100 latest tweets about the provided search string.
    fileprivate func fetchTweets() {
        if let searchText = textField.text {
            swifter.searchTweet(using: searchText, lang: "en", count: 100, tweetMode: .extended, success: { (results, metadata) in
                var tweets = [TweetSentimentClassifierInput]()
                for i in 0..<100 {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                self.predict(tweets)
            }) { (error) in
                print("error in API Request \(error)")
            }
        }
    }
    
    //MARK:- Predict Sentiments
    /// This method predicts the sentiments of fetched tweets.
    private func predict(_ tweets: [TweetSentimentClassifierInput]) {
        do {
            let predictions = try sentimentClassifier.predictions(inputs: tweets)
            var sentimentScore = 0
            for prediction in predictions {
                let sentiment = prediction.label
                if sentiment == "Pos" {sentimentScore += 1}
                else if sentiment == "Neg" {sentimentScore -= 1}
            }
            updateUI(with: sentimentScore)
        } catch {print(error)}
    }
    //MARK:- Display Sentiment
    /// This method updates the UI according to the overall prediction of sentiments.
    private func updateUI(with score: Int) {
        if score > 20 {sentimentLabel.text = "😍"}
        else if score > 10 {sentimentLabel.text = "😀"}
        else if score > 0 {sentimentLabel.text = "🙂"}
        else if score == 0 {sentimentLabel.text = "😐"}
        else if score > -10 {sentimentLabel.text = "😕"}
        else if score > -20 {sentimentLabel.text = "😡"}
        else {sentimentLabel.text = "🤮"}
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fetchTweets()
        textField.resignFirstResponder()
        return true
    }
}
