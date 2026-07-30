# FAST Identity — Golden Record & CSP Identifier Representation

Draft design notes for the FAST Identity STU3 co-leads workgroup.
Prepared by Mark Scrimshire (Onyx Health).

## Problem

FAST Identity STU3 needs to represent, on a FHIR `Patient`:

1. A **Golden Record Identifier (GRI)** — a master person identifier maintained by a
   governing identity authority.
2. **CSP-issued person identifiers** (CLEAR, ID.me, Login.gov, …), each of which may
   carry a different level of identity proofing.

The international dimension changes the shape of the model: because identity authority
is a sovereign function, a person can hold **more than one** Golden Record. A dual
US/UK citizen legitimately has a US GRI and a UK GRI. So GRI must be modeled as
**`0..*` and jurisdiction-scoped**, not as a single master key.

## Approach: open slicing on `Patient.identifier`

We stay on `Patient.identifier` (R4 `0..*`, US Core 6.1.0 makes it Must Support with
`system` and `value` required) and add **named slices** discriminated by
`identifier.type`:

| Slice | Type code | Card. | Purpose |
|-------|-----------|-------|---------|
| `goldenRecord` | `GRI` | `0..*` | One per jurisdiction; scoped by a jurisdiction extension |
| `cspIdentifier` | `CSPID` | `0..*` | One per CSP identity; carries assurance metadata |

Slicing is **open**, so ordinary identifiers (MRN, member ID) still validate and US Core
compliance is preserved. Slicing is discriminated by `type` rather than `system` so that
onboarding a new CSP or a new national authority requires **no profile change** — the new
identity simply appears as another `cspIdentifier` / `goldenRecord` entry differentiated
at runtime by its `system` and `assigner`.

## Handling the international / dual-citizenship case

Each `goldenRecord` slice carries a mandatory **`identity-jurisdiction`** extension
(ISO 3166-1 country, optionally ISO 3166-2 sub-division) plus an `assigner` pointing to
the national/state identity authority. A dual citizen therefore carries two
`goldenRecord` entries:

- `US-GRI-…`  jurisdiction `US`, assigner = US FAST Identity Trust Network
- `GB-GRI-…`  jurisdiction `GB`, assigner = NHS England Identity Authority

Matching/reconciliation logic resolves **within** a jurisdiction first, then uses the
shared **CSP identifiers as the cross-jurisdiction bridge** — a single CLEAR identity
linked to both GRIs is what lets you recognise the two golden records as the same human
without forcing a single global master key (which no sovereign authority would cede).
This also gives clean semantics for merge/unmerge: a GRI is scoped and owned, so merges
happen inside a jurisdiction and never silently collapse two nations' records.

## CSP assurance metadata

Each `cspIdentifier` carries an optional **`csp-assurance`** extension aligned to
NIST SP 800-63-3:

- `identityAssuranceLevel` — IAL1 / IAL2 / IAL3
- `authenticatorAssuranceLevel` — AAL1 / AAL2 / AAL3
- `verificationDate`
- `verificationEvidence` (repeating, free text for STU3; could be coded later)

This lets a relying party decide whether a given CSP identity meets its proofing bar
before trusting a match.

## Files

- `fast-identity-patient.fsh` — FSH: code systems, value sets, the two extensions, and
  the `FASTIdentityPatient` profile (parented on US Core 6.1.0 Patient).
- `Patient-fast-dual-citizen-example.json` — worked instance: dual US/UK citizen with two
  jurisdiction-scoped GRIs, CLEAR (IAL2/AAL2) and ID.me (IAL2) identities, and an MRN to
  demonstrate that unsliced identifiers still validate.

## Open questions for the workgroup

1. **Discriminator confirmation** — slice by `type` (scales) vs `system` (stricter but
   requires profile edits per new CSP/authority). Recommendation: `type`.
2. **Jurisdiction value set** — bind to ISO 3166 alone, or a FAST-curated authority
   registry that maps jurisdiction → governing organisation?
3. **Is a single GRI ever authoritative across jurisdictions**, or is the CSP-bridge model
   the accepted federation pattern? This is the core policy question behind the technical model.
4. **Evidence coding** — keep `verificationEvidence` as free text for STU3, or bind to a
   coded value set (e.g. evidence types) now?
5. **GRI vs Person/Linkage** — for cross-jurisdiction reconciliation, do we also want a
   `Person` or `Linkage` resource layer, or is the identifier-on-Patient model sufficient
   for STU3 scope?

> Placeholder canonical URLs use `fast.hl7.org` — replace with the official FAST
> canonical base before publication. Assurance codes are modeled as a local CodeSystem;
> if HL7 or NIST publishes an official 800-63-3 code system, bind to that instead.
