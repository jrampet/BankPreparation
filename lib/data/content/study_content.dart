import '../../domain/study_models.dart';

const exams = [
  Exam(
    id: 'ibps_po',
    name: 'IBPS Probationary Officer',
    shortName: 'IBPS PO',
    category: 'Banking',
  ),
  Exam(
    id: 'ibps_clerk',
    name: 'IBPS Customer Service Associate',
    shortName: 'IBPS Clerk',
    category: 'Banking',
  ),
  Exam(
    id: 'ibps_rrb_po',
    name: 'IBPS RRB Officer Scale I',
    shortName: 'IBPS RRB PO',
    category: 'Banking',
  ),
  Exam(
    id: 'ibps_rrb_clerk',
    name: 'IBPS RRB Office Assistant',
    shortName: 'IBPS RRB Clerk',
    category: 'Banking',
  ),
  Exam(
    id: 'rrb_ntpc',
    name: 'Railway Recruitment Board NTPC',
    shortName: 'RRB NTPC',
    category: 'Railways',
  ),
  Exam(
    id: 'rrb_group_d',
    name: 'Railway Recruitment Board Group D',
    shortName: 'RRB Group D',
    category: 'Railways',
  ),
  Exam(
    id: 'rrb_alp',
    name: 'Railway Recruitment Board Assistant Loco Pilot',
    shortName: 'RRB ALP',
    category: 'Railways',
  ),
  Exam(
    id: 'rrb_je',
    name: 'Railway Recruitment Board Junior Engineer',
    shortName: 'RRB JE',
    category: 'Railways',
  ),
];

