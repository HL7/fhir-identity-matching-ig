# Golden Record Identifier — Design Brief

**Workgroup:** HL7 FAST Interoperable Digital Identity and Patient Matching
**Author:** Mark Scrimshire, Co-Lead
**Date:** July 23, 2026
**Status:** DRAFT for workgroup discussion
**Scope of this brief:** (1) whether the Golden Record Identifier profile should derive from base FHIR Patient rather than US Core Patient; and (2) which identity attributes belong inside the Golden Record boundary versus employment, organizational, role, and other contextual data.

**Companion artifact:** `IDI-Patient-GoldenRecord.fsh` — a refined FHIR Shorthand profile implementing the recommendation in this brief.

---

## 1. Where this sits in the IG today

The STU3 working branch (`stu3`, version `3.0.0-current`, FHIR R4, depends on `hl7.fhir.us.core: 6.1.0`) already contains an in-progress artifact in `input/fsh/Patient.fsh`:

- A local `CodeSystem: IdentifierTypes` with a single concept `#golden` ("Golden Identifier").
- A `Profile: IDIPatient` (`Id: IDI-Patient`) whose **parent is `us-core-patient`**, slicing `Patient.identifier` on `type` and requiring a `GoldenIdentifier` slice (`1..*`, must-support) with `type`, `value`, `system`, `period`, and `assigner`.
- The `sushi-config.yaml` scaffolds a `golden-identity.md` page plus `LEI_vLEI_primer.md` / `LEI_vLEI_Profiling.md`.

So the decision in Janice's action item #2 is not hypothetical — the current draft **has already picked US Core as the parent**, and this brief evaluates whether that choice should hold. The recommendation below proposes a change, with a migration-safe path.

---

## 2. Base FHIR Patient vs. US Core Patient

### 2.1 What each parent commits us to

Deriving from **base FHIR R4 Patient** inherits only FHIR's own cardinalities and invariants. It carries no mandatory must-support elements and no US-realm demographic obligations.

Deriving from **US Core Patient (6.1.0)** inherits the US Core must-support set and invariants — including must-support on `identifier`, `name`, `telecom`, `gender`, `birthDate`, `address`, `communication`, and the USCDI demographic extensions (race, ethnicity, birth sex, and related). US Core also imposes conformance expectations that assume a US clinical data producer.

### 2.2 The core question: what is a Golden Record Identifier *for*?

The Golden Record Identifier is a **durable, cross-domain identity token** — a way to assert "this is the same person" across organizations, networks, and credential service providers (CSPs). Its job is identity *resolution*, not clinical data exchange. That framing drives the trade-off.

| Consideration | Base FHIR Patient | US Core Patient |
|---|---|---|
| **Applicability to non-EHR assigners** (CSPs, payers, HIEs, identity providers, international) | Broad — any actor can carry the slice | Narrow — presumes a US clinical data producer that can satisfy USCDI must-supports |
| **Coupling of identity to clinical/USCDI data** | Clean separation; identity concern stands alone | Identity profile inherits race/ethnicity/birth-sex must-supports irrelevant to identity resolution |
| **Reusability of the Golden Identifier slice** | Slice is portable to any Patient profile | Slice is bound into a US-Core-shaped record |
| **Alignment with FAST `$IDI-match` input** (deliberately minimal, weighted-attribute bundles) | Strong — match payloads need not be full US Core patients | Weak — forces fuller records than matching requires |
| **Regulatory floor / EHR reuse** (ONC USCDI, CMS interop; EHRs already emit US Core) | Requires a companion path for EHRs | Native — EHRs already produce this shape |
| **Continuity with STU2 design** (IDI matching profiles were intentionally lightweight) | Consistent | A departure |
| **IG dependency already present** | US Core still available for the companion profile | Already wired in |

### 2.3 Recommendation

**Derive the authoritative Golden Record Identifier profile from base FHIR R4 Patient, and provide a US Core–derived companion profile that reuses the identical `GoldenIdentifier` slice.**

Rationale:

The Golden Record Identifier is a context-neutral identity construct. Binding its normative definition to US Core forces every assigner — including CSPs and payers that are not US Core producers, and any future international reuse — to satisfy USCDI clinical must-supports that have nothing to do with establishing "who this is." Keeping the authoritative profile on base Patient preserves the clean separation between *identity* and *clinical/demographic* data that section 3 of this brief formalizes, and it stays consistent with the deliberately minimal, weighted-attribute philosophy of the STU2 `$IDI-match` design.

At the same time, because the IG already depends on US Core 6.1.0 and EHRs are the primary match responders, we should not strand US-realm implementers. The companion profile (`GoldenRecordPatientUSCore`, `Parent: us-core-patient`) applies the same slice inside a US Core record, so an EHR persists the Golden Identifier with zero additional modeling. Both profiles share one slice definition, so there is a single source of truth for the identifier structure.

