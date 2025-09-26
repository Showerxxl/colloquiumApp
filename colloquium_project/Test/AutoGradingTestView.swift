//
//  AutoGradingTestView.swift
//  colloquium_project
//
//  Created by AI Assistant
//

import SwiftUI
import FirebaseAuth

struct AutoGradingTestView: View {
    @StateObject private var viewModel = AutoGradingTestViewModel()
    @State private var showingResults = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        
                        Text("Отправка на проверку...")
                            .font(.headline)
                        
                        Text("Используется Hugging Face API для автоматической проверки ответов")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let gradingResult = viewModel.gradingResult {
                    ScrollView {
                        VStack(spacing: 16) {
                            GradingResultsView(gradingResult: gradingResult)
                                .padding()
                            
                            Button("Проверить снова") {
                                viewModel.resetTest()
                            }
                            .buttonStyle(.borderedProminent)
                            .padding()
                        }
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        
                        Text("Ошибка")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(errorMessage)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        
                        Button("Попробовать снова") {
                            viewModel.resetTest()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            Text("Тест автоматической проверки")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Этот тест демонстрирует работу автоматической проверки ответов с помощью Hugging Face API")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Тестовые вопросы:")
                                    .font(.headline)
                                
                                ForEach(viewModel.testQuestions.indices, id: \.self) { index in
                                    let question = viewModel.testQuestions[index]
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(index + 1). \(question.text)")
                                            .font(.body)
                                        
                                        if !question.options.isEmpty {
                                            Text("Варианты: \(question.options.map { $0.text }.joined(separator: ", "))")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            
                            VStack(spacing: 12) {
                                Button("Отправить на автоматическую проверку") {
                                    viewModel.submitForGrading()
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(viewModel.isLoading)
                                
                                Text("Используется Mock сервис для демонстрации")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Автопроверка")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.setupTest()
        }
    }
}

class AutoGradingTestViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var gradingResult: GradingResult?
    @Published var errorMessage: String?
    
    // Используем Mock сервис для демонстрации
    private let autoGradingService = MockAutoGradingService()
    private var currentSubmissionId: String?
    
    let testQuestions = [
        TestQuestion(
            id: "q1",
            text: "Что такое enum в Swift?",
            type: "single_choice",
            options: [
                TestOption(id: "a", text: "Перечисление"),
                TestOption(id: "b", text: "Класс"),
                TestOption(id: "c", text: "Структура")
            ],
            correctOptionIds: ["a"]
        ),
        TestQuestion(
            id: "q2",
            text: "Назовите основные принципы ООП",
            type: "text",
            options: [],
            correctOptionIds: []
        ),
        TestQuestion(
            id: "q3",
            text: "Какой протокол используется для сериализации?",
            type: "single_choice",
            options: [
                TestOption(id: "a", text: "Serializable"),
                TestOption(id: "b", text: "Codable"),
                TestOption(id: "c", text: "Encodable")
            ],
            correctOptionIds: ["b"]
        )
    ]
    
    func setupTest() {
        resetTest()
    }
    
    func submitForGrading() {
        // Используем тестовый userId для демонстрации без авторизации
        let userId = Auth.auth().currentUser?.uid ?? "test_user_\(UUID().uuidString.prefix(8))"
        
        isLoading = true
        errorMessage = nil
        
        // Создаем тестовые ответы
        let testAnswers: [String: Any] = [
            "q1": ["selectedOptionIds": ["a"]],
            "q2": ["text": "Инкапсуляция, наследование, полиморфизм"],
            "q3": ["selectedOptionIds": ["b"]]
        ]
        
        // Создаем submission
        autoGradingService.createSubmission(
            userId: userId,
            colloquiumId: "test_colloquium",
            answers: testAnswers
        ) { [weak self] result in
            switch result {
            case .success(let submissionId):
                self?.currentSubmissionId = submissionId
                self?.submitForAutoGrading(submissionId: submissionId)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = "Ошибка создания submission: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func submitForAutoGrading(submissionId: String) {
        autoGradingService.submitForAutoGrading(submissionId: submissionId) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = "Ошибка отправки на проверку: \(error.localizedDescription)"
                }
                return
            }
            
            // Начинаем прослушивание результатов
            self?.listenToGradingResults(submissionId: submissionId)
        }
    }
    
    private func listenToGradingResults(submissionId: String) {
        autoGradingService.listenToAutoGradingResults(submissionId: submissionId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.gradingResult = result
            }
        }
    }
    
    func resetTest() {
        gradingResult = nil
        errorMessage = nil
        isLoading = false
        currentSubmissionId = nil
        autoGradingService.stopListeningToGradingResults()
    }
}

struct TestQuestion {
    let id: String
    let text: String
    let type: String
    let options: [TestOption]
    let correctOptionIds: [String]
}

struct TestOption {
    let id: String
    let text: String
}

struct AutoGradingTestView_Previews: PreviewProvider {
    static var previews: some View {
        AutoGradingTestView()
    }
}
