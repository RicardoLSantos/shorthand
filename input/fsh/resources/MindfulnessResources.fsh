ValueSet: MindfulnessTypeVS
Id: mindfulness-type-vs
Title: "Mindfulness Practice Types Value Set"
Description: "Value set of mindfulness practice types"
* ^experimental = false
* LifestyleMedicineTemporaryCS#mindfulness-type-meditation "Meditation"
* LifestyleMedicineTemporaryCS#breathing "Breathing Exercise"
* LifestyleMedicineTemporaryCS#bodyScan "Body Scan"
* LifestyleMedicineTemporaryCS#mindfulness-type-walking "Mindful Walking"
* LifestyleMedicineTemporaryCS#movement "Mindful Movement"

ValueSet: EnvironmentTypeVS
Id: environment-type-vs
Title: "Practice Environment Types Value Set"
Description: "Value set of practice environment types"
* ^experimental = false
* LifestyleMedicineTemporaryCS#mindfulness-setting-home "Home Practice"
* LifestyleMedicineTemporaryCS#mindfulness-setting-clinic "Clinical Setting"
* LifestyleMedicineTemporaryCS#mindfulness-setting-group "Group Setting"
* LifestyleMedicineTemporaryCS#mindfulness-setting-retreat "Retreat Setting"
* LifestyleMedicineTemporaryCS#mindfulness-setting-workplace "Workplace Setting"

// MindfulnessSettingCS — MERGED into LifestyleMedicineTemporaryCS (Phase 4, 2026-02-27)
// 5 codes (home, clinic, group, retreat, workplace) now as mindfulness-setting-* in TemporaryCS
