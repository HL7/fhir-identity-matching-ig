
### B.1 Background and Scope

This guidance defines how the FAST Identity Matching IG profiles the use of the **LEI** and the **vLEI** for **verifiable organizational identity**. 

**In scope.**

- The FHIR `Organization` resource as the carrier of organizational identity.
- The decision rule for when an LEI string is sufficient and when a verifiable LEI credential is required.
- The bridge from a verified organization to an **IAL2-assured individual** acting on its behalf, conveyed via OOR or ECR credentials. (FHIR `Practitioner` / `PractitionerRole` profiling for OOR/ECR is referenced but defined in companion FAST Identity guidance.)
- Alignment with **UDAP** and the **FAST Security IG**.

**Out of scope.**

- Patient identity matching (covered elsewhere in this IG).
- The wire-level mechanics of KERI/ACDC verification (delegated to the GLEIF specifications and to FAST Security guidance on integration of vLEI and associated KERI-based credentials).
- Endpoint-level profiling beyond the touchpoints needed to explain the trust chain.

### B.2 LEI and vLEI — Definitions for Conformance

For use within this IG:

- **LEI** — a 20-character alphanumeric ISO 17442 identifier issued under the GLEIF system. The canonical identifier system URI for FHIR use is `https://www.gleif.org/lei` (see §B.5.1).
- **vLEI** — a verifiable credential issued under the GLEIF vLEI ecosystem, expressed as a KERI/ACDC credential, chained from GLEIF through a Qualified vLEI Issuer (QVI) to the legal entity. References to "the vLEI" in this IG mean the **Legal Entity vLEI Credential** unless explicitly qualified as OOR or ECR.
- **OOR credential** — a vLEI credential binding a named individual to the legal entity in an officially registered role (taxonomy per ISO 5009).
- **ECR credential** — a vLEI credential binding a named individual to the legal entity for a specific engagement context, with the role label defined by the issuing organization.
- **AID (Autonomic Identifier)** — a self-certifying KERI identifier whose value is mathematically derived from its controlling key state. The vLEI credential subject is identified by an AID. AIDs are stable across key rotations and are independent of the X.509 PKI; verification proceeds via the AID's KERI Key Event Log (KEL), resolved through one or more OOBI URLs.
- **KEL (Key Event Log)** — the tamper-evident, append-only log of all key events for an AID (inception, rotations, delegations). Verifiers consult the KEL to confirm the current key state of the AID at the time a credential was signed.
- **OOBI (Out-Of-Band Introduction)** — a URL that allows a relying party to bootstrap KERI verification material (KEL, witness endpoints) for a given AID. See §B.5.2 for healthcare-specific guidance on hosting OOBIs at organization-controlled `.well-known` paths.

### B.3 Profiling Principle: Identifier vs. Credential

The single most important profiling principle in this section is the distinction between an **identifier** and a **credential**:

- The **LEI is an identifier**. It tells you *which* legal entity is being referred to. It belongs in `Organization.identifier`.
- The **vLEI is a credential**. It tells you *that* the entity referred to is genuinely the one identified by that LEI, and it carries independently-verifiable cryptographic proof of that fact. It does not replace the LEI in `Organization.identifier`; it is conveyed via a credential reference and verified out of band of the FHIR resource itself.

A FHIR resource never embeds a vLEI credential inline. Instead, the resource:

1. Carries the LEI as a structured `identifier`, and
2. Optionally carries an extension or link indicating that a verifiable credential exists, where it is anchored (KERI AID), and through which QVI it was issued.

This separation matters because FHIR resources are mutable, propagated, and frequently re-served — the verifiable claim must be re-checkable from a stable cryptographic source, not from the FHIR copy.

### B.4 Decision Matrix — When LEI Is Sufficient, When vLEI Is Required

The following matrix maps common FAST scenarios to the minimum identity assurance needed for the **organizational** layer. The matrix is non-normative for STU3 but is intended to harden into SHALL/SHOULD language as adoption matures.

#### B.4.1 Matrix: Organizational Identity Assurance

| # | Scenario | Trust requirement | LEI sufficient? | vLEI required? | Rationale |
|---|---|---|---|---|---|
| 1 | Listing an organization in a directory (NDH, payer directory, network roster) | Identification only | Yes | No | The directory is the source of truth; the LEI cross-references the entity globally. |
| 2 | Cross-walking organizational records between networks (e.g., NDH ↔ TEFCA participant list) | Identification only | Yes | No | Reconciliation does not require real-time proof; the LEI is an unambiguous join key. |
| 3 | Regulatory or analytics reporting that names an organization | Identification only | Yes | No | The relying party validates by registry lookup, not by credential. |
| 4 | A FHIR `Organization` resource published as reference data | Identification only | Yes | Optional (recommended) | Adding a vLEI reference future-proofs the resource for downstream verifiers. |
| 5 | Issuing or rotating an OAuth client credential bound to an organization | Authentication of legal entity | No | Yes | The authorization server must prove which legal entity controls the client; LEI alone is unauthenticated. |
| 6 | Asserting an organization in a UDAP dynamic client registration | Authentication of legal entity | No | Yes | UDAP today binds to X.509 + DNS; the vLEI binds to the legal entity behind the cert. See §B.7. |
| 7 | Cross-network FHIR data exchange where TLS and the responding server's cert do not establish *who the requester legally is* | Authentication of legal entity | No | Yes | Endpoint trust ≠ entity trust. The vLEI closes the gap. |
| 8 | Submitting prior authorization, regulatory filings, claims attachments, or payment instructions on behalf of an organization | Authentication + delegation | No | Yes (Legal Entity + OOR/ECR) | High-trust transactions require both organizational authentication and proof that the human (or system) is authorized to act on the entity's behalf. |
| 9 | Delegating a specific authority to a vendor, an admin staff member, a system, or a downstream organization, or AI agent | Authentication + delegation | No | Yes (ECR) | ECR is the explicit mechanism for engagement-context delegation; LEI cannot express delegation. |
| 10 | Logging / auditing an action attributed to an organization in a way that survives later dispute | Cryptographic accountability | No | Yes | Only a cryptographically signed credential supports non-repudiation. |
| 11 | Population health, benchmarking, or de-identified analytics that name participating organizations | Identification only | Yes | No | No transactional trust required. |
| 12 | Initial onboarding of an organization to a network where credentials will *later* be issued | Identification (then authentication on issuance) | Yes (initial); vLEI on activation | Required by go-live | The organization can be referenced by LEI during paperwork; the vLEI is required before the entity is allowed to authenticate. |
{: .grid}

