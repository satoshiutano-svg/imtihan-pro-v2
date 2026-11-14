import '../../core/constants/kpk_boards.dart';
import '../models/paper_models.dart';

/// Authentic KPK BISE Past Paper fixtures (2022-2025) across Science, Arts, and Commerce.
abstract final class PastPapersFixtures {
  static List<PastPaper> all({
    required KpkBoard preferredBoard,
    required ClassLevel classLevel,
    AcademicGroup? group,
  }) {
    final papers = [
      // Science
      _buildPaper(
        id: 'paper_phy_2025',
        subjectId: 'physics',
        subjectName: 'Physics',
        year: 2025,
        board: preferredBoard,
        classLevel: classLevel,
        size: '1.4 MB',
      ),
      _buildPaper(
        id: 'paper_phy_2024',
        subjectId: 'physics',
        subjectName: 'Physics',
        year: 2024,
        board: preferredBoard,
        classLevel: classLevel,
        size: '1.3 MB',
      ),
      _buildPaper(
        id: 'paper_chem_2025',
        subjectId: 'chemistry',
        subjectName: 'Chemistry',
        year: 2025,
        board: preferredBoard,
        classLevel: classLevel,
        size: '1.2 MB',
      ),
      _buildPaper(
        id: 'paper_math_2024',
        subjectId: 'mathematics',
        subjectName: 'Mathematics',
        year: 2024,
        board: KpkBoard.abbottabad,
        classLevel: classLevel,
        size: '1.5 MB',
      ),
      _buildPaper(
        id: 'paper_phy_2023',
        subjectId: 'physics',
        subjectName: 'Physics',
        year: 2023,
        board: KpkBoard.mardan,
        classLevel: classLevel,
        size: '1.1 MB',
      ),
      _buildPaper(
        id: 'paper_bio_2022',
        subjectId: 'biology',
        subjectName: 'Biology',
        year: 2022,
        board: KpkBoard.swat,
        classLevel: classLevel,
        size: '1.3 MB',
      ),

      // Arts
      _buildPaper(
        id: 'paper_pst_2025',
        subjectId: 'pakistan_studies',
        subjectName: 'Pakistan Studies',
        year: 2025,
        board: preferredBoard,
        classLevel: classLevel,
        size: '1.1 MB',
      ),
      _buildPaper(
        id: 'paper_civ_2024',
        subjectId: 'civics',
        subjectName: 'Civics',
        year: 2024,
        board: KpkBoard.mardan,
        classLevel: classLevel,
        size: '1.0 MB',
      ),
      _buildPaper(
        id: 'paper_isl_2023',
        subjectId: 'islamic_studies',
        subjectName: 'Islamic Studies',
        year: 2023,
        board: KpkBoard.swat,
        classLevel: classLevel,
        size: '0.9 MB',
      ),

      // Commerce
      _buildPaper(
        id: 'paper_acc_2025',
        subjectId: 'accounting',
        subjectName: 'Principles of Accounting',
        year: 2025,
        board: preferredBoard,
        classLevel: classLevel,
        size: '1.4 MB',
      ),
      _buildPaper(
        id: 'paper_econ_2024',
        subjectId: 'economics',
        subjectName: 'Economics',
        year: 2024,
        board: KpkBoard.abbottabad,
        classLevel: classLevel,
        size: '1.2 MB',
      ),
      _buildPaper(
        id: 'paper_bmath_2023',
        subjectId: 'business_math',
        subjectName: 'Business Mathematics',
        year: 2023,
        board: KpkBoard.kohat,
        classLevel: classLevel,
        size: '1.3 MB',
      ),
    ];

    if (group == null) return papers;

    const scienceIds = {'physics', 'chemistry', 'mathematics', 'biology'};
    const artsIds = {'pakistan_studies', 'civics', 'islamic_studies'};
    const commerceIds = {'accounting', 'economics', 'business_math'};

    final Set<String> allowed = switch (group) {
      AcademicGroup.science => scienceIds,
      AcademicGroup.arts => artsIds,
      AcademicGroup.commerce => commerceIds,
    };

    return papers.where((p) => allowed.contains(p.subjectId)).toList();
  }

  static PastPaper _buildPaper({
    required String id,
    required String subjectId,
    required String subjectName,
    required int year,
    required KpkBoard board,
    required ClassLevel classLevel,
    required String size,
  }) {
    final List<PaperQuestion> questions = switch (subjectId) {
      'chemistry' => _chemistryQuestions(year),
      'mathematics' => _mathQuestions(year),
      'biology' => _biologyQuestions(year),
      'pakistan_studies' || 'civics' || 'islamic_studies' =>
        _artsQuestions(subjectName, year),
      'accounting' || 'economics' || 'business_math' =>
        _commerceQuestions(subjectName, year),
      _ => _physicsQuestions(year),
    };

    return PastPaper(
      id: id,
      subjectId: subjectId,
      subjectName: subjectName,
      year: year,
      board: board,
      classLevel: classLevel,
      totalMarks: 75,
      durationMinutes: 180,
      fileSizeLabel: size,
      questions: questions,
    );
  }

