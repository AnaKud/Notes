//
//  NotesListTableViewCell.swift
//  Notes
//
//  Created by Анастасия Кудашева on 16.03.2021.
//

import UIKit

class NotesListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setNote(note: Note) {
        noteTitleLabel.text = note.title
        noteTextLabel.text = note.text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
