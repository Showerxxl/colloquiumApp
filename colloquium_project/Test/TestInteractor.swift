//
//  TestInteractor.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 20.09.2025.
//

import Foundation

//// View -> Interactor (only)
//protocol TestInteractorInput: AnyObject {
//    func loadTest()
//    func selectQuestion(index: Int)
//    func saveAnswer(questionId: String, textAnswer: String?, optionId: String?)
//    func goNext()
//    func goPrev()
//    func finishTest()
//    func goBack()
//}
//
//// Interactor -> Presenter (only)
//protocol TestInteractorOutput: AnyObject {
//    func didLoad(state: TestState)
//    func didFailLoad(error: Error)
//    func didSaveAnswer(state: TestState, for questionId: String)
//    func shouldNavigateToQuestion(index: Int, state: TestState)
//}
//
//final class TestInteractor: TestInteractorInput {
//    private let worker: TestWorkerProtocol?
//    private var output: TestInteractorOutput?
//    
//    private(set) var test: Test?
//    private(set) var currentIndex: Int = 0
//    
//    private var answersText: [String: String] = [:]
//    private var answersOption: [String: String] = [:]
//    
//    // -- optional timer state inside interactor (если хотите хранить оставшееся время здесь)
//    private var testStartDate: Date?
//    private var durationSeconds: Int = 0
//    
//    init(worker: TestWorkerProtocol?, output: TestInteractorOutput?) {
//        self.worker = worker
//        self.output = output
//    }
//    
//    func loadTest() {
//        worker?.loadTest { [weak self] res in
//            guard let self = self else { return }
//            switch res {
//            case .success(let test):
//                self.test = test
//                self.currentIndex = 0
//                self.durationSeconds = test.durationSeconds
//                self.testStartDate = Date()
//                let state = self.makeState()
//                self.output?.didLoad(state: state)
//            case .failure(let err):
//                self.output?.didFailLoad(error: err)
//            }
//        }
//    }
//    
//    func selectQuestion(index: Int) {
//        print("Interactor.selectQuestion index:", index)
//        guard let t = test, t.questions.indices.contains(index) else { return }
//        currentIndex = index
//        
//        let state = makeState()
//        output?.didLoad(state: state) // Обновляем состояние
//        output?.shouldNavigateToQuestion(index: index, state: state) // Инициируем навигацию
//    }
//    
//    func saveAnswer(questionId: String, textAnswer: String?, optionId: String?) {
//        if let txt = textAnswer { answersText[questionId] = txt }
//        if let opt = optionId { answersOption[questionId] = opt }
//        output?.didSaveAnswer(state: makeState(), for: questionId)
//    }
//    
//    func goNext() {
//        guard let t = test else { return }
//        currentIndex = min(t.questions.count - 1, currentIndex + 1)
//        output?.didLoad(state: makeState())
//    }
//    
//    func goPrev() {
//        guard let t = test else { return }
//        currentIndex = max(0, currentIndex - 1)
//        output?.didLoad(state: makeState())
//    }
//    
//    func finishTest() {
//        guard let t = test else { return }
//        var results: [String: Any] = [:]
//        for q in t.questions {
//            results[q.id] = (q.type == .open) ? (answersText[q.id] ?? "") : (answersOption[q.id] ?? "")
//        }
//        print("=== MOCK FINISH RESULTS ===")
//        print(results)
//        output?.didLoad(state: makeState())
//    }
//    
//    func goBack() {
//        guard let t = test else { return }
//        currentIndex = max(0, currentIndex - 1)
//        output?.didLoad(state: makeState())
//    }
//    
//    // Helpers for constructing state
//    private func remainingSeconds() -> Int {
//        guard let start = testStartDate else { return durationSeconds }
//        let end = start.addingTimeInterval(TimeInterval(durationSeconds))
//        return max(0, Int(end.timeIntervalSinceNow))
//    }
//    
//    private func makeState() -> TestState {
//        return TestState(
//            test: test!,
//            currentIndex: currentIndex,
//            answersText: answersText,
//            answersOption: answersOption,
//            remainingSeconds: remainingSeconds()
//        )
//    }
//}

protocol TestInteractorInput {
    func loadTest()
}

protocol TestInteractorOutput {
    func didLoad(state: TestState)
    func didFailLoad(error: Error)
}

final class TestInteractor: TestInteractorInput {
    private let worker: TestWorkerProtocol?
    private var output: TestInteractorOutput?
    
    private(set) var test: Test?
    private(set) var currentIndex: Int = 0
    
    private var answersText: [String: String] = [:]
    private var answersOption: [String: String] = [:]
    
    // -- optional timer state inside interactor (если хотите хранить оставшееся время здесь)
    private var testStartDate: Date?
    private var durationSeconds: Int = 0
    
    init(worker: TestWorkerProtocol?, output: TestInteractorOutput?) {
        self.worker = worker
        self.output = output
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
    
    private func makeState() -> TestState {
        return TestState(
            test: test!,
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
