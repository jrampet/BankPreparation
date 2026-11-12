import '../../domain/study_models.dart';

const syllabusCheckedOn = '9 November 2026';

const _ibpsOfficialHub = 'https://www.ibps.in/index.php/recruitment/';
const _ibpsRrbOfficialHub =
    'https://www.ibps.in/index.php/regional-rural-bank/';
const _rrbOfficialHub = 'https://rrb.indianrailways.gov.in/cencall/cen-list';
const _rrbApplicationPortal = 'https://www.rrbapply.gov.in/';

const _ibpsNote =
    'The official recruitment hub is linked, but the active cycle’s full '
    'notification could not be retrieved during this build. The stage and '
    'subject-area outline is an orientation guide and has not been verified '
    'against the active cycle. The topic lists are PrepQuest practice coverage, '
    'not an authority-prescribed exhaustive topic-by-topic syllabus. Confirm '
    'the current notice before relying on the exam pattern.';
const _rrbNote =
    'The Ministry of Railways official CEN index was reachable and checked on '
    'this date; the active post-specific detailed notices could not be retrieved '
    'for this build. Treat the subject areas and stage outline as a high-level '
    'orientation guide and verify them against the active CEN. Topic drills are '
    'curated PrepQuest practice coverage, not an official exhaustive syllabus.';

