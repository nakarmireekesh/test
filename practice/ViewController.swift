//
//  ViewController.swift
//  practice
//
//  Created by Reekesh Nakarmi on 2/1/25.
//

import UIKit

class ViewController: UIPageViewController {
    
    // MARK: - Properties
    var questions: [Questions] = []
    var userAnswers: [[String]] = []
    var currentIndex = 0
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.delegate = self
        self.dataSource = self
        
        if let loadedQuestions = DataLoader.loadQuestionsData() {
            questions = loadedQuestions
            userAnswers = Array(repeating: [], count: questions.count)
            
            if let firstQuestionVC = createQuestionViewController(at: 0){
                setViewControllers([firstQuestionVC], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Public
    func createQuestionViewController(at index: Int) -> QuestionsViewController? {
        guard index >= 0 && index < questions.count else { return nil }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let questionVC = storyboard.instantiateViewController(withIdentifier: "QuestionsViewController") as? QuestionsViewController {
            questionVC.question = questions[index]
            questionVC.isLastQuestion = (index == questions.count - 1)
            questionVC.currentQuestionIndex = index
            questionVC.onAnswerSelected = { [weak self] answers in
                self?.userAnswers[index] = answers
            }
            return questionVC
        }
        return nil
    }
    
    func goToNextQuestion() {
        currentIndex += 1
        if currentIndex < questions.count {
            if let nextQuestionVC = createQuestionViewController(at: currentIndex) {
                setViewControllers([nextQuestionVC], direction: .forward, animated: true, completion: nil)
            }
        } else {
            showResults()
        }
    }
    
    func goToPreviousQuestion() {
        currentIndex -= 1
        if currentIndex >= 0 {
            if let previousQuestionVC = createQuestionViewController(at: currentIndex) {
                setViewControllers([previousQuestionVC], direction: .reverse, animated: true, completion: nil)
            }
        }
    }
    
    func showResults() {
        var resultMessage = "Your choices: \n\n"
        for (index, question) in questions.enumerated() {
            resultMessage += "Q: \(question.question)\nA: \(userAnswers[index].joined(separator: ", "))\n\n"
        }
        
        let alert = UIAlertController(title: "Results", message: resultMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Extensions
extension ViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? QuestionsViewController,
              let currentIndex = questions.firstIndex(where: {
                  $0.question == currentVC.question.question
              }) else { return nil }
        
        let previousIndex = currentIndex - 1
        return createQuestionViewController(at: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? QuestionsViewController,
              let currentIndex = questions.firstIndex(where: {
                  $0.question == currentVC.question.question
              }) else { return nil }
        
        let nextIndex = currentIndex + 1
        return createQuestionViewController(at: nextIndex)
    }
}

