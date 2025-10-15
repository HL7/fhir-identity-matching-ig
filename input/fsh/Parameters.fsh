Profile:        IDIMatchInputParameters
Parent:         Parameters
Id:             idi-match-input-parameters
Title:          "IDI Match Input Parameters"
Description:    "The Parameters profile used to define the inputs of the $IDI-match operation using an IDI-Patient profile for submission."

* ^status = #active
* parameter ^slicing.discriminator.type = #value
* parameter ^slicing.discriminator.path = "name"
* parameter ^slicing.rules = #open
* parameter ^slicing.description = "Slice based on $this pattern"
* parameter 1..* MS
* parameter contains 
	    IDIPatient 1..1 MS and
      onlySingleMatch 0..1 MS and
      onlyCertainMatches 0..1 MS and
      count 0..1 MS

* parameter[IDIPatient]
  * name = "IDIPatient"
  * resource 1..1 MS
  * resource only IDI-Patient or IDI-Patient-L0 or IDI-Patient-L1 or IDI-Patient-L2

* parameter[onlySingleMatch]
  * name = "onlySingleMatch" (exactly)
  * value[x] 1..1 MS
  * value[x] only boolean
  * resource 0..0

* parameter[onlyCertainMatches]
  * name = "onlyCertainMatches" (exactly)
  * value[x] 1..1 MS
  * value[x] only boolean
  * resource 0..0

* parameter[count]
  * name = "count" (exactly)
  * value[x] 1..1 MS
  * value[x] only integer
  * resource 0..0

//=============================================================//

Profile:        IDIMatchOutputParameters
Parent:         Parameters
Id:             idi-match-output-parameters
Title:          "IDI Match Output Parameters"
Description:    "The Parameters profile used to define the outputs of the $IDI-match operation."

* ^status = #active
* parameter ^slicing.discriminator.type = #value
* parameter ^slicing.discriminator.path = "name"
* parameter ^slicing.rules = #open
* parameter ^slicing.description = "Slice based on $this pattern"
* parameter 1..1 MS
* parameter contains 
	  IDIMatchBundle 1..1 MS

* parameter[IDIMatchBundle]
  * name = "IDIMatchBundle" (exactly)
  * resource 1..1 MS
  * resource only idi-match-bundle
