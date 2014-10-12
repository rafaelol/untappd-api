package Untappd::API;
use Moo;
use URI;
use LWP::UserAgent;

our $VERSION = 0.02;

has 'client_id',     is => 'ro', required => 1;
has 'client_secret', is => 'ro', required => 1;
has 'access_token',  is => 'ro'; 
has 'endpoint',      is => 'rwp', default => 'https://api.untappd.com/v4';

# User Methods

sub user_feed {
    my ($self, $username, $max_id, $limit) = @_;
    return $self->_request_get("/user/checkins/$username", {max_id => $max_id,
                                                            limit  => $limit});
}

sub user_info {
    my ($self, $username) = @_;
    return $self->_request_get("/user/info/$username");
}

sub user_info_compact {
    my ($self, $username) = @_;
    return $self->_request_get("/user/info/$username", {compact => 'true' });
}

sub user_badges {
    my ($self, $username, $offset) = @_;
    return $self->_request_get("/user/badges/$username", { offset => $offset }); 
}

sub user_friends {
    my ($self, $username, $offset, $limit) = @_;
    return $self->_request_get("/user/badges/$username", { offset => $offset,
                                                           limit => $limit });
}

# Beer Methods

sub beer_info {
    my ($self, $bid) = @_;
    return $self->_request_get("/beer/info/$bid");
}

sub beer_info_compact {
    my ($self, $bid) = @_;
    return $self->_request_get("/beer/info/$bid", { compact => 'true' });
}

sub beer_search_by_name {
    my ( $self, $beer_name ) = @_;
    return if !defined $beer_name;
    return $self->_beer_search( $beer_name, "name" );
}

sub beer_search_by_count {
    my ( $self, $beer_name ) = @_;
    return if !defined $beer_name;
    return $self->_beer_search( $beer_name, "count" );
}

sub _beer_search {
    my ( $self, $beer_name, $method ) = @_;
    return $self->_request_get("/search/beer", { q    => $beer_name,
                                                 sort => $method,
                                               });
}

sub _request_get {
    my ( $self, $method, $params_tmp ) = @_;

    $params_tmp->{client_id}     = $self->client_id;
    $params_tmp->{client_secret} = $self->client_secret;
    $params_tmp->{access_token}  = $self->access_token;

    my %params = map { defined $params_tmp->{$_} 
        ? ( $_ => $params_tmp->{$_} )
        : () } keys %$params_tmp;

    my $uri = URI->new( $self->endpoint . $method );
    $uri->query_form( %params );
    my $lwp = LWP::UserAgent->new;
    my $res = $lwp->get( $uri );
    return $res->decoded_content;
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

=head2 user_feed

=head2 user_info

=head2 user_info_compact

=head2 user_badges

=head2 user_friends

=head2 beer_info 

=head2 beer_info_compact

=head2 beer_search_by_name

=head2 beer_search_by_count

=head1 To-Do

=head2 User Methods
User Wish List
User Distinct Beer

=head2 Beer Methods
Beer Feed
Trending

=head2 Venue/Brewery Methods
All of them. =)

=head2 Untappd Methods
All of them. =)

=head1 Acknowledgments

First of all, I thank Ninkasi, the tutelary goddess of beer, and all the 
sumerian people for their creation. =)

Second, thank you Untappd for creating this service (and recording my
drinking history). =)

Last, but not least, this module would not exist without the support, help
and motivation given by GARU. Thanks, bro. =) 

=head1 If you're in Brazil...

Specially if you're in Rio... Send me a message. Let's drink some beer
together! =)

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