#### B.4.2 Plain-English Decision Rule

> **Use the LEI alone when you only need to *identify* the organization.**
> **Use the vLEI when the organization, or a person, or agent, acting on its behalf, is *acting* — making, signing, asserting, or authorizing something — and the relying party needs cryptographic proof.**

A useful test question: *"If this assertion turned out to be wrong, would I want a cryptographic record of who actually made it?"* If yes, vLEI is required.

### B.5 Organization Resource Profiling

#### B.5.1 LEI as `Organization.identifier`

The LEI is conveyed as an entry in `Organization.identifier` with the following semantics:

- `system` = `https://www.gleif.org/lei` (canonical GLEIF URI for the LEI)
- `value` = the 20-character LEI string (uppercase per ISO 17442)
- `use` = `official`
- `type.coding` = an `IDTYPE` code (the FAST Identity work group will publish a CodeSystem or extend an existing one; in the interim, a `Coding` with `display = "Legal Entity Identifier"` is acceptable for narrative IGs)

**Cardinality guidance.** This IG SHOULD treat the LEI as the *preferred* organizational identifier where one is available, while continuing to permit NPI, Tax ID, and OID identifiers in the same `Organization.identifier` array. Slicing on `system` allows multiple identifiers to coexist without ambiguity.

#### B.5.2 Conveying vLEI Verifiability

A FHIR resource cannot carry a verifiable credential by value. It can, however, signal:

- **That** a Legal Entity vLEI Credential exists for this organization,
- **Where** the credential's KERI AID can be discovered,
- **Through which QVI** the credential was issued, and
- **Where** verification material (KEL/TEL anchors, witness endpoints) can be reached via one or more **OOBI URLs**.

The FAST Identity work group SHOULD define a single extension on `Organization.identifier` (slice: LEI) for this purpose. A working name is `org-vlei-anchor`. The extension should carry, at minimum:

- `aid` — the KERI Autonomic Identifier of the Legal Entity vLEI credential subject,
- `qvi` — the LEI of the Qualified vLEI Issuer that issued the credential,
- `oobi` — one or more **OOBI (Out-Of-Band Introduction) URLs** through which a relying party can resolve KERI verification material for the AID.

Verifiers MUST resolve the credential out of band via the KERI infrastructure. The FHIR resource is a *pointer*, not a substitute for the credential.

##### B.5.2.1 Healthcare-specific guidance: the organization-controlled OOBI

For healthcare exchange, the OOBI URL SHOULD resolve to an endpoint that the organization itself controls — typically a path under the organization's primary domain. The recommended pattern is to publish the OOBI under a stable, well-known path:

```
https://{organization-domain}/.well-known/vlei/oobi
```

A `.well-known` path (per RFC 8615) is appropriate because it is a standardized, predictable location for service metadata that any relying party can find without prior coordination.

Hosting the OOBI on infrastructure the organization controls delivers three benefits at once:

1. **Self-sovereign verification anchor.** The organization, not a third party, is responsible for serving the KERI verification material. A relying party that trusts the organization's control of its primary domain (which it must already trust for TLS) can bootstrap vLEI verification from the same root.
2. **Service-discovery touchpoint.** Because the path is on the organization's own domain, it can co-locate or link to other exchange-relevant metadata: FHIR `CapabilityStatement` endpoints, `well-known/smart-configuration`, UDAP metadata, supported networks, technical and trust contacts, and so on. The OOBI URL becomes a hub for "everything a relying party needs to engage in exchange with this organization."
3. **Operational simplicity.** Key rotation, witness changes, or QVI changes are handled by updating the content served at the same well-known URL. FHIR `Organization` resources, directory listings, and downstream consumers do not need to be re-issued.

Implementers SHOULD ensure that:

- The OOBI URL uses HTTPS with a valid certificate.
- The endpoint is highly available (it is on the verification critical path).
- Content served at the OOBI URL is authoritative for the AID it represents and is kept in sync with the organization's KERI key state.
- Where the same `.well-known` namespace is used to host other exchange metadata, those resources are clearly distinguished from the OOBI itself (e.g., different path segments under `/.well-known/vlei/`).

##### B.5.2.2 Multiple OOBIs

