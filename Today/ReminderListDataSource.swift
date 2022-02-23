//
//  ReminderListDataSource.swift
//  Today
//
//  Created by Valentin Purrucker on 19.02.22.
//

import Foundation
import UIKit


class ReminderListDataSource: NSObject {
	
	enum Filter: Int {
		case today
		case future
		case all
		
		func shouldInclude(date: Date) -> Bool {
			let inToday = Locale.current.calendar.isDateInToday(date)
			switch self {
				case .today:
					return inToday
				case .future:
					return (date > Date()) && !inToday
				case .all:
					return true
			}
		}
	}
	
	var filter: Filter = .today
	
	private lazy var dateFormatter = RelativeDateTimeFormatter()
	
	private var filteredReminders: [Reminder] {
		return Reminder.reminders.filter { reminder in
			filter.shouldInclude(date: reminder.dueDate)
		}.sorted {
			$0.dueDate < $1.dueDate
		}
	}
	
	func reminder(at row: Int) -> Reminder {
		return filteredReminders[row]
	}
	
	func update(_ reminder: Reminder, at row: Int) {
		let index = index(for: row)
		Reminder.reminders[index] = reminder
	}
	
	func add(_ reminder: Reminder) -> Int? {
		Reminder.reminders.insert(reminder, at: 0)
		return filteredReminders.firstIndex {
			$0.id == reminder.id
		}
	}
	
	func delete(at row: Int) {
		let index = index(for: row)
		Reminder.reminders.remove(at: index)
	}
	
	func index(for filteredIndex: Int) -> Int {
		let filteredReminder = filteredReminders[filteredIndex]
		guard let originalIndex = Reminder.reminders.firstIndex(where: { $0.id == filteredReminder.id }) else { fatalError("No reminder with id \(filteredReminder.id)") }
		return originalIndex
	}
}

extension ReminderListDataSource: UITableViewDataSource {
	
	static let reminderListCellIdentifier = "ReminderListCell"
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		filteredReminders.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderListDataSource.reminderListCellIdentifier, for: indexPath) as? ReminderListCell else {fatalError()}
		
		let reminder = reminder(at: indexPath.row)
		
		let dateText = dateFormatter.localizedString(for: reminder.dueDate, relativeTo: .now)
		
		cell.configure(title: reminder.title, dateText: dateText, isDone: reminder.isComplete) {
			Reminder.reminders[indexPath.row].isComplete.toggle()
			tableView.reloadRows(at: [indexPath], with: .automatic)
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
		delete(at: indexPath.row)
		tableView.performBatchUpdates {
			tableView.deleteRows(at: [indexPath], with: .automatic)
		} completion: { _ in
			tableView.reloadData()
		}
	}
	
	
}
