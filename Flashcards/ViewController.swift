//
//  ViewController.swift
//  Flashcards
//
//  Created by ken on 9/19/22.
//

import UIKit

struct Flashcard{
    var question: String
    var answer: String
}

class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    // Array to hold our flashcards
    var flashcards = [Flashcard]()
    
    //Current flashcard index
    var currentIndex = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Read saved flashcards
        readSavedFlashcards()
        
        
        if flashcards.count == 0 {
            updateFlashcard(question: "What's the capital of Brazil?", answer: "Brasilia")
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        frontLabel.isHidden = true
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        // Decrease current index
        currentIndex = currentIndex - 1
        
        // Update Labels
        updateLabels()
        
        // Update Buttons
        updateNextPrevButtons()
        
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        // Increase current index
        currentIndex = currentIndex + 1
        
        // Update labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
    }
    
    
    func updateFlashcard(question: String, answer: String) {
        let flashcard = Flashcard(question: question, answer: answer)
        frontLabel.text = flashcard.question
        backLabel.text = flashcard.answer
        
        //Adding flashcard in the flashcards array
        flashcards.append(flashcard)
        
        //Logging to the console
        print("Added a new flashcard! Take a look ->", flashcards)
        print("Added new flashcard")
        print("We now have \(flashcards.count) flashcards.")
        
        //Update current index
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        
        //Update buttons
        updateNextPrevButtons()
        
        // Update Labels
        updateLabels()
        
        // Save flashcards
        saveAllFlashcardsToDisk()
    }
    
    func updateNextPrevButtons(){
        
        //Disable next button if at the end
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        // Disable prev button if at the beginning
    }
    
    func updateLabels(){
        
        //Get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        //Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        
    }
    
    func saveAllFlashcardsToDisk(){
        
        //From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer]
        }
        
        //Save array on disk using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        print("Flashcards saved to UserDefaults")
        
    }
    
    func readSavedFlashcards(){
        //Read dictionary array from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            
            // In here we know for sure..
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            //Put all these cards in our flashcards array
            flashcards.append(contentsOf: savedCards)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
    }
}