> **What is a witness?** In KERI, a *witness* is an independent service designated by the controller of an AID to observe that AID's Key Event Log (KEL) and counter-sign each event it sees, producing a **key event receipt**. Witnesses serve two purposes. First, they provide **independent attestation** that the controller's published KEL is the same history the witness observed — this is KERI's defence against *duplicity*, where a malicious controller could otherwise present different key histories to different verifiers. Second, they provide **availability**, since a verifier can fetch verification material from a witness even when the controller's own endpoint is unreachable. An organization typically designates a small set of witnesses (often 3–7) and specifies a witness *threshold* (for example, "any 2 of 3" or "any 5 of 7") that verifiers require before accepting a key event as confirmed. Witnesses are usually operated by independent parties — sometimes the QVI, sometimes dedicated witness operators — precisely so that no single party controls the historical record. For OOBI purposes, a witness endpoint is therefore both a *redundant route* to verification material and an *independent attestation* of the same key state.

An organization MAY publish more than one OOBI URL — for example, one on its own domain and one or more provided by witness operators — for resilience and for independent attestation. The `oobi` extension cardinality is therefore `1..*`. Verifiers SHOULD be prepared to try alternate OOBIs if one is unreachable, and MUST require that all reachable OOBIs resolve to materially consistent KERI state for the same AID. Where the relying party's policy specifies a witness threshold, the verifier MUST confirm that threshold has been met before accepting a credential.

#### B.5.3 Illustrative FSH

The following FSH is illustrative only — it shows the shape of the slicing and extension; final names, URIs, and binding strength are deferred to the FAST Identity work group.

```fsh
// Identifier slice for the LEI on FHIR Organization
Profile:        FASTOrganization
Parent:         Organization
Id:             fast-organization
Title:          "FAST Organization"
Description:    "Organization profile supporting LEI identification and optional vLEI verifiability."
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains lei 0..1 MS and npi 0..1 MS and taxId 0..1
* identifier[lei].system = "https://www.gleif.org/lei" (exactly)
* identifier[lei].value 1..1 MS
* identifier[lei].use = #official
* identifier[lei].extension contains
    OrgVleiAnchor named vleiAnchor 0..1 MS

Extension:      OrgVleiAnchor
Id:             org-vlei-anchor
Title:          "Organization vLEI Anchor"
Description:    "Pointer to the Legal Entity vLEI credential that verifies the LEI carried on this identifier slice. Verification is performed out of band via KERI. For healthcare exchange, at least one OOBI URL SHOULD resolve to an endpoint controlled by the organization itself, typically under /.well-known/vlei/oobi on the organization's primary domain."
* extension contains
    aid 1..1 MS and
    qvi 0..1 MS and
    oobi 1..* MS
* extension[aid].value[x] only string
* extension[aid].value[x] ^short = "KERI Autonomic Identifier (AID) of the Legal Entity vLEI subject"
* extension[qvi].value[x] only Identifier
* extension[qvi].value[x] ^short = "LEI of the Qualified vLEI Issuer that issued the credential"
* extension[oobi].value[x] only url
* extension[oobi].value[x] ^short = "OOBI URL for KERI verification (organization-controlled .well-known endpoint preferred for healthcare)"

// Example
Instance:       AcmeHealthOrganization
InstanceOf:     FASTOrganization
Title:          "Acme Health System"
Usage:          #example
* name = "Acme Health System"
* identifier[lei].system = "https://www.gleif.org/lei"
* identifier[lei].value = "549300ABCD1234567890"
* identifier[lei].use = #official
* identifier[lei].extension[vleiAnchor].extension[aid].valueString = "EAbCdEfGhIjKlMnOpQrStUvWxYz0123456789AbCd"
* identifier[lei].extension[vleiAnchor].extension[qvi].valueIdentifier.system = "https://www.gleif.org/lei"
* identifier[lei].extension[vleiAnchor].extension[qvi].valueIdentifier.value = "9876543210ZYXWVUTSRQ"
// Primary OOBI: organization-controlled .well-known endpoint
* identifier[lei].extension[vleiAnchor].extension[oobi][0].valueUrl = "https://acmehealth.example.org/.well-known/vlei/oobi"
// Secondary OOBI (optional): witness operator endpoint, for resilience
* identifier[lei].extension[vleiAnchor].extension[oobi][+].valueUrl = "https://oobi.example-witness.org/oobi/EAbCd.../witness/BWit..."
```

The example LEI value shown above is illustrative; production LEIs are governed by GLEIF and conform to ISO 17442.

### B.6 Delegation of Authority — Organization to IAL2 Individual

A central insight from the 9 April 2026 co-leads discussion is that delegation in healthcare is not primarily a *patient → caregiver* story; it is overwhelmingly an *organization → individual / vendor / system* story. This section profiles how an organization with a Legal Entity vLEI confers authority on an IAL2-assured individual, and how that delegation is conveyed to FHIR consumers.

#### B.6.1 The Trust Stack

The full delegation trust stack runs from the GLEIF root of trust to a specific transaction:

