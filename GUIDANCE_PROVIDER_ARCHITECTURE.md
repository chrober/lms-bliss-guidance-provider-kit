# Guidance provider architecture

This kit defines the shape of an independently installable Lyrion guidance
provider. A provider contributes optional, bounded evidence to candidates that
a host has already accepted through its Bliss-based selection. It cannot add
candidates, replace the host algorithm, or relax repeat and quality rules.

## Static provider anatomy

```mermaid
flowchart TB
    Settings["Provider-owned Lyrion settings page"]
    Plugin["Provider Plugin.pm\nDescriptor, defaults, status, native factory"]
    Config["Provider settings\nShared defaults and credentials"]
    Host["Consuming host plugin\nOpt-in and sparse overrides"]
    Shared["lms-bliss-guidance-host\nCanonical settings renderer and policy"]
    Perl["Optional Perl-only provider logic"]
    Native["Optional native provider executable"]
    Spi["bliss-guidance-jsonl-v2"]

    Settings --> Config
    Config --> Plugin
    Plugin --> Host
    Host --> Shared
    Plugin --> Perl
    Plugin --> Native
    Shared --> Spi
    Spi --> Native
```

A provider may be Perl-only. A native executable is appropriate when bounded
candidate scoring is high-volume or needs a language-neutral SPI; it is not a
requirement for discovery or settings integration.

## Discovery, opt-in, and effective settings

```mermaid
sequenceDiagram
    participant P as Provider plugin
    participant H as Host settings page
    participant M as Shared settings model
    participant U as User

    P-->>H: Descriptor, saved defaults, and availability
    H->>M: Combine provider defaults with host state
    M-->>H: Effective values and source annotations
    H-->>U: Render provider section disabled by default

    U->>H: Enable provider and edit a value
    H-->>U: Show descriptor-declared controls immediately
    U->>H: Use inherited default
    H-->>U: Restore provider value without saving
    U->>H: Save settings
    H->>M: Persist enablement and explicit host overrides

    Note over M: Effective order: job override, host override, provider setting, factory default
```

The provider controls whether a field is a slider or a simple numeric input
through its descriptor. Hosts render it unchanged, including the canonical
provider-settings link, effective-value annotation, and inherited-default
behaviour.

## Native provider execution

```mermaid
sequenceDiagram
    participant H as Host plugin
    participant P as Provider factory
    participant N as Native provider
    participant R as Provider data source

    H->>P: Request trusted native configuration
    P-->>H: Program, resolved options, trusted resources, artifacts
    H->>N: Manifest request
    N-->>H: Supported protocol and channels
    H->>N: Prepare request
    N->>R: Read only needed local or prepared data
    R-->>N: Evidence data
    N-->>H: Prepared acknowledgement
    H->>N: Score admitted candidates
    N-->>H: Bounded signals, rationale, and diagnostics
```

Settings form values never supply an executable path, database path, or
network destination. The provider factory derives all such values from trusted
plugin resources and the resolved policy.
