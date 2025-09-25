//
//  TestPresenter.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 20.09.2025.
//

import UIKit

//final class TestPresenter: TestInteractorOutput {
//    weak var view: UIViewController?
//
//    // factory that wiring will set — must assign interactor inside factory
//    var createQuestionVC: (() -> QuestionViewController)?
//
//    private var timer: Timer?
//    private var endDate: Date?
//
//    // Track last index we have already routed/handled — to detect user selection changes
//    private var lastHandledIndex: Int? = nil
//
//    init() {}
//
//    // Interactor -> Presenter now gives state
//    func didLoad(state: TestState) {
//        print("Presenter.didLoad currentIndex:", state.currentIndex, "lastHandledIndex:", lastHandledIndex as Any)
//        
//        // Если это Overview и индекс изменился - делаем навигацию
//        if view is OverviewViewController, lastHandledIndex != state.currentIndex {
//            routeToQuestion(at: state.currentIndex, using: state)
//            lastHandledIndex = state.currentIndex
//            return
//        }
//        
//        // If view is Overview and user changed index (selected question) -> route
//        if let overview = view as? OverviewViewController {
//            overview.displayOverview(
//                title: state.test.title,
//                questions: state.test.questions.map { $0.title },
//                remainingSeconds: state.remainingSeconds
//            )
//
//            // убираем авто-роутинг на вопрос при загрузке
//            startTimer(remainingSeconds: state.remainingSeconds)
//            return
//        }
//
//
//        // If view is QuestionViewController — update question UI
//        if let qvc = view as? QuestionViewController {
//            let idx = state.currentIndex
//            guard state.test.questions.indices.contains(idx) else { return }
//            let q = state.test.questions[idx]
//            let vm = QuestionViewModel(
//                id: q.id,
//                title: q.title,
//                type: q.type,
//                options: q.options,
//                minSymbols: q.minSymbols,
//                index: idx,
//                total: state.test.questions.count,
//                existingText: state.answersText[q.id],
//                selectedOptionId: state.answersOption[q.id]
//            )
//            qvc.displayQuestion(vm)
//            // update lastHandledIndex (we are now showing this question)
//            lastHandledIndex = idx
//            return
//        }
//
//        // If presenter.view nil or other screen — show overview by default
//        if let nav = view?.navigationController {
//            let overview = OverviewViewController()
//            // wiring should set overview.interactor externally (we expect assembly to do that)
//            self.view = overview
//            nav.setViewControllers([overview], animated: false)
//            // We don't call loadTest here because Interactor already delivered state
//        }
//    }
//
//    func didFailLoad(error: Error) {
//        if let vc = view {
//            let a = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//            a.addAction(UIAlertAction(title: "OK", style: .default))
//            vc.present(a, animated: true)
//        }
//    }
//
//    func didSaveAnswer(state: TestState, for questionId: String) {
//        // refresh overview if visible
//        if let overview = view as? OverviewViewController {
//            overview.displayOverview(title: state.test.title,
//                                     questions: state.test.questions.map { $0.title },
//                                     remainingSeconds: state.remainingSeconds)
//        }
//        // if currently on question, update it using state
//        if let qvc = view as? QuestionViewController {
//            let idx = state.currentIndex
//            guard state.test.questions.indices.contains(idx) else { return }
//            let q = state.test.questions[idx]
//            let vm = QuestionViewModel(
//                id: q.id,
//                title: q.title,
//                type: q.type,
//                options: q.options,
//                minSymbols: q.minSymbols,
//                index: idx,
//                total: state.test.questions.count,
//                existingText: state.answersText[q.id],
//                selectedOptionId: state.answersOption[q.id]
//            )
//            qvc.displayQuestion(vm)
//        }
//    }
//
//    // Router: uses createQuestionVC factory to ensure interactor is set BEFORE push
//    func routeToQuestion(at index: Int, using state: TestState) {
//        guard let nav = view?.navigationController, state.test.questions.indices.contains(index) else {
//            print("routeToQuestion aborted: no nav or invalid index")
//            return
//        }
//        guard let makeQVC = createQuestionVC else {
//            print("routeToQuestion aborted: createQuestionVC factory not set")
//            return
//        }
//
//        let qvc = makeQVC() // factory must set qvc.interactor
//        // Set presenter's view to new VC (weak)
//        self.view = qvc
//        nav.pushViewController(qvc, animated: true)
//
//        // Fill question data
//        let q = state.test.questions[index]
//        let vm = QuestionViewModel(
//            id: q.id,
//            title: q.title,
//            type: q.type,
//            options: q.options,
//            minSymbols: q.minSymbols,
//            index: index,
//            total: state.test.questions.count,
//            existingText: state.answersText[q.id],
//            selectedOptionId: state.answersOption[q.id]
//        )
//        qvc.displayQuestion(vm)
//    }
//    
//    func shouldNavigateToQuestion(index: Int, state: TestState) {
//        routeToQuestion(at: index, using: state)
//    }
//
//    // Timer helpers (optional)
//    private func startTimer(remainingSeconds: Int) {
//        stopTimer()
//        endDate = Date().addingTimeInterval(TimeInterval(remainingSeconds))
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//            self?.tick()
//        }
//    }
//    private func stopTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
//    private func tick() {
//        guard let end = endDate else { return }
//        let remaining = max(0, Int(end.timeIntervalSinceNow))
//        if let overview = view as? OverviewViewController {
//            overview.updateTimer(remaining: remaining)
//        }
//        if remaining == 0 {
//            // optionally notify interactor to finish if desired
//        }
//    }
//}

