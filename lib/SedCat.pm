package SedCat;
use Moose;
use namespace::autoclean;
use Catalyst::Runtime 5.80;
our $VERSION = "3.90001";

use Catalyst (qw/
       Unicode::Encoding
       ConfigLoader
       Static::Simple
       Session
       Session::State::Cookie
       Session::Store::Dummy
/);

#
#       RequireSSL

extends "Catalyst";

use Sys::Hostname "hostname";

__PACKAGE__->config(
    name => 'SedCat',
    disable_component_resolution_regex_fallback => 1,
    encoding => "UTF-8",
    host => hostname() || "UNKNOWN",
    "Plugin::ConfigLoader" => {
        file => "sedcat.yml", #__PACKAGE__->path_to("conf"),
        substitutions => {},
    },
    static => {
          include_path => [ __PACKAGE__->path_to('root', 'static') ],
          ignore_extensions => [],
          debug => 0,
          mime_types => {
              svg => "image/svg+xml",
              html => "text/html",
              jsn => "application/json",
          },
    },
);

has "online" =>
    is => "ro",
    required => 1,
    default => sub { scalar(@{[ gethostbyname('google.com')  ]}) ? 1 : 0 }
;

sub name {
    my $c = shift;
    $c->{name} ||= $c->config->{name};
}

#sub encoding {
#    my $c = shift;
#    blessed($c) ?
#        ( $c->{name} ||= $c->config->{name} ) : $c->config->{name};
#}

sub version { $VERSION }

has "repository" => 
    is => "ro",
    isa => "URI",
    lazy => 1,
    default => sub { URI->new("http://github.com/pangyre/sedition.com") },
    ;

__PACKAGE__->setup();

1;

__END__

=head1 NAME

SedCat - moo...

=head1 SYNOPSIS

    script/sedcat_server.pl

=head1 DESCRIPTION

Moo...

=head1 SEE ALSO

L<SedCat::Controller::Root>, L<Catalyst>.

=head1 AUTHOR

Ashley Pond V.

=head1 LICENSE

This library is free software. You can redistribute it, modify it, or both under the same terms as Perl itself.

=cut
