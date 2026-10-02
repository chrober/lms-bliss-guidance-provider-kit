package Plugins::LyrionProvider::Provider;

use strict;
use warnings;

sub descriptor {
    return {
        protocol_version => 1,
        provider_id => 'example-guidance',
        display_name => 'Example Guidance',
        settings_uri => 'plugins/ExampleGuidance/settings/exampleguidance.html',
        capabilities => ['example_signal'],
        scopes => ['global_candidate'],
        settings_schema_version => 1,
        controls => [
            {
                key => 'strength', type => 'integer', render_as => 'slider',
                minimum => 0, maximum => 100, step => 1, factory_default => 25,
                host_overridable => 1, label => 'Example influence',
                help => 'Shared default for enabled hosts.', guidance_channel => 'example_signal',
            },
            {
                key => 'horizon_days', type => 'integer', render_as => 'number',
                minimum => 1, maximum => 3650, step => 1, factory_default => 180,
                host_overridable => 1, label => 'Example horizon (days)',
                help => 'Numeric duration input.',
            },
        ],
        native_spi => {
            provider_id => 'example-guidance-native', spi_version => 2,
            protocol => 'bliss-guidance-jsonl-v2',
            channels => { example_signal => 'example_signal' },
            artifact_kinds => [], resource_kinds => [],
        },
    };
}

sub defaults {
    return { strength => 25, horizon_days => 180, settings_revision => 1 };
}

sub status {
    return { available => 1, reason => '' };
}

sub native_spi_config {
    my ($resolved_policy, $trusted_context) = @_;
    return {
        id => 'example-guidance-native',
        program => '/trusted/plugin/path/example-guidance',
        options => {
            horizon_days => $resolved_policy->{effective}->{horizon_days},
        },
        artifacts => [], resources => [], timeout_ms => 500,
    };
}

1;
