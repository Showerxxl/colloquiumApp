//
//  GradingResultsView.swift
//  colloquium_project
//
//  Created by AI Assistant
//

import SwiftUI

struct GradingResultsView: View {
    let gradingResult: GradingResult
    @State private var showingDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Заголовок
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title2)
                
                Text("Результаты автоматической проверки")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if gradingResult.gradingMethod != nil {
                    Text("Hugging Face")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
            }
            
            // Общий балл
            HStack {
                Text("Общая оценка:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(gradingResult.autoScore)/10")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(scoreColor(gradingResult.autoScore))
            }
            
            // Обратная связь
            if !gradingResult.autoFeedback.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Обратная связь:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(gradingResult.autoFeedback)
                        .font(.body)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .multilineTextAlignment(.leading)
                }
            }
            
            // Ошибка автоматической проверки
            if let error = gradingResult.autoGradeError {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ошибка проверки:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                    
                    Text(error)
                        .font(.body)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            
            // Детализация по вопросам
            if !gradingResult.questionScores.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Детализация по вопросам:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button(action: {
                            showingDetails.toggle()
                        }) {
                            Text(showingDetails ? "Скрыть" : "Показать")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    if showingDetails {
                        ForEach(Array(gradingResult.questionScores.keys.sorted()), id: \.self) { questionId in
                            if let questionScore = gradingResult.questionScores[questionId] {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("Вопрос \(questionId)")
                                            .font(.body)
                                            .fontWeight(.medium)
                                        
                                        Spacer()
                                        
                                        Text("\(questionScore.score)/10")
                                            .font(.body)
                                            .fontWeight(.semibold)
                                            .foregroundColor(scoreColor(questionScore.score))
                                    }
                                    
                                    if !questionScore.comment.isEmpty {
                                        Text(questionScore.comment)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .padding(.leading, 8)
                                    }
                                }
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                                .background(Color.gray.opacity(0.05))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            
            // Время проверки
            if let gradedAt = gradingResult.gradedAt {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Text("Проверено: \(gradedAt.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private func scoreColor(_ score: Int) -> Color {
        switch score {
        case 9...10:
            return .green
        case 7...8:
            return .blue
        case 5...6:
            return .orange
        default:
            return .red
        }
    }
}

struct GradingResultsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockResult = GradingResult(
            autoScore: 8,
            autoFeedback: "Хорошая работа! Есть небольшие неточности, но в целом ответы правильные.",
            questionScores: [
                "q1": QuestionScore(score: 10, comment: "Правильно"),
                "q2": QuestionScore(score: 6, comment: "Частично правильно")
            ],
            gradedAt: Date(),
            gradingMethod: "huggingface",
            autoGradeError: nil
        )
        
        GradingResultsView(gradingResult: mockResult)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