1. **GLEIF** — root of trust for the vLEI ecosystem.
2. **Qualified vLEI Issuer (QVI)** — accredited by GLEIF to issue Legal Entity, OOR, and ECR credentials.
3. **Legal Entity vLEI Credential** — anchors the organization (the LEI).
4. **OOR or ECR credential** — issued by the organization (or its authorized issuer), binding a named individual to a role or engagement context.
5. **IAL2 individual digital identity** — the individual's identity has been proofed to NIST SP 800-63A IAL2. The OOR/ECR credential binds this proofed identity to the organization and the role.
6. **Authentication assertion (AAL2 or higher)** — the individual authenticates at the appropriate AAL when they act.
7. **Transactional authority** — the relying party verifies the vLEI chain, the OOR/ECR scope, and the AAL of the session, and grants the requested action.

The IAL2 layer is independent of the vLEI: **IAL2 establishes who the human is**; **the OOR/ECR establishes which organization that human is acting for, and in what capacity.** Both are required for high-trust transactions; neither is a substitute for the other.

#### B.6.2 OOR vs. ECR — Choosing the Right Credential

| Aspect | OOR (Official Organizational Role) | ECR (Engagement Context Role) |
|---|---|---|
| Role taxonomy | ISO 5009 (general-business roles: CEO, CFO, etc.) | Defined by the issuing organization for a specific context |
| Stability | Long-lived; tied to public corporate roles | Often time-bounded or scoped to a transaction class |
| Healthcare fit | Limited (few healthcare-specific roles in ISO 5009) | High — encodes "authorized for prior auth," "authorized for regulatory filing," "data exchange representative" |
| When to require | Board attestations, public regulatory filings, signed corporate disclosures | Day-to-day transactional authority across FHIR APIs, TEFCA exchange, payer-provider workflows |
{: .grid}

For most FAST FHIR use cases, the **ECR is the operative credential**. OORs are useful for high-formality attestations.

#### B.6.3 IAL2 Anchoring

The OOR/ECR credential binds the *individual subject identifier* (e.g., a KERI AID controlled by the individual, or another resolvable identifier) to the organization. The IAL2 identity proofing process — and the chosen identity provider — sit *underneath* this binding. This IG does not prescribe a specific IdP. It does require that:

- The individual's identifier in the OOR/ECR credential resolves to an identity proofed to **at least IAL2**.
- The session in which the credential is exercised is authenticated to **at least AAL2**.
- The relying party verifies *both* the vLEI credential chain (organizational + role) *and* the IAL2/AAL2 properties of the underlying identity assertion.

FHIR profiling of the OOR/ECR-to-`PractitionerRole` mapping is companion guidance to this document and is referenced from the `Practitioner` and `PractitionerRole` profiles.

### B.7 Alignment with UDAP and the FAST Security IG

This guidance is intended to be **layered on top of**, not in conflict with, UDAP and the FAST Security IG. The vLEI does not displace UDAP's PKI-based client identity; it complements it by adding a **legal entity** layer beneath the existing **endpoint / client** layer.

#### B.7.1 The Existing UDAP Pattern

UDAP today identifies an OAuth client by binding it to an X.509 certificate whose subject identifies the client and whose issuer is a trusted CA. The certificate establishes:

- *Which TLS endpoint or OAuth client* is making the request;
- *That the certificate was issued by a recognized CA*.

It does **not** by itself establish that the legal entity behind the client is who it claims to be globally. In a multi-network world (TEFCA, CMS Aligned Networks, payer-provider, vendor ecosystems), CA-rooted trust fragments along network boundaries.

#### B.7.2 What the vLEI Adds

A Legal Entity vLEI Credential, presented alongside or referenced from the X.509-based UDAP credential, anchors the client to a **globally recognized legal entity** under a single root of trust (GLEIF) that crosses network boundaries.

Two integration patterns are anticipated for FAST Security:

1. **Side-by-side.** The X.509 certificate continues to authenticate the OAuth client; the relying party additionally resolves a Legal Entity vLEI credential (via the `org-vlei-anchor` extension on the corresponding `Organization` resource, or via a JWT claim) to confirm the legal entity. This is the lower-disruption path and is the expected near-term posture.
2. **vLEI-native.** The OAuth client's authentication itself is mediated by KERI/ACDC primitives — for example, a software statement signed by a key chained from the Legal Entity vLEI. This is the direction enabled by the FAST Security ↔ HealthKeri integration noted in the 9 April call, and is expected to mature alongside the vLEI tooling ecosystem.

##### B.7.2.1 Why this matters: durability across PKI lifecycle events

A practical motivation for layering the vLEI under UDAP is that vLEI-based legal-entity identity is **durable across trust boundaries and PKI lifecycle events** in a way that X.509-based identity is not. (The educational framing of this point appears in §A.4.1; the security-engineering implications are summarized below.)

| Event | Effect on X.509 / UDAP identity | Effect on vLEI legal-entity identity |
|---|---|---|
| Joining a new network with a different CA trust list | Re-issue or re-cross-certify; re-register UDAP client | None — the vLEI is recognized by every ecosystem rooted in GLEIF |
| Certificate routine rotation (1–2 yr cycle) | Every artifact bound to the old cert subject/thumbprint must be updated | None — AID is stable; the KEL records the rotation, no downstream re-issuance |
| Key compromise / emergency rotation | Cert revoked; new cert issued; downstream systems must trust the new cert | KERI rotation event recorded in the KEL; AID and vLEI remain valid |
| CA distrust / root program change | All certs under that CA must be replaced; trust paths break until reissued | Verification path runs through GLEIF/KERI, not X.509 — unaffected |
| Organization changes its TLS provider | New cert from a different CA; counterparty trust must be re-established | None — vLEI is independent of the TLS provider |
| Organization changes its OAuth client implementation | New `client_id`, new software statement, new dynamic registration | Same vLEI references the same legal entity; only the client-auth layer is rebuilt |
{: .grid}

