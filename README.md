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

Read [the authoring guide](PROVIDER_AUTHORING_GUIDE.md), copy the template,
replace its example IDs, and retain its separate provider settings page.
