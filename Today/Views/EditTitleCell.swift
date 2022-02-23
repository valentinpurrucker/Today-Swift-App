//
//  EditTitleCell.swift
//  Today
//
//  Created by Valentin Purrucker on 20.02.22.
//

import Foundation
import UIKit

class EditTitleCell: UITableViewCell {
	
	typealias TitleChangeAction = (String) -> Void
	
	private var titleChangeAction: TitleChangeAction?
	
	@IBOutlet var titleTextField: UITextField!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		titleTextField.delegate = self
	}
	
	func configure(title: String, titleChangeAction: @escaping TitleChangeAction) {
		self.titleTextField.text = title
		self.titleChangeAction = titleChangeAction
	}
}

extension EditTitleCell: UITextFieldDelegate {
	func textField(_ textField: UITextField,
				   shouldChangeCharactersIn range: NSRange,
				   replacementString string: String) -> Bool {
		if let original = textField.text {
			let title = (original as NSString).replacingCharacters(in: range, with: string)
			self.titleChangeAction?(title)
		}
		return true
	}
}
