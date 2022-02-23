//
//  ReminderDetailDataSource.swift
//  Today
//
//  Created by Valentin Purrucker on 19.02.22.
//

import Foundation
import UIKit

class ReminderDetailDataSource: NSObject {
	private var reminder: Reminder
	
	enum ReminderRow: Int, CaseIterable {
		case title
		case date
		case time
		case notes
		
		static var timeFormatter: DateFormatter {
			let formatter = DateFormatter()
			formatter.timeStyle = .none
			formatter.dateStyle = .short
			return formatter
		}
		
		static var dateFormatter: DateFormatter {
			let formatter = DateFormatter()
			formatter.timeStyle = .none
			formatter.dateStyle = .long
			return formatter
		}
		
		func displayText(for reminder: Reminder?) -> String? {
			switch self {
				case .title:
					return reminder?.title
				case .date:
					guard let date = reminder?.dueDate else {fatalError()}
					return Self.dateFormatter.string(from: date)
				case .notes:
					return reminder?.notes
				case .time:
					guard let date = reminder?.dueDate else {fatalError()}
					return Self.timeFormatter.string(from: date)
			}
		}
		
		var image: UIImage? {
			switch self {
				case .title:
					return nil
				case .date:
					return UIImage(systemName: "calendar.circle")
				case .time:
					return UIImage(systemName: "calendar.circle")
				case .notes:
					return UIImage(systemName: "pencil.circle")
			}
		}
	}
	
	init(reminder: Reminder) {
		self.reminder = reminder
		super.init()
	}
}

extension ReminderDetailDataSource: UITableViewDataSource {
	
	static let reminderDetailCellIdentifier = "ReminderDetailCell"
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		ReminderRow.allCases.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ReminderDetailDataSource.reminderDetailCellIdentifier, for: indexPath)
		
		let row = ReminderRow(rawValue: indexPath.row)
		
		cell.textLabel?.text = row?.displayText(for: reminder)
		cell.imageView?.image = row?.image
		
		
		return cell
	}
}
