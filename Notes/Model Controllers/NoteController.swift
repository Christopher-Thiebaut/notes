//
//  NoteController.swift
//  Notes
//
//  Created by Christopher Thiebaut on 1/19/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

class NoteController {
    
    private var notes: [Note] = []
    static let `default` = NoteController()
    var count: Int { return notes.count }
    
    init(){
        if let notes = loadFromPersistentStorage(){
            self.notes = notes
        }
    }
    
    //CREATE
    ///Append a new not with the specified title and text as long as at least 1 of them contains a value.
    ///Returns the appended note if it was created, or nil otherwise.
    func appendNewNote(withTitle title: String?, andText text: String?) -> Note? {
        if validateNote(title: title, text: text){
            let newNote = Note(title: title, text: text)
            notes.append(newNote)
            saveToPersistentStorage()
            return newNote
        }else{
            return nil
        }
    }
    //READ
    subscript(index: Int) -> Note {
        get {
            return notes[index]
        }
    }
    //UPDATE
    func edit(note: Note, titleTo title: String?, andTextTo text: String?) {
        if validateNote(title: title, text: text) {
            note.title = title
            note.text = text
            saveToPersistentStorage()
        }else{
            delete(note: note)
            //Delete handles its own save request.
        }
    }
    //DELETE
    ///Delete a note owned by this instance of NoteController. Returns true if the note was deleted and false otherwise.
    func delete(note: Note){
        if let indexToDelete = notes.index(of: note){
            notes.remove(at: indexToDelete)
        }
        saveToPersistentStorage()
    }
    private func validateNote(title: String?, text: String?) -> Bool{
        return validateDataExists(in: title) || validateDataExists(in: text)
    }
    private func validateDataExists(`in` input: String?) -> Bool{
        if let input = input, !input.isEmpty {
            return true
        }else{
            return false
        }
    }
    //PERSISTENCE
    private func filePath() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "notes.json"
        let fullURL = urls[0].appendingPathComponent(fileName)
        return fullURL
    }
    private func saveToPersistentStorage(){
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(notes)
            try data.write(to: filePath())
        } catch let error {
            print("Failed to write to \(filePath()): \(error.localizedDescription)")
        }
    }
    private func loadFromPersistentStorage() -> [Note]?{
        do {
            let data = try Data.init(contentsOf: filePath())
            let jsonDecoder = JSONDecoder()
            let notes = try jsonDecoder.decode([Note].self, from: data)
            return notes
        } catch let error {
            print("Failed to read data from \(filePath()): \(error.localizedDescription)")
            return nil
        }
    }
}
