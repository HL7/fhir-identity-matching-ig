# OAuth and OpenID Token Cross-Reference

This table cross-references the token names and related protocol objects in
the source documents. The names do not all describe distinct
OAuth token types: in particular, the TEFCA and CMS-aligned identity tokens are
both described as CSP-issued OpenID Connect ID tokens, while an OpenID for
Verifiable Presentations (OID4VP) VP Token carries presentations rather than
serving as that identity assertion.

| Token or object | Issuer / source | Purpose and contents | Cross-reference and status |
|---|---|---|---|
| **TEFCA IAS Identity Token** | Credential Service Provider (CSP); TEFCA IAS SOP and unified identity-token discussion | CSP-issued identity assertion used by QHINs for patient-mediated record retrieval over TEFCA. The discussion identifies it as an OIDC ID token carrying identity-proofing claims. | A profile/use of an **OIDC ID Token**, not a separate OAuth grant or token class. |
| **CMS-Aligned Networks CSP Identity Token** / **IAL2 Claims Token** | CSP; CMS Patient Matching Proposal and unified identity-token discussion | The proposal defines an IAL2 Claims Token as a signed OIDC ID token issued after proofing to at least NIST IAL2. A patient-facing app includes it in a matching query; responders validate it and may use its verified demographic claims. | These are alternate names for the CMS-aligned CSP identity assertion in the cited material. They are the same broad token type as the TEFCA IAS Identity Token, but the documents describe different profiles and claim conventions. |
| **Unified identity token, v1 / v2** | Working proposal in the unified identity-token discussion | Proposed single identity assertion usable by both TEFCA and CMS-aligned networks. v1 is a backwards-compatible payload superset; v2 is the cleaner OIDC4IDA-style payload using a `verified_claims` envelope and explicit assurance signaling. | These are proposed payload versions of the CSP-issued **OIDC ID Token**, not additional OAuth token types. The discussion is explicitly non-normative. |
| **OIDC ID Token** (`id_token`) | OpenID Provider / CSP; CMS Patient Matching Proposal, unified identity-token discussion, and OID4VP specification copy | An OpenID Connect identity assertion about the authenticated subject. In the patient-matching documents, it carries CSP-issued identity and assurance claims. | The common token type underlying the TEFCA, CMS CSP, and proposed unified identity-token names. It is distinct from an OAuth access token. |
| **Access Token** (`access_token`) | Authorization Server; referenced in the CMS Patient Matching Proposal | Used to authorize access to a protected resource. The proposal mentions it only as the value whose hash may appear in the ID Token's optional `at_hash` claim. | Distinct from the patient identity assertion; it does not by itself establish IAL2 assurance. Other profiles can carry verified claims in access tokens, but the cited patient-matching documents do not define its format or lifecycle. |
| **Refresh Token** (`refresh_token`) | Authorization Server; discussed in the unified identity-token discussion | Used to obtain replacement access tokens without repeating the initial authorization flow. | The discussion says a 90-day rolling refresh window is referenced informally and calls for a separate specification; it does not define a refresh-token payload or complete behavior. It is not an ID Token. |
| **VP Token** (`vp_token`) | Wallet / credential holder in an OID4VP flow; OID4VP specification copy and the [SMART Health Check-in Protocol](https://smart-health-checkin.joshuamandel.com/protocol/) | Carries one or more Verifiable Presentations assembled from requested credentials. OID4VP allows it in the Authorization Response or Token Response, depending on the response type. The SMART Health Check-in profile keys it by `smart-checkin`, with a one-element Presentation array containing the clinical response object. | Despite its name, this is not the CSP's OIDC ID Token or an OAuth access token. The SMART profile specifies the shape of its VP Token value. |
| **Self-Issued ID Token** (`id_token` in `vp_token id_token`) | End-user / wallet under the Self-Issued OpenID Provider v2 profile; OID4VP specification copy | In the OID4VP combined response type, an ID Token can accompany the VP Token when the request includes the `openid` scope. OID4VP identifies this as a Self-Issued ID Token. | Separate from a CSP-issued TEFCA/CMS IAL2 Claims Token. Do not infer CSP identity proofing or IAL2 assurance from this token's presence. |
{: .grid}

## Reading the cross-reference

- **Identity assertion:** `id_token` is the relevant OIDC token for the TEFCA
  and CMS-aligned identity claims. The two network-specific names describe
  profiles of that token; the unified v1/v2 entries describe proposed ways to
  align their payloads.
- **Authorization:** `access_token` and `refresh_token` serve OAuth
  authorization and renewal purposes. The identity-token documents do not
  specify a complete access-token or refresh-token profile.
- **Credential presentation:** OID4VP's `vp_token` is a presentation response,
  not another name for `id_token` or `access_token`. The check-in protocol uses
  that response to carry its clinical payload.
- An **authorization code** may appear in an OAuth/OIDC response, but it is a
  short-lived grant credential, not one of the token payloads cross-referenced
  here.

See [RFC 7519](https://www.rfc-editor.org/rfc/rfc7519),
[OpenID Connect Core](https://openid.net/specs/openid-connect-core-1_0.html),
and [OpenID Connect for Identity Assurance](https://openid.net/specs/openid-connect-4-identity-assurance-1_0.html).

## Data-element encoding cross-reference

This matrix compares payload encodings, not conformance requirements or
interchangeability. Claim names are case-sensitive. The columns use these
specific sources:

- **JWT:** RFC 7519 registered claims; JWT is a container, not a demographic
  or identity-proofing model.
- **OIDC Core:** standard ID Token and end-user claims. Standard end-user
  claims can also be returned through UserInfo; they are not automatically
  present in every ID Token.
- **OIDC4IDA:** OpenID Connect for Identity Assurance, using the verified
  claims envelope in addition to ordinary OIDC claims.
- **TEFCA v3:** June 2026 IAS SOP, section 4.9, rather than the older SOP
  versions discussed in the unified draft.
- **CMS v3.4:** CMS Patient Matching Proposal v3.4.0, sections D and E. This
  is not the separately referenced CSP Proposal v7.1.
- **Unified v1:** the [working payload gist](https://gist.github.com/jdjkelly/9371a4edd2fd21abfd8bdbea38af40d8)
  referenced by the discussion; a draft targeting TEFCA v2.1 compatibility.
- **Unified v2:** the illustrative payload in section 5.2 of the unified
  identity-token discussion, including separately identified proposed additions.
- **OID4VP / Check-in:** the credential-presentation model and its SMART
  Health Check-in profile, respectively, not CSP identity-token profiles.

### Notation and verification

- **V** means an identity attribute is explicitly carried in OIDC4IDA's
  verified claims envelope, or is asserted as CSP-verified by the TEFCA/CMS
  profile. The latter profiles use top-level claims, not a per-field envelope.
  This annotation is conditional on a valid token and the applicable trust
  and assurance policy; a signature alone does not prove identity verification.
- **C** abbreviates `verified_claims.claims`; **M** abbreviates
  `verified_claims.verification`. For an array of verified claim sets, apply
  those paths within each set. Ordinary top-level OIDC claims can coexist with
  verified claims and must not be treated as verified merely because the
  envelope is also present.
- Address-member paths are shown for an object; where a draft allows an
  address array, apply the member path to each array entry.
- **ND** means the cited model does not define a corresponding claim, not
  that extensions are prohibited. **P** means the encoding depends on the
  presented credential or clinical payload, with no common demographic claim
  path defined by the presentation protocol.
- **Proposed** means absent from the illustrated v2 payload but listed as a
  future addition. **Custom** means an extension, not a standard OIDC claim.
- Email/phone **control verification** (`email_verified`,
  `phone_number_verified`) is distinct from identity proofing under a trust
  framework. Unified v1 retains a mix of draft fields without an explicit
  verified-claims envelope; the matrix does not infer verification for every
  field, particularly nicknames and alternate-name types.

| Data element | JWT | OIDC Core | OIDC4IDA | TEFCA v3 | CMS v3.4 | Unified v1 (draft) | Unified v2 (draft) | OID4VP | Check-in |
|---|---|---|---|---|---|---|---|---|---|
| First Name | ND | `given_name` | V `C.given_name` | V `given_name` | V `given_name` | `given_name` | V `C.given_name` | P | P |
| Middle Name | ND | `middle_name` | V `C.middle_name` | V `middle_name` | V `middle_name` | `middle_name` | V `C.middle_name` | P | P |
| Middle Initial | ND | ND; no separate claim | ND; extension needed | V `middle initial` (literal table label; see notes) | ND | `middle_initial` | ND | P | P |
| Last Name | ND | `family_name` | V `C.family_name` | V `family_name` | V `family_name` | `family_name` | V `C.family_name` | P | P |
| Full Name | ND | `name` | V `C.name` | ND | ND | `name_full` | ND | P | P |
| Name Suffix | ND | ND; may be part of `name` | ND; extension needed | V `suffix` | ND | `suffix`; `name_historical[].suffix` | ND | P | P |
| Nickname / Preferred Name | ND | `nickname` | Ordinary `nickname`; no implied identity proofing | ND | ND | `nickname` | Excluded from main verified payload | P | P |
| Historical Legal Names | ND | ND | ND; extension needed | V URI-named extension; exact suffix unspecified | V `historical_name` | `name_historical[]` with `given_name`, `middle_name`, `family_name`, `suffix`, `name_type` | V `C.name_historical[]` (proposed) | P | P |
| Date of Birth | ND | `birthdate` | V `C.birthdate` | V `birthdate` | V `birthdate` | `birthdate` | V `C.birthdate` | P | P |
| Gender / Legal Sex (not equivalent) | ND | `gender` | V `C.gender`, when asserted as verified | V `gender`; semantics not detailed in table | `gender` described as legal sex or gender at birth | Intentionally excluded pending semantic alignment | V `C.sex_legal` (custom) | P | P |
| Email Address | ND | `email` | V `C.email`; ordinary `email` can coexist | V `email` | V `email` | `email` | V `C.email` | P | P |
| Email Control Verified | ND | `email_verified` (boolean) | Ordinary `email_verified` can coexist with `C.email` | Not separately listed | `email_verified` SHALL NOT be populated | Excluded as discussed errata | Omitted; verified-envelope membership instead | P | P |
| Phone Number | ND | `phone_number` | V `C.phone_number`; ordinary `phone_number` can coexist | V `phone_number` | V `phone_number` | `phone_number` | V `C.phone_number` | P | P |
| Phone Control Verified | ND | `phone_number_verified` (boolean) | Ordinary `phone_number_verified` can coexist with `C.phone_number` | Not separately listed | `phone_number_verified` SHALL NOT be populated | ND | Omitted; verified-envelope membership instead | P | P |
| Historical Phone Numbers | ND | ND | ND; extension needed | V URI-named extension; exact suffix unspecified | `historical_phone_number` | `phone_number_historical[]` | V `C.phone_number_historical[]` | P | P |
| Current Address | ND | `address` (object) | V `C.address` | V `address` (single object) | V `address` | `address` (object or array) | V `C.address` (object in example) | P | P |
| Formatted Address | ND | `address.formatted` | V `C.address.formatted` | V `address.formatted` | ND | `address.formatted` | V `C.address.formatted` | P | P |
| Street Address | ND | `address.street_address` | V `C.address.street_address` | V `address.street_address` | V `address.street_address` | `address.street_address` | V `C.address.street_address` | P | P |
| Address Line 2 | ND | No separate member; multiple lines in `address.street_address` | Same within V `C.address.street_address` | No separate member | No separate member | `address.address_line2` (custom) | No separate member | P | P |
| City | ND | `address.locality` | V `C.address.locality` | V `address.locality` | V `address.locality` | `address.locality` | V `C.address.locality` | P | P |
| State / Region | ND | `address.region` | V `C.address.region` | V `address.region` | V `address.region` | `address.region` | V `C.address.region` | P | P |
| ZIP / Postal Code | ND | `address.postal_code` | V `C.address.postal_code` | V `address.postal_code` | V `address.postal_code` | `address.postal_code`; separate `["ZIP+4"]` | V `C.address.postal_code` | P | P |
| Country | ND | `address.country` | V `C.address.country` | V `address.country` | V `address.country` | `address.country` | V `C.address.country` | P | P |
| Historical Addresses | ND | ND | ND; extension needed | V `historical_address` | V `historical_address[]` if validated by CSP | `historical_address` (object or array) | V `C.address_historical` (object in example) | P | P |
| Full SSN / ITIN | ND | ND | ND; extension needed | Not listed; URI-named extension if supplied | `ssn_itin` | `SSN`; `itin` | ND | P | P |
| Last Four SSN / ITIN Digits | ND | ND | ND; extension needed | Not listed; URI-named extension if supplied | `ssn_itin_short` | `SSN_Last_four_digits` (SSN) | V `C.ssn_last4` (custom; SSN) | P | P |
| Legal Identity Document | ND | ND | `M.evidence[]` entries of type `document`, with `document_details` | Not listed; URI-named extension if supplied | `legal_id` object (for discussion): `legal_id_issuer`, `id_number` | `legal_id_issuer` object: `issuer`, `type`, `identifier` (assumed draft structure) | ND | P | P |
| Stable CSP Person Identifier | ND; `sub` does not ensure lifetime stability | `sub`; distinct stable identifier not defined | Inherits `sub`; distinct stable identifier not defined | `csp_issued_identifier` (optional; stable across accounts) | `uuid` (for discussion) | `csp_uuid` | `uuid` | P | P |
| Issuer | `iss` | `iss` | `iss` | `iss` | `iss` | `iss` | `iss` | Credential/presentation-specific issuer, not a common `vp_token.iss` | Payload-dependent |
| Subject Identifier | `sub` | `sub` | `sub` | `sub` (inherited OIDC requirement) | `sub` | `sub` | `sub` | Credential/holder-specific; not a common `vp_token.sub` | Payload-dependent |
| Audience | `aud` (string or array) | `aud` includes client ID | Inherits OIDC `aud` | `aud` = IAS Provider HCID URI | `aud` = app client ID | `aud` (string or array) | `aud` | Format-specific verifier binding; not a common `vp_token.aud` | No CSP ID Token audience claim defined |
| Issued At / Expiration | `iat`; `exp` (NumericDate) | `iat`; `exp` | Inherits OIDC `iat`; `exp` | `iat`; `exp` (short-lived) | `iat`; `exp` with `exp <= iat + 300` | `iat`; `exp` | `iat`; `exp` | Credential/presentation-specific | Payload-dependent |
| Token Identifier | `jti` | `jti` if used; not Core-required | Inherits JWT/OIDC `jti` if used | `jti` | `jti` | `jti` | `jti` | Format-specific; no common `vp_token.jti` | No common `jti` defined |
| Authentication Time | ND | `auth_time` | Inherits OIDC `auth_time` | OIDC `auth_time` when applicable; not separately listed | `auth_time` | `auth_time` | `auth_time` | Not an OIDC authentication-time claim for all presentations | ND |
| Request Nonce | ND | `nonce` | Inherits OIDC `nonce` | OIDC `nonce` when applicable; not separately listed | Not listed | Not declared in gist | `nonce` | Request `nonce`; response binding is format-specific | Inherits OID4VP request context |
| Access Token Hash | ND | `at_hash` | Inherits OIDC `at_hash` | OIDC `at_hash` when applicable; not separately listed | `at_hash` (optional) | `at_hash` | `at_hash` | Not a common VP claim | ND |
| Trust Framework / Identity Assurance | ND | `acr` is authentication context, not a generic IAL claim | `M.trust_framework`; `M.assurance_level` | IAL2 required by profile; no separate framework/IAL claim listed | `tToken_policy.trust_framework`; `tToken_policy.assurance_level` (literal source spelling) | No explicit framework/IAL claim in gist | `M.trust_framework`; `M.assurance_level`; `identity_assurance_level` (proposed) | Credential-specific assurance; no universal IAL claim | No IAL2 assertion defined by clinical response wrapper |
| Payload / Policy Version | ND | ND | No universal token-version claim | `tefca_ial2claims_version` (SHOULD include; default `"1.0"`) | ND | No explicit version claim | Computed vs. explicit version remains open | Protocol/format-specific | Clinical request `meta.request.version = "1"`; not an identity-token version |
{: .grid}

### Mapping cautions

- **Version differences matter.** TEFCA v3 prohibits unverified demographic
  claims. It requires a full `YYYY-MM-DD` birthdate and uses `address.region`,
  unlike issues described for older TEFCA drafts. Its table prints
  `middle initial` with a space; this matrix preserves that label rather than
  assuming an authoritative `middle_initial` wire key.
- **Verification is not uniform.** TEFCA explicitly prohibits unverified
  demographics, and CMS section D describes CSP-proofed demographic claims.
  CMS nevertheless leaves some fields optional or for discussion. A mapping
  does not establish that every listed attribute was verified at IAL2.
  OIDC4IDA expresses the distinction structurally; its presence does not make
  ordinary top-level claims verified.
- **Drafts are not schemas to implement unchanged.** Unified v2's example
  uses scalar names and address objects despite the discussion's proposed
  multiple-value default. Its historical-name array and top-level
  `identity_assurance_level` are proposed additions, not present in the example.
  Unified v1's legal-document structure is explicitly an assumption in the gist.
  CMS's `tToken_policy` spelling is reproduced as published, not corrected to
  an inferred name.
- **Similar labels need not mean the same thing.** OIDC `gender`, legal sex,
  SSN, ITIN, historical aliases, and historical legal names require semantic
  alignment before translation. A document used as verification evidence is
  not automatically a verified end-user document-identifier claim.
- **Presentation protocols do not define a First Name claim.** OID4VP
  returns credential-specific presentations in `vp_token`. Check-in uses
  `vp_token["smart-checkin"][0]` for its clinical response; demographics may
  be in returned FHIR resources or other requested artifacts, not a universal
  `given_name` field. The **P** cells deliberately avoid inventing such paths.
- **Other token types do not add demographic schemas.** Access and refresh
  tokens have no demographic encoding specified in these source proposals.
  An access-token profile can carry identity claims (including OIDC4IDA
  structures), but being an access token alone establishes no IAL2 assurance.
  A Self-Issued ID Token uses its applicable OIDC/SIOP profile and does not
  inherit CSP verification simply by using OIDC claim names.
