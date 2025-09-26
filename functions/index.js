const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// Функция для автоматической проверки ответов с помощью Hugging Face
exports.autoGradeSubmission = functions.firestore
  .document('submissions/{submissionId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    
    // Проверяем, что статус изменился на "submitted"
    if (before.status !== 'submitted' && after.status === 'submitted') {
      const submissionId = context.params.submissionId;
      
      try {
        console.log(`Начинаем автоматическую проверку для submission: ${submissionId}`);
        
        // Получаем вопросы коллоквиума
        const questionsSnapshot = await admin.firestore()
          .collection('colloquia')
          .doc(after.colloquiumId)
          .collection('questions')
          .orderBy('order')
          .get();
        
        const questions = questionsSnapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data()
        }));
        
        console.log(`Найдено ${questions.length} вопросов для проверки`);
        
        // Формируем промпт для LLM
        const gradingPrompt = buildGradingPrompt(questions, after.answers);
        
        // Вызываем Hugging Face API
        const gradingResult = await callHuggingFaceAPI(gradingPrompt);
        
        console.log(`Результат проверки: ${gradingResult.totalScore}/10`);
        
        // Обновляем submission с результатами
        await admin.firestore()
          .collection('submissions')
          .doc(submissionId)
          .update({
            autoGraded: true,
            autoScore: gradingResult.totalScore,
            autoFeedback: gradingResult.feedback,
            gradedAt: admin.firestore.FieldValue.serverTimestamp(),
            questionScores: gradingResult.questionScores,
            gradingMethod: 'huggingface'
          });
          
        console.log(`Автоматическая проверка завершена для submission: ${submissionId}`);
          
      } catch (error) {
        console.error('Ошибка автоматической проверки:', error);
        
        // Помечаем как ошибку автоматической проверки
        await admin.firestore()
          .collection('submissions')
          .doc(submissionId)
          .update({
            autoGraded: false,
            autoGradeError: error.message,
            gradingMethod: 'huggingface'
          });
      }
    }
  });

// Функция для вызова Hugging Face API
async function callHuggingFaceAPI(prompt) {
  try {
    // Используем модель microsoft/DialoGPT-medium для генерации текста
    const response = await fetch('https://api-inference.huggingface.co/models/microsoft/DialoGPT-medium', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        inputs: prompt,
        parameters: {
          max_length: 300,
          temperature: 0.3,
          do_sample: true,
          return_full_text: false
        }
      })
    });
    
    if (!response.ok) {
      console.error(`Hugging Face API error: ${response.status} ${response.statusText}`);
      throw new Error(`Hugging Face API error: ${response.status}`);
    }
    
    const data = await response.json();
    console.log('Hugging Face API response:', data);
    
    // Парсим ответ
    return parseHuggingFaceResponse(data[0]?.generated_text || '');
    
  } catch (error) {
    console.error('Ошибка вызова Hugging Face API:', error);
    
    // Fallback к простому правилу-основанному оцениванию
    return await fallbackRuleBasedGrading(prompt);
  }
}

// Формирование промпта для проверки
function buildGradingPrompt(questions, answers) {
  let prompt = "Оцените ответы студента по шкале от 0 до 10 баллов за каждый вопрос:\n\n";
  
  questions.forEach((question, index) => {
    prompt += `Вопрос ${index + 1}:\n`;
    prompt += `Текст: ${question.text || question.title}\n`;
    
    if (question.options && question.options.length > 0) {
      prompt += `Варианты ответов:\n`;
      question.options.forEach(option => {
        prompt += `- ${option.id}: ${option.text}\n`;
      });
    }
    
    if (question.correctOptionIds) {
      prompt += `Правильные ответы: ${question.correctOptionIds.join(', ')}\n`;
    }
    
    const answer = answers[question.id];
    if (answer) {
      if (answer.selectedOptionIds) {
        prompt += `Ответ студента: ${answer.selectedOptionIds.join(', ')}\n`;
      }
      if (answer.text) {
        prompt += `Текстовый ответ студента: ${answer.text}\n`;
      }
    } else {
      prompt += `Ответ студента: Нет ответа\n`;
    }
    
    prompt += `Оценка (0-10): `;
  });
  
  prompt += `\n\nДайте общую оценку и краткий комментарий.`;
  
  return prompt;
}

// Парсинг ответа от Hugging Face
function parseHuggingFaceResponse(response) {
  console.log('Парсинг ответа Hugging Face:', response);
  
  // Простой парсинг для демонстрации
  const numbers = response.match(/\d+/g) || [];
  let totalScore = 5; // По умолчанию средняя оценка
  
  if (numbers.length > 0) {
    const score = parseInt(numbers[0]);
    if (score >= 0 && score <= 10) {
      totalScore = score;
    }
  }
  
  // Определяем обратную связь на основе оценки
  let feedback = '';
  if (totalScore >= 9) {
    feedback = 'Отличная работа! Ответы демонстрируют глубокое понимание материала.';
  } else if (totalScore >= 7) {
    feedback = 'Хорошая работа! Есть небольшие неточности, но в целом ответы правильные.';
  } else if (totalScore >= 5) {
    feedback = 'Удовлетворительно. Некоторые ответы требуют доработки.';
  } else {
    feedback = 'Требуется дополнительная подготовка по данной теме.';
  }
  
  return {
    totalScore,
    feedback,
    questionScores: {} // Для простоты пока не парсим детальные оценки
  };
}

// Fallback функция с правилами
async function fallbackRuleBasedGrading(prompt) {
  console.log('Используем fallback правило-основанное оценивание');
  
  // Простая логика на основе ключевых слов в промпте
  let score = 5; // Базовая оценка
  
  if (prompt.includes('Нет ответа') || prompt.includes('Пустой ответ')) {
    score = 0;
  } else if (prompt.includes('Правильный ответ') || prompt.includes('правильно')) {
    score = 9;
  } else if (prompt.includes('Частично правильно') || prompt.includes('частично')) {
    score = 6;
  } else if (prompt.includes('Неправильный ответ') || prompt.includes('неправильно')) {
    score = 2;
  }
  
  let feedback = '';
  if (score >= 9) {
    feedback = 'Отличная работа! Все ответы правильные.';
  } else if (score >= 7) {
    feedback = 'Хорошая работа! Есть небольшие ошибки.';
  } else if (score >= 5) {
    feedback = 'Удовлетворительно. Нужно больше внимания к деталям.';
  } else {
    feedback = 'Требуется дополнительная подготовка.';
  }
  
  return {
    totalScore: score,
    feedback,
    questionScores: {}
  };
}

// HTTP функция для тестирования
exports.testGrading = functions.https.onRequest(async (req, res) => {
  try {
    const { questions, answers } = req.body;
    
    if (!questions || !answers) {
      return res.status(400).json({ error: 'Требуются questions и answers' });
    }
    
    const gradingPrompt = buildGradingPrompt(questions, answers);
    const result = await callHuggingFaceAPI(gradingPrompt);
    
    res.json({
      success: true,
      result,
      prompt: gradingPrompt
    });
    
  } catch (error) {
    console.error('Ошибка тестирования:', error);
    res.status(500).json({ error: error.message });
  }
});
