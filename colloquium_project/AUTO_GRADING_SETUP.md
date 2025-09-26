# Настройка автоматической проверки с Hugging Face

## Что уже настроено

✅ **Cloud Functions** - создан файл `functions/index.js` с интеграцией Hugging Face API
✅ **Firestore правила** - настроены правила безопасности в `firestore.rules`
✅ **iOS сервисы** - созданы `AutoGradingService.swift` и `MockAutoGradingService.swift`
✅ **UI компоненты** - созданы `GradingResultsView.swift` и `AutoGradingTestView.swift`
✅ **Модели данных** - созданы `Colloquium.swift` с поддержкой автоматической проверки

## Что нужно сделать для полной работы

### 1. Обновить план Firebase
- Перейдите в [Firebase Console](https://console.firebase.google.com/project/ios-colloquium/usage/details)
- Обновите план на **Blaze (pay-as-you-go)**
- Это необходимо для работы Cloud Functions

### 2. Деплой Cloud Functions
```bash
firebase deploy --only functions
```

### 3. Деплой правил Firestore
```bash
firebase deploy --only firestore:rules
```

### 4. Деплой индексов Firestore
```bash
firebase deploy --only firestore:indexes
```

## Как использовать в приложении

### Переключение с Mock на реальный сервис

В файле `AutoGradingTestView.swift` замените:
```swift
private let autoGradingService = MockAutoGradingService()
```

На:
```swift
private let autoGradingService = AutoGradingService()
```

### Добавление экрана в навигацию

Добавьте `AutoGradingTestView` в вашу навигацию для тестирования:

```swift
NavigationLink("Тест автопроверки") {
    AutoGradingTestView()
}
```

## Структура данных в Firestore

### Коллоквиумы
```
colloquia/{colloquiumId}
├── title: string
├── description: string
├── startsAt: timestamp
├── endsAt: timestamp
├── isActive: boolean
└── createdAt: timestamp
```

### Вопросы
```
colloquia/{colloquiumId}/questions/{questionId}
├── order: number
├── type: string (single_choice, multiple_choice, text)
├── text: string
├── options: array
├── correctOptionIds: array
└── minSymbols: number
```

### Ответы пользователей
```
submissions/{submissionId}
├── userId: string
├── colloquiumId: string
├── status: string (draft, submitted, graded)
├── answers: map
├── createdAt: timestamp
├── updatedAt: timestamp
├── autoGraded: boolean
├── autoScore: number
├── autoFeedback: string
├── gradedAt: timestamp
├── questionScores: map
├── gradingMethod: string
└── autoGradeError: string
```

## Как работает автоматическая проверка

1. **Пользователь отправляет ответы** - статус меняется на "submitted"
2. **Cloud Function срабатывает** - автоматически вызывается при изменении статуса
3. **Hugging Face API** - отправляется запрос с промптом для проверки
4. **Результат сохраняется** - оценка и обратная связь записываются в Firestore
5. **iOS получает результат** - через listener обновляется UI

## Тестирование

1. Запустите приложение
2. Перейдите в "Тест автопроверки"
3. Нажмите "Отправить на автоматическую проверку"
4. Дождитесь результата (2-3 секунды в Mock версии)

## Альтернативные LLM API

Если Hugging Face не подходит, можно заменить в `functions/index.js`:

### Google Gemini (бесплатно с лимитами)
```javascript
const response = await fetch('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    contents: [{ parts: [{ text: prompt }] }],
    generationConfig: { temperature: 0.3, maxOutputTokens: 1000 }
  })
});
```

### OpenAI (требует API ключ)
```javascript
const openai = new OpenAI({ apiKey: functions.config().openai.key });
const completion = await openai.chat.completions.create({
  model: "gpt-4o-mini",
  messages: [{ role: "user", content: prompt }],
  temperature: 0.3
});
```

## Troubleshooting

### Ошибка "API not enabled"
- Убедитесь, что план Firebase обновлен на Blaze
- Проверьте, что Cloud Functions API включен

### Ошибка "Permission denied"
- Проверьте правила Firestore
- Убедитесь, что пользователь авторизован

### Hugging Face API недоступен
- Функция автоматически переключится на правило-основанное оценивание
- Проверьте логи Cloud Functions в Firebase Console
