//
//  NotesListTableViewController.swift
//  Notes
//
//  Created by Анастасия Кудашева on 16.03.2021.
//

import UIKit
import CoreData

class NotesListTableViewController: UITableViewController {
    //create array to
    var notes = [Note]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFile()
        // add editing button
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadNotes()
        tableView.reloadData()
    }
    
    // function for fetching notes
    func loadNotes() {
        let fetchReguest: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            notes = try context.fetch(fetchReguest)
        } catch {
            print("DataBase Fetching is failed")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotesListTableViewCell
        cell.setNote(note: notes[indexPath.row])
        
        return cell
    }
    
    // function for deleting note from array & CoreData
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            
            if let managedObjectContext = note.managedObjectContext {
                managedObjectContext.delete(note)
                
                do {
                    try managedObjectContext.save()
                    self.notes.remove(at: indexPath.row)
                    tableView.reloadData()
                } catch {
                    print("Delete error")
                    tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ViewController else {
            return
        }
        if let segueIdentifier = segue.identifier, segueIdentifier == "segueEdit", let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            destination.note = notes[indexPathForSelectedRow.row]
        }
    }
    
    @IBAction func addNoteButton(_ sender: Any) {
    }
}

//MARK: - Obligatory requirement: application should display one note when first opening.
extension NotesListTableViewController {
    func getDataFromFile() {
        // Should be changed to UserDefaults
        if notes.count == 0 {
            guard let pathToFile = Bundle.main.path(forResource: "defaultNote", ofType: "plist"), let dataArray = NSArray(contentsOfFile: pathToFile) else { return }
            for dictionary in dataArray {
                guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: context) else { return }
                let firstNote = NSManagedObject(entity: entity, insertInto: context) as! Note
                
                let noteDictionary = dictionary as! [String: AnyObject]
                firstNote.title = noteDictionary["title"] as? String
                firstNote.text = noteDictionary["text"] as? String
            }
        }
    }
}
