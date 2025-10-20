# URL Shortener

## Overview

The **SHI - URL Shortener (SUS)** is a security-focused, privacy respecting, compliance-ready URL redirection service. SUS provides controlled creation and management of short URLs, delegated administration through RBAC, strong input validation, and guardrails to prevent misuse (e.g., banned terms, domain scoping).

## Audience

This documentation is primarily intended for technical users who are responsible for deploying, configuring, and maintaining the URL Shortener service within customer environments. While the content is geared toward technical implementation, it is written to be accessible to non-technical stakeholders as well.

## SUS in the Security Landscape

- Zero trust: Every request re‑validated (types, UUID formats, filter shapes).
- Strong runtime validation: Uses structural equality/type guards to reject malformed inputs early (400).
- Principle of least privilege: Distinct scopes required for privileged sets (e.g., domain & ban list modifications).
- Protective lists: Banned terms and controlled domains for fine grained control over what is created by end users.
- Separation of concerns: Routing layer delegates business logic to a Redirect Engine singleton.
- Minimal disclosure: Nonexistent management records yield 404 without leaking broader state.
- Auditable mutation points: Create/Update/Delete paths are centralized for logging.

## Prerequisites

Check out this page for more details: [Getting Started - Prerequisites](Prerequisites/index.md)

## Summary

In the rest of the documentation, we will provide detailed instructions on how to install, configure, and use SUS to achieve these benefits.
