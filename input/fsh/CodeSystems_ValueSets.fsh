//////////////////////////////
// Code Systems and Value Sets
//////////////////////////////
Alias: $IDTYPESVS = http://hl7.org/fhir/ValueSet/identifier-type

CodeSystem: IdentityIdentifierCodeSystem
Id: Identity-Identifier-cs
Title: "Identity Identifier Code System"
Description: "Defining codes for describing specialized identifiers to be used in Patient resource for $idi-match."
* #STID "State Level Identifier" "Represents any appropriate identifier corresponding to a state- or territory-issued photo ID that is not a Driver's License. This code will likely be migrated to THO at some point in the future."
* ^caseSensitive = true
* ^experimental = false
* #SSN4 "SSN Last 4" "Represents the last four digits of US Social Security Number. This code may be migrated to THO at some point in the future."
* ^caseSensitive = false
* ^experimental = false

ValueSet: IdentityIdentifierValueSet
Id: Identity-Identifier-vs
Title: "Identity Identifier Value Set"
Description: "Codes describing various identifiers to be used in Patient resource for $idi-match."
* include codes from system IdentityIdentifierCodeSystem
* include codes from valueset $IDTYPESVS
* ^experimental = false
