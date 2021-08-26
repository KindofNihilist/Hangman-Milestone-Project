//
//  MainMenuViewController.swift
//  Hangman Milestone Project
//
//  Created by Artem Dolbiev on 06.03.2021.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet var startButton: UIButton!
    @IBOutlet var languagePicker: UISegmentedControl!
    
    static var languagePicked = "English"

    override func viewDidLoad() {
        super.viewDidLoad()
        languagePicker.setTitle("ENG", forSegmentAt: 0)
        languagePicker.setTitle("RUS", forSegmentAt: 1)
        languagePicker.setEnabled(true, forSegmentAt: 0)
    }
    
    
    @IBAction func startGame(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gamescreenViewController = storyBoard.instantiateViewController(identifier: "gamescreen") as! ViewController
        gamescreenViewController.modalPresentationStyle = .fullScreen
        show(gamescreenViewController, sender: nil)
    }
    
    @IBAction func changeLanguage(_ sender: UISegmentedControl) {
        
        switch languagePicker.selectedSegmentIndex {
        
        case 0: do {
            MainMenuViewController.languagePicked = "English"
            startButton.setTitle("START GAME", for: .normal)}
        case 1: do {
            MainMenuViewController.languagePicked = "Russian"
            startButton.setTitle("НАЧАТЬ ИГРУ", for: .normal)}
        default: break
        }
    }
}
