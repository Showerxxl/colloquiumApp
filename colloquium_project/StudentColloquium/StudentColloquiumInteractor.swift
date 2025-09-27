import Foundation

protocol StudentColloquiumBusinessLogic: AnyObject {
    func loadHistory()
    func startButtonTapped()
    func openAttempt(email: String, code: String)
}

final class StudentColloquiumInteractor: StudentColloquiumBusinessLogic {

    var presenter: StudentColloquiumPresentationLogic?

    private let sessionStore: SessionStoring
    private let historyService: StudentHistoryService
    private let attemptService: StudentAttemptService

    init(sessionStore: SessionStoring = UserDefaultsSessionStore(),
         historyService: StudentHistoryService = FirebaseStudentHistoryService(), attemptService: StudentAttemptService = FirebaseStudentAttemptService()) {
        self.sessionStore = sessionStore
        self.historyService = historyService
        self.attemptService = attemptService
    }

    func loadHistory() {
        guard let session = sessionStore.load(), !session.email.isEmpty else {
            // почты нет — отдадим пустое состояние
            presenter?.presentHistory(.init(items: []))
            return
        }

        historyService.fetchAttempts(forEmail: session.email) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                // на ошибке тоже можно показать пустое состояние/тултип — пока просто пусто
                DispatchQueue.main.async {
                    self.presenter?.presentHistory(.init(items: []))
                }
            case .success(let attempts):
                // Маппим DTO -> внутренние модели презентера
                let mapped: [StudentColloquiumModels.History.Item] = attempts.map {
                    .init(
                        title: "Коллоквиум \($0.testId) • код \($0.code)",
                        date: $0.createdAt,
                        score: nil,
                        email: $0.email,
                        code:  $0.code
                    )
                }
                DispatchQueue.main.async {
                    self.presenter?.presentHistory(.init(items: mapped))
                }
            }
        }
    }
    
    func openAttempt(email: String, code: String) {
        attemptService.fetchAttempt(email: email, code: code) { [weak self] result in
            switch result {
            case .failure:
                // можно показать алерт — пока просто пустую попытку
                self?.presenter?.presentAttempt(rows: [])
            case .success(let rows):
                self?.presenter?.presentAttempt(rows: rows)
            }
        }
    }
    
    func startButtonTapped() {
        presenter?.presentStart()
    }
}
