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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var indicatorBar: UIProgressView!
    
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
    }
    
    // MARK: - Public
    func setupUI() {
        questionsLabel.text = question.question
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        // Fetch stored answers
        if let pageVC = parent as? ViewController {
            selectedAnswers = pageVC.userAnswers[currentQuestionIndex]
        }
        updateProgress()
        updateButtonState()
    }
    
    func updateProgress() {
        let totalQuestions = (parent as? ViewController)?.questions.count ?? 1
        let progress = Float(currentQuestionIndex + 1) / Float(totalQuestions)
        indicatorBar.setProgress(progress, animated: true)
    }
    
    func updateButtonState() {
        guard isViewLoaded else { return }
        backButton.isHidden = (currentQuestionIndex == 0)
        nextButton.setTitle(isLastQuestion ? "Submit" : "Next", for: .normal)
        
        self.nextButton.isEnabled = !self.selectedAnswers.isEmpty
        self.nextButton.alpha = self.selectedAnswers.isEmpty ? 1.0 : 1.0
    }
    
    // MARK: - IBActions
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

// MARK: - Extension
extension QuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OptionsTableViewCell
        let option = question.options[indexPath.row]
        
        cell.optionsTextLabel.text = option
        
        if selectedAnswers.contains(option) {
            cell.backgroundColor = .systemBlue
            cell.optionsTextLabel.textColor = .white
        } else {
            cell.backgroundColor = .clear
            cell.optionsTextLabel.textColor = .systemBlue
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = question.options[indexPath.row]
        
        if question.isMultiSelect {
            if selectedAnswers.contains(selectedOption) {
                selectedAnswers.removeAll { $0 == selectedOption }
            } else {
                selectedAnswers.append(selectedOption)
            }
        } else {
            selectedAnswers = [selectedOption]
        }
        
        onAnswerSelected?(selectedAnswers)
        updateButtonState()
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
