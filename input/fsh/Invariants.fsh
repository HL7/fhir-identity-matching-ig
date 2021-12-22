Invariant:  idi-1
Description: "One of identifier or telecom or family and given names or address or birthdate SHALL be present"
Expression: "identifier.exists() or telecom.exists() or (name.family.exists() and name.given.exists()) or address.exists() or birthDate.exists()"
Severity:   #error

Invariant:  idi-2
Description: "Both given and family SHALL be present"
Expression: "given.exists() and family.exists()"
Severity:   #error

Invariant:  idi-3
Description: "At least one telecom SHALL exist with system = 'phone' and use = 'mobile'"
Expression: "exists(system = 'phone' and use = 'mobile')"
Severity:   #error

Invariant:  idi-L1
Description: "Combined weighted values of included elements exceeds value of 6 (see Patient Weighted Elements table)"
Expression: "((identifier.type.coding.exists(code = 'PPN') and identifier.value.exists()).toInteger()*9) + 
((identifier.type.coding.exists(code = 'DL') and identifier.value.exists()).toInteger()*9) + 
((telecom.exists(system = 'email') and telecom.value.exists()).toInteger()*7) + 
((telecom.exists(use = 'mobile') and telecom.value.exists()).toInteger()*7) + 
((name.family.exists() and name.given.exists()).toInteger()*5) + 
((address.exists(use = 'home') and address.line.exists() and address.city.exists()).toInteger()*5) + 
(birthDate.exists().toInteger()*2) + 
((maritalStatus.coding.code.exists() and maritalStatus.coding.system.exists()).toInteger()*1) + 
(gender.exists().toInteger()*1) > 6"
Severity:   #error

Invariant:  idi-L2
Description: "Combined weighted values of included elements exceeds value of 12 (see Patient Weighted Elements table)"
Expression: "((identifier.type.coding.exists(code = 'PPN') and identifier.value.exists()).toInteger()*9) + 
((identifier.type.coding.exists(code = 'DL') and identifier.value.exists()).toInteger()*9) + 
((telecom.exists(system = 'email') and telecom.value.exists()).toInteger()*7) + 
((telecom.exists(use = 'mobile') and telecom.value.exists()).toInteger()*7) + 
((name.family.exists() and name.given.exists()).toInteger()*5) + 
((address.exists(use = 'home') and address.line.exists() and address.city.exists()).toInteger()*5) + 
(birthDate.exists().toInteger()*2) + 
((maritalStatus.coding.code.exists() and maritalStatus.coding.system.exists()).toInteger()*1) + 
(gender.exists().toInteger()*1) > 12"
Severity:   #error