//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

class TriviaQuestionService {
	static func fetchData(amount: Int,
						  completion: (([TriviaQuestion]) -> Void)? = nil) {
		let parameters = "amount\(amount)"
		let url = "https://opentdb.com/api.php?amount=\(amount)&type=multiple"
		guard let url = URL(string: url) else { return }
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			// this closure is fired when the response is received
			guard error == nil else {
				assertionFailure("Error: \(error!.localizedDescription)")
				return
			}
			guard let httpResponse = response as? HTTPURLResponse else {
				assertionFailure("Invalid response")
				return
			}
			guard let data = data, httpResponse.statusCode == 200 else {
				assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
				return
			}
			let decoder = JSONDecoder()
			do {
				let response = try decoder.decode(TriviaAPIResponse.self, from: data)
				DispatchQueue.main.async {
					completion?(response.results)
				}
			} catch {
				print("Decoding error:", error)
			}
			}
		task.resume() // resume the task and fire the request
	}

}

	
struct TriviaQuestion: Decodable {
	let category: String
	let question: String
	let correctAnswer: String
	let incorrectAnswers: [String]
	
	private enum CodingKeys: String, CodingKey {
		case category
		case question
		case correctAnswer = "correct_answer"
		case incorrectAnswers = "incorrect_answers"
	}
}

	
	struct TriviaAPIResponse: Decodable {
		let results: [TriviaQuestion]
		private enum CodingKeys: String, CodingKey {
			case results = "results"
		}
	}

