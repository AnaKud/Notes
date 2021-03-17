//
//  ViewController.swift
//  Notes
//
//  Created by Анастасия Кудашева on 16.03.2021.
//

import UIKit

class ViewController: UIViewController {
    
    //if note is nil, it's a new note, if note has value, it's existing note from segue
    var note: Note?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //if it's existing note display note's entities
        if let note = note {
            titleTextField.text = note.title
            noteTextView.text = note.text
        } else {
            //if it's new note, textField and textView should be empty
            titleTextField.text = ""
            noteTextView.text = ""
        }
    }
    
    @IBAction func saveNoteButton(_ sender: Any) {
        // Protection from app crushing
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespaces), !title.isEmpty else {
            displayAlert(alert: "You can't save note without title")
            return
        }
        guard let noteText = noteTextView.text, !noteText.isEmpty else {
            displayAlert(alert: "You can't save note without text")
            return
        }
        // update block for existing note
        if let note = note {
            note.title = title
            note.text = noteTextView.text
            do {
                try context.save()
            } catch {
                print("Note was updated")
            }
        } else {
            // saving block for new note
            let newNote = Note(context: context)
            newNote.title = titleTextField.text
            newNote.text = noteTextView.text
            
            do {
                let managedObjectContext = note?.managedObjectContext
                try managedObjectContext?.save()
            } catch {
                displayAlert(alert: "Note can't be saved")
            }
        }
        navigationController?.popViewController(animated: false)
    }
}

// MARK:- Extesion for AlertController
extension ViewController {
    func displayAlert(alert: String) {
        let alert = UIAlertController(title: alert, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
