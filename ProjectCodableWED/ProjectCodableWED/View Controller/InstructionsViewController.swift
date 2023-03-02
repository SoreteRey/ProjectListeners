//
//  InstructionsViewController.swift
//  ProjectCodableWED
//
//  Created by Sebastian Guiscardo on 3/2/23.
//

import UIKit

class InstructionsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var instructionsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    // MARK: - Properties
    var instructions: String?
    
    // MARK: - Functions
    func updateUI() {
        guard let instructions = instructions else { return }
        instructionsTextView.text = instructions
    }
}