const topics = [
  StudyTopic(
    id: 'percentages',
    title: 'Percentages',
    subject: 'Quantitative Aptitude',
    icon: '％',
    durationMinutes: 5,
    concept: 'Percent means “per hundred”. A percentage compares a part with a whole, with the whole treated as 100.',
    formula: 'Percentage = (part ÷ whole) × 100',
    example: 'If 18 out of 60 questions are correct, the score is (18 ÷ 60) × 100 = 30%.',
    questions: [
      StudyQuestion(
        id: 'pct_1',
        prompt: 'What is 25% of 240?',
        options: ['40', '50', '60', '80'],
        answerIndex: 2,
        explanation: '25% is one quarter. 240 ÷ 4 = 60.',
      ),
      StudyQuestion(
        id: 'pct_2',
        prompt:
            'A value rises from 80 to 100. What is the percentage increase?',
        options: ['20%', '25%', '24%', '125%'],
        answerIndex: 1,
        explanation:
            'Increase = 20. Divide by the original 80: (20 ÷ 80) × 100 = 25%.',
      ),
      StudyQuestion(
        id: 'pct_3',
        prompt: '40% of a number is 72. What is the number?',
        options: ['160', '170', '180', '200'],
        answerIndex: 2,
        explanation: 'Number = 72 ÷ 0.40 = 180.',
      ),
      StudyQuestion(
        id: 'pct_4',
        prompt: 'A ₹500 item is discounted by 10%. What is its sale price?',
        options: ['₹450', '₹460', '₹490', '₹550'],
        answerIndex: 0,
        explanation: '10% of ₹500 is ₹50. Sale price = ₹500 − ₹50 = ₹450.',
      ),
      StudyQuestion(
        id: 'pct_5',
        prompt: 'Express 3/8 as a percentage.',
        options: ['32.5%', '35%', '37.5%', '42.5%'],
        answerIndex: 2,
        explanation: '(3 ÷ 8) × 100 = 37.5%.',
      ),
    ],
  ),
  StudyTopic(
    id: 'number_system',
    title: 'Number System',
    subject: 'Quantitative Aptitude',
    icon: '∑',
    durationMinutes: 5,
    concept: 'A number can be classified as natural, whole, integer, rational or irrational. Divisibility rules help simplify calculations.',
    formula: 'For any integer n: dividend = divisor × quotient + remainder',
    example: 'When 47 is divided by 5, the quotient is 9 and remainder is 2: 47 = 5 × 9 + 2.',
    questions: [
      StudyQuestion(
        id: 'num_1',
        prompt: 'What is the remainder when 47 is divided by 5?',
        options: ['1', '2', '3', '4'],
        answerIndex: 1,
        explanation: '5 × 9 = 45; 47 − 45 = 2.',
      ),
      StudyQuestion(
        id: 'num_2',
        prompt: 'Which of these numbers is divisible by 9?',
        options: ['234', '235', '236', '238'],
        answerIndex: 0,
        explanation: 'The digit sum of 234 is 2 + 3 + 4 = 9, a multiple of 9.',
      ),
      StudyQuestion(
        id: 'num_3',
        prompt: 'What is the LCM of 6 and 8?',
        options: ['12', '18', '24', '48'],
        answerIndex: 2,
        explanation: 'The smallest number divisible by both 6 and 8 is 24.',
      ),
      StudyQuestion(
        id: 'num_4',
        prompt: 'Which is a prime number?',
        options: ['21', '27', '29', '33'],
        answerIndex: 2,
        explanation: '29 has no positive divisors other than 1 and 29.',
      ),
      StudyQuestion(
        id: 'num_5',
        prompt: 'What is the HCF of 18 and 30?',
        options: ['3', '6', '9', '12'],
        answerIndex: 1,
        explanation: 'The greatest number that divides both 18 and 30 is 6.',
      ),
    ],
  ),
  StudyTopic(
    id: 'ratio',
    title: 'Ratio & Proportion',
    subject: 'Quantitative Aptitude',
    icon: '÷',
    durationMinutes: 5,
    concept: 'A ratio compares quantities of the same kind. Keep units consistent and simplify both terms by their highest common factor.',
    formula: 'If a:b = c:d, then a × d = b × c',
    example:
        'The ratio 12:18 simplifies to 2:3 after dividing both terms by 6.',
    questions: [
      StudyQuestion(
        id: 'ratio_1',
        prompt: 'Simplify the ratio 24:36.',
        options: ['2:3', '3:4', '4:5', '6:7'],
        answerIndex: 0,
        explanation: 'Divide both terms by their HCF, 12: 24:36 = 2:3.',
      ),
      StudyQuestion(
        id: 'ratio_2',
        prompt: 'Divide 100 in the ratio 2:3. What is the smaller share?',
        options: ['20', '40', '50', '60'],
        answerIndex: 1,
        explanation:
            'There are 5 total parts. Each is 100 ÷ 5 = 20, so 2 parts = 40.',
      ),
      StudyQuestion(
        id: 'ratio_3',
        prompt: 'If 3:5 = x:20, what is x?',
        options: ['10', '12', '15', '18'],
        answerIndex: 1,
        explanation: '3/5 = x/20, so x = (3 × 20) ÷ 5 = 12.',
      ),
      StudyQuestion(
        id: 'ratio_4',
        prompt: 'Two amounts are in the ratio 4:7. If the first is 28, what is the second?',
        options: ['35', '42', '49', '56'],
        answerIndex: 2,
        explanation: '4 parts = 28, so 1 part = 7 and 7 parts = 49.',
      ),
      StudyQuestion(
        id: 'ratio_5',
        prompt: 'Convert 2.5 metres : 50 centimetres into simplest form.',
        options: ['1:2', '2:1', '5:1', '50:1'],
        answerIndex: 2,
        explanation: 'Convert to the same units: 250 cm : 50 cm = 5:1.',
      ),
    ],
  ),
  StudyTopic(
    id: 'averages',
    title: 'Averages',
    subject: 'Quantitative Aptitude',
    icon: 'μ',
    durationMinutes: 5,
    concept: 'The arithmetic mean shares a total equally across the observations. Use the total when one value is added or removed.',
    formula: 'Average = sum of observations ÷ number of observations',
    example: 'The average of 6, 8 and 10 is (6 + 8 + 10) ÷ 3 = 8.',
    questions: [
      StudyQuestion(
        id: 'avg_1',
        prompt: 'What is the average of 12, 18 and 24?',
        options: ['16', '18', '20', '22'],
        answerIndex: 1,
        explanation: '(12 + 18 + 24) ÷ 3 = 54 ÷ 3 = 18.',
      ),
      StudyQuestion(
        id: 'avg_2',
        prompt: 'The average of 5 numbers is 14. What is their sum?',
        options: ['19', '56', '70', '75'],
        answerIndex: 2,
        explanation: 'Sum = average × count = 14 × 5 = 70.',
      ),
      StudyQuestion(
        id: 'avg_3',
        prompt:
            'The average of 4 numbers is 10. Add 15; what is the new average?',
        options: ['10', '11', '12', '12.5'],
        answerIndex: 1,
        explanation: 'Original sum = 40. New sum = 55 across 5 numbers, so average = 11.',
      ),
      StudyQuestion(
        id: 'avg_4',
        prompt: 'The average age of 3 people is 20. A fourth person aged 24 joins. New average?',
        options: ['20', '21', '22', '24'],
        answerIndex: 1,
        explanation:
            'Total age = 3 × 20 = 60. New average = (60 + 24) ÷ 4 = 21.',
      ),
      StudyQuestion(
        id: 'avg_5',
        prompt: 'The average of 8 values is 25. If one value is 32, what is the average of the other 7?',
        options: ['23', '24', '25', '26'],
        answerIndex: 1,
        explanation:
            'Total = 8 × 25 = 200. Remaining total = 168; 168 ÷ 7 = 24.',
      ),
    ],
  ),
  StudyTopic(
    id: 'coding_decoding',
    title: 'Coding & Decoding',
    subject: 'Reasoning Ability',
    icon: '⌘',
    durationMinutes: 5,
    concept: 'Find the consistent transformation between letters or words. Check alphabet shifts, reverse order and position values.',
    formula: 'Alphabet position: A = 1, B = 2, …, Z = 26',
    example: 'With a +1 shift, CAT becomes DBU: each letter moves one place forward.',
    questions: [
      StudyQuestion(
        id: 'code_1',
        prompt: 'Using a +1 letter shift, how is DOG coded?',
        options: ['EPH', 'CNG', 'FQI', 'EOG'],
        answerIndex: 0,
        explanation: 'D→E, O→P and G→H, so DOG becomes EPH.',
      ),
      StudyQuestion(
        id: 'code_2',
        prompt: 'If each letter shifts back by 1, how is BANK coded?',
        options: ['CBOL', 'AZMJ', 'ABMJ', 'AZNK'],
        answerIndex: 1,
        explanation: 'B→A, A→Z, N→M and K→J.',
      ),
      StudyQuestion(
        id: 'code_3',
        prompt: 'If A=1, B=2, …, what is the value of CAB?',
        options: ['5', '6', '7', '8'],
        answerIndex: 1,
        explanation: 'C + A + B = 3 + 1 + 2 = 6.',
      ),
      StudyQuestion(
        id: 'code_4',
        prompt: 'In a code, every letter moves forward by 2. What is the code for MAP?',
        options: ['NBO', 'OCR', 'OCP', 'KYN'],
        answerIndex: 1,
        explanation: 'M→O, A→C and P→R, giving OCR.',
      ),
      StudyQuestion(
        id: 'code_5',
        prompt: 'If the word TRAIN is written backwards, what is the result?',
        options: ['NIART', 'NIRAT', 'RIANT', 'TIARN'],
        answerIndex: 0,
        explanation:
            'Read the letters from right to left: TRAIN becomes NIART.',
      ),
    ],
  ),
  StudyTopic(
    id: 'syllogism',
    title: 'Syllogisms',
    subject: 'Reasoning Ability',
    icon: '◎',
    durationMinutes: 5,
    concept: 'Judge conclusions only from the statements given. Do not rely on real-world assumptions or reverse a one-way statement.',
    formula: '“All A are B” does not mean “All B are A”.',
    example: 'All roses are flowers. Some flowers fade quickly. It does not follow that some roses fade quickly.',
    questions: [
      StudyQuestion(
        id: 'syl_1',
        prompt: 'Statements: All pens are tools. All tools are useful. Conclusion: All pens are useful.',
        options: [
          'Follows',
          'Does not follow',
          'Cannot be determined',
          'Contradicts',
        ],
        answerIndex: 0,
        explanation: 'Every pen is a tool, and every tool is useful; therefore every pen is useful.',
      ),
      StudyQuestion(
        id: 'syl_2',
        prompt: 'Statements: Some books are new. All new things are costly. Conclusion: Some books are costly.',
        options: ['Follows', 'Does not follow', 'Contradicts', 'None'],
        answerIndex: 0,
        explanation:
            'The books that are new must be costly, so some books are costly.',
      ),
      StudyQuestion(
        id: 'syl_3',
        prompt: 'Statements: All cats are animals. Conclusion: All animals are cats.',
        options: [
          'Follows',
          'Does not follow',
          'Both follow',
          'Cannot be determined',
        ],
        answerIndex: 1,
        explanation: 'The statement only places cats inside the group of animals; it cannot be reversed.',
      ),
      StudyQuestion(
        id: 'syl_4',
        prompt:
            'Statements: No cups are plates. Conclusion: Some cups are plates.',
        options: [
          'Follows',
          'Does not follow',
          'Both follow',
          'Cannot be determined',
        ],
        answerIndex: 1,
        explanation: 'The conclusion directly contradicts the statement that no cups are plates.',
      ),
      StudyQuestion(
        id: 'syl_5',
        prompt: 'Statements: Some cars are electric. All electric vehicles are quiet. Conclusion: Some cars are quiet.',
        options: ['Follows', 'Does not follow', 'Contradicts', 'None'],
        answerIndex: 0,
        explanation:
            'The electric cars belong to the group of quiet electric vehicles.',
      ),
    ],
  ),
  StudyTopic(
    id: 'grammar',
    title: 'Subject–Verb Agreement',
    subject: 'English Language',
    icon: 'Aa',
    durationMinutes: 5,
    concept: 'A verb agrees with its subject in number. Ignore phrases between the subject and verb when identifying the main subject.',
    formula: 'Singular subject → singular verb; plural subject → plural verb',
    example: '“The list of items is ready.” The subject is “list”, not “items”, so use “is”.',
    questions: [
      StudyQuestion(
        id: 'eng_1',
        prompt: 'Choose the correct sentence.',
        options: [
          'She go to work daily.',
          'She goes to work daily.',
          'She going to work daily.',
          'She gone to work daily.',
        ],
        answerIndex: 1,
        explanation: '“She” is third-person singular, so the simple present verb is “goes”.',
      ),
      StudyQuestion(
        id: 'eng_2',
        prompt: 'The bouquet of roses ___ on the table.',
        options: ['are', 'were', 'is', 'have'],
        answerIndex: 2,
        explanation:
            'The head subject is the singular noun “bouquet”, so use “is”.',
      ),
      StudyQuestion(
        id: 'eng_3',
        prompt: 'Neither of the answers ___ correct.',
        options: ['are', 'is', 'were', 'have'],
        answerIndex: 1,
        explanation:
            '“Neither” is treated as singular in this sentence, so use “is”.',
      ),
      StudyQuestion(
        id: 'eng_4',
        prompt: 'The players ___ ready for the match.',
        options: ['is', 'was', 'are', 'has'],
        answerIndex: 2,
        explanation: '“Players” is plural, so the correct verb is “are”.',
      ),
      StudyQuestion(
        id: 'eng_5',
        prompt: 'Each of the applicants ___ an identity card.',
        options: ['have', 'has', 'are having', 'were'],
        answerIndex: 1,
        explanation: '“Each” is singular, so it takes the singular verb “has”.',
      ),
    ],
  ),
  StudyTopic(
    id: 'indian_polity',
    title: 'Indian Polity: The Constitution',
    subject: 'General Awareness',
    icon: '⚖',
    durationMinutes: 5,
    concept: 'The Constitution of India is the supreme legal framework that defines government institutions, powers and citizens’ rights.',
    formula: 'Adopted: 26 November 1949 · Came into force: 26 January 1950',
    example: 'Republic Day marks the date the Constitution came into effect, not the date it was adopted.',
    questions: [
      StudyQuestion(
        id: 'pol_1',
        prompt: 'When did the Constitution of India come into force?',
        options: [
          '15 August 1947',
          '26 November 1949',
          '26 January 1950',
          '2 October 1950',
        ],
        answerIndex: 2,
        explanation: 'It came into force on 26 January 1950, celebrated as Republic Day.',
      ),
      StudyQuestion(
        id: 'pol_2',
        prompt: 'When was the Constitution of India adopted?',
        options: [
          '26 November 1949',
          '26 January 1950',
          '15 August 1947',
          '24 January 1950',
        ],
        answerIndex: 0,
        explanation: 'The Constituent Assembly adopted the Constitution on 26 November 1949.',
      ),
      StudyQuestion(
        id: 'pol_3',
        prompt: 'Which part of the Constitution contains Fundamental Rights?',
        options: ['Part I', 'Part II', 'Part III', 'Part IV'],
        answerIndex: 2,
        explanation:
            'Fundamental Rights are set out in Part III of the Constitution.',
      ),
      StudyQuestion(
        id: 'pol_4',
        prompt: 'Who is the constitutional head of the Union executive?',
        options: [
          'Prime Minister',
          'President',
          'Chief Justice',
          'Lok Sabha Speaker',
        ],
        answerIndex: 1,
        explanation:
            'The President is the constitutional head of the Union executive.',
      ),
      StudyQuestion(
        id: 'pol_5',
        prompt: 'Which body is the lower house of the Indian Parliament?',
        options: [
          'Rajya Sabha',
          'Lok Sabha',
          'Vidhan Parishad',
          'Supreme Court',
        ],
        answerIndex: 1,
        explanation: 'The Lok Sabha is the House of the People, or lower house of Parliament.',
      ),
    ],
  ),
];

const bankingTopicIds = {
  'percentages',
  'number_system',
  'ratio',
  'averages',
  'coding_decoding',
  'syllogism',
  'grammar',
  'indian_polity',
};

const railwayTopicIds = {
  'percentages',
  'number_system',
  'ratio',
  'averages',
  'coding_decoding',
  'syllogism',
  'indian_polity',
};

List<StudyTopic> topicsForExam(String examId) {
  final topicIds = examId.startsWith('ibps_')
      ? bankingTopicIds
      : railwayTopicIds;
  return topics.where((topic) => topicIds.contains(topic.id)).toList();
}

StudyTopic topicById(String id) => topics.firstWhere((topic) => topic.id == id);
