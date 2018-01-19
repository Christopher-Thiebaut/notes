//
//  NoteDetailViewController.swift
//  Notes
//
//  Created by Christopher Thiebaut on 1/19/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    var note: Note?
    let noteController = NoteController.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        // Do any additional setup after loading the view.
    }
    //Set up this view controller's views to reflect any data that may have been passed in through its note property.
    func setupViews(){
        if let note = note {
            noteTitleTextField.text = note.title
            noteTextView.text = note.text
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //MARK: Actions
    @IBAction func userTappedSaveButton(_ sender: Any) {
        if let note = note {
            noteController.edit(note: note, titleTo: noteTitleTextField.text, andTextTo: noteTextView.text)
        }else{
            _ = noteController.appendNewNote(withTitle: noteTitleTextField.text, andText: noteTextView.text)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func userTappedOutsideField(_ sender: Any) {
        if noteTextView.isFirstResponder {
            noteTextView.resignFirstResponder()
        }
    }
    
}
