**Unified Identity Token Payload v0.1**

Aligning TEFCA IAS and the CMS-Aligned Networks CSP Identity Token

*Working draft for review by CMS-Aligned Networks, Sequoia / RCE / ONC,
and the FAST community*

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr>
<td><p><strong>Status</strong></p>
<p><strong>This document is a discussion summary, not a normative
specification.</strong> It captures the state of an in-progress
conversation among working group participants and should not be cited,
implemented against, or treated as authoritative guidance. Field names,
structures, and positions described here are working proposals subject
to change.</p>
<p>Working draft developed in the CMS Aligned Networks Slack. Reflects
discussion among Flexpa, Fasten Health, CSPs (CLEAR, ID.me), and other
CMS-aligned network participants. Source spec gist:
https://gist.github.com/jdjkelly/9371a4edd2fd21abfd8bdbea38af40d8 The
content of this document may not reflect the opinions of any individual
contributor or their organization.</p></td>
</tr>
</tbody>
</table>

1\. Background and Problem Statement

Patient-mediated health data exchange in the United States is converging
around two related but separately-specified identity token formats:

- **TEFCA IAS Identity Token** — defined in the SOP-TEFCA-IAS-XP
  (currently v2.1, with a v3.0 redline circulating from RCE/Sequoia in
  March 2026). Issued by Credential Service Providers (CSPs) and
  consumed by QHINs to authorize patient-mediated record retrieval over
  TEFCA.

- **CMS-Aligned Networks CSP Identity Token** — described in the v7.1
  CSP Proposal under the CMS Aligned Networks framework, used for
  identity assurance in non-TEFCA flows (Blue Button V3, Kill the
  Clipboard, payer API access, etc.).

Today these two token formats are inconsistent in non-trivial ways:
field naming conventions differ, structures for addresses and identity
documents differ, and assurance-level signaling differs. The same CSP
(CLEAR or ID.me) is being asked to mint slightly different OIDC ID
tokens depending on whether the downstream consumer is a TEFCA QHIN or a
CMS-aligned network.

