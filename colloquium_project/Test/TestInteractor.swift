//
//  TestInteractor.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 20.09.2025.
//

import Foundation

protocol TestInteractorInput {
    func loadTest()
    func selectQuestion(index: Int)
    func goNext()
    func goBack()
    func saveAnswer(questionId: String, textAnswer: String?, optionId: String?)
    func finishTest()
    func hasEmptyAnswers() -> Bool
}

protocol TestInteractorOutput {
    func didLoad(state: TestState)
    func didFailLoad(error: Error)
    func shouldNavigateToQuestion(index: Int, state: TestState)
    func didSaveAnswer(state: TestState, for questionId: String)
    func routeMenu()
}

final class TestInteractor: TestInteractorInput {
    private let worker: TestWorkerProtocol?
    private var output: TestInteractorOutput?
    
    private let codeStore: CodeStoring
    private let sessionStore: SessionStoring
    private let resultsService: ResultsUploadService
    
    private(set) var test: Test?
    private(set) var currentIndex: Int = 0
    
    private var answersText: [String: String] = [:]
    private var answersOption: [String: String] = [:]
    
    private var testStartDate: Date?
    private var durationSeconds: Int = 0
    private var isFinishing = false
    
    init(worker: TestWorkerProtocol?,
         output: TestInteractorOutput?,
         codeStore: CodeStoring = UserDefaultsCodeStore(),
         sessionStore: SessionStoring = UserDefaultsSessionStore(),
         resultsService: ResultsUploadService = FirebaseResultsUploadService()) {
        self.worker = worker
        self.output = output
        self.codeStore = codeStore
        self.sessionStore = sessionStore
        self.resultsService = resultsService
    }
    
    func loadTest() {
        worker?.loadTest { [weak self] res in
            guard let self = self else { return }
            switch res {
            case .success(let test):
                self.test = test
                self.currentIndex = 0
                self.durationSeconds = test.durationSeconds
                self.testStartDate = Date()
                let state = self.makeState()
                self.output?.didLoad(state: state)
            case .failure(let err):
                self.output?.didFailLoad(error: err)
            }
        }
    }
    
    func selectQuestion(index: Int) {
        print("Interactor.selectQuestion index:", index)
        guard let t = test, t.questions.indices.contains(index) else { return }
        currentIndex = index
        
        let state = makeState()
        output?.didLoad(state: state) // Обновляем состояние
        output?.shouldNavigateToQuestion(index: index, state: state) // Инициируем навигацию
    }
    
    func goNext() {
        guard let t = test else { return }
        currentIndex = min(t.questions.count - 1, currentIndex + 1)
        output?.didLoad(state: makeState())
    }
    
    func goBack() {
        guard let t = test else { return }
        currentIndex = max(0, currentIndex - 1)
        output?.didLoad(state: makeState())
    }
    
    
    func saveAnswer(questionId: String, textAnswer: String?, optionId: String?) {
        if let txt = textAnswer { answersText[questionId] = txt }
        if let opt = optionId { answersOption[questionId] = opt }
        output?.didSaveAnswer(state: makeState(), for: questionId)
    }
    
    func finishTest() {
        guard !isFinishing else { return }
        guard let t = test else { return }
        
        // 1) Достаём code и email
        guard let code = codeStore.load(), !code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("❌ finishTest: code is missing in UserDefaults")
            // по желанию: сообщить презентеру об ошибке
            return
        }
        
        guard let session = sessionStore.load(),
              !session.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("❌ finishTest: email is missing in UserDefaults session")
            // по желанию: сообщить презентеру об ошибке
            return
        }
        
        // 2) Собираем ответы в единый массив пар (questionId, answer)
        //    для open — берём текст, для остальных — выбранный optionId
        var flatAnswers: [(questionId: String, answer: String)] = []
        flatAnswers.reserveCapacity(t.questions.count)
        
        for q in t.questions {
            let answer: String
            switch q.type {
            case .open:
                answer = (answersText[q.id] ?? "")
            default:
                answer = (answersOption[q.id] ?? "")
            }
            flatAnswers.append((questionId: q.id, answer: answer))
        }
        
        // 3) Отправляем в Firestore
        isFinishing = true
        resultsService.uploadResults(
            testId: t.id,
            code: code,
            email: session.email,
            answers: flatAnswers
        ) { [weak self] result in
            guard let self = self else { return }
            self.isFinishing = false
            
            switch result {
            case .success:
                print("✅ Results uploaded")
                // Можно уведомить презентер, чтобы показать финальный экран/алерт «отправлено»
                self.output?.didLoad(state: self.makeState())
                self.output?.routeMenu()
            case .failure(let error):
                print("❌ Failed to upload results: \(error)")
                // По-хорошему — отдельный output метод, например didFailFinish(error:)
                self.output?.didFailLoad(error: error)
            }
        }
    }
    
    func hasEmptyAnswers() -> Bool {
        guard let t = test else { return false }

        for q in t.questions {
            switch q.type {
            case .open:
                // нет записи или только пробелы — считаем пустым
                let txt = answersText[q.id]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                if txt.isEmpty { return true }

            default:
                // нет выбранного варианта
                if answersOption[q.id] == nil { return true }
            }
        }
        return false
    }
    
    private func makeState() -> TestState {
        guard let test = test else {
            fatalError("makeState() called before test was loaded")
        }
        
        return TestState(
            test: test,
            currentIndex: currentIndex,
            answersText: answersText,
            answersOption: answersOption,
            remainingSeconds: remainingSeconds()
        )
    }
    
    private func remainingSeconds() -> Int {
        guard let start = testStartDate else { return durationSeconds }
        let end = start.addingTimeInterval(TimeInterval(durationSeconds))
        return max(0, Int(end.timeIntervalSinceNow))
    }
}
