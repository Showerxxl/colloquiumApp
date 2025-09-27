//
//  TestPresenter.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 20.09.2025.
//

import UIKit

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
            qvc.updateTimer(remaining: state.remainingSeconds)
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
        qvc.updateTimer(remaining: state.remainingSeconds)
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
    
    func routeMenu() {
        DispatchQueue.main.async {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = scene.windows.first else { return }

            let next = StudentColloquiumAssembly.make()

            if let nav = window.rootViewController as? UINavigationController {
                nav.setViewControllers([next], animated: true)
            } else {
                let nav = UINavigationController(rootViewController: next)
                window.rootViewController = nav
                window.makeKeyAndVisible()
            }
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
        questionVC?.updateTimer(remaining: remaining)
        if remaining == 0 {
            // optionally notify interactor to finish if desired
        }
    }
}