**Why this matters for patients.** If the two formats remain
incompatible, an application that wants to use both TEFCA and a
CMS-aligned network for the same patient is forced to send the patient
through identity proofing twice — once per token format. The CSP cannot
return two id_token values in a single OAuth token response, so this is
not a small implementation detail; it is a hard UX failure ("why am I
going through CLEAR / ID.me again?").

**Why this matters for the ecosystem.** The TEFCA IAS SOP v2.1 contains
documented errata that have been silently worked around in production by
the CSPs. The v3.0 redline circulating from RCE in March 2026 fixes a
meaningful share of these (lowercased SSN field name, restructured claim
tables, removed defective example token, clarified address
singular/array semantics). Several issues remain — notably the birthdate
“Unknown” default, the zip+4 address duplication, the introduction of
the non-standard regionality field in place of region, missing ISO 3166
constraints on country and region, and absence of a verified
historical-names list parallel to historical address. The v7.1 CSP
Proposal repeats some of those problems and introduces its own. This is
the moment, before either spec is locked in further, to align them.

**Conformance to OpenID Connect for Identity Assurance 1.0.** A core
goal of this work is to bring the unified payload into conformance with
the OpenID Connect for Identity Assurance (OIDC4IDA) 1.0 profile.
OIDC4IDA defines the verified_claims envelope that cleanly separates the
trust framework and assurance level (the verification block) from the
verified attributes themselves (the claims block), provides standard
mechanisms for evidence and assurance signaling, and is supported by an
existing ecosystem of identity providers and tooling. Aligning to
OIDC4IDA gives the unified token a recognized international standard to
anchor against, removes ambiguity around tautological verification
flags, and reduces the long-term maintenance burden on TEFCA, the
CMS-Aligned Networks framework, and CSPs by inheriting structural
decisions rather than re-litigating them locally.

2\. Goals of the Group

The working group (members from Flexpa, Fasten Health, the CSPs, and
other CMS-aligned network participants) is pursuing three goals in
parallel:

2.1 Define a unified, well-formed identity token payload

Produce a single OIDC ID token specification that is acceptable to TEFCA
QHINs and CMS-aligned networks, with clean field naming, well-formed
structures, and explicit assurance-level signaling.

2.2 Enable a non-disruptive migration path

Patients and CSPs cannot be asked to re-proof. The migration must be
staged: a backwards-compatible v1 superset that all networks accept
today, and a cleaner v2 that both TEFCA and CMS-aligned networks adopt
in parallel before v1 is sunset.

2.3 Push corrections back upstream

File errata against TEFCA IAS SOP (v2.1 → v3.0 cycle, currently in
redline at Sequoia/RCE) and against the v7.1 CSP Proposal so that the
next revisions of both documents converge rather than diverge further.
Where appropriate, escalate to ONC. Note: the v3.0 public comment window
may have already closed; if so, the working group should still submit
consolidated feedback to RCE (and in parallel to ONC) so it can be
carried into v3.x or v4.0, rather than waiting for the next formal
cycle.

3\. Errata Identified in the Existing Specs

The discussion identified the following concrete issues. They are
grouped by which document they come from. Several are not just cosmetic
— inconsistent casing or structure has caused real interoperability
problems with QHIN partners (e.g., CommonWell rejecting payloads that
don't allow multiple values for fields where they expect arrays).

3.1 Issues in TEFCA IAS SOP v2.1

These are issues in the SOP itself. The RCE v3.0 redline addresses some
of them; the working group has reviewed both and tracked which remain.

| **Field / Issue** | **Problem** | **Group's Position** |
|----|----|----|
| birthdate "Unknown" default | SOP defines "Unknown" as the default for unset birthdate datetimes; appears in real CLEAR / ID.me tokens. | Annoying but defined in spec. Lower priority — flag for v3.0 cycle but don't block on it. |
| Zip+4 / address duplication | Spec defines a separate Zip+4 field that duplicates information already present in the address.postal_code field. Neither CSP uses it today. | Drop Zip+4. Use a single postal_code on the address object. |
| region / country format | Spec does not constrain these to ISO 3166 codes. | Constrain to 2-letter codes (ISO 3166-1 alpha-2 for country, ISO 3166-2 region codes). |
| regionality vs region | v3.0 redline introduces regionality, which is non-standard. | Prefer region. Flag this with RCE before v3.0 finalizes. |
| verified historical names | SOP supports address_historical and phone_number_historical but does not consistently support a verified historical-names list. | Add. Should mirror the structure of address_historical. |

3.2 Issues in the v7.1 CSP Proposal

| **Field / Issue** | **Problem** | **Group's Position** |
|----|----|----|
| at_hash purpose unclear | Included in CSP proposal but its security role overlaps with nonce. Unclear whether it adds value in 1-to-many QHIN queries. | Open question for CSPs (CLEAR / ID.me). Need a security review — both at_hash and nonce may be inadequate replay-attack protection in a 1-to-many topology. |
| name_type | Difficult for CSPs to determine reliably from upstream identity sources. | Drop or move to extension claims. Real-world data does not cleanly populate this. |
| nickname in main payload | CSP payload is supposed to be authoritative; nicknames are by nature non-authoritative. | Remove from the main payload. Move to extension claims if retained at all. |
| name_full vs historical names | If we offer name_full in the main payload, we should offer it for historical names too — or strike it entirely for symmetry. | Lean toward striking name_full from main payload. Use given_name / middle_name / family_name consistently. |
| email_verified / phone_number_verified flags | Payload represents verified demographics by definition — these flags are tautological. | Remove. Flagged tension with a separate proposal to add unverified demographics to IAS, which would need its own structural treatment. |
| LegalIdentityDocument as nested object | CLEAR has noted that breaking this into individual line items would be operationally easier than a nested object. | Open — needs alignment between CLEAR and ID.me. Either is acceptable; pick one. |
| identity_assurance_level missing | No explicit IAL signaling in payload (currently inferred). | Add identity_assurance_level: 2 (or appropriate value) explicitly. Aligns with NIST 800-63A and the OIDC4IDA verified_claims pattern. |
| Refresh tokens not specified | 90-day rolling refresh token behavior is referenced informally but not specified. | Add a parallel refresh-token spec section. Not strictly errata — gap to fill. |
| Singular vs plural fields | Spec calls out specific fields as accepting multiples. CommonWell has historically rejected payloads where they expected arrays. Default rule is unclear. | Invert the default: allow multiples everywhere, explicitly call out fields that must be a single value (e.g., birthdate, ssn_last4). |

4\. Design Principles

Across the discussion, several principles emerged that the unified spec
should follow:

- **Self-explanatory field names.** ssn_last4 is better than
  ssn_last_four_digits. region is better than regionality. Field names
  should make their content unambiguous to a reader who has not
  memorized the spec.

- **Allow multiples by default.** Most identity attributes (addresses,
  phone numbers, names) can legitimately have multiples. Default to
  arrays; call out the exceptions explicitly.

- **Authoritative payload only.** The main verified_claims block
  represents what the CSP has actually verified at IAL2. Nicknames,
  self-asserted demographics, and verification flags do not belong
  inside it.

- **Self-asserted vs verified separation.** Self-asserted demographics
  belong in the XCPD query (TEFCA) or an analogous query path
  (CMS-aligned networks), not embedded in the IAL2 token. QHINs and
  CMS-aligned RLS implementations should treat data present in the query
  but absent from the token as self-asserted.

- **Standards alignment.** Use ISO 3166-1 / 3166-2 for country and
  region. Use NIST 800-63A trust framework signaling. Where OIDC4IDA's
  verified_claims envelope structure is cleaner than the current TEFCA
  layout, adopt it.

- **Backwards compatibility through versioning.** v1 = superset that
  current TEFCA / CSP infrastructure accepts. v2 = clean unified format.
  Networks accept both during transition; v1 deprecates once TEFCA is on
  v2.

5\. Proposed Payload Examples

5.1 Cleaned-up v1 superset

This is the working example currently in the gist
(https://gist.github.com/jdjkelly/9371a4edd2fd21abfd8bdbea38af40d8). It
is a superset of what TEFCA IAS v2.1 and the v7.1 CSP proposal each
describe, with the lowest-risk errata corrections applied. A CSP that
emits this format can satisfy both consumers.

**Note:** the actual gist contents are the canonical reference; the
example here illustrates the shape only.

5.2 OIDC4IDA-style v2 (cleaner target)

This is closer to where the group would like to land. It uses the
OIDC4IDA verified_claims envelope, drops tautological verification
flags, uses explicit IAL signaling, and uses sensible field names. Alex
Dzeda's draft from the discussion:

> {
>
> "iss": "\<csp iss\>",
>
> "sub": "c60fd4cb7ad14aa39e8610a86ae1a172",
>
> "aud": "ea0909cf0c6d5f8b9e9a3f4a88f70937",
>
> "exp": 1774907776,
>
> "iat": 1774889776,
>
> "nonce": "60f8b776-1e28-4cf7-8474-1efca504c924",
>
> "jti": "77028a09-a261-4894-9fdf-9b6b13a3349e",
>
> "uuid": "c60fd4cb7ad14aa39e8610a86ae1a17a",
>
> "auth_time": 1774889775,
>
> "at_hash": "hashymchash",
>
> "verified_claims": {
>
> "verification": {
>
> "trust_framework": "nist_800_63A",
>
> "assurance_level": "ial2"
>
> },
>
> "claims": {
>
> "given_name": "ALEX",
>
> "middle_name": null,
>
> "family_name": "DZEDA",
>
> "birthdate": "1995-03-19",
>
> "email": "alexdzeda@gmail.com",
>
> "phone_number": "15124592222",
>
> "phone_number_historical": \[\],
>
> "sex_legal": "male",
>
> "ssn_last4": "9999",
>
> "address": {
>
> "formatted": "123 Test Dr, St Paul, MN 55123-1234 US",
>
> "street_address": "123 Test Dr",
>
> "locality": "St Paul",
>
> "region": "MN",
>
> "postal_code": "55123-1234",
>
> "country": "US"
>
> },
>
> "address_historical": {
>
> "formatted": "7525 E Hwy 290, Austin, TX 78723 US",
>
> "street_address": "7525 E Hwy 290",
>
> "locality": "Austin",
>
> "region": "TX",
>
> "postal_code": "78723",
>
> "country": "US"
>
> }
>
> }
>
> }
>
> }

**Why this is better.** It cleanly separates trust-framework signaling
(verification block) from the verified attributes (claims block). It
uses standard OIDC field names. It does not carry email_verified — the
entire claims block is verified by definition. SSN field is named for
what it is. Address uses ISO-aligned region / country.

Items still to add to this example:

- name_historical array, parallel to address_historical /
  phone_number_historical — verified former legal names.

- identity_assurance_level: 2 as a top-level claim alongside the
  verification block (redundant with assurance_level inside
  verification, but mirrors NIST signaling expected by some downstream
  consumers).

- A separate refresh-token specification section, calling out the 90-day
  rolling refresh window explicitly.

6\. Path Forward

6.1 Versioning

Two paths were considered:

- **Computed version.** Version is inferred from payload structure
  (presence/absence of verified_claims envelope, etc.). No new claim
  required.

- **Hinted version.** Add a version claim. Simpler for consumers but
  introduces yet another field.

The group is leaning toward computed versioning to avoid expanding the
claim surface, but this is open. The relevant RFCs (OIDC Core, OIDC4IDA)
need a closer read before locking this in.

6.2 Migration sequence

- Phase 1: Define the v1 superset formally. Both TEFCA QHINs and
  CMS-aligned networks accept it today. CSPs already mint something
  close — this is mostly a documentation and conformance exercise.

- Phase 2: Define v2 (the cleaner OIDC4IDA-style format). Networks
  announce intent to accept both. CSPs add v2 issuance.

- Phase 3: Sunset v1 once TEFCA SOP is updated to align with v2 (likely
  SOP v3.x or v4.0).

6.3 Upstream engagement

Channels for pushing this work upstream:

- **Sequoia / RCE —** for TEFCA IAS SOP errata. The v3.0 redline is in
  flight (March 2026). Coordinate feedback so it lands as a single voice
  from CMS-aligned networks rather than scattered comments. Ryan Howells
  (CARIN / Leavitt) is the noted ally; his instinct was to escalate to
  ONC, which suggests the right path is RCE → ONC.

- **ONC —** for the broader question of TEFCA / CMS-aligned network
  alignment. Engagement should run through established ONC contact
  channels; Ryan Howells’ instinct to take SOP errata directly to ONC
  reinforces this as a parallel track to RCE.

- **CSPs (CLEAR, ID.me) —** for v7.1 CSP Proposal corrections. Direct
  review with Harry Morgenstern (CLEAR) and Peter Eivaz (ID.me). Several
  items (at_hash purpose, LegalIdentityDocument structure, nickname)
  need their input before the spec stabilizes.

- **FAST —** for the security and architecture review, especially around
  1-to-many query topologies (replay-attack protections, nonce vs
  at_hash semantics) where existing OIDC patterns assume 1:1 RP-IdP
  relationships.

6.4 Open questions

- **Replay-attack protection in 1-to-many queries.** OIDC's nonce /
  at_hash pattern was designed for 1:1 OIDC flows. When the same
  id_token is presented to multiple QHINs in a single query, what
  guarantees do we need? This is a security-expert question that the
  group has flagged for FAST.

- **Self-asserted demographics carrier.** In TEFCA, self-asserted
  demographics ride in the XCPD query. CMS-aligned networks are required
  to have an RLS but the wire format is not yet specified to match XCPD
  1:1. The design rule (Query − CSP token = self-asserted) should hold
  across both, but the carrier needs to be defined for CMS-aligned
  networks.

- **OIDC4IDA "unverified demographics" proposal.** There is a proposal
  to add unverified demographics to the IAS payload. This is in tension
  with the principle that the payload represents only verified data.
  Needs resolution before v2 is finalized — either reject the proposal
  or design a clean structural separation (e.g., a sibling
  unverified_claims block).

- **Singular vs plural defaults.** Group consensus is that defaulting to
  plural and calling out the singular exceptions is correct.
  CommonWell's historical pushback supports this. Final list of
  single-value-only fields needs to be enumerated.

7\. Practical Examples of the Problem

7.1 The dual-authentication trap

A patient uses an application that needs both:

- TEFCA-mediated record retrieval (e.g., from a hospital not on a
  CMS-aligned payer network), and

- CMS-aligned network access (e.g., Blue Button V3 for Medicare claims).

Today, if the TEFCA IAS token format and the CSP token format are not
unified, the application has to initiate **two separate identity
proofing sessions** with the same CSP. The CSP cannot return two
id_token values in a single OAuth token response. The patient sees CLEAR
or ID.me twice in one onboarding flow. Real conversion impact, real
abandonment risk.

**Unified payload solution:** one IAL2 proofing event yields one
id_token that is acceptable as a TEFCA IAS token AND as a CSP identity
token. One CSP visit, both networks accessible.

7.2 The CommonWell array rejection

The v7.1 CSP Proposal calls out specific fields that may carry multiples
(e.g., historical addresses) and implicitly treats other fields as
singular. CommonWell has historically rejected payloads where it
expected an array but received a scalar.

**Concrete failure mode:** a patient with two verified phone numbers
gets one of them dropped on the floor by the CSP because the spec is
ambiguous, and CommonWell then rejects the inbound query because the
structure doesn't match its expectation.

**Unified payload solution:** invert the default. All identity
attributes that can plausibly have multiples are arrays; the spec
explicitly enumerates the few that must be singular (birthdate,
ssn_last4).

7.3 The casing-mismatch debugging cost

ID.me currently emits SSN_Last_four_digits because that is what SOP v2.1
literally says, even though the SOP’s own example uses different casing
and standard OIDC convention is lowercase snake_case. The v3.0 RCE
redline corrects the casing to ssn_last_four_digits — resolving the
casing bug. The remaining concern is that the field is still verbose and
does not signal whether it can carry an ITIN.

**Cost of not fixing further:** v3.0 fixes the casing but keeps the
verbose name. Implementers that already special-cased the v2.1 form must
still update mapping code, and the field name still does not communicate
ITIN-vs-SSN semantics. If the working group does not push for a cleaner
name now, the next breaking change opportunity will not come around for
years.

**Unified payload solution:** ssn_last4 (or ssn_itin_last4 if
differentiation is needed) — short, unambiguous, conventional.
Coordinate with RCE so the v3.0 cycle takes the rename in one move
rather than fixing casing now and the name later.

8\. Contributors and References

**Note:** Listing below acknowledges participation in the discussion
only. The content of this document may not reflect the opinions of any
individual contributor or their organization.

Core contributors to this discussion:

- **Joshua Kelly (Flexpa)**

- **Alexander Dzeda**

- **Jason Kulatunga (Fasten Health)**

- **Harry Morgenstern (CLEAR)**

- **Peter Eivaz (ID.me)**

- **Ryan Howells (CARIN / Leavitt)**

References

- Working unified spec gist:
  https://gist.github.com/jdjkelly/9371a4edd2fd21abfd8bdbea38af40d8

- TEFCA IAS SOP v3.0 redline (March 2026):
  https://rce.sequoiaproject.org/wp-content/uploads/2026/03/Redline-for-508_SOP-TEFCA-IAS-XP-v3_March-2026.pdf

- v7.1 CSP Proposal (CMS-Aligned Networks).

- OIDC Core 1.0; OIDC for Identity Assurance (OIDC4IDA); NIST SP
  800-63A.
