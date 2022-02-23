//
//  EditNotesCell.swift
//  Today
//
//  Created by Valentin Purrucker on 20.02.22.
//

import Foundation
import UIKit
class EditNotesCell: UITableViewCell {
	
	typealias NotesChangeAction = (String) -> Void
	
	private var notesChangeAction: NotesChangeAction?
	
	@IBOutlet var notesTextView: UITextView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		notesTextView.delegate = self
	}
	
	func configure(notesText: String?, notesChangeAction: @escaping NotesChangeAction) {
		notesTextView.text = notesText ?? ""
		self.notesChangeAction = notesChangeAction
	}
}

extension EditNotesCell: UITextViewDelegate {
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if let original = textView.text {
			let notes = (original as NSString).replacingCharacters(in: range, with: text)
			self.notesChangeAction?(notes)
		}
		return true
	}
}
