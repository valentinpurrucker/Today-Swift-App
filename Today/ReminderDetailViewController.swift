//
//  ReminderDetailViewController.swift
//  Today
//
//  Created by Valentin Purrucker on 19.02.22.
//

import Foundation
import UIKit

class ReminderDetailViewController: UITableViewController {
	
	typealias ReminderChangeAction = (Reminder) -> Void
	
	private var reminderEditAction: ReminderChangeAction?
	private var reminderAddAction: ReminderChangeAction?
	
	private var reminder: Reminder?
	private var tempReminder: Reminder?
	
	private var isNew = false
	
	private var dataSource: UITableViewDataSource?
	
	func configure(with reminder: Reminder, isNew: Bool = false, editAction: ReminderChangeAction? = nil, addAction: ReminderChangeAction? = nil) {
		self.reminder = reminder
		self.isNew = isNew
		self.reminderEditAction = editAction
		self.reminderAddAction = addAction
		
		if isViewLoaded {
			setEditing(isNew, animated: false)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setEditing(isNew, animated: false)
		navigationItem.setRightBarButton(editButtonItem, animated: false)
		// we'll use a default tablecell that doesnt exist, so we have to register it
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReminderDetailEditDataSource.dateLabelCellIdentifier)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if let navController = navigationController, !navController.isToolbarHidden {
			navController.setToolbarHidden(true, animated: animated)
		}
	}
	
	private func transitionToViewMode(_ reminder: Reminder) {
		if isNew {
			let newReminder = tempReminder ?? reminder
			dismiss(animated: true) {
				self.reminderAddAction?(newReminder)
			}
			return
		}
		
		if let tempReminder = tempReminder {
			self.reminder = tempReminder
			self.tempReminder = nil
			self.reminderEditAction?(tempReminder)
			dataSource = ReminderDetailDataSource(reminder: tempReminder)
		} else {
			dataSource = ReminderDetailDataSource(reminder: reminder)
		}
		navigationItem.leftBarButtonItem = nil
		editButtonItem.isEnabled = true
		navigationItem.title = NSLocalizedString("View Reminder", comment: "View a reminder")
	}
	
	private func transitionToEditMode(_ reminder: Reminder) {
		dataSource = ReminderDetailEditDataSource(reminder: reminder) { reminder in
			self.tempReminder = reminder
			self.editButtonItem.isEnabled = true
		}
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtontrigger))
		navigationItem.title = isNew ?  NSLocalizedString("Add Reminder", comment: "Add a new reminder") : NSLocalizedString("Edit Reminder", comment: "Edit a reminder")
	}
	
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		guard let reminder = reminder else { fatalError("Nil Reminder not valid")}
		if editing {
			transitionToEditMode(reminder)
		} else {
			transitionToViewMode(reminder)
		}
		tableView.dataSource = dataSource
		tableView.reloadData()
	}
	
	@objc
	func cancelButtontrigger() {
		if isNew {
			dismiss(animated: true)
		} else {
			self.tempReminder = nil
			setEditing(false, animated: true)
		}
	}
}
