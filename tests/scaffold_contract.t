use strict;
use warnings;
use FindBin;
use JSON::PP qw(decode_json);
use Test::More;

my $root = "$FindBin::Bin/..";
my $descriptor_path = "$root/fixtures/provider-descriptor-v1-all-controls.json";
open my $descriptor_fh, '<', $descriptor_path or die "cannot read $descriptor_path: $!";
my $descriptor = decode_json(do { local $/; <$descriptor_fh> });
close $descriptor_fh;

is($descriptor->{protocol_version}, 1, 'fixture declares descriptor protocol v1');
is($descriptor->{provider_id}, 'example-guidance', 'fixture has stable provider identity');
is($descriptor->{settings_uri}, 'plugins/ExampleGuidance/settings/exampleguidance.html', 'fixture declares a provider-owned settings page');
ok(ref($descriptor->{controls}) eq 'ARRAY' && @{$descriptor->{controls}} == 4, 'fixture covers all canonical control kinds');

my %controls = map { $_->{key} => $_ } @{$descriptor->{controls}};
is($controls{enabled_by_default}->{type}, 'boolean', 'boolean setting is described without markup');
is($controls{strategy}->{type}, 'enum', 'enum setting is described without markup');
is($controls{strength}->{render_as}, 'slider', 'slider widget is descriptor-owned');
is($controls{horizon_days}->{render_as}, 'number', 'number widget is descriptor-owned');
ok(!exists $controls{strength}->{html}, 'descriptor never contains raw markup');

for my $relative (
    'templates/LyrionProvider/Plugin.pm',
    'templates/LyrionProvider/Provider.pm',
    'templates/LyrionProvider/Settings.pm',
    'templates/LyrionProvider/HTML/EN/plugins/LyrionProvider/settings/provider.html',
) {
    ok(-f "$root/$relative", "template exists: $relative");
}

open my $template_fh, '<', "$root/templates/LyrionProvider/HTML/EN/plugins/LyrionProvider/settings/provider.html"
    or die "cannot read provider settings template: $!";
my $template = do { local $/; <$template_fh> };
close $template_fh;
like($template, qr/settings\/footer\.html/, 'provider settings template includes the standard explicit Save footer');

done_testing();
