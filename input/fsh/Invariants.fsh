Invariant:  idi-1
Description: "One of identifier or telecom or family and given names or address or birthdate SHALL be present"
Expression:  "identifier.exists() or telecom.exists() or (name.family.exists() and name.given.exists()) or (address.line.exists() and address.city.exists()) or birthDate.exists()"
Severity:   #error

Invariant:  idi-2
Description: "Either the given or family name SHALL be present"
Expression: "given.exists() or family.exists()"
Severity:   #error

//==========================================================================================================
// Weighted values:
// ----------------
//    10	Passport Number (PPN) and issuing country (max weight of 10 for this category, even if multiple Passport Numbers included)
//    10	Driver’s License Number (DL) or other State ID Number and (in either case) Issuing US State (max weight of 10 for this category, even if multiple ID Numbers included)
//     4	Address (including line and city), telecom email or phone, identifier (other than passport, DL or other state ID) OR verified facial photo (i.e. max weight of 4 for any combination of these)
//     4	First Name & Last Name
//     2    Date of Birth
// 
// Base Invariant:
// ---------------
//     ((identifier.type.coding.exists(code = 'PPN') and identifier.value.exists()).toInteger()*10) +
//     ((identifier.type.coding.exists(code = 'DL' or code = 'STID') and identifier.value.exists()).toInteger()*10) +
//     ((((address.exists(use = 'home') and address.line.exists() and address.city.exists()).toInteger() + (identifier.type.coding.exists(code != 'PPN' and code != 'DL')).toInteger() + ((telecom.exists(system = 'email') and telecom.value.exists()) or (telecom.exists(system = 'phone') and telecom.value.exists())).toInteger() + (photo.exists()).toInteger()) > 1).toInteger() * 4) +
//     ((name.family.exists() and name.given.exists()).toInteger()*4)

Invariant:  idi-L0
Description: "Combined weighted values of included elements must have a minimum value of 10 (see Patient Weighted Elements table)"
Expression: "(((identifier.type.coding.exists(code = 'PPN') and identifier.value.exists()).toInteger()*10) +
((identifier.type.coding.exists(code = 'DL' or code = 'STID') and identifier.value.exists()).toInteger()*10) +
(((address.exists(use = 'home') and address.line.exists() and address.city.exists()) or (identifier.type.coding.exists(code != 'PPN' and code != 'DL' and code != 'STID')) or ((telecom.exists(system = 'email') and telecom.value.exists()) or (telecom.exists(system = 'phone') and telecom.value.exists())) or (photo.exists())).toInteger() * 4) + ((name.family.exists() and name.given.exists()).toInteger()*4) + (birthDate.exists().toInteger()*2)) >= 10"
Severity:   #error

Invariant:  idi-L1
Description: "Combined weighted values of included elements must have a minimum value of 20 (see Patient Weighted Elements table)"
Expression: "(((identifier.type.coding.exists(code = 'PPN') and identifier.value.exists()).toInteger()*10) +
((identifier.type.coding.exists(code = 'DL' or code = 'STID') and identifier.value.exists()).toInteger()*10) +
(((address.exists(use = 'home') and address.line.exists() and address.city.exists()) or (identifier.type.coding.exists(code != 'PPN' and code != 'DL' and code != 'STID')) or ((telecom.exists(system = 'email') and telecom.value.exists()) or (telecom.exists(system = 'phone') and telecom.value.exists())) or (photo.exists())).toInteger() * 4) + ((name.family.exists() and name.given.exists()).toInteger()*4) + (birthDate.exists().toInteger()*2)) >= 20"
Severity:   #error
