//
//  ViewController.swift
//  Hangman Milestone Project
//
//  Created by Artem Dolbiev on 04.03.2021.
//

import UIKit

class ViewController: UIViewController {
    var words = [String]()
    var word: String!
    var filename = "hangmaneng"
    var isHintPreviouslyRequested = false
    var triesTitle = ""
    var winTitle = ""
    var winMessage = ""
    var gameoverTitle = ""
    var gameoverMessage = ""
    var restartButtonText = ""
    var tries = 0 {
        didSet {
            triesCount.text = "\(triesTitle) \(tries)"
            if tries == 0 {
                gameoverAlert()
            }
        }
    }
    var wordLetters = [Character]() {
        didSet {
            currentWord.text = String(wordLetters)
            if String(wordLetters) == word {
                youWinAlert()
            }
        }
    }
    
    var alphabet = ""
    var triesCount: UILabel!
    var currentWord: UILabel!
    var hintButton: UIButton!
    var restartButton: UIButton!
    var letterButtons = [UIButton]()
   
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.systemBackground

        triesCount = UILabel()
        triesCount.translatesAutoresizingMaskIntoConstraints = false
        triesCount.textAlignment = .right
        triesCount.font = UIFont.systemFont(ofSize: 20)
        triesCount.textColor = UIColor.label
        view.addSubview(triesCount)
        
        hintButton = UIButton(type: .system)
        hintButton.translatesAutoresizingMaskIntoConstraints = false
        hintButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        hintButton.setTitleColor(.label, for: .normal)
        hintButton.addTarget(self, action: #selector(hintRequested), for: .touchUpInside)
        view.addSubview(hintButton)
        
        
        restartButton = UIButton(type: .system)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        restartButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        restartButton.setTitleColor(.label, for: .normal)
        view.addSubview(restartButton)
        
        
        currentWord = UILabel()
        currentWord.translatesAutoresizingMaskIntoConstraints = false
        currentWord.font = UIFont.systemFont(ofSize: 40)
        currentWord.textAlignment = .center
        currentWord.textColor = UIColor.label
        view.addSubview(currentWord)
        
        if  MainMenuViewController.languagePicked == "Russian" {
            hintButton.setTitle("Подсказка", for: .normal)
            restartButton.setTitle("Заново", for: .normal)
            triesTitle = "Попыток:"
            winTitle = "Поздравляем!"
            winMessage = "Вы угадали слово!"
            gameoverTitle = "Игра окончена"
            gameoverMessage = "Вы использовали все попытки."
            restartButtonText = "Заново"
            filename = "hangmanrus"
            alphabet = "А Б В Г Д Е Ё Ж З И Й К Л М Н О П Р С Т У Ф Х Ц Ч Ш Щ Ъ Ы Ь Э Ю Я"
        } else if MainMenuViewController.languagePicked == "English" {
            hintButton.setTitle("Hint", for: .normal)
            restartButton.setTitle("Retry", for: .normal)
            triesTitle = "Tries:"
            winTitle = "Congratulations"
            winMessage = "You guessed the word"
            gameoverTitle = "Game Over"
            gameoverMessage = "You ran out of tries"
            restartButtonText = "Restart"
            filename = "hangmaneng"
            alphabet = "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
        }
        
        let letterButtonsView = UIView()
        letterButtonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(letterButtonsView)
        
        NSLayoutConstraint.activate([
            triesCount.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 15),
            triesCount.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            restartButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            restartButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            hintButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            hintButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            currentWord.topAnchor.constraint(equalTo: triesCount.bottomAnchor, constant: 100),
            currentWord.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            currentWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            letterButtonsView.topAnchor.constraint(equalTo: currentWord.bottomAnchor, constant: 110),
            letterButtonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 10),
            letterButtonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            letterButtonsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            letterButtonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
        func constructKeyboard(forAlphabet alphabet: String) {
            let alphabetArray = alphabet.components(separatedBy: " ")
            var numberOfRows: Int
            var columnX: Int
            var rowY: Int
            var column = 0
            var row = 0
           
            if alphabetArray.count == 26 {
                numberOfRows = 4
                columnX = 90
                rowY = 50
            } else {
                numberOfRows = 5
                columnX = 68
                rowY = 50
            }
            
            for (index, letter) in alphabetArray.enumerated() {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
                letterButton.setTitle(String(letter), for: .normal)
                letterButton.setTitleColor(.label, for: .normal)
                letterButton.setTitleColor(.lightGray, for: .disabled)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                let frame = CGRect(x: column * columnX, y: row * rowY, width: 70, height: 44)
                letterButton.frame = frame
                letterButtons.append(letterButton)
                letterButtonsView.addSubview(letterButton)
                column += 1
                if (index + 1) % numberOfRows == 0 {
                    row += 1
                    column = 0
                }
            }
        }
        constructKeyboard(forAlphabet: alphabet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWords()
        startGame()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @objc func loadWords() {
        if let wordList = Bundle.main.url(forResource: "\(filename)", withExtension: "txt") {
            if let wordsArray = try? String(contentsOf: wordList) {
                words = wordsArray.components(separatedBy: "\n")
            }
        }
    }
    
    
    @objc func startGame(action: UIAlertAction! = nil) {
        isHintPreviouslyRequested = false
        self.wordLetters = [Character]()
        self.words.shuffle()
        self.word = self.words.randomElement()
        if let word = self.word {
            self.tries = word.count
            for _ in word {
                self.wordLetters.append("_")
            }
            print(word)
        }
        for button in letterButtons {
            button.isEnabled = true
        }
        DispatchQueue.main.async {
            self.currentWord.text = String(self.wordLetters)
        }
    }
    
    
    @objc func letterTapped(_ sender: UIButton) {
        let chosenLetter = Character((sender.titleLabel?.text?.lowercased())!)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        if word.contains(chosenLetter) {
            for (index, char) in word.enumerated() {
                if char == chosenLetter {
                    wordLetters[index] = chosenLetter
                    sender.isEnabled = false
                }
            }
        } else {
            generator.notificationOccurred(.warning)
            tries -= 1
            sender.isEnabled = false
            shakeOnError(label: currentWord)
        }
    }
    
    @objc func hintRequested() {
        if isHintPreviouslyRequested == false {
            let randomLetter = Array(word).randomElement()
            for (index, char) in word.enumerated() {
                if char == randomLetter {
                    wordLetters[index] = randomLetter!
                }
            }
        } else { return }
        isHintPreviouslyRequested = true
    }
    
    func youWinAlert(){
        let youwinAC = UIAlertController(title: winTitle, message: winMessage, preferredStyle: .alert)
        youwinAC.addAction(UIAlertAction(title: restartButtonText, style: .default, handler: startGame))
        present(youwinAC, animated: true)
    }
    
    func gameoverAlert() {
        let gameoverAC = UIAlertController(title: gameoverTitle, message: gameoverMessage, preferredStyle: .alert)
        gameoverAC.addAction(UIAlertAction(title: restartButtonText, style: .default, handler: startGame))
        present(gameoverAC, animated: true)
    }
    
    func shakeOnError(label: UILabel) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: label.center.x - 10, y: label.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: label.center.x + 10, y: label.center.y))
        label.layer.add(animation, forKey: "position")
        
        
//        UIView.animate(withDuration: 1, delay: 0, options:[.repeat, .autoreverse], animations: {
//            label.textColor = UIColor.red
//        })
    }
    
}