  static List<PaperQuestion> _physicsQuestions(int year) => [
        PaperQuestion(
          id: 'p_q1_$year',
          section: PaperSectionType.mcqs,
          questionNumber: 'Q1 (i)',
          prompt: 'The SI unit of magnetic flux is:',
          marks: 1,
          options: ['Tesla', 'Weber', 'Henry', 'Gauss'],
          solution:
              'Correct Answer: Weber (Wb). 1 Weber = 1 Tesla × 1 m². Tesla measures magnetic flux density.',
        ),
        PaperQuestion(
          id: 'p_q2_$year',
          section: PaperSectionType.mcqs,
          questionNumber: 'Q1 (ii)',
          prompt:
              'Which rule determines the direction of the magnetic field around a straight current-carrying conductor?',
          marks: 1,
          options: [
            'Right-hand grip rule',
            'Left-hand rule',
            'Coulomb rule',
            'Ampere law only',
          ],
          solution:
              'Correct Answer: Right-hand grip rule. Thumb points in current direction; curled fingers show magnetic field direction.',
        ),
        PaperQuestion(
          id: 'p_q3_$year',
          section: PaperSectionType.shortQuestions,
          questionNumber: 'Q2 (i)',
          prompt:
              'Define Lenz’s Law and explain how it obeys the law of conservation of energy.',
          marks: 4,
          solution:
              'Lenz’s Law states that the direction of induced EMF always opposes the change in magnetic flux producing it (ε = −N ΔΦ/Δt). Mechanical work done against this opposing magnetic force converts directly into electrical energy, conserving total energy.',
        ),
        PaperQuestion(
          id: 'p_q4_$year',
          section: PaperSectionType.shortQuestions,
          questionNumber: 'Q2 (ii)',
          prompt:
              'Why does a transformer not operate on a steady DC battery supply?',
          marks: 4,
          solution:
              'A steady DC current produces constant magnetic flux (ΔΦ/Δt = 0). By Faraday’s Law, induced EMF in the secondary coil requires a continuously changing magnetic flux, which only AC provides.',
        ),
        PaperQuestion(
          id: 'p_q5_$year',
          section: PaperSectionType.longQuestions,
          questionNumber: 'Q3 (a)',
          prompt:
              'Derive the expression for force on a current-carrying conductor placed in a uniform magnetic field. When is this force maximum and minimum?',
          marks: 7,
          solution:
              'Step 1: Force on a single moving charge F = qvB sinθ.\nStep 2: For N charges flowing across length L in time t, I = qN/t and v = L/t.\nStep 3: Total Force F = B · I · L · sinθ.\n• Maximum when θ = 90° (conductor perpendicular to B): Fmax = BIL.\n• Minimum (zero) when θ = 0° or 180° (parallel to B).',
        ),
      ];

  static List<PaperQuestion> _chemistryQuestions(int year) => [
        PaperQuestion(
          id: 'c_q1_$year',
          section: PaperSectionType.mcqs,
          questionNumber: 'Q1 (i)',
          prompt: 'At 25 °C, the pH of pure neutral water is:',
          marks: 1,
          options: ['0', '7', '10', '14'],
          solution: 'Correct Answer: 7, since [H⁺] = [OH⁻] = 10⁻⁷ M.',
        ),
        PaperQuestion(
          id: 'c_q2_$year',
          section: PaperSectionType.shortQuestions,
          questionNumber: 'Q2 (i)',
          prompt: 'State Le Chatelier’s Principle with one industrial application.',
          marks: 4,
          solution:
              'If a stress (concentration, pressure, or temperature) is applied to a system at equilibrium, the system shifts in a direction that minimizes that stress. Example: High pressure (200 atm) favors ammonia yield in the Haber process.',
        ),
        PaperQuestion(
          id: 'c_q3_$year',
          section: PaperSectionType.longQuestions,
          questionNumber: 'Q3 (a)',
          prompt:
              'Derive the equilibrium constant Kc expression for a general reversible reaction aA + bB ⇌ cC + dD.',
          marks: 7,
          solution:
              'Rate of forward reaction Rf = kf[A]ᵃ[B]ᵇ. Rate of reverse reaction Rr = kr[C]ᶜ[D]ᵈ. At equilibrium Rf = Rr, so Kc = kf/kr = ([C]ᶜ[D]ᵈ) / ([A]ᵃ[B]ᵇ).',
        ),
      ];

