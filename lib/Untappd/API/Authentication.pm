package Untappd::API::Authentication;
use Moo;
extends 'Untappd::API';

our $VERSION = 0.02;

sub server_side_authentication_step_1 {
    my ( $self, $return_address ) = @_;

    return if !defined $return_address;

    return "https://untappd.com/oauth/authenticate/?client_id="
           . $self->client_id
           . "&client_secret="
           . $self->client_secret
           . "&response_type=code&redirect_url="
           . $return_address; 
}

sub server_side_authentication_step_2 {
    my ( $self, $redirect_url, $code ) = @_;

    return if ( !defined $code || !defined $redirect_url );

    my $path = "https://untappd.com/oauth/authorize/?client_id="
             . $self->client_id
             . "&client_secret="
             . $self->client_secret
             . "&response_type=code"
             . "&redirect_url="
             . $redirect_url
             . "&code="
             . $code;

    my $uri = URI->new( $path );

    my $lwp = LWP::UserAgent->new;
    my $res = $lwp->get( $uri );

    return $res->decoded_content;
}

sub client_side_authentication {
    my ( $self, $redirect_url ) = @_;
    
    return if ( !defined $redirect_url );

    return "https://untappd.com/oauth/authenticate/"
           . "?client_id="
           . $self->client_id
           . "&response_type=token"
           . "&redirect_url="
           . $redirect_url; 
}

1;
__END__

=head1 NAME

Untappd::API - interface to the Untappd API

=head1 SYNOPSIS

=head1 DESCRIPTION

This module implements the Untappd API version 4, as specified in L<https://untappd.com/api/docs/v4>

To use the API you will need to register for a Client ID and Client Secret. You can
do it for free on L<https://untappd.com/api/register>.

=head2 new

=head1 LICENSE AND COPYRIGHT

Copyright 2014 Rafael Oliveira Lopes C<< <rlopes at cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlartistic>.



=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.



