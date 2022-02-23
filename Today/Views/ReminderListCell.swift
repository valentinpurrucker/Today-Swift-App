//
//  ReminderListCell.swift
//  Today
//
//  Created by Valentin Purrucker on 18.02.22.
//

import UIKit

class ReminderListCell: UITableViewCell {
	
	typealias DoneButtonAction = () -> Void
	
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var dateLabel: UILabel!
	
	@IBOutlet var doneButton: UIButton!
	
	private var doneButtonAction: DoneButtonAction?
	
	@IBAction func handleDoneButtonPressed(_ sender: UIButton) {
		doneButtonAction?()
	}
	
	func configure(title: String, dateText: String, isDone: Bool, doneButtonAction: @escaping DoneButtonAction) {
		titleLabel.text = title
		dateLabel.text = dateText
		self.doneButtonAction = doneButtonAction
		let doneButtonImg = isDone ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
		doneButton.setImage(doneButtonImg, for: .normal)
	}
}

