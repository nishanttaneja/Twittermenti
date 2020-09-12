#  Twittermenti
An iOS Application to analyse sentiment of tweets.

This application fetches latest tweets regarding the provided search string as a Hashtag or Username, then analyses sentiment of tweets and displays the overall sentiment.

## Screenshots

## Technologies

## DIY
- <a href=""> Download Training Data </a>
- Create TweetSentimentClassifier MLModel

            import Cocoa
            import CreateML

            let trainingData = try MLDataTable(contentsOf: URL(fileURLWithPath: "<full_path_to_training_data>"))
            let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")
            let metadata = MLModelMetadata(author: "<username>", shortDescription: "A model trained to classify sentiment of tweets", version: "1.0")
            try sentimentClassifier.write(toFile: "<path_to_save_mlmodel>")

- Move MLModel to project's root directory and add reference (drag and drop MLModel to project).
- 
