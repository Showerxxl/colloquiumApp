# Подробное объяснение автоматической проверки

## 🔄 **Полный процесс проверки**

### 1. **Источники данных**

#### В тестовой версии:
```swift
// Вопросы захардкожены в AutoGradingTestView
let testQuestions = [
    TestQuestion(
        id: "q1",
        text: "Что такое enum в Swift?",
        type: "single_choice",
        options: [...],
        correctOptionIds: ["a"]
    )
]

// Ответы тоже захардкожены
let testAnswers: [String: Any] = [
    "q1": ["selectedOptionIds": ["a"]],
    "q2": ["text": "Инкапсуляция, наследование, полиморфизм"]
]
```

#### В настоящем приложении:
```swift
// Вопросы загружаются из Firestore
colloquia/{colloquiumId}/questions/{questionId}
├── order: 1
├── type: "single_choice"
├── text: "Что такое enum в Swift?"
├── options: [{"id": "a", "text": "Перечисление"}]
└── correctOptionIds: ["a"]

// Ответы приходят от пользователя через UI
answers: {
    "q1": {"selectedOptionIds": ["a"]},
    "q2": {"text": "Пользовательский ответ"}
}
```

### 2. **Поток данных**

```
Пользователь заполняет форму
        ↓
Ответы сохраняются в submission
        ↓
Статус меняется на "submitted"
        ↓
Cloud Function срабатывает автоматически
        ↓
Загружаются вопросы из Firestore
        ↓
Формируется промпт для LLM
        ↓
Отправляется запрос к Hugging Face
        ↓
Результат сохраняется в Firestore
        ↓
iOS получает результат через listener
```

### 3. **Формирование промпта для LLM**

```javascript
// В Cloud Function
function buildGradingPrompt(questions, answers) {
  let prompt = "Оцените ответы студента по шкале от 0 до 10 баллов:\n\n";
  
  questions.forEach((question, index) => {
    prompt += `Вопрос ${index + 1}:\n`;
    prompt += `Текст: ${question.text}\n`;
    
    if (question.options) {
      prompt += `Варианты: ${question.options.map(opt => `${opt.id}. ${opt.text}`).join(', ')}\n`;
    }
    
    if (question.correctOptionIds) {
      prompt += `Правильные ответы: ${question.correctOptionIds.join(', ')}\n`;
    }
    
    const answer = answers[question.id];
    if (answer.selectedOptionIds) {
      prompt += `Ответ студента: ${answer.selectedOptionIds.join(', ')}\n`;
    }
    if (answer.text) {
      prompt += `Текстовый ответ: ${answer.text}\n`;
    }
    
    prompt += `Оценка (0-10): `;
  });
  
  return prompt;
}
```

### 4. **Обработка ответа LLM**

```javascript
// Парсинг ответа от Hugging Face
function parseLLMResponse(response) {
  const numbers = response.match(/\d+/g) || [];
  let totalScore = 5; // По умолчанию
  
  if (numbers.length > 0) {
    const score = parseInt(numbers[0]);
    if (score >= 0 && score <= 10) {
      totalScore = score;
    }
  }
  
  let feedback = '';
  if (totalScore >= 9) {
    feedback = 'Отличная работа! Ответы демонстрируют глубокое понимание материала.';
  } else if (totalScore >= 7) {
    feedback = 'Хорошая работа! Есть небольшие неточности, но в целом ответы правильные.';
  }
  // ... и т.д.
  
  return { totalScore, feedback, questionScores: {} };
}
```

## 🚀 **Как интегрировать с настоящими данными**

### Шаг 1: Создать настоящий экран коллоквиума

```swift
struct ColloquiumView: View {
    @StateObject private var viewModel = ColloquiumViewModel()
    let colloquiumId: String
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Загрузка вопросов...")
            } else {
                ForEach(viewModel.questions, id: \.id) { question in
                    QuestionView(question: question, answer: $viewModel.answers[question.id])
                }
                
                Button("Отправить на проверку") {
                    viewModel.submitAnswers()
                }
            }
        }
        .onAppear {
            viewModel.loadQuestions(colloquiumId: colloquiumId)
        }
    }
}
```

### Шаг 2: ViewModel для настоящего коллоквиума

