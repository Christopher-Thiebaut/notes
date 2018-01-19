//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Christopher Thiebaut on 1/19/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    let noteController = NoteController.default
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Allow the user to put the tableview into editing mode.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // There should be 1 row for each note to be presented.
        return noteController.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        // Get the data to be displayed...
        let note = noteController[indexPath.row]
        let title = note.title
        let text = note.text
        var textToDisplay: String
        if let title = title, !title.isEmpty {
            textToDisplay = title
        }else if let text = text {
            textToDisplay = text
        }else {
            fatalError("NoteTableViewController refuses to display completely blank note at \(indexPath.row)")
        }
        // Configure the cell...
        cell.textLabel?.text = textToDisplay
        return cell
    }
    
    // Allow users to re-order notes.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        //Change the order of the cells in the tableview
        if noteController.moveNote(from: fromIndexPath.row, to: to.row){
            tableView.moveRow(at: fromIndexPath, to: to)
        }
    }

    // Allow users to delete a note by swiping left.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let noteToDelete = noteController[indexPath.row]
            noteController.delete(note: noteToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Check if we are going from a cell representing an existing note to the edit screen.
        if segue.identifier == "toNoteDetailVCfromCell" {
            guard let destination = segue.destination as? NoteDetailViewController else {
                fatalError("Unexpected destination for \(String(describing: segue.identifier))")
            }
            guard let indexPath = tableView.indexPathForSelectedRow else {
                fatalError("Cannot pass data to \(destination) as requested because no row has been selected from the table view")
            }
            let noteToPass = noteController[indexPath.row]
            destination.note = noteToPass
        }
    }
    
}
