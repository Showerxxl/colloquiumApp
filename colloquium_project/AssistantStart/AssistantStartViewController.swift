//
//  AssistantStartViewController.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 24.09.2025.
//

import UIKit

final class AssistantStartViewController: UIViewController {
    private let interactor: AssistantStartInteractionLogic
    
    init(interactor: AssistantStartInteractionLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
