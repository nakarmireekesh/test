//
//  QuestionsViewController.swift
//  practice
//
//  Created by Reekesh Nakarmi on 2/1/25.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var questionsLabel: UILabel!
    @IBOutlet weak var optionsStackView: UIStackView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var question: Questions!
    var selectedAnswers: [String] = []
    var onAnswerSelected: (([String]) -> Void)?
    var isLastQuestion: Bool = false {
        didSet {
            updateButtonState()
        }
    }
    var currentQuestionIndex: Int = 0 {
        didSet {
            updateButtonState()
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        updateButtonState()
    }
    
    // MARK: - Public
    func setupUI() {
        questionsLabel.text = question.question
        
        // Clearing previous options
        optionsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        // Fetch stored answers
        if let pageVC = parent as? ViewController {
            selectedAnswers = pageVC.userAnswers[currentQuestionIndex]
        }
        
        for option in question.options {
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemBlue.cgColor
            button.setTitleColor(.systemBlue, for: .normal)
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            if selectedAnswers.contains(option) {
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
            }
            
            optionsStackView.addArrangedSubview(button)
        }
    }
    
    // Option Selection
    @objc func optionSelected(_ sender: UIButton) {
        guard let selectedAnswer = sender.titleLabel?.text else { return }
        
        if question.isMultiSelect {
            if selectedAnswers.contains(selectedAnswer) {
                selectedAnswers.removeAll { $0 == selectedAnswer }
                sender.backgroundColor = .clear
                sender.setTitleColor(.systemBlue, for: .normal)
            } else {
                selectedAnswers.append(selectedAnswer)
                sender.backgroundColor = .systemBlue
                sender.setTitleColor(.white, for: .normal)
                
            }
        } else {
            selectedAnswers = [selectedAnswer]
            optionsStackView.arrangedSubviews.forEach { view in
                if let button = view as? UIButton {
                    button.backgroundColor = (button == sender) ? .systemBlue : .clear
                    button.setTitleColor((button == sender) ? .white : .systemBlue, for: .normal)
                }
            }
        }
        
        onAnswerSelected?(selectedAnswers)
    }
    
    func updateButtonState() {
        guard isViewLoaded else { return }
        backButton.isHidden = (currentQuestionIndex == 0)
        nextButton.setTitle(isLastQuestion ? "Submit" : "Next", for: .normal)
        
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if let pageVC = parent as? ViewController {
            if isLastQuestion {
                pageVC.showResults()
            } else {
                pageVC.goToNextQuestion()
            }
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if let pageVC = parent as? ViewController {
            pageVC.goToPreviousQuestion()
        }
    }
}
