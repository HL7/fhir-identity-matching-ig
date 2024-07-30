Profile:        IDIMatchInputParameters
Parent:         Parameters
Id:             idi-match-input-parameters
Title:          "IDI Match Input Parameters"
Description:    "The Parameters profile used to define the inputs of the $IDI-match operation using an IDI-Patient profile for submission."

* ^status = #active
* parameter ^slicing.discriminator.type = #pattern
* parameter ^slicing.discriminator.path = "name"
* parameter ^slicing.rules = #open
* parameter ^slicing.description = "Slice based on $this pattern"
* parameter 1..1 MS
* parameter contains 
	  IDIPatient 0..1 MS
* parameter[IDIPatient].name = "patient"
* parameter[IDIPatient].resource 1..1 MS
* parameter[IDIPatient].resource only IDI-Patient or IDI-Patient-L0 or IDI-Patient-L1


Profile:        IDIMatchOutputParameters
Parent:         Parameters
Id:             idi-match-output-parameters
Title:          "IDI Match Output Parameters"
Description:    "The Parameters profile used to define the outputs of the $IDI-match operation."

* ^status = #active
* parameter ^slicing.discriminator.type = #pattern
* parameter ^slicing.discriminator.path = "name"
* parameter ^slicing.rules = #open
* parameter ^slicing.description = "Slice based on $this pattern"
* parameter 1..1 MS
* parameter contains 
	  IDIMatchBundle 1..1 MS
* parameter[IDIMatchBundle].name = "coverage"
* parameter[IDIMatchBundle].resource 1..1 MS
* parameter[IDIMatchBundle].resource only idi-match-bundle