```swift
class ColloquiumViewModel: ObservableObject {
    @Published var questions: [ColloquiumQuestion] = []
    @Published var answers: [String: Any] = [:]
    @Published var isLoading = false
    @Published var gradingResult: GradingResult?
    
    private let colloquiumService = ColloquiumService()
    private let autoGradingService = AutoGradingService() // Настоящий сервис!
    private var submissionId: String?
    
    func loadQuestions(colloquiumId: String) {
        isLoading = true
        colloquiumService.fetchQuestions(colloquiumId: colloquiumId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let questions):
                    self?.questions = questions
                case .failure(let error):
                    print("Ошибка загрузки вопросов: \(error)")
                }
            }
        }
    }
    
    func submitAnswers() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Создаем submission с настоящими ответами
        autoGradingService.createSubmission(
            userId: userId,
            colloquiumId: colloquiumId,
            answers: answers
        ) { [weak self] result in
            switch result {
            case .success(let submissionId):
                self?.submissionId = submissionId
                self?.submitForGrading(submissionId: submissionId)
            case .failure(let error):
                print("Ошибка создания submission: \(error)")
            }
        }
    }
    
    private func submitForGrading(submissionId: String) {
        autoGradingService.submitForAutoGrading(submissionId: submissionId) { [weak self] error in
            if let error = error {
                print("Ошибка отправки на проверку: \(error)")
                return
            }
            
            // Слушаем результаты
            self?.listenToResults(submissionId: submissionId)
        }
    }
    
    private func listenToResults(submissionId: String) {
        autoGradingService.listenToAutoGradingResults(submissionId: submissionId) { [weak self] result in
            DispatchQueue.main.async {
                self?.gradingResult = result
            }
        }
    }
}
```

### Шаг 3: Компонент для отображения вопроса

```swift
struct QuestionView: View {
    let question: ColloquiumQuestion
    @Binding var answer: Any?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(question.text)
                .font(.headline)
            
            switch question.type {
            case .singleChoice, .multipleChoice:
                ForEach(question.options, id: \.id) { option in
                    Button(action: {
                        handleOptionSelection(option.id)
                    }) {
                        HStack {
                            Image(systemName: isOptionSelected(option.id) ? "checkmark.circle.fill" : "circle")
                            Text(option.text)
                            Spacer()
                        }
                    }
                }
                
            case .open:
                TextField("Введите ответ", text: Binding(
                    get: { (answer as? [String: String])?["text"] ?? "" },
                    set: { newValue in
                        answer = ["text": newValue]
                    }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding()
    }
    
    private func handleOptionSelection(_ optionId: String) {
        if question.type == .singleChoice {
            answer = ["selectedOptionIds": [optionId]]
        } else {
            // Multiple choice logic
            var selectedIds = (answer as? [String: [String]])?["selectedOptionIds"] ?? []
            if selectedIds.contains(optionId) {
                selectedIds.removeAll { $0 == optionId }
            } else {
                selectedIds.append(optionId)
            }
            answer = ["selectedOptionIds": selectedIds]
        }
    }
    
    private func isOptionSelected(_ optionId: String) -> Bool {
        let selectedIds = (answer as? [String: [String]])?["selectedOptionIds"] ?? []
        return selectedIds.contains(optionId)
    }
}
```

### Шаг 4: Переключение с Mock на настоящий сервис

```swift
// В ColloquiumViewModel замените:
private let autoGradingService = MockAutoGradingService()

// На:
private let autoGradingService = AutoGradingService()
```

### Шаг 5: Деплой Cloud Functions

```bash
# Обновите план Firebase на Blaze
# Затем деплойте функции:
firebase deploy --only functions
```

## 📊 **Структура данных в Firestore**

### Коллоквиум:
```
colloquia/{colloquiumId}
├── title: "Математика. Коллоквиум №1"
├── startsAt: timestamp
├── endsAt: timestamp
└── isActive: true
```

### Вопросы:
```
colloquia/{colloquiumId}/questions/{questionId}
├── order: 1
├── type: "single_choice"
├── text: "Сколько будет 2+2?"
├── options: [
│   {"id": "A", "text": "3"},
│   {"id": "B", "text": "4"},
│   {"id": "C", "text": "5"}
│ ]
└── correctOptionIds: ["B"]
```

### Ответы пользователя:
```
submissions/{submissionId}
├── userId: "uid_123"
├── colloquiumId: "col_1"
├── status: "submitted"
├── answers: {
│   "q1": {"selectedOptionIds": ["B"]},
│   "q2": {"text": "Развернутый ответ..."}
│ }
├── autoGraded: true
├── autoScore: 8
├── autoFeedback: "Хорошая работа!"
└── gradedAt: timestamp
```

## 🎯 **Итоговый процесс**

1. **Пользователь заходит в коллоквиум** → загружаются вопросы из Firestore
2. **Заполняет ответы** → сохраняются в локальном состоянии
3. **Нажимает "Отправить"** → создается submission в Firestore
4. **Cloud Function срабатывает** → автоматически вызывается при изменении статуса
5. **LLM проверяет ответы** → отправляется запрос к Hugging Face
6. **Результат сохраняется** → оценка и обратная связь записываются в Firestore
7. **UI обновляется** → пользователь видит результат через listener

Это полная интеграция автоматической проверки с настоящими данными!