Operationally, this means the vLEI gives healthcare organizations an identity layer that **outlives the certs and CAs underneath it**. UDAP keeps doing what UDAP does well at the channel and client-auth layers; the vLEI provides continuity at the legal-entity layer. For long-lived FHIR exchange relationships — which is most of healthcare — that continuity is a substantial reduction in operational and audit burden.

#### B.7.3 Authorization-Time Mapping

When a relying party processes an OAuth/UDAP request:

| Layer | Question answered | Mechanism |
|---|---|---|
| TLS | Is the channel authentic and confidential? | Server X.509 cert |
| OAuth client auth | Which registered client is this? | UDAP / X.509 client cert / private_key_jwt |
| **Legal entity** | **Which legal entity is behind this client?** | **Legal Entity vLEI** |
| **Acting individual** | **Which proofed person is making this request, and on whose behalf?** | **OOR / ECR + IAL2/AAL2 assertion** |
| Authorization | What is this combination allowed to do? | Scopes, purpose-of-use, network policy |
{: .grid}

Profiling each layer is the responsibility of the IG that owns it. The **legal entity** and **acting individual** layers are owned by FAST Identity (this IG); the **client auth** layer is owned by FAST Security; the **TLS** layer is owned by deployment guidance.

### B.8 Use Case Walkthroughs

This section walks through five relationship patterns — the four flagged in the 9 April 2026 co-leads call (action item 10.A) plus an emerging **Organization ↔ AI Agent** pattern that healthcare implementations are encountering with increasing frequency — and shows how the LEI/vLEI profiling guidance applies to each. Every walkthrough follows the same template — *Scenario, Parties, Identity needs, Credentials, FHIR conveyance, Decision (LEI / vLEI), Notes* — so that implementers can compare patterns side-by-side.

A summary at the end (§B.8.6) consolidates the credential picture across all five.

#### B.8.1 Provider ↔ Organization

**Scenario.** A licensed clinician practices at one or more healthcare organizations. A relying party — another provider, a payer, a network — needs to be confident both that the organization is who it claims to be and that this clinician is genuinely associated with it in a specific role.

**Parties.**
- *Organization* — e.g., Acme Health System, a hospital, clinic, or group practice (the legal entity).
- *Provider* — an individual clinician (physician, nurse practitioner, etc.) with IAL2-proofed digital identity.

**Identity needs.**
- The organization must be globally identifiable (LEI) and, for any transactional or attestational interaction, cryptographically authenticatable (Legal Entity vLEI).
- The provider must be IAL2-proofed.
- The *binding* between provider and organization, including the role/specialty under which the provider acts, must be verifiable.

**Credentials required.**
- *Legal Entity vLEI Credential* — issued to the Organization.
- *ECR credential* — issued by the Organization to the provider, encoding the engagement context (e.g., "attending physician," "telehealth-authorized clinician for X service line"). OOR is generally not the right fit because clinical roles are not in the ISO 5009 corporate-role taxonomy.
- The provider's identity in the ECR resolves to an **IAL2-proofed** identifier; sessions in which the provider acts use **AAL2 or higher** authentication.

**FHIR conveyance.**
- `Organization` profile (FAST) carrying the LEI in `identifier[lei]` and an `org-vlei-anchor` extension pointing to the Legal Entity vLEI.
- `Practitioner` profile carrying the provider's identifiers (NPI, etc.) and a reference (via FAST Identity companion guidance) to the OOR/ECR credential anchor.
- `PractitionerRole` linking `Practitioner` to `Organization`, with role/specialty coded as today, plus a verifiable-credential pointer that lets a relying party check the ECR.

**Decision.** **vLEI required** for the organization in any transactional context (matrix rows 5–10). **LEI alone is sufficient** when only listing the organization in a directory or static reference data (rows 1–4).

**Notes.** This use case is the closest analogue to the existing FHIR `Practitioner ↔ PractitionerRole ↔ Organization` pattern. The vLEI does not invent new constructs; it adds *verifiability* to the join. A directory consumer that previously trusted the directory itself can now independently verify the organization and the provider-to-organization binding.

#### B.8.2 Payer ↔ Vendor

**Scenario.** A payer (health plan) engages a third-party vendor — for example, a clearinghouse, a prior authorization automation vendor, an analytics or quality-measurement vendor, or a UM partner — to act on the payer's behalf for a defined scope of work. The vendor's systems issue or receive FHIR transactions that must be attributable to the payer.

**Parties.**
- *Payer* — a legal entity (insurance company, MCO, ACO acting in payer capacity).
- *Vendor* — an independent legal entity contracted by the payer.

**Identity needs.**
- Both parties are independent legal entities and need their own verifiable identity (each has its own LEI and Legal Entity vLEI).
- The vendor (or specific personnel inside the vendor) must be able to *prove* it is acting under the payer's delegated authority for a specific scope, and only that scope.
- A relying party (e.g., a provider organization or a regulator) must be able to verify both who the vendor is *and* what the payer authorized them to do.

**Credentials required.**
- *Legal Entity vLEI Credential* — issued to the payer.
- *Legal Entity vLEI Credential* — issued to the vendor.
- *ECR credential* — issued **by the payer** to the vendor (as a system actor) and/or to specific named individuals at the vendor, encoding the engagement context: "authorized to submit prior authorization decisions on behalf of this payer," "authorized to query member roster for quality measurement," etc.