const examSyllabi = <String, ExamSyllabus>{
  'ibps_po': ExamSyllabus(
    examId: 'ibps_po',
    sections: [
      ExamSection(
        name: 'Preliminary examination',
        subjects: [
          'English Language',
          'Reasoning Ability',
          'Quantitative Aptitude',
        ],
        description: 'Objective screening areas listed for the PO preliminary stage; verify the active CRP notice for the exact structure.',
      ),
      ExamSection(
        name: 'Main examination',
        subjects: [
          'Reasoning & Computer Aptitude',
          'General / Economy / Banking Awareness',
          'English Language',
          'Data Analysis & Interpretation',
          'Descriptive English',
        ],
        description: 'Main-stage areas. Interview and other selection requirements are notice-specific.',
      ),
    ],
    sourceLabel: 'IBPS official recruitment notifications',
    sourceUrl: _ibpsOfficialHub,
    sourceCheckedOn: syllabusCheckedOn,
    noticeCycle: 'Check the active CRP-PO/MT notification',
    verificationNote: _ibpsNote,
  ),
  'ibps_clerk': ExamSyllabus(
    examId: 'ibps_clerk',
    sections: [
      ExamSection(
        name: 'Preliminary examination',
        subjects: [
          'English Language',
          'Reasoning Ability',
          'Numerical Ability',
        ],
        description: 'Objective screening areas; exact test structure can change by CRP.',
      ),
      ExamSection(
        name: 'Main examination',
        subjects: [
          'General / Financial Awareness',
          'General English',
          'Reasoning Ability',
          'Quantitative Aptitude',
          'Computer Aptitude',
        ],
        description: 'Main-stage areas. The current CRP uses the post name and structure specified in its notification.',
      ),
    ],
    sourceLabel: 'IBPS official recruitment notifications',
    sourceUrl: _ibpsOfficialHub,
    sourceCheckedOn: syllabusCheckedOn,
    noticeCycle: 'Check the active CRP-CSA notification',
    verificationNote: _ibpsNote,
  ),
  'ibps_rrb_po': ExamSyllabus(
    examId: 'ibps_rrb_po',
    sections: [
      ExamSection(
        name: 'Officer Scale I preliminary examination',
        subjects: ['Reasoning Ability', 'Quantitative Aptitude'],
        description:
            'Objective preliminary areas; verify the active CRP-RRB notice.',
      ),
      ExamSection(
        name: 'Officer Scale I main examination',
        subjects: [
          'Reasoning Ability',
          'Computer Knowledge',
          'General Awareness',
          'English Language or Hindi Language',
          'Quantitative Aptitude',
        ],
        description: 'Main-stage areas. Language choice and subsequent interview requirements are governed by the current notification.',
      ),
    ],
    sourceLabel: 'IBPS official Regional Rural Banks notices',
    sourceUrl: _ibpsRrbOfficialHub,
    sourceCheckedOn: syllabusCheckedOn,
    noticeCycle: 'Check the active CRP-RRB Officer Scale I notification',
    verificationNote: _ibpsNote,
  ),
  'ibps_rrb_clerk': ExamSyllabus(
    examId: 'ibps_rrb_clerk',
    sections: [
      ExamSection(
        name: 'Office Assistant preliminary examination',
        subjects: ['Reasoning Ability', 'Numerical Ability'],
        description:
            'Objective preliminary areas; verify the active CRP-RRB notice.',
      ),
      ExamSection(
        name: 'Office Assistant main examination',
        subjects: [
          'Reasoning Ability',
          'Computer Knowledge',
          'General Awareness',
          'English Language or Hindi Language',
          'Numerical Ability',
        ],
        description: 'Main-stage areas. The notification governs the language option and final selection process.',
      ),
    ],
    sourceLabel: 'IBPS official Regional Rural Banks notices',
    sourceUrl: _ibpsRrbOfficialHub,
    sourceCheckedOn: syllabusCheckedOn,
    noticeCycle: 'Check the active CRP-RRB Office Assistant notification',
    verificationNote: _ibpsNote,
  ),
  'rrb_ntpc': ExamSyllabus(
    examId: 'rrb_ntpc',
    sections: [
      ExamSection(
        name: 'Computer-based test subject areas',
        subjects: [
          'Mathematics',
          'General Intelligence & Reasoning',
          'General Awareness',
        ],
        description: 'Broad NTPC CBT areas. CBT stage, post level, typing or aptitude requirements vary by post and active CEN.',
      ),
    ],
    sourceLabel: 'Ministry of Railways official RRB CEN index',
    sourceUrl: _rrbOfficialHub,
    sourceCheckedOn: syllabusCheckedOn,
    noticeCycle: 'Use the current NTPC CEN listed by the RRBs',
    verificationNote: _rrbNote,
  ),
  'rrb_group_d': ExamSyllabus(
    examId: 'rrb_group_d',
    sections: [
      ExamSection(
        name: 'Computer-based test subject areas',
        subjects: [
          'Mathematics',
          'General Intelligence & Reasoning',
          'General Science',
          'General Awareness & Current Affairs',
        ],
        description: 'Broad Level 1 CBT areas. Physical efficiency and other requirements are governed by the active CEN.',
      ),
    ],
    sourceLabel: 'Ministry of Railways official RRB CEN index',
    sourceUrl: _rrbOfficialHub,
    sourceCheckedOn: syllabusCheckedOn,
    noticeCycle: 'Use the current Level 1 CEN listed by the RRBs',
    verificationNote: _rrbNote,
  ),
  'rrb_alp': ExamSyllabus(
    examId: 'rrb_alp',
    sections: [
      ExamSection(
        name: 'CBT 1 subject areas',
        subjects: [
          'Mathematics',
          'Mental Ability',
          'General Science',
          'General Awareness',
        ],
        description: 'Screening CBT. Later stages include technical/trade-specific assessment as specified by the active ALP CEN.',
      ),
      ExamSection(
        name: 'CBT 2 subject areas',
        subjects: [
          'Mathematics',
          'General Intelligence & Reasoning',
          'Basic Science & Engineering',
          'Relevant trade',
        ],
        description: 'Trade-specific requirements and Computer Based Aptitude Test applicability are notice-specific.',
      ),
    ],
    sourceLabel: 'Ministry of Railways official RRB CEN index',
    sourceUrl: _rrbOfficialHub,
    sourceCheckedOn: syllabusCheckedOn,
    noticeCycle: 'Use the current ALP CEN listed by the RRBs',
    verificationNote: _rrbNote,
  ),
  'rrb_je': ExamSyllabus(
    examId: 'rrb_je',
    sections: [
      ExamSection(
        name: 'CBT 1 subject areas',
        subjects: [
          'Mathematics',
          'General Intelligence & Reasoning',
          'General Awareness',
          'General Science',
        ],
        description: 'Screening areas. Exact structure must be confirmed in the active JE CEN.',
      ),
      ExamSection(
        name: 'CBT 2 subject areas',
        subjects: [
          'General Awareness',
          'Physics & Chemistry',
          'Basics of Computers & Applications',
          'Basics of Environment & Pollution Control',
          'Technical Abilities',
        ],
        description: 'Technical subject coverage depends on the notified post and discipline.',
      ),
    ],
    sourceLabel: 'Ministry of Railways official RRB CEN index',
    sourceUrl: _rrbOfficialHub,
    sourceCheckedOn: syllabusCheckedOn,
    noticeCycle: 'Use the current JE CEN listed by the RRBs',
    verificationNote: _rrbNote,
  ),
};

