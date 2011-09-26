package SedCat::Controller::Session;
use Moose;
use namespace::autoclean;

BEGIN { extends "Catalyst::Controller" }

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->response->body('Matched SedCat::Controller::Session in Session.');
}

__PACKAGE__->meta->make_immutable;

__END__

