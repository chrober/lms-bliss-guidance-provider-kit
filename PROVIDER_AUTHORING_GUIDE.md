# Guidance provider authoring guide

The [README](README.md) contains diagrams of the provider boundary, host
opt-in, settings precedence, and native execution session.

## Choose the provider shape

- **Configuration-only Perl:** discovery, defaults, and lightweight local work.
- **JSONL executable:** any language implementing the native SPI.
- **Rust provider:** recommended for bounded, high-volume candidate scoring.

All shapes publish `guidance_provider_descriptor_v1`. The descriptor provides
stable identity, capabilities, settings schema, and safe native-backend
metadata. It does not contain raw HTML, JavaScript, CSS, or form callbacks.

## Settings ownership

Every provider has its own Lyrion settings page. It owns credentials, source
behaviour, diagnostics, and shared defaults. A consuming host owns whether the
provider is enabled and its sparse per-host overrides. The effective order is:
per-job override, host override, provider saved default, then factory default.
Explicit `0` and `false` are overrides, not inheritance.

Hosts render provider controls from the descriptor. `render_as => 'slider'`
must stay a Material Skin slider; `render_as => 'number'` must stay a simple
number field. Do not build custom host markup for a provider.

## Native execution

Use the `bliss-guidance-jsonl-v2` contract for an executable provider. Trusted
host code supplies the program, artifacts, resources, and resolved options.
Never accept executable paths, database paths, or network destinations from
settings form values. Native providers return structured signals/rationales;
hosts localize logs and user-visible explanations.

## Testing and packaging

Start from `fixtures/provider-descriptor-v1-all-controls.json`. Add a provider
contract test for descriptor validity, defaults, status, and native config.
Use the standard settings footer so users always save explicitly. Package the
provider as an ordinary Lyrion extension; hosts discover enabled provider
modules at runtime and default them to disabled.
