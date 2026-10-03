# Lyrion Bliss Guidance Provider Kit

This repository is the starting point for independently installable Lyrion
guidance providers. A provider supplies bounded secondary evidence to a host's
existing Bliss-qualified candidate pool; it never admits a track or bypasses a
host's repeat and quality constraints.

Use the kit for configuration-only Perl providers, language-neutral JSONL
providers, or high-volume Rust providers. The native protocol is owned by
[bliss-playlist-guidance-spi](https://github.com/chrober/bliss-playlist-guidance-spi).
The canonical host settings UI is owned by
[lms-bliss-guidance-host](https://github.com/chrober/lms-bliss-guidance-host).

## Provider anatomy

```mermaid
flowchart TB
    Settings["Provider-owned Lyrion settings page"]
    Plugin["Provider Plugin.pm\nDescriptor, defaults, status, native factory"]
    Config["Provider settings\nShared defaults and credentials"]
    Host["Consuming host plugin\nOpt-in and sparse overrides"]
    Shared["Guidance host library\nCanonical renderer and policy"]
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

## Provider discovery and execution flow

```mermaid
sequenceDiagram
    participant U as User
    participant H as Host plugin
    participant P as Provider plugin
    participant N as Native provider
    participant R as Provider data source

    H->>P: Read descriptor, defaults, and status
    P-->>H: Provider metadata and shared defaults
    U->>H: Enable provider and save host overrides
    H->>P: Request trusted native configuration
    P-->>H: Program, resolved options, trusted resources, artifacts
    H->>N: Prepare request
    N->>R: Read needed local or prepared data
    R-->>N: Evidence data
    N-->>H: Prepared acknowledgement
    H->>N: Score host-admitted candidates
    N-->>H: Bounded signals, rationale, and diagnostics
```

The effective value order is: per-job override, host override, provider
setting, then factory default. **Use inherited default** changes the form and
its source annotation without saving; the ordinary host Save action persists
the chosen host state.

Read [the authoring guide](PROVIDER_AUTHORING_GUIDE.md), copy the template,
replace its example IDs, and retain its separate provider settings page.