This two-profile pattern is a well-established HL7 approach when one construct must serve both a broad base and a constrained realm. It directly answers item #2 ("evaluate whether the profile should derive from base FHIR Patient rather than US Core") with: **yes for the authoritative profile, with a US Core companion for realm alignment.**

**If the workgroup prefers a single profile**, the fallback is to keep `Parent: us-core-patient` (today's draft) and document that non-EHR assigners assert the slice on a base Patient out of scope of this IG. That is simpler to ballot but pushes the identity/clinical coupling problem onto implementers and weakens CSP applicability — which is why it is the fallback, not the recommendation.

### 2.4 If FAST Identity becomes a Universal IG rather than US Realm

The action list should weigh a strategic possibility: FAST Identity evolving from a **US Realm** IG into a **Universal Realm** IG. This is not a hypothetical detail — it changes the base-vs-US-Core decision from a preference into a near-constraint.

**US Core cannot anchor a universal IG.** US Core is definitionally US-realm: its jurisdiction is `urn:iso:std:iso:3166#US`, its content is driven by USCDI (a US regulatory data set), and its must-supports encode US demographic and reporting obligations (race, ethnicity, birth sex per OMB/ONC categories). A Universal IG **must not** take a hard dependency on US Core, because doing so would export US-specific demographic modeling to jurisdictions where those categories are inapplicable, differently defined, or legally sensitive. So if universality is on the table, deriving the authoritative Golden Record Identifier profile from **base FHIR Patient is effectively required**, not merely preferred.

Implications if the workgroup wants to keep the universal option open:

- **Parent choice becomes load-bearing.** The recommended base-Patient authoritative profile is universal-ready today. The US Core companion becomes exactly that — a *realm adapter* — one of potentially several (e.g., a future AU Base or other national companion). The architecture in §2.3 scales cleanly to this: one universal slice definition, N realm companions.
- **Jurisdiction and naming systems.** `sushi-config.yaml` currently pins `jurisdiction: urn:iso:std:iso:3166#US`. A universal IG would drop or generalize this, and identifier `system`/naming-system references would need to accommodate non-US authoritative sources and CSPs.
- **Assurance vocabulary.** The IDIAL scheme is framed against NIST 800-63. A universal IG should either abstract assurance to a framework-neutral construct or map NIST levels to equivalents (e.g., eIDAS assurance levels) so non-US CSPs can assert conformance.
- **Organizational identity travels well.** LEI/vLEI (items #6) is already a *global* scheme managed by GLEIF under ISO 17442 — it is inherently universal and needs no realm adaptation. This is a point in favor of universality: the organizational-identity half of the model is realm-neutral by construction, so only the personal-demographic half needs realm companions.
- **Balloting cost.** Universal scope raises the bar for community review and for demonstrating cross-jurisdiction implementability; it should be a deliberate strategic decision, not a byproduct of the parent-profile choice.

**Net effect on the recommendation:** the universal scenario removes the strongest argument *for* a US-Core parent (native EHR/USCDI alignment) by making that alignment realm-specific rather than global. It therefore reinforces §2.3 — build the authoritative profile on base Patient — and reframes any US Core derivation as one realm adapter among potentially several. The workgroup should decide **realm scope (US vs. Universal) first**, because that decision, more than any modeling nuance, settles the parent question.

### 2.5 Slicing discriminator note

The current draft slices `identifier` with a **value** discriminator on `type`. Because `type` is a CodeableConcept bound to a local single-code system, a **`pattern`-based discriminator on `identifier.type`** (or on `identifier.system`) is more robust and is the conventional choice. The companion FSH sets the discriminator to `pattern` on `type` and pins the pattern to `IdentifierTypes#golden`. This is a small correctness fix, flagged here so it is a conscious workgroup decision rather than an incidental change.

---

## 3. The Golden Record boundary — core identity vs. contextual data

### 3.1 Boundary principle

> **Inside the boundary:** the minimum set of attributes needed to *assert and resolve who a person is* with high confidence, plus the metadata that makes that assertion verifiable (assurance, assigner, validity period).
>
> **Outside the boundary:** everything that describes *what a person does, where they work, what role they hold, or their clinical/coverage context.* These change over time, are relationship-specific, and must not be required to establish identity.

A single test distinguishes the two: *if the attribute can change without the person becoming a different human being and without weakening an identity match, it is contextual, not core.* Employer, job title, provider role, and coverage all fail this test; legal name, date of birth, and the assigned identifier pass it.

### 3.2 Attribute classification

**Inside the Golden Record boundary (core identity — must-support in the profile):**

| Attribute | FHIR element | Why it is core |
|---|---|---|
| Golden Identifier value | `identifier[GoldenIdentifier].value` | The identity token itself |
| Identifier namespace / authoritative source | `identifier[GoldenIdentifier].system` | Scopes the value; names the authority/naming system |
| Issuing CSP / assigner | `identifier[GoldenIdentifier].assigner` | Which credential service provider issued it |
| Identifier type | `identifier[GoldenIdentifier].type` | Marks the slice as a Golden Identifier |
| Validity period | `identifier[GoldenIdentifier].period` | When the assignment is/was valid |
| Legal name | `name` | Primary human-readable identity attribute |
| Date of birth | `birthDate` | High-value, stable matching attribute |
| Administrative gender | `gender` | Administrative matching attribute (not clinical sex) |
| Verified mobile & email *(matching aid)* | `telecom` | Used to bind and confirm identity; verified-control attributes |
| Verified home address *(matching aid)* | `address` | Standard demographic matching attribute |

**Outside the Golden Record boundary (contextual — not required by this profile):**

| Data | Where it lives instead | Why it is out |
|---|---|---|
| Employer / employment status | `PractitionerRole`, coverage, or org resources | Relationship-specific; changes without changing identity |
| Organizational affiliation | Organization / affiliation resources; **LEI/vLEI** for the org's own identity | Belongs to the org's identity model, not the person's |
| Professional / provider role | `PractitionerRole`, **vLEI role credentials** | A role held, not who the person is |
| Insurance / member ID | `Coverage`; usable as an Enterprise Identifier for matching | Coverage context, not core identity |
| Clinical data (conditions, meds, allergies) | Clinical resources | Out of scope of identity entirely |
| USCDI race, ethnicity, birth sex, tribal affiliation | US Core extensions on the record | Demographic/clinical reporting, not identity resolution |
| Communication language, marital status, emergency contact | Base Patient elements | Contextual; not needed to resolve identity |

### 3.3 How this connects to the assurance model and to LEI/vLEI

Two adjacent items in the action list intersect this boundary and should be cross-referenced when this brief is socialized:

- **Identity assurance.** The IG's IDIAL levels (IDIAL1.5 / 1.8 / 2) qualify *how well* the core attributes were verified. Assurance metadata — the IAL achieved, verification date, and per-attribute verification status — is **inside** the boundary as metadata about the identity assertion. The companion FSH marks where an assurance extension attaches to the Golden Identifier slice (placeholder pending a canonical URL decision).
- **Organizational identity (LEI/vLEI).** The person's *organizational role* is explicitly **outside** the personal Golden Record boundary. The organization's own identity is modeled separately via LEI/vLEI (item #6), and an individual's authority to act for that organization is a **vLEI role credential** — a contextual, revocable relationship, not a core personal attribute. Keeping this out of the personal boundary is what lets the same person carry different roles across organizations without fragmenting their Golden Record.

---

## 4. Open questions for the workgroup

1. **Realm scope — decide first.** US Realm or Universal Realm? Per §2.4 this gates the parent-profile decision: a universal IG cannot depend on US Core.
2. **One profile or two?** Adopt the recommended base-Patient authoritative profile + US Core companion (a "realm adapter"), or keep the single US-Core-parented draft?
3. **Discriminator:** move `identifier` slicing from `value`-on-`type` to `pattern`-on-`type` (or on `system`)?
4. **Matching aids as must-support:** should verified `telecom` and `address` be must-support (strong matching) or optional (lighter payloads, better privacy posture)?
5. **Assurance extension:** define an IG-local extension to carry IDIAL / verification status on the identifier, or rely on out-of-band assurance signaling? If universal, abstract or map to eIDAS/other frameworks (§2.4)?
6. **`system` semantics:** confirm whether `identifier.system` names the authoritative source/naming system while `identifier.assigner` names the issuing CSP — and whether both are required when a CSP and authoritative source differ (multi-CSP scenario, item #7).

---

## 5. Suggested next actions

- Circulate this brief and `IDI-Patient-GoldenRecord.fsh` ahead of the next workgroup meeting.
- Get a decision on §4 Q1 (one vs. two profiles) — it gates the FSH direction.
- Fold the agreed attribute boundary into the `golden-identity.md` narrative page already scaffolded in the STU3 branch.
- Coordinate the LEI/vLEI role-credential treatment (item #6) so the personal-vs-organizational boundary is described consistently across the personal profile and the LEI/vLEI profiling page.

---

## References

- FAST Interoperable Digital Identity and Patient Matching IG — STU2 v2.0.0 (published 2025-12-10): https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/
- Digital Identity (Digital / Enterprise / Miscellaneous identifier tiers; UUID and assigner rules): https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/digital-identity.html
- Guidance on Identity Assurance (IDIAL levels): https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/guidance-on-identity-assurance.html
- Identity-HL7-Person-Identifier naming system: https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/NamingSystem-Identity-HL7-Person-Identifier.html
- STU3 branch working profile (`input/fsh/Patient.fsh`) and `sushi-config.yaml`: https://github.com/HL7/fhir-identity-matching-ig/tree/stu3
- US Core Patient 6.1.0: https://hl7.org/fhir/us/core/STU6.1/StructureDefinition-us-core-patient.html

*This brief is preliminary and for workgroup discussion; it does not constitute a balloted position.*