**FHIR conveyance.**
- Two `Organization` resources, each carrying its own LEI and vLEI anchor.
- Where the vendor "operates on behalf of" the payer for a transaction, this can be conveyed by:
  - An OAuth/UDAP assertion that carries the ECR reference (issuer = payer LEI, subject = vendor or vendor's individual, scope = engagement context); and/or
  - A FAST Identity-defined extension on the relevant resource (e.g., `Provenance.agent.onBehalfOf`) referencing the payer Organization.
- `Provenance` is the natural FHIR carrier for "this assertion was made by *X* on behalf of *Y*" and SHOULD be used for transactions where attribution must survive later dispute (matrix row 10).

**Decision.** **vLEI required** for both parties. The defining feature of this use case is delegation across legal-entity boundaries; the LEI alone cannot represent that delegation.

**Notes.** This is structurally an *organization-to-organization* delegation. The ECR pattern still applies — ECRs can be issued to a system or to a person at the delegated organization. The relying party's verification logic must walk *both* chains: the vendor's own vLEI (to know who the vendor is) and the ECR (to know what the payer authorized them to do).

#### B.8.3 Organization ↔ IT Vendor

**Scenario.** A healthcare organization outsources part of its IT stack — for example, EHR hosting, FHIR API publication, identity provider operation, or specific data services — to a technology vendor. The IT vendor operates the infrastructure, but the *data steward* and *legal entity responsible* is the healthcare organization. Relying parties making API calls need to know whose data they are actually receiving.

**Parties.**
- *Healthcare Organization* — the data steward and legal entity ultimately responsible (e.g., the hospital, payer, or provider group).
- *IT Vendor* — the technical operator (e.g., an EHR vendor, API hosting provider, or HIE technical operator).

**Identity needs.**
- The healthcare organization's identity must be the one asserted to relying parties even though the IT vendor's infrastructure is making the API call.
- The IT vendor's own identity must also be discoverable, for accountability and incident response.
- The delegation scope ("operate the FHIR API on behalf of this organization") must be verifiable.

**Credentials required.**
- *Legal Entity vLEI Credential* — issued to the healthcare organization.
- *Legal Entity vLEI Credential* — issued to the IT vendor.
- *ECR credential* — issued by the healthcare organization to the IT vendor for the specific engagement context (e.g., "operates FHIR R4 API on behalf of this organization," "publishes directory data on behalf of this organization").

**FHIR conveyance.**
- API responses populate `Organization.identifier` with the healthcare organization's LEI and the `org-vlei-anchor` extension, *not* the IT vendor's.
- The `managingOrganization` pattern in FHIR (e.g., `Patient.managingOrganization`, `Practitioner.qualification.issuer`) continues to refer to the healthcare organization.
- At the OAuth/UDAP layer, the *client* presented to the authorization server may legitimately be the IT vendor; the **legal entity** layer (§B.7.3) resolves to the healthcare organization via the ECR. This is the canonical "side-by-side" pattern in §B.7.2(1).
- `Provenance.agent` may carry both the IT vendor (as the operating agent) and the healthcare organization (as the legal-entity principal) when transactional attribution is required.

**Decision.** **vLEI required** for both parties. The whole point of this use case is that endpoint trust (TLS / X.509) does not by itself answer "*whose* data is this?" — the vLEI does.

**Notes.** This is the use case where the failure mode of "endpoint trust ≠ entity trust" (§B.7.1) is most visible. Today, relying parties often infer the legal entity from the cert subject or the OAuth client name. With the vLEI, that inference becomes a verifiable claim. This pattern also generalizes to subcontracting chains (IT Vendor → Subcontractor) by issuing nested ECRs, though such chains should be kept short for auditability.

#### B.8.4 Organization ↔ Delegate (Administrative Staff)

**Scenario.** An administrative staff member — a non-clinician — performs actions on behalf of an organization. Examples: a credentialing coordinator updates provider directory entries; a billing administrator submits claims attachments; a compliance officer signs a regulatory filing; a directory admin manages endpoint metadata.

**Parties.**
- *Organization* — e.g., a hospital or payer.
- *Delegate (individual)* — an administrative staff member, IAL2-proofed.

**Identity needs.**
- The organization must be verifiable (Legal Entity vLEI).
- The delegate must be IAL2-proofed.
- The delegate's authority — *which* administrative actions, in *what* engagement context, with *what* limits — must be verifiable and revocable.

**Credentials required.**
- *Legal Entity vLEI Credential* — issued to the organization.
- *ECR credential* — issued by the organization to the delegate. The role label is organization-defined (e.g., "Provider Directory Administrator," "Authorized Claims Submitter," "Endpoint Metadata Manager"). ECR is the right choice precisely because these are not ISO 5009 roles.
- The delegate's identifier in the ECR resolves to an **IAL2** identity; sessions use **AAL2** or higher.

**FHIR conveyance.**
- The administrative delegate is often *not* appropriately modeled as a `Practitioner` (they are not delivering care). Options:
  - `RelatedPerson` is awkward; it is patient-anchored.
  - A `Person` resource linked into a workflow context is one possibility.
  - For directory and registry use cases, FAST Identity may need to define or reuse a non-clinical agent profile. This is flagged in §B.9.
- For audit and attribution, `Provenance.agent.who` SHOULD reference whatever resource represents the delegate, with `Provenance.agent.onBehalfOf` referencing the `Organization` and a credential pointer to the ECR.

**Decision.** **vLEI required.** Administrative actions on behalf of an organization are exactly the kind of "the relying party will want a cryptographic record of who actually made this assertion" use case the matrix is designed to flag.

**Notes.** This use case exposes a real FHIR gap: the platform's role-binding constructs are clinician-centric, but a large fraction of organizational accountability lives with non-clinical staff. The vLEI ECR mechanism does not solve that gap on its own, but it gives FAST Identity a clean mechanism for conveying authority *outside* the `Practitioner` graph, which can then be linked to whichever FHIR construct best represents the delegate.

#### B.8.5 Organization ↔ AI Agent

**Scenario.** An AI agent — a software system that takes autonomous or semi-autonomous actions — operates on behalf of an organization. Examples include AI scribes that draft clinical documentation, prior-authorization automation agents that submit and respond to PA requests, claims-processing agents that prepare or adjudicate transactions, patient-communication agents, and orchestration agents that chain together multiple FHIR API calls to complete a workflow. The agent is not a human and cannot be IAL2-proofed, but every action it takes must be attributable to a specific agent identity and bound to the authorizing organization's accountability.

**Parties.**
- *Organization* — the legal entity that has deployed the AI agent and is accountable for its actions (e.g., a hospital, payer, vendor).
- *AI Agent* — a software system identified by its own KERI AID, with its controlling keys managed under the organization's governance.

**Identity needs.**
- The organization must be verifiable (Legal Entity vLEI).
- The AI agent must have a stable, cryptographically verifiable identity of its own — typically a KERI AID — so that every signed action is attributable to the same agent over time, and so that agent identity persists across model updates and deployments.
- The agent's authority — *which* actions, *on whose behalf*, *in what context*, *with what guardrails* — must be verifiable, scoped, and revocable.
- Attribution must be unambiguous: actions by the agent are attributable to the agent itself (not generically to "an agent of the organization") *and*, through the credential chain, to the authorizing organization.

**Credentials required.**
- *Legal Entity vLEI Credential* — issued to the organization.
- *ECR credential* — issued by the organization to the agent (subject = agent's AID), encoding the engagement context (e.g., "authorized to draft clinical documentation," "authorized to submit prior authorization requests on behalf of this organization for in-network providers"). ECR is the right credential type — OOR does not apply because agents are neither natural persons nor occupants of ISO 5009 corporate roles.
- *Optional agent attestation credentials*, chained from the ECR, that describe the agent itself — for example, model identity and version, evaluation results, intended scope of use, and any oversight or human-co-sign requirements. Standardization of these attestations is an emerging area and is flagged as an open question (see §B.9).
- *Human co-signing requirement, where regulated.* For actions that require human accountability (e.g., final clinical decisions, executed claims approvals), the agent's ECR SHOULD require co-presentation with a human's OOR or ECR carrying appropriate authority, so that the relying party can enforce policy by inspecting credentials rather than maintaining out-of-band rules.

**FHIR conveyance.**
- The AI agent does not fit `Practitioner` (it is not delivering care). Candidate FHIR carriers:
  - `Device` is the closest existing fit for a software agent acting in healthcare workflows; `Device.identifier` can carry the agent's AID and `Device.owner` can reference the `Organization`.
  - A FAST Identity non-clinical agent profile (the same gap raised in §B.8.4 for administrative staff) MAY be more appropriate for orchestration agents whose scope exceeds a single device's traditional remit. This is flagged in §B.9.
- For attribution, `Provenance.agent` SHOULD record: `agent.who` referencing the agent's resource representation; `agent.type` (or an extension) distinguishing software / AI agents from human actors; `agent.onBehalfOf` referencing the `Organization`; and a pointer to the agent's ECR credential anchor.
- For regulated actions requiring human co-sign, `Provenance.agent` MAY include both the AI agent and the responsible human, each with their own credential pointers — recording that the action was prepared by the agent and authorized by the human.

**Decision.** **vLEI required.** The whole purpose of this use case is to make AI-agent actions attributable, scoped, and revocable. None of those properties is achievable with the LEI alone; all of them depend on a verifiable credential.

**Notes.** This use case is structurally similar to Org ↔ IT Vendor delegation (a non-human system actor authorized via ECR) but with three healthcare-specific tightening factors: (1) ECR scopes for AI agents SHOULD be **narrower and more frequently revisited** than for IT vendors, because agent capabilities and risk profiles evolve as models change; (2) **provenance is mandatory, not optional** — every regulated agent action SHOULD be recorded with full credential attribution, both for accountability and to enable later dispute resolution; and (3) agent ECRs SHOULD encode any **oversight or human-co-sign requirements** as part of the credential's scope, so that those requirements travel with the credential and are enforceable by any relying party. Agent-to-agent delegation chains MAY be expressed via nested ECRs (analogous to subcontracting in §B.8.3), but SHOULD be kept short for auditability.

#### B.8.6 Cross-Use-Case Summary

| Aspect | Provider ↔ Organization | Payer ↔ Vendor | Org ↔ IT Vendor | Org ↔ Delegate | Org ↔ AI Agent |
|---|---|---|---|---|---|
| Number of legal entities | 1 (org) + 1 individual | 2 (payer, vendor) | 2 (org, IT vendor) | 1 (org) + 1 individual | 1 (org) + 1 software agent |
| Org-level credential | Legal Entity vLEI (org) | Legal Entity vLEI (both) | Legal Entity vLEI (both) | Legal Entity vLEI (org) | Legal Entity vLEI (org) |
| Person/system credential | ECR (clinical role) | ECR (transactional auth) | ECR (operational scope) | ECR (administrative scope) | ECR (scoped agent authority) + optional agent attestations |
| OOR plausible? | No (not in ISO 5009) | Rarely (e.g., signing officer) | Rarely | For a few signing roles | No (agent is not a natural person) |
| IAL2 individual involved? | Yes | Yes (often) | Sometimes (system actor possible) | Yes | Not for the agent itself; human IAL2 required for co-sign on regulated actions |
| Primary FHIR carrier | `Practitioner` + `PractitionerRole` | `Organization` (×2) + `Provenance` | `Organization` (×2) + `Provenance` | Non-clinical agent + `Provenance` | `Device` or non-clinical agent profile + `Provenance` |
| LEI sufficient anywhere? | Directory listings only | Directory listings only | Directory listings only | Directory listings only | Directory listings only |
| vLEI required for action? | Yes | Yes | Yes | Yes | Yes |
| Defining trust gap closed | Provider-to-org binding | Cross-entity delegation | Endpoint trust ≠ entity trust | Non-clinical accountability | Attribution and scoping of autonomous AI actions |
{: .grid}

The pattern across all five is the same: **LEI is enough for static reference; vLEI is required as soon as anyone — or anything — *acts*.**

### B.9 Open Questions and Next Steps

The following items are flagged for resolution before the LEI/vLEI guidance leaves draft status. They map back to action items 10.A–10.D from the 9 April 2026 co-leads call.

1. **Use case → identity model mapping (10.B).** §B.8 enumerates the four primary relationship patterns and their credential needs. The next refinement is to bind each walkthrough to a specific FAST conformance profile and example bundle.
2. **vLEI structural detail (10.D, deepening).** A companion explainer comparing the vLEI's structure and verification model to X.509 chains and OAuth assertions is needed for implementer audiences. §A.4 begins this work; a longer technical note is in scope for the next iteration.
3. **Healthcare relevance of vLEI attributes.** Not all attributes of OOR/ECR credentials are useful in clinical FHIR exchange. The work group will identify which attributes are essential, which are optional, and which should be excluded from FHIR-conveyed metadata to avoid overloading the identity layer with clinical semantics.
4. **Identifier system URI and `IDTYPE` code.** The canonical `Organization.identifier.system` URI for LEI is widely cited as `https://www.gleif.org/lei`; this should be confirmed against current GLEIF guidance and registered as appropriate.
5. **Extension finalization.** The `org-vlei-anchor` extension shape (§B.5.2) is a working sketch and will be finalized in coordination with FAST Security.
6. **Conformance language.** As adoption matures, the matrix in §B.4.1 should be re-expressed as SHALL / SHOULD statements bound to specific use case profiles.
7. **Non-clinical agent profile (raised by §B.8.4 and §B.8.5).** FAST Identity should decide whether to define a profile (or reuse `Person`, `Device`, or a custom resource pattern) for non-clinical actors that do not fit `Practitioner` — both human administrative delegates and software / AI agents acting on behalf of an organization.
8. **Provenance integration (raised by §B.8.2, §B.8.3, and §B.8.5).** Confirm and document the canonical use of `Provenance` to carry vLEI credential anchors for cross-entity delegation, IT-vendor scenarios, and AI-agent actions (including the multi-agent record needed when a regulated action requires human co-sign on top of an AI-prepared transaction).
9. **AI agent attestation credentials (raised by §B.8.5).** AI agents introduce identity needs that go beyond "who is this and what are they authorized to do" — relying parties may also need to verify *what kind of agent it is*: model identity and version, evaluation results, intended scope of use, oversight requirements, and revocation triggers tied to model updates. FAST Identity should partner with FAST Security and the broader healthcare AI governance community to define a standard pattern for chained agent attestation credentials, and to clarify whether these belong inside the ECR's payload, alongside it as separate ACDC credentials, or in a parallel attestation registry.

### B.10 References

- **GLEIF.** Global Legal Entity Identifier Foundation. https://www.gleif.org
- **ISO 17442-1:2020.** Financial services — Legal entity identifier (LEI).
- **GLEIF vLEI Ecosystem Governance Framework.** https://www.gleif.org/en/vlei
- **KERI.** Key Event Receipt Infrastructure. https://keri.one
- **ACDC.** Authentic Chained Data Containers specification.
- **NIST SP 800-63A.** Digital Identity Guidelines — Enrollment and Identity Proofing (IAL).
- **NIST SP 800-63B.** Digital Identity Guidelines — Authentication and Lifecycle Management (AAL).
- **HL7 FHIR FAST Identity Matching IG (STU3 draft).** https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/branches/stu3/index.html
- **HealthKeri.** Open-source vLEI tooling for healthcare. https://healthkeri.com
- **UDAP.** Unified Data Access Profiles. https://www.udap.org
- **IETF RFC 8615.** Well-Known Uniform Resource Identifiers. https://www.rfc-editor.org/rfc/rfc8615
- **FAST Identity Co-Leads call notes, 9 April 2026.** Internal record (this document responds to action items 10.C and 10.D from that call).
