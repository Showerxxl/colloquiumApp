import Foundation

protocol StudentColloquiumBusinessLogic: AnyObject {
    func loadHistory()
    func startButtonTapped()
}

final class StudentColloquiumInteractor: StudentColloquiumBusinessLogic {

    var presenter: StudentColloquiumPresentationLogic?

    private let sessionStore: SessionStoring
    private let historyService: StudentHistoryService

    init(sessionStore: SessionStoring = UserDefaultsSessionStore(),
         historyService: StudentHistoryService = FirebaseStudentHistoryService()) {
        self.sessionStore = sessionStore
        self.historyService = historyService
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
                    // title можешь подстроить; добавил и testId, и code
                    .init(
                        title: "Коллоквиум \($0.testId) • код \($0.code)",
                        date: $0.createdAt,
                        score: nil // если в будущем появится оценка — сюда
                    )
                }
                DispatchQueue.main.async {
                    self.presenter?.presentHistory(.init(items: mapped))
                }
            }
        }
    }

    func startButtonTapped() {
        presenter?.presentStart()
    }
}
