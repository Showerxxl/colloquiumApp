//
//  AssesmentViewController.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 26.09.2025.
//

import UIKit

final class AssesmentViewController: UIViewController {
    
    private let interactor: AssesmentInteractionLogic
    
    init(interactor: AssesmentInteractionLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    private func configureUI() {
        
    }
}
