// ShareableValueSet Compliance RuleSet
RuleSet: ShareableMetadata(version, status, experimental, publisher, description)
* ^version = {version}
* ^status = #{status}
* ^experimental = {experimental}
* ^publisher = "{publisher}"
* ^description = "{description}"
* ^date = "2024-01-01"
* ^contact[0].name = "Clinical Development Team"
* ^contact[0].telecom[0].system = #email
* ^contact[0].telecom[0].value = "clinical@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"

// Apply to all ValueSets
RuleSet: ApplyShareableVS
* insert ShareableMetadata("0.1.0", active, false, 2RDoc PT, [[Comprehensive value set for iOS Lifestyle Medicine]])

// Apply to all CodeSystems  
RuleSet: ApplyShareableCS
* insert ShareableMetadata("0.1.0", active, false, 2RDoc PT, [[Code system for iOS Lifestyle Medicine]])
* ^content = #complete
* ^caseSensitive = true
