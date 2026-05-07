
This primer addresses the educational gap identified in the FAST Identity co-leads call of 9 April 2026: implementers and stakeholders need a clear, plain-language explanation of the LEI and vLEI before the profiling guidance will land. It is intentionally written for readers who are familiar with FHIR and healthcare identity, but who have not previously encountered the GLEIF ecosystem.

### A.1 What is an LEI?

The **Legal Entity Identifier (LEI)** is a 20-character alphanumeric code, defined by ISO 17442, that uniquely identifies a legal entity participating in a financial or business transaction. LEIs are issued by Local Operating Units (LOUs) accredited by the **Global Legal Entity Identifier Foundation (GLEIF)**. Each LEI is associated with a public **Level 1 record** (who is who: legal name, jurisdiction, registered address) and a **Level 2 record** (who owns whom: parent and ultimate parent relationships).

In short: an LEI is a *globally unique, openly searchable identifier* for a legal entity. It is portable across industries, jurisdictions, and ecosystems, and it does not depend on any single regulator or trust framework.

### A.2 What is a vLEI?

The **verifiable LEI (vLEI)** is the GLEIF ecosystem's cryptographic, machine-verifiable counterpart to the LEI. Where an LEI is a string in a public registry, a vLEI is a **verifiable credential** that an organization (or a person acting on behalf of an organization) can present — and that any relying party can validate — without contacting the issuer in real time.

> **Mental model for a healthcare audience.** *The vLEI is to organizations what a "Golden Identifier" is to patients.* In patient identity, a Golden Identifier is the high-trust, reconciled, single source of truth for who a patient is, against which lower-quality identifiers can be matched and resolved. A vLEI plays the same role for a legal entity: it is the high-trust, cryptographically verifiable, reconciled organizational identity to which any number of network-specific, payer-specific, or directory-specific identifiers can be linked. Once you treat the vLEI as the organizational Golden Identifier, every other organizational identifier in the ecosystem becomes a *reference* to it rather than an independent claim of identity.

A vLEI rests on two open standards:

- **KERI (Key Event Receipt Infrastructure)** — a self-certifying, decentralized identifier and key-management protocol. KERI separates an entity's cryptographic identifier — an **Autonomic Identifier (AID)** — from any specific registry, ledger, or certificate authority.
- **ACDC (Authentic Chained Data Containers)** — the credential format. ACDCs carry signed claims, can be chained to upstream issuing credentials, and support selective disclosure.

> **What is an AID?** An **AID (Autonomic Identifier)** is the cryptographic identifier that names a vLEI subject — for example, a legal entity, a QVI, or an individual role-holder. It is *self-certifying*: the AID string is mathematically derived from the keys that control it, so the identifier itself is the proof of who controls it. No central registry has to vouch for it. KERI then maintains a tamper-evident **Key Event Log (KEL)** that records every key rotation, witness change, or controller change for the AID. The crucial property for healthcare exchange is that **the AID stays the same across all of those events** — keys can rotate, witnesses can be replaced, X.509 certificates underneath can expire and be reissued, but the organization's AID, and therefore its verifiable identity, remains stable.

A vLEI credential also carries one or more **Out-Of-Band Introduction (OOBI) URLs** — these are how a relying party bootstraps verification of the credential's KERI key state. In a healthcare context, an OOBI URL SHOULD point to an endpoint that the organization itself controls (typically under a `.well-known` path on the organization's primary domain). This serves two purposes at once: it is the *verification anchor* for the vLEI, and it can simultaneously act as an *informational discovery endpoint* — for example, advertising the organization's FHIR exchange capabilities, supported networks, endpoint metadata, or trust contacts. The OOBI thus does double duty as a cryptographic verification handle and as a service-discovery touchpoint, which is uniquely useful for healthcare exchange. (The mechanics of this pattern, including how the OOBI URL is conveyed in a FHIR `Organization` resource, are profiled in §B.5.2.)

Three types of credentials matter for organizational identity:

1. **Legal Entity vLEI Credential** — issued to the legal entity itself. Contains the 20-character LEI plus core identifying attributes (legal name, registered address, the issuing Qualified vLEI Issuer). This is the *organizational* anchor.
2. **Official Organizational Role (OOR) credential** — binds a named individual to the legal entity in a publicly recognized role (e.g., CEO, CFO, Compliance Officer). The role taxonomy is anchored in ISO 5009.
3. **Engagement Context Role (ECR) credential** — binds a named individual to the legal entity for a specific *engagement context* — e.g., "authorized to submit prior authorization requests on behalf of this organization," or "authorized signatory for regulatory filings." ECRs are defined by the issuing organization itself.

Every vLEI credential carries a cryptographic chain of issuance back through a **Qualified vLEI Issuer (QVI)** to **GLEIF as the root of trust**. A relying party verifies the chain end-to-end; the credential proves both *what* it asserts and *who* is entitled to assert it.

### A.3 Why does it matter for healthcare?

Healthcare in the United States identifies organizations through a patchwork of identifiers: NPI (organizational subtype), Tax ID, OIDs, payer-issued IDs, network-issued IDs, and DNS names embedded in X.509 certificates used for TLS and OAuth client authentication. Each works inside its own ecosystem, but none of them simultaneously offers all four of the following properties:

| Property | What it means | Why it matters |
|---|---|---|
| Globally unique | One identifier per legal entity, worldwide | Removes ambiguity in cross-network exchange (TEFCA, CMS Aligned Networks, payer-provider, vendor) |
| Portable | Not bound to one regulator, network, or sector | Lets the same identity work across FHIR APIs, non-FHIR APIs, directories, and OAuth |
| Cryptographically verifiable | Trust does not depend on a directory lookup | Enables zero-trust patterns and offline / asynchronous validation |
| Role-aware | Can carry "who is authorized to do what on behalf of whom" | Supports delegation, purpose-of-use, and accountability |

The LEI provides the first two. The vLEI adds the second two. Together they directly advance the core FAST objective of building **scalable, reusable infrastructure that enables FHIR exchange at national scale** — a foundational layer that every network, directory, and trust framework can rely on rather than each one inventing its own organizational identity. By pinning organizational identity to a single, globally rooted, cryptographically verifiable anchor, the LEI/vLEI pair lets FAST extend the same exchange infrastructure across FHIR APIs, non-FHIR APIs, directories, OAuth-secured endpoints, and trust frameworks (TEFCA, CMS Aligned Networks, payer-provider, vendor ecosystems) without bespoke per-network identity work. This aligns with the FAST principle of solving foundational interoperability problems *once*, in a way that is reusable and composable, rather than re-solving them inside every implementation guide.

### A.4 How does it compare to existing approaches?

The vLEI does not replace existing identifiers — it *anchors* and *verifies* them. The table below positions the vLEI against the most common organizational identity mechanisms in healthcare today.

| Mechanism | What it identifies | Trust model | Verifiable in transit? | Healthcare gaps it leaves |
|---|---|---|---|---|
| **NPI (Type 2)** | A US healthcare organization | Centralized (NPPES) | No — it is a directory string | US-only; not all org types are eligible; no cryptographic binding |
| **Tax ID / EIN** | A US legal entity for tax purposes | Centralized (IRS) | No | US-only; sensitive (treated like PII in some contexts); no cryptographic binding |
| **OID (root + branch)** | An organization's namespace | Hierarchical (ISO/ITU) | No | Free-form; inconsistent registration; no automated proof of control |
| **DNS / X.509 client cert (UDAP)** | The TLS endpoint or OAuth client | PKI (CA-rooted) | Yes (cert-bound) | Identifies the *endpoint or client*, not the *legal entity*; CA trust is fragmented; revocation is brittle |
| **OAuth client_id** | An OAuth client app | Per-authorization-server | No (string only) | Local to one AS; no global identity meaning |
| **LEI** | A legal entity worldwide | GLEIF + LOU | No (string only) | Identification only — not authentication |
| **vLEI (Legal Entity Credential)** | A legal entity worldwide | GLEIF → QVI chain (KERI/ACDC) | Yes — credential is signed, chain is verifiable | Adoption is early in healthcare; tooling is maturing |
| **vLEI OOR / ECR** | A person + role + organization | Same chain, anchored to Legal Entity vLEI | Yes | Role taxonomy (OOR) is general business; ECR vocabulary for healthcare is emerging |

The strongest mental model is layered:

- **LEI** answers "*who* is this organization?" (identification)
- **vLEI Legal Entity Credential** answers "*prove* this organization is the one identified by this LEI" (authentication of the legal entity)
- **OOR / ECR** answer "*who is authorized to act on behalf of that organization, in what capacity?*" (delegation and accountability)
- **UDAP / OAuth / TLS** answer "*how* is the request being made over the wire?" (channel and session security)

Existing healthcare patterns continue to work — the LEI/vLEI layer sits *under* them and gives them a common, cryptographically anchored organizational identity to refer to.

#### A.4.1 Durability across trust boundaries and PKI lifecycle events

A particular strength of the vLEI in healthcare is that an organization's verifiable identity remains valid *across* trust boundaries and *through* the lifecycle events that disrupt PKI-based identity today. Three properties matter most:

- **One identity across networks.** PKI trust is rooted in CAs, and each network (TEFCA, CMS Aligned Networks, payer networks, vendor ecosystems) typically maintains its own trust list. An organization can find itself re-vetted, re-listed, or re-credentialed for each network it joins — and a single legal entity ends up with multiple, network-specific PKI identities that have to be reconciled. A vLEI is rooted in **GLEIF**, which is recognized in every ecosystem the organization touches. Adding a new network or counter-party does not require re-issuing the organization's identity; the same vLEI is presented and verified the same way everywhere.

- **Persistence through certificate rotation and expiry.** X.509 certificates expire, are reissued, are revoked, and are sometimes re-rooted at different CAs. Every one of those events disrupts artifacts that bind to the old certificate — UDAP dynamic client registrations, signed software statements, mTLS-anchored counterparty agreements, OAuth client credentials. By contrast, the **AID underneath a vLEI is stable across key rotations**, because KERI binds identity to a key event log rather than to a single public key. An organization can rotate keys (which it should do regularly), have its TLS certificate expire and be reissued, or change CAs entirely, **without** changing its legal-entity identity. The vLEI **outlives the certificates and CAs underneath it**.

- **Survives CA failures and trust-list churn.** Healthcare has lived through CA distrust events, root program changes, and trust-list updates that have broken established connections. Because the verification path for a vLEI runs through KERI/ACDC and is rooted in GLEIF, a CA-related incident does not invalidate organizational identity. The TLS layer may need to be repaired; the legal-entity layer keeps working — and the directory entries, signed assertions, and audit records that point at the vLEI continue to resolve correctly.

In short: **certs and CAs change. The vLEI does not.** This durability is what makes the vLEI a foundation worth building on, rather than another short-lived identity artifact.

