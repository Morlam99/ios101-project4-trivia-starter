//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class TriviaViewController: UIViewController {
  
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  
  private var questions = [TriviaQuestion]()
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    questionContainerView.layer.cornerRadius = 8.0
    // TODO: FETCH TRIVIA QUESTIONS HERE
	  TriviaQuestionService.fetchData(amount: 5) { [weak self] fetchedQuestions in
		  guard let self = self else { return }
		  self.questions = fetchedQuestions
		  self.currQuestionIndex = 0
		  self.numCorrectQuestions = 0
		  if !self.questions.isEmpty {
			  self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
		  } else {
			  print("No questions were fetched.")
		  }
	  }

  }
  
	private func updateQuestion(withQuestionIndex questionIndex: Int) {
		currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
		let question = questions[questionIndex]
		questionLabel.text = question.question.htmlDecoded
		categoryLabel.text = question.category.htmlDecoded

		let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
		let buttons = [answerButton0, answerButton1, answerButton2, answerButton3]

		for (index, button) in buttons.enumerated() {
			if index < answers.count {
				button?.setTitle(answers[index].htmlDecoded, for: .normal)
				button?.isHidden = false
			} else {
				button?.isHidden = true
			}
		}
	}

  
	private func updateToNextQuestion(answer: String) {
		if isCorrectAnswer(answer) {
			let alert = UIAlertController(
				title: "Correct!",
				message: "You have: \(numCorrectQuestions + 1)/\(questions.count) correct answers",
				preferredStyle: .alert
			)
			
			let okAction = UIAlertAction(title: "Next", style: .default) { [weak self] _ in
				guard let self = self else { return }
				self.numCorrectQuestions += 1
				self.advanceToNextQuestion()
			}
			
			alert.addAction(okAction)
			present(alert, animated: true, completion: nil)
			
		} else {
			let alert = UIAlertController(
				title: "Incorrect",
				message: "The correct answer was: \(questions[currQuestionIndex].correctAnswer)",
				preferredStyle: .alert
			)
			
			let okAction = UIAlertAction(title: "Next", style: .default) { [weak self] _ in
				self?.advanceToNextQuestion()
			}
			
			alert.addAction(okAction)
			present(alert, animated: true, completion: nil)
		}
	}

	private func advanceToNextQuestion() {
		currQuestionIndex += 1
		guard currQuestionIndex < questions.count else {
			showFinalScore()
			return
		}
		updateQuestion(withQuestionIndex: currQuestionIndex)
	}
  
  private func isCorrectAnswer(_ answer: String) -> Bool {
    return answer == questions[currQuestionIndex].correctAnswer
  }
  
	private func showFinalScore() {
		let alertController = UIAlertController(
			title: "Game Over!",
			message: "Final score: \(numCorrectQuestions)/\(questions.count)",
			preferredStyle: .alert
		)

		let resetAction = UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
			self?.fetchNewQuestions()
		}

		alertController.addAction(resetAction)
		present(alertController, animated: true, completion: nil)
	}

  
	private func fetchNewQuestions() {
		TriviaQuestionService.fetchData(amount: 5) { [weak self] fetchedQuestions in
			guard let self = self else { return }
			self.questions = fetchedQuestions
			self.currQuestionIndex = 0
			self.numCorrectQuestions = 0
			if !self.questions.isEmpty {
				self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
			} else {
				print("No new questions were fetched.")
			}
		}
	}

  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
}

