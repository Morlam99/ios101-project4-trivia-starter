//
//  Strings+Extensions.swift
//  Trivia
//
//  Created by Morgan Martinez on 7/8/25.
//

import Foundation

extension String {
	var htmlDecoded: String {
		guard let data = self.data(using: .utf8) else { return self }
		let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
			.documentType: NSAttributedString.DocumentType.html,
			.characterEncoding: String.Encoding.utf8.rawValue
		]
		if let attributed = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
			return attributed.string
		}
		return self
	}
}
