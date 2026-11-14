import '../models/practice_models.dart';

/// Realistic KPK BISE MCQ bank across Science, Arts, and Commerce with board tags.
abstract final class McqFixtures {
  static const List<McqQuestion> all = [
    // Physics
    McqQuestion(
      id: 'mcq_phy_1',
      subjectId: 'physics',
      chapterId: 'phy_ch3',
      question:
          'When a current-carrying wire is placed parallel to a uniform magnetic field (θ = 0°), the magnetic force acting on it is:',
      options: ['Maximum (BIL)', 'Half of maximum', 'Zero', 'Infinite'],
      correctIndex: 2,
      boardTag: 'BISE Peshawar 2025',
      explanation:
          'F = BIL sinθ. When θ = 0°, sin(0°) = 0, so the magnetic force on the conductor is zero.',
    ),
    McqQuestion(
      id: 'mcq_phy_2',
      subjectId: 'physics',
      chapterId: 'phy_ch3',
      question: 'A step-up transformer increases AC voltage by having:',
      options: [
        'More turns in primary coil than secondary',
        'More turns in secondary coil than primary',
        'Equal turns in both coils',
        'DC input battery',
      ],
      correctIndex: 1,
      boardTag: 'BISE Abbottabad 2024',
      explanation:
          'Since Vs/Vp = Ns/Np, a step-up transformer requires Ns > Np so secondary voltage exceeds primary voltage.',
    ),
    McqQuestion(
      id: 'mcq_phy_3',
      subjectId: 'physics',
      chapterId: 'phy_ch1',
      question: 'The area under a velocity-time graph represents:',
      options: ['Acceleration', 'Momentum', 'Distance covered', 'Force'],
      correctIndex: 2,
      boardTag: 'BISE Mardan 2024',
      explanation:
          'Multiplying velocity (m/s) by time (s) yields displacement / distance covered (m).',
    ),
    McqQuestion(
      id: 'mcq_phy_4',
      subjectId: 'physics',
      chapterId: 'phy_ch2',
      question: 'The SI unit of linear momentum is equivalent to:',
      options: ['N · s', 'N / s', 'J · s', 'kg · m / s²'],
      correctIndex: 0,
      boardTag: 'BISE Swat 2025',
      explanation:
          'Impulse F·Δt = Δp, so momentum (kg·m/s) is equivalent to Newton-second (N·s).',
    ),
    McqQuestion(
      id: 'mcq_phy_5',
      subjectId: 'physics',
      chapterId: 'phy_ch4',
      question:
          'If the length of a simple pendulum is made four times, its time period becomes:',
      options: ['Half', 'Double', 'Four times', 'Unchanged'],
      correctIndex: 1,
      boardTag: 'BISE Kohat 2023',
      explanation:
          'T = 2π√(l/g). Since T ∝ √l, multiplying length by 4 multiplies T by √4 = 2.',
    ),
    McqQuestion(
      id: 'mcq_phy_6',
      subjectId: 'physics',
      chapterId: 'phy_ch6',
      question: 'One kilowatt-hour (1 kWh) of electrical energy equals:',
      options: ['3.6 × 10³ J', '3.6 × 10⁵ J', '3.6 × 10⁶ J', '3.6 × 10⁹ J'],
      correctIndex: 2,
      boardTag: 'BISE Bannu 2024',
      explanation: '1000 W × 3600 s = 3,600,000 J = 3.6 × 10⁶ Joules.',
    ),
    McqQuestion(
      id: 'mcq_phy_7',
      subjectId: 'physics',
      chapterId: 'phy_ch5',
      question:
          'Which nuclear radiation has the highest ionizing power but lowest penetration?',
      options: ['Alpha (α)', 'Beta (β)', 'Gamma (γ)', 'X-rays'],
      correctIndex: 0,
      boardTag: 'BISE D.I. Khan 2023',
      explanation:
          'Alpha particles carry +2e charge and large mass, causing dense ionization over a short range.',
    ),
    McqQuestion(
      id: 'mcq_phy_8',
      subjectId: 'physics',
      chapterId: 'phy_ch3',
      question:
          'Lenz’s Law is a direct consequence of the law of conservation of:',
      options: ['Charge', 'Mass', 'Energy', 'Angular momentum'],
      correctIndex: 2,
      boardTag: 'BISE Malakand 2025',
      explanation:
          'The work done overcoming opposing induced magnetic force transforms into electrical energy.',
    ),
    McqQuestion(
      id: 'mcq_phy_9',
      subjectId: 'physics',
      chapterId: 'phy_ch6',
      question:
          'When resistors are connected in parallel, the quantity that remains identical across each branch is:',
      options: ['Current', 'Voltage', 'Resistance', 'Power'],
      correctIndex: 1,
      boardTag: 'BISE Peshawar 2024',
      explanation:
          'All parallel branches share the same two nodes, so potential difference (voltage) is equal.',
    ),
    McqQuestion(
      id: 'mcq_phy_10',
      subjectId: 'physics',
      chapterId: 'phy_ch1',
      question: 'The slope of a velocity-time graph gives:',
      options: ['Displacement', 'Speed', 'Acceleration', 'Work'],
      correctIndex: 2,
      boardTag: 'BISE Abbottabad 2025',
      explanation: 'Slope = Δv / Δt, which defines acceleration.',
    ),

    // Chemistry
    McqQuestion(
      id: 'mcq_chem_1',
      subjectId: 'chemistry',
      chapterId: 'chem_ch1',
      question: 'Which factor can change the numerical value of Kc?',
      options: ['Catalyst', 'Pressure', 'Temperature', 'Concentration'],
      correctIndex: 2,
      boardTag: 'BISE Peshawar 2024',
      explanation:
          'The equilibrium constant Kc depends solely on temperature for a given reaction.',
    ),
    McqQuestion(
      id: 'mcq_chem_2',
      subjectId: 'chemistry',
      chapterId: 'chem_ch2',
      question: 'According to Lewis concept, an acid is a substance that:',
      options: [
        'Donates a proton',
        'Accepts an electron pair',
        'Donates an electron pair',
        'Produces OH⁻ ions',
      ],
      correctIndex: 1,
      boardTag: 'BISE Abbottabad 2025',
      explanation:
          'A Lewis acid accepts a lone pair of electrons (e.g., BF₃, AlCl₃).',
    ),
    McqQuestion(
      id: 'mcq_chem_3',
      subjectId: 'chemistry',
      chapterId: 'chem_ch2',
      question: 'At 25 °C, the sum of pH + pOH of an aqueous solution equals:',
      options: ['7', '10', '14', '1'],
      correctIndex: 2,
      boardTag: 'BISE Swat 2024',
      explanation: 'Since Kw = [H⁺][OH⁻] = 10⁻¹⁴ at 25 °C, pH + pOH = 14.',
    ),

    // Mathematics
    McqQuestion(
      id: 'mcq_math_1',
      subjectId: 'mathematics',
      chapterId: 'math_ch1',
      question:
          'If discriminant b² − 4ac of a quadratic equation is negative, the roots are:',
      options: [
        'Real and equal',
        'Rational and unequal',
        'Irrational',
        'Complex / Imaginary',
      ],
      correctIndex: 3,
      boardTag: 'BISE Mardan 2025',
      explanation:
          'Taking the square root of a negative discriminant produces complex conjugate roots.',
    ),
    McqQuestion(
      id: 'mcq_math_2',
      subjectId: 'mathematics',
      chapterId: 'math_ch2',
      question: 'The value of sin²(45°) + cos²(45°) is:',
      options: ['0', '1/2', '1', '√2'],
      correctIndex: 2,
      boardTag: 'BISE Swat 2024',
      explanation:
          'By the fundamental Pythagorean identity, sin²θ + cos²θ = 1 for all θ.',
    ),
    McqQuestion(
      id: 'mcq_math_3',
      subjectId: 'mathematics',
      chapterId: 'math_ch1',
      question: 'The product of the roots of ax² + bx + c = 0 (a ≠ 0) is:',
      options: ['−b/a', 'c/a', '−c/a', 'b/a'],
      correctIndex: 1,
      boardTag: 'BISE Kohat 2024',
      explanation: 'For ax² + bx + c = 0, α + β = −b/a and αβ = c/a.',
    ),

    // Biology & Computer Science & English
    McqQuestion(
      id: 'mcq_bio_1',
      subjectId: 'biology',
      chapterId: 'bio_ch1',
      question:
          'Which brain region controls involuntary actions like breathing and heartbeat?',
      options: [
        'Cerebrum',
        'Medulla oblongata',
        'Cerebellum',
        'Corpus callosum',
      ],
      correctIndex: 1,
      boardTag: 'BISE Peshawar 2025',
      explanation:
          'Medulla oblongata in the hindbrain regulates vital autonomic reflexes.',
    ),
    McqQuestion(
      id: 'mcq_cs_1',
      subjectId: 'computer_science',
      chapterId: 'cs_ch1',
      question: 'Which pair of logic gates are known as universal gates?',
      options: [
        'AND and OR',
        'NOT and XOR',
        'NAND and NOR',
        'OR and XNOR',
      ],
      correctIndex: 2,
      boardTag: 'BISE Abbottabad 2024',
      explanation:
          'Any Boolean logic function can be implemented using only NAND gates or only NOR gates.',
    ),
    McqQuestion(
      id: 'mcq_eng_1',
      subjectId: 'english',
      chapterId: 'eng_ch1',
      question: 'Passive voice of "She writes a letter" is:',
      options: [
        'A letter was written by her.',
        'A letter is written by her.',
        'A letter has been written by her.',
        'A letter is being written by her.',
      ],
      correctIndex: 1,
      boardTag: 'BISE Kohat 2025',
      explanation:
          'Present Indefinite active (writes) transforms to is/am/are + V3 (is written).',
    ),

    // Arts Group (Civics, Islamic Studies, Pakistan Studies)
    McqQuestion(
      id: 'mcq_civ_1',
      subjectId: 'civics',
      chapterId: 'civ_ch1',
      question: 'Which element distinguishes a sovereign state from other associations?',
      options: ['Population', 'Territory', 'Sovereignty', 'Language'],
      correctIndex: 2,
      boardTag: 'BISE Peshawar 2024',
      explanation:
          'Sovereignty is supreme legal authority both internally and externally.',
    ),
    McqQuestion(
      id: 'mcq_pst_1',
      subjectId: 'pakistan_studies',
      chapterId: 'pst_ch1',
      question: 'The Lahore Resolution was passed on:',
      options: [
        '23 March 1940',
        '14 August 1947',
        '29 December 1930',
        '3 June 1947',
      ],
      correctIndex: 0,
      boardTag: 'BISE Mardan 2025',
      explanation:
          'The historic Lahore Resolution was adopted on 23 March 1940 at Minto Park.',
    ),
    McqQuestion(
      id: 'mcq_isl_1',
      subjectId: 'islamic_studies',
      chapterId: 'isl_ch1',
      question: 'Returning trusts safely to their rightful owners is termed:',
      options: ['Sabr', 'Amanah', 'Shukr', 'Qanaat'],
      correctIndex: 1,
      boardTag: 'BISE Swat 2025',
      explanation:
          'Amanah (trustworthiness) encompasses safeguarding property, duties, and confidences.',
    ),

    // Commerce Group (Accounting, Business Math, Economics)
    McqQuestion(
      id: 'mcq_acc_1',
      subjectId: 'accounting',
      chapterId: 'acc_ch1',
      question: 'The fundamental accounting equation is:',
      options: [
        'Assets = Liabilities − Capital',
        'Assets = Liabilities + Owner’s Equity',
        'Capital = Assets + Liabilities',
        'Revenue = Assets + Expenses',
      ],
      correctIndex: 1,
      boardTag: 'BISE Peshawar 2025',
      explanation:
          'Every financial transaction maintains Assets = Liabilities + Owner’s Equity.',
    ),
    McqQuestion(
      id: 'mcq_bmath_1',
      subjectId: 'business_math',
      chapterId: 'bmath_ch1',
      question: 'Simple interest on Rs. 10,000 at 5% per annum for 2 years is:',
      options: ['Rs. 500', 'Rs. 1,000', 'Rs. 1,500', 'Rs. 2,000'],
      correctIndex: 1,
      boardTag: 'BISE Abbottabad 2024',
      explanation: 'I = P × R × T = 10,000 × 0.05 × 2 = Rs. 1,000.',
    ),
    McqQuestion(
      id: 'mcq_econ_1',
      subjectId: 'economics',
      chapterId: 'econ_ch1',
      question: 'According to the Law of Demand, when price rises (ceteris paribus):',
      options: [
        'Quantity demanded rises',
        'Quantity demanded falls',
        'Supply becomes zero',
        'Demand curve disappears',
      ],
      correctIndex: 1,
      boardTag: 'BISE Bannu 2025',
      explanation:
          'Price and quantity demanded have an inverse relationship holding other factors constant.',
    ),
  ];
}
