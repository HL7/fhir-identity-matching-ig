//////////////////////////////
// Code Systems and Value Sets
//////////////////////////////
Alias: $IDTYPESVS = http://hl7.org/fhir/ValueSet/identifier-type

CodeSystem: IdentityIdentifierCodeSystem
Id: Identity-Identifier-cs
Title: "Identity Identifier Code System"
Description: "Defining codes for describing specialized identifiers to be used in Patient resource for $match."
* #STID "State Level Identifier" "Represents any appropriate identifier corresponding to a state-issued photo ID that is not a Driver's License"
* ^caseSensitive = true
* ^experimental = false

ValueSet: IdentityIdentifierValueSet
Id: Identity-Identifier-vs
Title: "Identity Identifier Value Set"
Description: "Codes describing various identifiers to be used in Patient resource for $match."
* include codes from system IdentityIdentifierCodeSystem
* include codes from valueset $IDTYPESVS
* ^experimental = false
