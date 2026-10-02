package Plugins::LyrionProvider::Settings;

use strict;
use warnings;
use base qw(Slim::Web::Settings);

sub name { 'PLUGIN_EXAMPLEGUIDANCE' }
sub page { 'plugins/ExampleGuidance/settings/exampleguidance.html' }
sub prefs { return preferences('plugin.exampleguidance') }

1;
