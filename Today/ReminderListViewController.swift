//
//  ViewController.swift
//  Today
//
//  Created by Valentin Purrucker on 18.02.22.
//

import UIKit

class ReminderListViewController: UITableViewController {
	
	
	@IBOutlet weak var filterSegmentControl: UISegmentedControl!
	
	static let showDetailSegue = "ShowReminderDetailSegue"
	
	static let mainStoryboardName = "Main"
	static let detailViewControllerIdentifier = "ReminderDetailViewController"
	
	private var reminderListDataSource: ReminderListDataSource?
	
	private var filter: ReminderListDataSource.Filter {
		guard let filter = ReminderListDataSource.Filter(rawValue: filterSegmentControl.selectedSegmentIndex) else { fatalError("No valid filter selected")}
		return filter
	}

	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if let navController = navigationController, navController.isToolbarHidden {
			navController.setToolbarHidden(false, animated: animated)
		}
	}
	
	/**
	 Is called right before performing the segue
	 */
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == ReminderListViewController.showDetailSegue, let destination = segue.destination as? ReminderDetailViewController, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
			let indexRow = indexPath.row
			guard let reminder = reminderListDataSource?.reminder(at: indexRow) else { fatalError() }
			destination.configure(with: reminder, editAction: { reminder in
				self.reminderListDataSource?.update(reminder, at: indexRow)
				self.tableView.reloadData()
			})
		}
	}
	
	override func viewDidLoad() {
		reminderListDataSource = ReminderListDataSource()
		tableView.dataSource = reminderListDataSource
		
	}
	
	@IBAction func addButtonTriggered(_ sender: UIBarButtonItem) {
		addReminder()
	}
	
	@IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
		reminderListDataSource?.filter = filter
		tableView.reloadData()
	}
	
	private func addReminder() {
		let storyboard = UIStoryboard.init(name: Self.mainStoryboardName, bundle: nil)
		let detailViewController: ReminderDetailViewController = storyboard.instantiateViewController(withIdentifier: Self.detailViewControllerIdentifier) as! ReminderDetailViewController
		let reminder = Reminder(title: "New Reminder", dueDate: Date())
		detailViewController.configure(with: reminder, isNew: true, addAction: { reminder in
			if let index = self.reminderListDataSource?.add(reminder) {
				self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
			}
		})
		let navController = UINavigationController(rootViewController: detailViewController)
		present(navController, animated: true)
	}
}

extension Reminder {
	static let timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .none
		formatter.timeStyle = .short
		return formatter
	}()
	
	static let futureDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter
	}()
	
	static let todayDateFormatter: DateFormatter = {
		let format = NSLocalizedString("Today at '%@'", comment: "A date string for todays date")
		let formatter = DateFormatter()
		formatter.dateFormat = String(format: format, "hh:mm a")
		return formatter
	}()
	
	func dueDateText(for filter: ReminderListDataSource.Filter) -> String {
		let inToday = Locale.current.calendar.isDateInToday(dueDate)
		switch filter {
			case .today:
				return Reminder.timeFormatter.string(from: dueDate)
			case .future:
				return Reminder.futureDateFormatter.string(from: dueDate)
			case .all:
				if inToday {
					return Self.todayDateFormatter.string(from: dueDate)
				} else {
					return Self.futureDateFormatter.string(from: dueDate)
				}
		}
	}
}
