import '../../core/constants/kpk_boards.dart';
import '../models/curriculum_models.dart';

/// Realistic KPK BISE curriculum fixtures across Science, Arts, and Commerce.
abstract final class CurriculumFixtures {
  static List<Subject> allSubjects() => [
        _physics,
        _chemistry,
        _mathematics,
        _biology,
        _computerScience,
        _englishScience,
        _civics,
        _islamicStudies,
        _pakistanStudies,
        _accounting,
        _businessMath,
        _economics,
      ];

  static const Subject _physics = Subject(
    id: 'physics',
    title: 'Physics',
    description: 'Mechanics, Electromagnetism, Waves & Modern Physics',
    group: AcademicGroup.science,
    visualKind: SubjectVisualKind.physics,
    totalChaptersCount: 12,
    chapters: [
      Chapter(
        id: 'phy_ch1',
        subjectId: 'physics',
        number: 1,
        title: 'Motion',
        summary:
            'Kinematics, displacement-time graphs, equations of uniformly accelerated motion, and projectile motion.',
        estimatedMinutes: 35,
        weightagePercent: 12,
        keyConcepts: [
          'Scalars vs. Vectors and resultant displacement',
          'Uniform velocity vs. instantaneous acceleration',
          'Graphical derivation of equations of motion',
          'Free fall motion under gravity (g = 9.8 m/s²)',
        ],
        keyPoints: [
          'Slope of a displacement-time graph gives velocity.',
          'Area under a velocity-time graph gives total distance covered.',
          'At the highest point of vertical throw, velocity is zero while acceleration remains g.',
        ],
        diagramTitle: 'Velocity-Time Graph Area',
        diagramCaption: 'Uniform acceleration produces a linear v-t slope.',
        solvedExamples: [
          SolvedExample(
            title: 'Example 1.1 — Uniform Acceleration',
            problem:
                'A car starts from rest and accelerates uniformly at 2.5 m/s² for 8 seconds. Find its final velocity and distance covered.',
            givenData: ['Initial velocity (vi) = 0 m/s', 'a = 2.5 m/s²', 't = 8 s'],
            formula: 'vf = vi + at  and  S = vi·t + ½at²',
            solutionSteps: [
              'vf = 0 + (2.5)(8) = 20 m/s',
              'S = 0 + 0.5 × 2.5 × (8)² = 1.25 × 64 = 80 m',
            ],
            answer: 'vf = 20 m/s, Distance = 80 m',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: [
            'vf = vi + at',
            'S = vi·t + ½at²',
            '2aS = vf² − vi²',
          ],
          importantPoints: [
            'Retardation (deceleration) is negative acceleration.',
            'SI unit of acceleration is m/s².',
          ],
          examTips: [
            'Always convert km/h to m/s by multiplying by 5/18 before substituting.',
            'Label graph axes with units in KPK Board short questions.',
          ],
          rememberHighlight:
              'Slope of v-t graph = acceleration; Area under v-t graph = distance!',
        ),
      ),
      Chapter(
        id: 'phy_ch2',
        subjectId: 'physics',
        number: 2,
        title: 'Forces',
        summary:
            'Newton’s laws of motion, linear momentum, impulse, friction, and circular centripetal force.',
        estimatedMinutes: 40,
        weightagePercent: 14,
        keyConcepts: [
          'Inertia and Newton’s First Law of Motion',
          'Force, mass, and acceleration relation (F = ma)',
          'Law of conservation of linear momentum',
          'Static vs. kinetic friction and banking of roads',
        ],
        keyPoints: [
          '1 Newton is the force that produces 1 m/s² acceleration in a 1 kg mass.',
          'Rate of change of momentum equals the applied net force.',
          'Centripetal force acts radially inward perpendicular to velocity.',
        ],
        diagramTitle: 'Force Vector & Momentum',
        diagramCaption: 'Action and reaction act on two different bodies.',
        solvedExamples: [
          SolvedExample(
            title: 'Example 2.1 — Centripetal Force',
            problem:
                'A 1200 kg car turns along a circular curve of radius 60 m at 15 m/s. Calculate the centripetal force.',
            givenData: ['m = 1200 kg', 'v = 15 m/s', 'r = 60 m'],
            formula: 'Fc = mv² / r',
            solutionSteps: [
              'Fc = (1200 × 15²) / 60',
              'Fc = (1200 × 225) / 60 = 20 × 225 = 4500 N',
            ],
            answer: 'Fc = 4,500 N',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: [
            'F = ma',
            'p = mv',
            'Fc = mv² / r',
            'F · Δt = Δp (Impulse)',
          ],
          importantPoints: [
            'Total momentum of an isolated system remains constant.',
            'Limiting friction is directly proportional to normal reaction.',
          ],
          examTips: [
            'State both mathematical form and vector direction when defining Newton’s 2nd Law.',
          ],
          rememberHighlight:
              'F = Δp / Δt works even when mass changes, such as in rocket propulsion!',
        ),
      ),
      Chapter(
        id: 'phy_ch3',
        subjectId: 'physics',
        number: 3,
        title: 'Electromagnetism',
        summary:
            'Electromagnetism is the branch of physics that studies the relationship between electricity and magnetism.',
        estimatedMinutes: 45,
        weightagePercent: 18,
        keyConcepts: [
          'Magnetic field around a current-carrying conductor',
          'Force on a current-carrying wire in a magnetic field (F = BIL sinθ)',
          'Electromagnetic induction & Faraday’s Law',
          'Lenz’s Law, DC Motor, and Step-up/Step-down Transformers',
        ],
        keyPoints: [
          'Electromagnetic waves propagate without requiring a material medium.',
          'Magnetic field lines form closed loops from North to South outside a magnet.',
          'Electric field exerts force on stationary charges; magnetic field acts on moving charges.',
        ],
        diagramTitle: 'Magnetic Field Flux Lines',
        diagramCaption:
            'Concentric flux lines surround a magnet and current-carrying coil.',
        solvedExamples: [
          SolvedExample(
            title: 'Example 3.1 — Magnetic Force on Conductor',
            problem:
                'A 0.5 m straight wire carries 4 A current perpendicular to a 0.6 T magnetic field. Find the magnetic force.',
            givenData: ['L = 0.5 m', 'I = 4 A', 'B = 0.6 T', 'θ = 90°'],
            formula: 'F = B · I · L · sinθ',
            solutionSteps: [
              'sin 90° = 1',
              'F = 0.6 × 4 × 0.5 × 1 = 1.2 N',
            ],
            answer: 'F = 1.2 N',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: [
            'F = BIL sinθ',
            'F = qvB sinθ',
            'ε = −N (ΔΦ / Δt)',
            'Vs / Vp = Ns / Np (Transformer)',
          ],
          importantPoints: [
            'Transformers operate only on alternating current (AC).',
            'Induced EMF opposes the change in magnetic flux that produces it (Lenz’s Law).',
          ],
          examTips: [
            'Practice neat labeled diagrams of AC Generator and Transformer for Section C long questions.',
            'Memorize SI units: Magnetic field B in Tesla (T), Flux Φ in Weber (Wb).',
          ],
          rememberHighlight:
              'Use the right-hand grip rule to find the direction of the magnetic field around a current-carrying wire!',
        ),
      ),
      Chapter(
        id: 'phy_ch4',
        subjectId: 'physics',
        number: 4,
        title: 'Waves',
        summary:
            'Simple harmonic motion, transverse and longitudinal waves, reflection, refraction, and sound properties.',
        estimatedMinutes: 30,
        weightagePercent: 14,
        keyConcepts: [
          'Simple Harmonic Motion (SHM) of mass-spring & simple pendulum',
          'Wave equation (v = fλ)',
          'Speed of sound in solids, liquids, and gases',
          'Echo, resonance, and audible frequency range (20 Hz – 20 kHz)',
        ],
        keyPoints: [
          'Time period of a simple pendulum depends on length and gravity, not mass.',
          'Sound waves are longitudinal mechanical waves.',
        ],
        diagramTitle: 'Transverse Wave Profile',
        diagramCaption: 'Crest-to-crest distance equals one complete wavelength λ.',
        solvedExamples: [
          SolvedExample(
            title: 'Example 4.1 — Wave Speed',
            problem:
                'A wave of frequency 500 Hz has a wavelength of 0.68 m. Calculate its speed.',
            givenData: ['f = 500 Hz', 'λ = 0.68 m'],
            formula: 'v = f · λ',
            solutionSteps: ['v = 500 × 0.68 = 340 m/s'],
            answer: 'v = 340 m/s',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: [
            'v = fλ',
            'T = 1 / f',
            'T = 2π √(l / g)',
          ],
          importantPoints: [
            'Frequency does not change when a wave passes from one medium to another.',
          ],
          examTips: [
            'Write the restoring force equation F = −kx clearly when deriving SHM.',
          ],
          rememberHighlight:
              'Double the pendulum length → Period increases by √2!',
        ),
      ),
      Chapter(
        id: 'phy_ch5',
        subjectId: 'physics',
        number: 5,
        title: 'Modern Physics',
        summary:
            'Atomic spectra, nuclear structure, radioactivity, half-life, and nuclear fission & fusion reactions.',
        estimatedMinutes: 35,
        weightagePercent: 12,
        keyConcepts: [
          'Atomic number Z and mass number A',
          'Alpha, Beta, and Gamma decay properties',
          'Half-life decay law and Carbon-14 dating',
          'Einstein mass-energy equivalence (E = mc²)',
        ],
        keyPoints: [
          'Gamma rays have zero rest mass and highest penetrating power.',
          'Nuclear fusion powers the Sun and stars.',
        ],
        diagramTitle: 'Radioactive Decay Curve',
        diagramCaption: 'Activity halves after every half-life interval T½.',
        solvedExamples: [
          SolvedExample(
            title: 'Example 5.1 — Half-Life Calculation',
            problem:
                'A radioactive sample has an initial mass of 80 g and half-life of 4 days. How much remains after 12 days?',
            givenData: ['N0 = 80 g', 'T½ = 4 days', 't = 12 days'],
            formula: 'n = t / T½  and  N = N0 / 2ⁿ',
            solutionSteps: [
              'n = 12 / 4 = 3 half-lives',
              'N = 80 / 2³ = 80 / 8 = 10 g',
            ],
            answer: '10 g remains undecayed',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: ['E = mc²', 'N = N0 · (½)ⁿ', 'A = Z + N'],
          importantPoints: [
            'Alpha emission decreases A by 4 and Z by 2.',
            'Beta-minus emission keeps A unchanged and increases Z by 1.',
          ],
          examTips: [
            'Compare α, β, γ particles in a neat 3-column table for full marks.',
          ],
          rememberHighlight:
              'Half-life is an intrinsic nuclear property unaffected by heat or pressure!',
        ),
      ),
      Chapter(
        id: 'phy_ch6',
        subjectId: 'physics',
        number: 6,
        title: 'Current Electricity',
        summary:
            'Ohm’s Law, series and parallel resistors, Joule heating, kilowatt-hour energy billing, and safety fuses.',
        estimatedMinutes: 35,
        weightagePercent: 16,
        keyConcepts: [
          'Conventional current vs. electronic current',
          'Ohm’s Law (V = IR) and ohmic vs. non-ohmic conductors',
          'Equivalent resistance in series and parallel circuits',
          'Electrical power (P = VI = I²R) and kWh calculation',
        ],
        keyPoints: [
          'In parallel circuits, voltage across every branch is identical.',
          '1 kWh equals 3.6 × 10⁶ Joules.',
        ],
        diagramTitle: 'Parallel Resistor Circuit',
        diagramCaption: 'Total parallel resistance is always less than the smallest resistor.',
        solvedExamples: [
          SolvedExample(
            title: 'Example 6.1 — Equivalent Resistance',
            problem:
                'Two resistors of 6 Ω and 3 Ω are connected in parallel across a 12 V battery. Find total current.',
            givenData: ['R1 = 6 Ω', 'R2 = 3 Ω', 'V = 12 V'],
            formula: '1/Req = 1/R1 + 1/R2  and  I = V / Req',
            solutionSteps: [
              '1/Req = 1/6 + 1/3 = 3/6 = 1/2 → Req = 2 Ω',
              'I = 12 / 2 = 6 A',
            ],
            answer: 'Total Current = 6 A',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: [
            'V = IR',
            'P = VI = I²R = V²/R',
            '1 kWh = 3.6 MJ',
          ],
          importantPoints: [
            'Fuse is always connected in series on the live wire.',
          ],
          examTips: [
            'Show both circuit diagram and unit conversions in electricity numericals.',
          ],
          rememberHighlight:
              'Series = same Current; Parallel = same Voltage!',
        ),
      ),
    ],
  );

  static const Subject _chemistry = Subject(
    id: 'chemistry',
    title: 'Chemistry',
    description: 'Atomic Structure, Bonding, Equilibrium & Organic Chemistry',
    group: AcademicGroup.science,
    visualKind: SubjectVisualKind.chemistry,
    totalChaptersCount: 14,
    chapters: [
      Chapter(
        id: 'chem_ch1',
        subjectId: 'chemistry',
        number: 1,
        title: 'Chemical Equilibrium',
        summary:
            'Reversible reactions, Law of Mass Action, Kc expression, and Le Chatelier’s Principle.',
        estimatedMinutes: 35,
        weightagePercent: 15,
        keyConcepts: [
          'Dynamic equilibrium in closed systems',
          'Equilibrium constant Kc and units',
          'Haber & Contact industrial processes',
        ],
        keyPoints: [
          'At dynamic equilibrium, forward rate equals reverse rate.',
          'Kc depends solely on temperature.',
        ],
        diagramTitle: 'Forward vs Reverse Rate',
        diagramCaption: 'Rates converge at equilibrium t_eq.',
        solvedExamples: [
          SolvedExample(
            title: 'Example 1.1 — Equilibrium Constant Kc',
            problem:
                'For H₂ + I₂ ⇌ 2HI at equilibrium: [H₂] = 0.2 M, [I₂] = 0.2 M, [HI] = 1.6 M. Find Kc.',
            givenData: ['[H₂]=0.2', '[I₂]=0.2', '[HI]=1.6'],
            formula: 'Kc = [HI]² / ([H₂][I₂])',
            solutionSteps: ['Kc = (1.6)² / (0.2 × 0.2) = 2.56 / 0.04 = 64'],
            answer: 'Kc = 64 (no units)',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: ['Kc = [Products] / [Reactants]'],
          importantPoints: ['Catalyst speeds up attainment of equilibrium without shifting Kc.'],
          examTips: ['Always square/cube concentrations according to balanced stoichiometric coefficients.'],
          rememberHighlight: 'If Δn = 0, Kc has no units!',
        ),
      ),
      Chapter(
        id: 'chem_ch2',
        subjectId: 'chemistry',
        number: 2,
        title: 'Acids, Bases & Salts',
        summary:
            'Arrhenius, Bronsted-Lowry, and Lewis theories, pH scale, indicators, and neutralization.',
        estimatedMinutes: 30,
        weightagePercent: 14,
        keyConcepts: [
          'Conjugate acid-base pairs',
          'Self-ionization of water (Kw = 10⁻¹⁴)',
          'pH and pOH calculations',
        ],
        keyPoints: [
          'pH + pOH = 14 at 25 °C.',
          'Lewis acids are electron-pair acceptors.',
        ],
        diagramTitle: 'pH Scale Spectrum',
        diagramCaption: '0–6 Acidic • 7 Neutral • 8–14 Basic.',
        solvedExamples: [
          SolvedExample(
            title: 'Example 2.1 — pH of Strong Acid',
            problem: 'Calculate the pH of a 0.001 M HCl solution.',
            givenData: ['[H⁺] = 10⁻³ M'],
            formula: 'pH = −log₁₀[H⁺]',
            solutionSteps: ['pH = −log₁₀(10⁻³) = 3'],
            answer: 'pH = 3',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: ['pH = −log[H⁺]', 'pH + pOH = 14'],
          importantPoints: ['All Arrhenius acids are Bronsted acids, but not all Lewis acids are Bronsted acids.'],
          examTips: ['Give one balanced equation for each type of salt preparation.'],
          rememberHighlight: 'Electron pair Acceptor = Lewis Acid!',
        ),
      ),
    ],
  );

  static const Subject _mathematics = Subject(
    id: 'mathematics',
    title: 'Mathematics',
    description: 'Algebra, Quadratic Equations, Trigonometry & Matrices',
    group: AcademicGroup.science,
    visualKind: SubjectVisualKind.mathematics,
    totalChaptersCount: 16,
    chapters: [
      Chapter(
        id: 'math_ch1',
        subjectId: 'mathematics',
        number: 1,
        title: 'Quadratic Equations',
        summary:
            'Standard quadratic form, factorization, completing the square, quadratic formula, and discriminant nature of roots.',
        estimatedMinutes: 40,
        weightagePercent: 16,
        keyConcepts: [
          'Standard form ax² + bx + c = 0 (a ≠ 0)',
          'Derivation of Quadratic Formula',
          'Sum & Product of roots (α + β = −b/a, αβ = c/a)',
        ],
        keyPoints: [
          'Discriminant Δ = b² − 4ac determines real vs. complex roots.',
          'If Δ = 0, roots are real and equal.',
        ],
        diagramTitle: 'Parabola Root Intercepts',
        diagramCaption: 'Δ > 0 yields two distinct real x-intercepts.',
        solvedExamples: [
          SolvedExample(
            title: 'Example 1.1 — Quadratic Formula',
            problem: 'Solve x² − 5x + 6 = 0 using the quadratic formula.',
            givenData: ['a = 1', 'b = −5', 'c = 6'],
            formula: 'x = (−b ± √(b² − 4ac)) / 2a',
            solutionSteps: [
              'Δ = (−5)² − 4(1)(6) = 25 − 24 = 1',
              'x = (5 ± 1) / 2 → x = 3 or x = 2',
            ],
            answer: 'Solution Set = {2, 3}',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: [
            'x = (−b ± √(b² − 4ac)) / 2a',
            'α + β = −b/a',
            'αβ = c/a',
          ],
          importantPoints: ['Always write final answers inside curly braces as a Solution Set.'],
          examTips: ['Verify extraneous roots when solving radical equations!'],
          rememberHighlight: 'Check Δ = b² − 4ac first to predict the nature of roots.',
        ),
      ),
      Chapter(
        id: 'math_ch2',
        subjectId: 'mathematics',
        number: 2,
        title: 'Trigonometry',
        summary:
            'Radian measure, trigonometric identities, fundamental ratios, and angle of elevation/depression.',
        estimatedMinutes: 35,
        weightagePercent: 15,
        keyConcepts: [
          'Degree to Radian conversion (π rad = 180°)',
          'Arc length l = rθ',
          'Pythagorean identities (sin²θ + cos²θ = 1)',
        ],
        keyPoints: [
          'In Quadrant I all ratios are positive; in II sine, in III tangent, in IV cosine.',
        ],
        diagramTitle: 'Unit Circle Quadrants',
        diagramCaption: 'ASTC sign rule across the four quadrants.',
        solvedExamples: [
          SolvedExample(
            title: 'Example 2.1 — Arc Length',
            problem: 'Find the arc length of a circle of radius 14 cm subtending π/2 rad.',
            givenData: ['r = 14 cm', 'θ = π/2'],
            formula: 'l = r · θ',
            solutionSteps: ['l = 14 × (22/7 × 0.5) = 22 cm'],
            answer: 'l = 22 cm',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: ['l = rθ', 'sin²θ + cos²θ = 1', '1 + tan²θ = sec²θ'],
          importantPoints: ['θ in l = rθ must always be in radians.'],
          examTips: ['Work from the more complex LHS side when proving trigonometric identities.'],
          rememberHighlight: 'Always convert degrees to radians before using l = rθ!',
        ),
      ),
    ],
  );

  static const Subject _biology = Subject(
    id: 'biology',
    title: 'Biology',
    description: 'Cell Biology, Enzymes, Homeostasis & Genetics',
    group: AcademicGroup.science,
    visualKind: SubjectVisualKind.biology,
    totalChaptersCount: 12,
    chapters: [
      Chapter(
        id: 'bio_ch1',
        subjectId: 'biology',
        number: 1,
        title: 'Nervous Coordination',
        summary:
            'Structure of neuron, nerve impulse transmission, brain lobes, spinal cord, and reflex arc.',
        estimatedMinutes: 35,
        weightagePercent: 15,
        keyConcepts: [
          'Sensory, associative, and motor neurons',
          'Central Nervous System (Brain & Spinal Cord)',
          'Synapse and neurotransmitters',
        ],
        keyPoints: [
          'Cerebellum coordinates voluntary muscle movement and balance.',
          'Medulla oblongata regulates breathing and heart rate.',
        ],
        diagramTitle: 'Reflex Arc Pathway',
        diagramCaption: 'Receptor → Sensory Neuron → Spinal Cord → Motor Neuron → Effector.',
        solvedExamples: [
          SolvedExample(
            title: 'Concept Check — Reflex Action Speed',
            problem: 'Why do spinal reflexes occur faster than conscious brain responses?',
            givenData: ['Short neural pathway via spinal cord interneuron'],
            formula: 'Receptor → Spinal Cord → Effector',
            solutionSteps: [
              'Impulse bypasses higher cerebral processing initially.',
              'Signal reaches effector immediately to prevent tissue damage.',
            ],
            answer: 'Shorter synaptic pathway in the spinal cord.',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: ['Resting Potential ≈ −70 mV'],
          importantPoints: ['Myelin sheath speeds up impulse conduction (saltatory conduction).'],
          examTips: ['Draw a neat labeled neuron diagram with dendrites, cell body, and axon.'],
          rememberHighlight: 'Cerebrum = Intelligence & memory; Cerebellum = Balance!',
        ),
      ),
    ],
  );

  static const Subject _computerScience = Subject(
    id: 'computer_science',
    title: 'Computer Science',
    description: 'Logic Gates, C Programming, Loops & Data Representation',
    group: AcademicGroup.science,
    visualKind: SubjectVisualKind.computerScience,
    totalChaptersCount: 10,
    chapters: [
      Chapter(
        id: 'cs_ch1',
        subjectId: 'computer_science',
        number: 1,
        title: 'Logic Gates & Boolean Algebra',
        summary:
            'AND, OR, NOT, NAND, NOR gates, truth tables, and Boolean simplification.',
        estimatedMinutes: 30,
        weightagePercent: 14,
        keyConcepts: [
          'Basic gates (AND, OR, NOT)',
          'Universal gates (NAND, NOR)',
          'De Morgan’s Theorems',
        ],
        keyPoints: [
          'NAND and NOR are called universal gates because any Boolean circuit can be built from them.',
        ],
        diagramTitle: 'Logic Gate Truth Matrix',
        diagramCaption: 'AND outputs 1 only when all inputs are 1.',
        solvedExamples: [
          SolvedExample(
            title: 'Example 1.1 — Boolean Evaluation',
            problem: 'Evaluate Y = (A · B) + A̅ when A = 0, B = 1.',
            givenData: ['A = 0', 'B = 1'],
            formula: 'Y = (A · B) + A̅',
            solutionSteps: ['(0 · 1) + 1 = 0 + 1 = 1'],
            answer: 'Y = 1',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: ['(A + B)̅ = A̅ · B̅', '(A · B)̅ = A̅ + B̅'],
          importantPoints: ['Number of rows in a truth table with n inputs is 2ⁿ.'],
          examTips: ['Always verify truth table row order from 00 to 11 cleanly.'],
          rememberHighlight: 'Break the bar, change the sign (De Morgan’s Law)!',
        ),
      ),
    ],
  );

  static const Subject _englishScience = Subject(
    id: 'english',
    title: 'English',
    description: 'Prose, Poetry, Grammar, Tenses & Board Essay Writing',
    group: AcademicGroup.science,
    visualKind: SubjectVisualKind.english,
    totalChaptersCount: 12,
    chapters: [
      Chapter(
        id: 'eng_ch1',
        subjectId: 'english',
        number: 1,
        title: 'Active & Passive Voice',
        summary:
            'Rules for transforming tenses, imperative sentences, and interrogatives accurately.',
        estimatedMinutes: 25,
        weightagePercent: 12,
        keyConcepts: [
          'Object becomes subject in passive voice',
          'Past participle (V3) usage across all tenses',
          'Modal auxiliary passive transformations',
        ],
        keyPoints: [
          'Intransitive verbs cannot be converted into passive voice.',
        ],
        diagramTitle: 'Voice Transformation Flow',
        diagramCaption: 'Subject + Verb + Object → Object + Be + V3 + by Subject.',
        solvedExamples: [
          SolvedExample(
            title: 'Example 1.1 — Present Continuous',
            problem: 'Convert: "The students are solving the past paper."',
            givenData: ['Tense: Present Continuous'],
            formula: 'is/are + being + V3',
            solutionSteps: ['The past paper is being solved by the students.'],
            answer: 'The past paper is being solved by the students.',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: ['Passive = Auxiliary (be) + Past Participle (V3)'],
          importantPoints: ['Continuous passive always requires "being".'],
          examTips: ['Double-check singular/plural agreement with the new subject.'],
          rememberHighlight: 'Perfect tenses use "been"; continuous tenses use "being"!',
        ),
      ),
    ],
  );

  static const Subject _civics = Subject(
    id: 'civics',
    title: 'Civics',
    description: 'State, Constitution, Fundamental Rights & Citizenship',
    group: AcademicGroup.arts,
    visualKind: SubjectVisualKind.humanities,
    totalChaptersCount: 10,
    chapters: [
      Chapter(
        id: 'civ_ch1',
        subjectId: 'civics',
        number: 1,
        title: 'Elements of the State',
        summary: 'Population, territory, government, and sovereignty in political science.',
        estimatedMinutes: 25,
        weightagePercent: 16,
        keyConcepts: ['Four essential elements of a state', 'Internal & external sovereignty'],
        keyPoints: ['Sovereignty distinguishes a state from other associations.'],
        diagramTitle: 'Pillars of a Modern State',
        diagramCaption: 'Population • Territory • Government • Sovereignty.',
        solvedExamples: [
          SolvedExample(
            title: 'Board Question — Essential Elements',
            problem: 'List the four essential elements of a modern state.',
            givenData: ['KPK BISE Civics Section B'],
            formula: 'State = Population + Territory + Government + Sovereignty',
            solutionSteps: ['Explain each element in 2–3 concise sentences with examples.'],
            answer: 'Population, Fixed Territory, Government, and Sovereignty.',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: ['4 Pillars: Population, Territory, Government, Sovereignty'],
          importantPoints: ['Without sovereignty, a territory cannot act as an independent state.'],
          examTips: ['Include Aristotle’s definition of Civics in introductory paragraphs.'],
          rememberHighlight: 'Sovereignty is the supreme, indivisible authority of the state.',
        ),
      ),
    ],
  );

  static const Subject _islamicStudies = Subject(
    id: 'islamic_studies',
    title: 'Islamic Studies',
    description: 'Quranic Teachings, Hadith, Seerah & Islamic Ethics',
    group: AcademicGroup.arts,
    visualKind: SubjectVisualKind.humanities,
    totalChaptersCount: 10,
    chapters: [
      Chapter(
        id: 'isl_ch1',
        subjectId: 'islamic_studies',
        number: 1,
        title: 'Rights & Responsibilities in Islam',
        summary: 'Huqooq-ul-Ibad, justice, honesty, and respect for parents and teachers.',
        estimatedMinutes: 25,
        weightagePercent: 18,
        keyConcepts: ['Huqooq-ullah vs Huqooq-ul-Ibad', 'Social justice and truthfulness'],
        keyPoints: ['Fair dealing in trade and promises is emphasized repeatedly in the Quran.'],
        diagramTitle: 'Moral Framework',
        diagramCaption: 'Truthfulness • Justice • Kindness • Trustworthiness.',
        solvedExamples: [
          SolvedExample(
            title: 'Short Question — Trustworthiness (Amanah)',
            problem: 'Explain the significance of Amanah in social life.',
            givenData: ['KPK Board Short Question'],
            formula: 'Amanah covers wealth, duties, and spoken trusts.',
            solutionSteps: ['Quote Quranic principle of returning trusts to rightful owners.'],
            answer: 'Amanah builds social stability and mutual confidence.',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: ['Adl (Justice) + Ihsan (Excellence)'],
          importantPoints: ['Quote accurate translations of verses and Hadith for full marks.'],
          examTips: ['Structure long answers with clear subheadings.'],
          rememberHighlight: 'Always distinguish Huqooq-ullah from Huqooq-ul-Ibad clearly.',
        ),
      ),
    ],
  );

  static const Subject _pakistanStudies = Subject(
    id: 'pakistan_studies',
    title: 'Pakistan Studies',
    description: 'Ideology, Constitutional History, Geography & Foreign Policy',
    group: AcademicGroup.arts,
    visualKind: SubjectVisualKind.humanities,
    totalChaptersCount: 8,
    chapters: [
      Chapter(
        id: 'pst_ch1',
        subjectId: 'pakistan_studies',
        number: 1,
        title: 'Ideological Basis of Pakistan',
        summary: 'Two-Nation Theory, Allama Iqbal’s Allahabad Address, and Quaid-e-Azam’s vision.',
        estimatedMinutes: 30,
        weightagePercent: 20,
        keyConcepts: ['1930 Allahabad Address', '1940 Lahore Resolution', '1973 Constitution basics'],
        keyPoints: ['Lahore Resolution was passed on 23 March 1940.'],
        diagramTitle: 'Timeline 1930–1947',
        diagramCaption: '1930 Allahabad → 1940 Lahore → 1947 Independence.',
        solvedExamples: [
          SolvedExample(
            title: 'Board Question — 1940 Resolution',
            problem: 'State the key demand of the Lahore Resolution 1940.',
            givenData: ['23 March 1940, Minto Park Lahore'],
            formula: 'Independent states for Muslim-majority zones',
            solutionSteps: ['Presented by A.K. Fazlul Haq under Quaid-e-Azam’s leadership.'],
            answer: 'Autonomous & sovereign Muslim-majority regions.',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: ['23 March 1940 • 14 August 1947 • 1973 Constitution'],
          importantPoints: ['Write exact dates and historical personalities accurately.'],
          examTips: ['Use chronological bullet points for historical milestones.'],
          rememberHighlight: 'Dates and constitutional articles earn decisive marks in Pak Studies!',
        ),
      ),
    ],
  );

  static const Subject _accounting = Subject(
    id: 'accounting',
    title: 'Principles of Accounting',
    description: 'Journal, Ledger, Trial Balance & Financial Statements',
    group: AcademicGroup.commerce,
    visualKind: SubjectVisualKind.commerce,
    totalChaptersCount: 12,
    chapters: [
      Chapter(
        id: 'acc_ch1',
        subjectId: 'accounting',
        number: 1,
        title: 'Accounting Equation & Journal',
        summary: 'Assets = Liabilities + Owner’s Equity and double-entry debit/credit rules.',
        estimatedMinutes: 35,
        weightagePercent: 18,
        keyConcepts: ['Double-entry bookkeeping', 'Rules of Debit and Credit'],
        keyPoints: ['Every transaction affects at least two accounts equally.'],
        diagramTitle: 'Accounting Equation Balance',
        diagramCaption: 'Assets = Liabilities + Capital.',
        solvedExamples: [
          SolvedExample(
            title: 'Example 1.1 — Cash Investment',
            problem: 'Owner invested Rs. 500,000 cash into business. Show journal entry.',
            givenData: ['Cash (Asset) increases', 'Capital (Equity) increases'],
            formula: 'Debit Asset Increase, Credit Capital Increase',
            solutionSteps: ['Cash A/c ... Dr. 500,000', 'To Capital A/c ... 500,000'],
            answer: 'Debit Cash Rs. 500,000; Credit Capital Rs. 500,000',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: ['Assets = Liabilities + Owner’s Equity'],
          importantPoints: ['Drawings reduce Owner’s Equity.'],
          examTips: ['Always include brief narration under each journal entry.'],
          rememberHighlight: 'DEALER rule: Dividends, Expenses, Assets increase on Debit!',
        ),
      ),
    ],
  );

  static const Subject _businessMath = Subject(
    id: 'business_math',
    title: 'Business Mathematics',
    description: 'Ratios, Simple & Compound Interest, Annuities & Matrices',
    group: AcademicGroup.commerce,
    visualKind: SubjectVisualKind.mathematics,
    totalChaptersCount: 10,
    chapters: [
      Chapter(
        id: 'bmath_ch1',
        subjectId: 'business_math',
        number: 1,
        title: 'Simple & Compound Interest',
        summary: 'Principal, interest rate, time period, and compound growth.',
        estimatedMinutes: 30,
        weightagePercent: 16,
        keyConcepts: ['Simple Interest I = P × R × T', 'Compound Amount A = P(1 + r)ⁿ'],
        keyPoints: ['Interest rate must match the compounding period.'],
        diagramTitle: 'Compound Growth Curve',
        diagramCaption: 'Compound interest grows exponentially over time.',
        solvedExamples: [
          SolvedExample(
            title: 'Example 1.1 — Simple Interest',
            problem: 'Find simple interest on Rs. 20,000 at 8% p.a. for 3 years.',
            givenData: ['P = 20,000', 'R = 0.08', 'T = 3'],
            formula: 'I = P × R × T',
            solutionSteps: ['I = 20,000 × 0.08 × 3 = Rs. 4,800'],
            answer: 'Rs. 4,800',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: ['I = PRT', 'A = P(1 + r)ⁿ'],
          importantPoints: ['Convert percentage rate by dividing by 100.'],
          examTips: ['Show formula clearly before plugging in financial values.'],
          rememberHighlight: 'Simple interest grows linearly; compound interest grows exponentially!',
        ),
      ),
    ],
  );

  static const Subject _economics = Subject(
    id: 'economics',
    title: 'Economics',
    description: 'Demand, Supply, Elasticity, National Income & Banking',
    group: AcademicGroup.commerce,
    visualKind: SubjectVisualKind.commerce,
    totalChaptersCount: 11,
    chapters: [
      Chapter(
        id: 'econ_ch1',
        subjectId: 'economics',
        number: 1,
        title: 'Law of Demand & Elasticity',
        summary: 'Inverse price-quantity relationship, demand curve shifts, and price elasticity.',
        estimatedMinutes: 30,
        weightagePercent: 16,
        keyConcepts: ['Ceteris paribus assumption', 'Movement vs shift of demand curve'],
        keyPoints: ['Normal goods exhibit downward-sloping demand curves.'],
        diagramTitle: 'Demand Equilibrium Curve',
        diagramCaption: 'Price and quantity demanded move inversely.',
        solvedExamples: [
          SolvedExample(
            title: 'Example 1.1 — Price Elasticity',
            problem: 'Price falls 10% and quantity demanded rises 20%. Find Ed.',
            givenData: ['%ΔQ = +20%', '%ΔP = −10%'],
            formula: 'Ed = |%ΔQ / %ΔP|',
            solutionSteps: ['Ed = 20 / 10 = 2.0 (Elastic)'],
            answer: 'Ed = 2.0 (Elastic Demand)',
          ),
        ],
        quickRevision: QuickRevisionData(
          keyFormulas: ['Ed = %ΔQ / %ΔP', 'GDP = C + I + G + (X − M)'],
          importantPoints: ['Ed > 1 is elastic; Ed < 1 is inelastic.'],
          examTips: ['Draw neat labeled price-quantity graphs in every microeconomics question.'],
          rememberHighlight: 'Price change = movement along curve; income change = shift of curve!',
        ),
      ),
    ],
  );
}
