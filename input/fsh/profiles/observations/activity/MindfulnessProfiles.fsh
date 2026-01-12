// =============================================================================
// Mindfulness Observation Profile - Lifestyle Medicine Pillar
// =============================================================================
// Updated: 2026-01-12
// Added: Comprehensive bibliographic references
//
// MINDFULNESS & MEDITATION REFERENCES:
// -----------------------------------------------------------------------------
// Foundational Research:
// - Kabat-Zinn J. (2003). Mindfulness-based interventions in context: past,
//   present, and future. Clin Psychol Sci Pract 10(2):144-156.
//   DOI:10.1093/clipsy.bpg016 [MBSR founder, seminal paper]
// - Kabat-Zinn J. (1990). Full Catastrophe Living: Using the Wisdom of Your Body
//   and Mind to Face Stress, Pain, and Illness. Delacorte Press.
//
// Meta-Analyses & Systematic Reviews:
// - Goyal M et al. (2014). Meditation programs for psychological stress and
//   well-being: a systematic review and meta-analysis. JAMA Intern Med
//   174(3):357-368. DOI:10.1001/jamainternmed.2013.13018
//   [47 trials; moderate evidence for anxiety, depression, pain]
// - Goldberg SB et al. (2018). Mindfulness-based interventions for psychiatric
//   disorders: A systematic review and meta-analysis. Clin Psychol Rev 59:52-60.
//   DOI:10.1016/j.cpr.2017.10.011
//
// Physiological Effects:
// - Tang YY et al. (2015). The neuroscience of mindfulness meditation. Nat Rev
//   Neurosci 16(4):213-225. DOI:10.1038/nrn3916
// - Black DS & Slavich GM. (2016). Mindfulness meditation and the immune system:
//   a systematic review of randomized controlled trials. Ann N Y Acad Sci
//   1373(1):13-24. DOI:10.1111/nyas.12998
//
// Stress Reduction:
// - Creswell JD & Lindsay EK. (2014). How does mindfulness training affect
//   health? A mindfulness stress buffering account. Curr Dir Psychol Sci
//   23(6):401-407. DOI:10.1177/0963721414547415
// - Pascoe MC et al. (2017). Mindfulness mediates the physiological markers of
//   stress: Systematic review and meta-analysis. J Psychiatr Res 95:156-178.
//   DOI:10.1016/j.jpsychires.2017.08.004
//
// Digital & App-Based Mindfulness:
// - Linardon J. (2020). Can acceptance, mindfulness, and self-compassion be
//   learned by smartphone apps? A systematic and meta-analytic review of RCTs.
//   Behav Ther 51(4):646-658. DOI:10.1016/j.beth.2019.10.002
// - Huberty J et al. (2019). Efficacy of the mindfulness meditation mobile app
//   "Calm" to reduce stress among college students. JMIR Mhealth Uhealth
//   7(6):e14273. DOI:10.2196/14273
//
// SNOMED CT Codes:
// - 711020003: Meditation (procedure)
// - 228557008: Cognitive and behavioral interventions (procedure)
// - 225364009: Relaxation training (procedure)
// =============================================================================

Profile: MindfulnessObservation
Parent: Observation
Id: mindfulness-observation
Title: "Mindfulness Session Observation"
Description: """
Profile for recording mindfulness practice sessions and outcomes.

**Evidence Base** (Goyal et al. 2014, JAMA):
- Moderate evidence for anxiety reduction (ES 0.38)
- Moderate evidence for depression reduction (ES 0.30)
- Moderate evidence for pain reduction (ES 0.33)

**Session Components**:
- Duration: Minimum 10-20 min/session recommended
- Type: Focused attention, open monitoring, loving-kindness
- Pre/post stress and mood assessment

**Validated Programs**:
- MBSR: Mindfulness-Based Stress Reduction (Kabat-Zinn 1990)
- MBCT: Mindfulness-Based Cognitive Therapy (Segal et al. 2002)

References:
- Kabat-Zinn J. (2003). Clin Psychol Sci Pract 10(2):144-156
- Goyal M et al. (2014). JAMA Intern Med 174(3):357-368
- Tang YY et al. (2015). Nat Rev Neurosci 16(4):213-225
- Linardon J. (2020). Behav Ther 51(4):646-658
"""

* status MS
* code MS
* subject MS
* effectiveDateTime MS
* performer MS
* value[x] MS
* component MS

* status = #final
* code = $LIFESTYLEOBS#mindfulness-session "Mindfulness practice session"
* subject only Reference(Patient)
* effectiveDateTime 1..1
* performer only Reference(Practitioner or PractitionerRole)

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    sessionDuration 0..1 MS and
    stressLevel 0..1 MS and
    moodState 0..1 MS and
    relaxationResponse 0..1 MS and
    mindfulnessType 0..1 MS

* component[sessionDuration]
  * code = $SCT#704323007 "Process duration"
  * value[x] only Quantity
  * valueQuantity
    * value 1..1
    * unit = "min"
    * system = "http://unitsofmeasure.org"
    * code = #min

* component[stressLevel]
  * code = $SCT#365949003 "Health-related behavior finding"
  * value[x] only integer

* component[moodState]
  * code = $SCT#106131003 "Mood finding"
  * value[x] only CodeableConcept
  * valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mood (required)

* component[relaxationResponse]
  * code = $LIFESTYLEOBS#relaxation-response "Relaxation response observation"
  * value[x] only string

* component[mindfulnessType]
  * code = $LIFESTYLEOBS#mindfulness-type "Type of mindfulness practice"
  * value[x] only CodeableConcept
  * valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-type (required)
