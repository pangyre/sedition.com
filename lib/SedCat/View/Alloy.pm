package SedCat::View::Alloy;
use strict;
use parent "Catalyst::View::TT::Alloy";
use JSON::XS ();
use DBIx::Class::ResultClass::HashRefInflator;
use Scalar::Util "blessed";

__PACKAGE__->config
    (
     ENCODING => "UTF-8",
     RECURSION => 1,
     TEMPLATE_EXTENSION => ".tt",
     PRE_PROCESS => "lib/macros.tt",
     FILTERS => {
         format_number => sub {
             require Number::Format;
             Number::Format::format_number(shift);
         },
         num2en => sub {
             require Lingua::EN::Numbers;
             Lingua::EN::Numbers::num2en(shift);
         },
     },
     );

Template::Alloy->define_vmethod
    (
     "LIST",
     serial => sub {
         my @list = @{ +shift || [] };
         join(", ", @list[0..$#list-1]) .
             (@list>2 ? ",":"" ) .
             (@list>1 ? (" and " . $list[-1]) : $list[-1]);
     }
     );

Template::Alloy->define_vmethod
    ("LIST",
     encode_json => sub {
         my $thingy = shift || return "[]";
         JSON::XS::encode_json($thingy);
     });

Template::Alloy->define_vmethod
    ("HASH",
     encode_json => sub {
         my $thingy = shift || return "{}";
         if ( blessed($thingy) eq "DBIx::Class::ResultSet" )
         {
             $thingy->result_class("DBIx::Class::ResultClass::HashRefInflator");
             return JSON::XS::encode_json({ map { $_->{id} => $_ } $thingy->all });
         }
         return JSON::XS::encode_json($thingy);
     });

1;

__END__

=pod

=head1 Name

SedCat::View::Alloy

=head1 See also

=cut
