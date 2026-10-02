package Plugins::LyrionProvider::Plugin;

use strict;
use warnings;
use base qw(Slim::Plugin::Base);
use Plugins::LyrionProvider::Provider;

sub initPlugin {
    my $class = shift;
    $class->SUPER::initPlugin(@_);
}

sub guidance_provider_descriptor_v1 {
    return Plugins::LyrionProvider::Provider::descriptor();
}

sub guidance_provider_defaults_v1 {
    return Plugins::LyrionProvider::Provider::defaults();
}

sub guidance_provider_status_v1 {
    return Plugins::LyrionProvider::Provider::status();
}

sub guidance_provider_native_spi_config_v1 {
    return Plugins::LyrionProvider::Provider::native_spi_config(@_);
}

1;