  static List<PaperQuestion> _mathQuestions(int year) => [
        PaperQuestion(
          id: 'm_q1_$year',
          section: PaperSectionType.mcqs,
          questionNumber: 'Q1 (i)',
          prompt: 'The sum of roots of 2x² − 6x + 5 = 0 is:',
          marks: 1,
          options: ['3', '−3', '5/2', '−5/2'],
          solution: 'Correct Answer: 3. Sum = −b/a = −(−6)/2 = 3.',
        ),
        PaperQuestion(
          id: 'm_q2_$year',
          section: PaperSectionType.shortQuestions,
          questionNumber: 'Q2 (i)',
          prompt: 'Prove that tanθ + cotθ = secθ · cosecθ.',
          marks: 4,
          solution:
              'LHS = sinθ/cosθ + cosθ/sinθ = (sin²θ + cos²θ)/(sinθ·cosθ) = 1/(sinθ·cosθ) = secθ · cosecθ = RHS.',
        ),
      ];

  static List<PaperQuestion> _biologyQuestions(int year) => [
        PaperQuestion(
          id: 'b_q1_$year',
          section: PaperSectionType.mcqs,
          questionNumber: 'Q1 (i)',
          prompt: 'Which part of the brain maintains body posture and balance?',
          marks: 1,
          options: ['Cerebrum', 'Cerebellum', 'Pons', 'Thalamus'],
          solution:
              'Correct Answer: Cerebellum coordinates fine muscle movements and equilibrium.',
        ),
        PaperQuestion(
          id: 'b_q2_$year',
          section: PaperSectionType.shortQuestions,
          questionNumber: 'Q2 (i)',
          prompt: 'Differentiate between sensory and motor neurons.',
          marks: 4,
          solution:
              'Sensory neurons carry impulses from receptors toward the CNS; motor neurons carry impulses from the CNS to effectors (muscles or glands).',
        ),
      ];

  static List<PaperQuestion> _artsQuestions(String subjectName, int year) => [
        PaperQuestion(
          id: 'a_q1_$year',
          section: PaperSectionType.mcqs,
          questionNumber: 'Q1 (i)',
          prompt: '$subjectName ($year): The Lahore Resolution was adopted in:',
          marks: 1,
          options: ['1930', '1940', '1946', '1947'],
          solution: 'Correct Answer: 1940 (23 March 1940).',
        ),
        PaperQuestion(
          id: 'a_q2_$year',
          section: PaperSectionType.shortQuestions,
          questionNumber: 'Q2 (i)',
          prompt: 'Write four key civic responsibilities of a good citizen.',
          marks: 4,
          solution:
              'Obeying constitutional laws, paying taxes honestly, respecting public property, and participating constructively in civic life.',
        ),
      ];

  static List<PaperQuestion> _commerceQuestions(String subjectName, int year) => [
        PaperQuestion(
          id: 'com_q1_$year',
          section: PaperSectionType.mcqs,
          questionNumber: 'Q1 (i)',
          prompt:
              '$subjectName ($year): Assets minus Liabilities equals:',
          marks: 1,
          options: ['Drawings', 'Owner’s Equity', 'Expenses', 'Purchases'],
          solution:
              'Correct Answer: Owner’s Equity (Assets = Liabilities + Owner’s Equity).',
        ),
        PaperQuestion(
          id: 'com_q2_$year',
          section: PaperSectionType.shortQuestions,
          questionNumber: 'Q2 (i)',
          prompt: 'Distinguish between movement along a demand curve and shift of demand curve.',
          marks: 4,
          solution:
              'Movement occurs due to change in the good’s own price; a shift occurs due to non-price factors such as income, tastes, or population.',
        ),
      ];

  static List<PaperTrendPoint> examinationTrends() => const [
        PaperTrendPoint(
          label: 'Ch 3',
          chapterTitle: 'Electromagnetism',
          marksWeightage: 18,
          frequencyYears: 5,
        ),
        PaperTrendPoint(
          label: 'Ch 6',
          chapterTitle: 'Current Electricity',
          marksWeightage: 16,
          frequencyYears: 5,
        ),
        PaperTrendPoint(
          label: 'Ch 2',
          chapterTitle: 'Forces & Momentum',
          marksWeightage: 14,
          frequencyYears: 4,
        ),
        PaperTrendPoint(
          label: 'Ch 4',
          chapterTitle: 'Waves & Sound',
          marksWeightage: 14,
          frequencyYears: 4,
        ),
        PaperTrendPoint(
          label: 'Ch 1',
          chapterTitle: 'Motion & Graphs',
          marksWeightage: 12,
          frequencyYears: 4,
        ),
        PaperTrendPoint(
          label: 'Ch 5',
          chapterTitle: 'Modern Physics',
          marksWeightage: 12,
          frequencyYears: 3,
        ),
      ];
}
