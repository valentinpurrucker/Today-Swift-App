//
//  EditDateCell.swift
//  Today
//
//  Created by Valentin Purrucker on 20.02.22.
//

import Foundation
import UIKit

class EditDateCell: UITableViewCell {
	
	typealias DateChangeAction = (Date) -> Void
	
	private var dateChangeAction: DateChangeAction?
	
	@IBOutlet var datePicker: UIDatePicker!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
		datePicker.minimumDate = .now
	}
	
	func configure(date: Date, dateChangeAction: @escaping DateChangeAction) {
		datePicker.date = date
		self.dateChangeAction = dateChangeAction
	}
	
	@objc
	func dateChanged(_ sender: UIDatePicker) {
		self.dateChangeAction?(sender.date)
	}
}
