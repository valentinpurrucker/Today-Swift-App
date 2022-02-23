//
//  ReminderDetailEditDataSource.swift
//  Today
//
//  Created by Valentin Purrucker on 20.02.22.
//

import UIKit
class ReminderDetailEditDataSource: NSObject {
	
	typealias ReminderChangeAction = (Reminder) -> Void
	
	private var reminderChangeAction: ReminderChangeAction?
	
	private lazy var formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .full
		formatter.timeStyle = .short
		return formatter
	}()
	
	private var reminder: Reminder
	
	init(reminder: Reminder, reminderChangeAction: @escaping ReminderChangeAction) {
		self.reminder = reminder
		self.reminderChangeAction = reminderChangeAction
	}
	
	enum ReminderSection: Int, CaseIterable {
		case title
		case dueDate
		case notes
		
		var displayText: String {
			switch self {
				case .title:
					return "Title"
				case .dueDate:
					return "Date"
				case .notes:
					return "Notes"
			}
		}
		
		var numRows: Int {
			switch self {
				case .title, .notes:
					return 1
				case .dueDate:
					return 2
			}
		}
		func cellIdentifier(for row: Int) -> String {
			switch self {
				case .title:
					return "EditTitleCell"
				case .dueDate:
					return row == 0 ? "EditDateLabelCell" : "EditDateCell"
				case .notes:
					return "EditNotesCell"
			}
		}
	}
	
	static var dateLabelCellIdentifier: String {
		return ReminderSection.dueDate.cellIdentifier(for: 0)
	}
	
	private func dequeueAndConfigureCell(for indexPath: IndexPath, from tableView: UITableView) -> UITableViewCell {
		guard let section = ReminderSection(rawValue: indexPath.section) else { fatalError() }
		let identifier = section.cellIdentifier(for: indexPath.row)
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
		
		switch section {
			case .title:
				if let titleCell = cell as? EditTitleCell {
					titleCell.configure(title: reminder.title) { title in
						self.reminder.title = title
						self.reminderChangeAction?(self.reminder)
					}
				}
			case .dueDate:
				if indexPath.row == 0 {
					cell.textLabel?.text = formatter.string(from: reminder.dueDate)
				} else {
					if let dateCell = cell as? EditDateCell {
						dateCell.configure(date: reminder.dueDate) { date in
							self.reminder.dueDate = date
							self.reminderChangeAction?(self.reminder)
						}
					}
				}
			case .notes:
				if let notesCell = cell as? EditNotesCell {
					notesCell.configure(notesText: reminder.notes) { notes in
						self.reminder.notes = notes
						self.reminderChangeAction?(self.reminder)
					}
				}
		}
		return cell
	}
}

extension ReminderDetailEditDataSource: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		ReminderSection(rawValue: section)?.numRows ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		dequeueAndConfigureCell(for: indexPath, from: tableView)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		ReminderSection.allCases.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let section = ReminderSection(rawValue: section) else {fatalError()}
		
		return section.displayText
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		false
	}
	
}
