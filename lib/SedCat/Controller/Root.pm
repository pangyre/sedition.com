package SedCat::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends "Catalyst::Controller" }

__PACKAGE__->config(namespace => "");

sub base :Path :Args(0) {
    my ( $self, $c ) = @_;
}

sub default :Path {
    my ( $self, $c, @path ) = @_;
    return $c->response->status(204) if $path[0] eq "favicon.ico";
    $c->response->status(404);
}

sub render :ActionClass("RenderView") {}
sub end :Private {
    my ( $self, $c ) = @_;

    $c->forward("render") unless @{$c->error};
    if ( grep /no such table/, @{$c->error} )
    {
        $c->log->error("Apparently there is no database, attempting auto deployment");
        $c->model("DBIC")->schema->deploy();
        $c->clear_errors;
        $c->forward("render");
    }

    # If there was an error in the render above, process it and re-render.
    if ( @{$c->error} )
    {
        $c->forward("Error") and $c->forward("render");
    }

    # If there is a new error at this point, it's time to redirect to
    # a static page or do something terribly simple...
    if ( @{$c->error} )
    {
        $c->forward("Error::Static");
    }
}

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

SedCat::Controller::Root - Root Controller for SedCat

=cut