const practiceTopicsBySubject = <String, List<String>>{
  'Quantitative Aptitude': [
    'Number System',
    'Simplification',
    'Percentage',
    'Ratio and Proportion',
    'Average',
    'Profit and Loss',
    'Simple and Compound Interest',
    'Time and Work',
    'Pipes and Cisterns',
    'Speed, Time and Distance',
    'Trains',
    'Mixture and Alligation',
    'Data Interpretation',
    'Mensuration',
    'Number Series',
    'Quadratic Equations',
  ],
  'Numerical Ability': [
    'Number System',
    'Simplification',
    'Percentage',
    'Ratio and Proportion',
    'Average',
    'Profit and Loss',
    'Simple and Compound Interest',
    'Time and Work',
    'Pipes and Cisterns',
    'Speed, Time and Distance',
    'Trains',
    'Mixture and Alligation',
    'Data Interpretation',
    'Number Series',
  ],
  'Data Analysis & Interpretation': [
    'Data Interpretation',
    'Percentage',
    'Ratio and Proportion',
    'Average',
    'Number Series',
    'Quadratic Equations',
  ],
  'Reasoning Ability': [
    'Analogy',
    'Classification',
    'Coding and Decoding',
    'Blood Relations',
    'Direction Sense',
    'Ranking',
    'Syllogism',
    'Inequality',
    'Seating Arrangement',
    'Puzzles',
    'Alphanumeric Series',
    'Statement and Conclusion',
    'Input and Output',
    'Logical Reasoning',
  ],
  'General Intelligence & Reasoning': [
    'Analogy',
    'Classification',
    'Coding and Decoding',
    'Blood Relations',
    'Direction Sense',
    'Ranking',
    'Syllogism',
    'Seating Arrangement',
    'Puzzles',
    'Alphanumeric Series',
    'Statement and Conclusion',
    'Logical Reasoning',
  ],
  'Mental Ability': [
    'Analogy',
    'Classification',
    'Coding and Decoding',
    'Blood Relations',
    'Direction Sense',
    'Ranking',
    'Number Series',
  ],
  'English Language': [
    'Grammar',
    'Vocabulary',
    'Synonyms and Antonyms',
    'Error Detection',
    'Sentence Improvement',
    'Cloze Test',
    'Reading Comprehension',
    'Para Jumbles',
    'Fill in the Blanks',
    'Subject–Verb Agreement',
  ],
  'General English': [
    'Grammar',
    'Vocabulary',
    'Synonyms and Antonyms',
    'Error Detection',
    'Cloze Test',
    'Reading Comprehension',
    'Para Jumbles',
    'Fill in the Blanks',
    'Subject–Verb Agreement',
  ],
  'Descriptive English': [
    'Essay writing',
    'Email and letter writing',
    'Precis writing',
  ],
  'Reasoning & Computer Aptitude': [
    'Analogy',
    'Coding and Decoding',
    'Syllogism',
    'Inequality',
    'Seating Arrangement',
    'Puzzles',
    'Computer Fundamentals',
    'Operating Systems',
    'Networking and Internet',
    'Cyber Safety',
  ],
  'Computer Aptitude': [
    'Computer Fundamentals',
    'Operating Systems',
    'Networking and Internet',
    'Cyber Safety',
    'Office Applications',
  ],
  'Computer Knowledge': [
    'Computer Fundamentals',
    'Operating Systems',
    'Networking and Internet',
    'Cyber Safety',
    'Office Applications',
  ],
  'General / Economy / Banking Awareness': [
    'Banking Awareness',
    'Indian Economy',
    'Indian Polity',
    'Government Schemes',
    'Current Affairs',
    'Awards and Important Events',
  ],
  'General / Financial Awareness': [
    'Banking Awareness',
    'Indian Economy',
    'Indian Polity',
    'Government Schemes',
    'Current Affairs',
    'Awards and Important Events',
  ],
  'General Awareness': [
    'Indian History',
    'Indian Geography',
    'Indian Polity',
    'Indian Economy',
    'General Science',
    'Static GK',
    'Government Schemes',
    'Banking Awareness',
    'Computer Awareness',
    'Current Affairs',
  ],
  'General Awareness & Current Affairs': [
    'Indian History',
    'Indian Geography',
    'Indian Polity',
    'Indian Economy',
    'General Science',
    'Static GK',
    'Government Schemes',
    'Current Affairs',
  ],
  'General Science': ['Physics', 'Chemistry', 'Biology', 'Everyday Science'],
  'Basic Science & Engineering': [
    'Engineering Mechanics',
    'Electricity and Magnetism',
    'Materials and Measurements',
    'Basic Science',
  ],
  'Technical Abilities': [
    'Civil Engineering',
    'Mechanical Engineering',
    'Electrical Engineering',
    'Electronics Engineering',
    'Computer Engineering',
  ],
  'Relevant trade': ['Trade theory', 'Trade calculations', 'Workshop safety'],
  'Physics & Chemistry': ['Physics', 'Chemistry'],
  'Basics of Computers & Applications': [
    'Computer Fundamentals',
    'Operating Systems',
    'Networking and Internet',
    'Office Applications',
  ],
  'Basics of Environment & Pollution Control': [
    'Environment',
    'Pollution Control',
    'Waste Management',
  ],
  'English Language or Hindi Language': ['English Language', 'Hindi Language'],
};

const officialRrbApplicationUrl = _rrbApplicationPortal;