import UIKit
import QuartzCore

final class TestPresenter: TestInteractorOutput {
    // Две слабые ссылки на разные экраны
    weak var overviewVC: OverviewViewController?
    weak var questionVC: QuestionViewController?
    
    // Фабрика вопрос-экрана; assembly должен проставить interactor внутрь создаваемого VC
    var createQuestionVC: (() -> QuestionViewController)?
    
    private var timer: Timer?
    private var endDate: Date?
    
    // Чтобы понимать, на какой вопрос уже перешли/отрисовали
    private var lastHandledIndex: Int? = nil
    
    init() {}
    
    // Interactor -> Presenter
    func didLoad(state: TestState) {
        print("Presenter.didLoad currentIndex:", state.currentIndex, "lastHandledIndex:", lastHandledIndex as Any)

        // 1) Если сейчас показываем вопрос — обновляем вопрос
        if let qvc = questionVC {
            let idx = state.currentIndex
            guard state.test.questions.indices.contains(idx) else { return }
            let q = state.test.questions[idx]
            let vm = QuestionViewModel(
                id: q.id,
                title: q.title,
                type: q.type,
                options: q.options,
                minSymbols: q.minSymbols,
                index: idx,
                total: state.test.questions.count,
                existingText: state.answersText[q.id],
                selectedOptionId: state.answersOption[q.id],
                isBackEnabled: idx > 0,
                isNextEnabled: idx < state.test.questions.count - 1
            )
            qvc.displayQuestion(vm)
            lastHandledIndex = idx
            return
        }

        // 2) Иначе — обновляем Overview
        if let overview = overviewVC {
            overview.displayOverview(
                title: state.test.title,
                questions: state.test.questions.map { $0.title },
                remainingSeconds: state.remainingSeconds
            )
            startTimer(remainingSeconds: state.remainingSeconds)
            if lastHandledIndex == nil { lastHandledIndex = state.currentIndex }
            return
        }

        // 3) Иначе — ничего (assembly должен привязать overviewVC)
    }
    
    func didFailLoad(error: Error) {
        if let vc = overviewVC ?? questionVC {
            let a = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            a.addAction(UIAlertAction(title: "OK", style: .default))
            vc.present(a, animated: true)
        }
    }
    
    // Навигация на вопрос
    func routeToQuestion(at index: Int, using state: TestState) {
        guard let nav = overviewVC?.navigationController,
              state.test.questions.indices.contains(index) else {
            print("routeToQuestion aborted: no nav or invalid index")
            return
        }
        guard let makeQVC = createQuestionVC else {
            print("routeToQuestion aborted: createQuestionVC factory not set")
            return
        }
        
        let qvc = makeQVC()      // фабрика должна выставить qvc.interactor
        self.questionVC = qvc    // держим слабую ссылку
        nav.pushViewController(qvc, animated: true)
        
        // начальная отрисовка вопроса
        let q = state.test.questions[index]
        let vm = QuestionViewModel(
            id: q.id,
            title: q.title,
            type: q.type,
            options: q.options,
            minSymbols: q.minSymbols,
            index: index,
            total: state.test.questions.count,
            existingText: state.answersText[q.id],
            selectedOptionId: state.answersOption[q.id],
            isBackEnabled: index > 0,
            isNextEnabled: index < state.test.questions.count - 1
        )
        qvc.displayQuestion(vm)
        lastHandledIndex = index
    }
    
    func shouldNavigateToQuestion(index: Int, state: TestState) {
        routeToQuestion(at: index, using: state)
    }
    
    func didSaveAnswer(state: TestState, for questionId: String) {
        // refresh overview if visible
        if let overview = overviewVC {
            overview.displayOverview(title: state.test.title,
                                     questions: state.test.questions.map { $0.title },
                                     remainingSeconds: state.remainingSeconds)
        }
        // if currently on question, update it using state
        if let qvc = questionVC {
            let idx = state.currentIndex
            guard state.test.questions.indices.contains(idx) else { return }
            let q = state.test.questions[idx]
            let vm = QuestionViewModel(
                id: q.id,
                title: q.title,
                type: q.type,
                options: q.options,
                minSymbols: q.minSymbols,
                index: idx,
                total: state.test.questions.count,
                existingText: state.answersText[q.id],
                selectedOptionId: state.answersOption[q.id],
                isBackEnabled: idx > 0,
                isNextEnabled: idx < state.test.questions.count - 1
            )
            qvc.displayQuestion(vm)
        }
    }
    
    // Таймер
    private func startTimer(remainingSeconds: Int) {
        stopTimer()
        endDate = Date().addingTimeInterval(TimeInterval(remainingSeconds))
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func tick() {
        guard let end = endDate else { return }
        let remaining = max(0, Int(end.timeIntervalSinceNow))
        overviewVC?.updateTimer(remaining: remaining)
        if remaining == 0 {
            // optionally notify interactor to finish if desired
        }
    }
}
