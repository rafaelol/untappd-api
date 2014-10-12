package Untappd::API;
use Moo;
use URI;
use LWP::UserAgent;

our $VERSION = 0.02;

has 'client_id',     is => 'ro';
has 'client_secret', is => 'ro';
has 'access_token',  is => 'ro'; 
has 'endpoint',      is => 'rwp', default => 'https://api.untappd.com/v4';

# User Methods

sub user_feed {
    my ($self, $username, $max_id, $limit) = @_;
    
    return if !defined $username;
    return $self->_request_get("/user/checkins/$username", {max_id => $max_id,
                                                            limit  => $limit});
}

sub user_info {
    my ($self, $username) = @_;

    return if !defined $username;
    return $self->_request_get("/user/info/$username");
}

sub user_info_compact {
    my ($self, $username) = @_;

    return if !defined $username;
    return $self->_request_get("/user/info/$username", {compact => 'true' });
}

sub user_badges {
    my ($self, $username, $offset) = @_;

    return if !defined $username;
    return $self->_request_get("/user/badges/$username", { offset => $offset }); 
}

sub user_friends {
    my ($self, $username, $offset, $limit) = @_;

    return if !defined $username;
    return $self->_request_get("/user/badges/$username", { offset => $offset,
                                                           limit => $limit });
}

# Beer Methods

sub beer_info {
    my ($self, $beer_id) = @_;

    return if !defined $beer_id;
    return $self->_request_get("/beer/info/$beer_id");
}

sub beer_info_compact {
    my ($self, $beer_id) = @_;

    return if !defined $beer_id;
    return $self->_request_get("/beer/info/$beer_id", { compact => 'true' });
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

    return if ( !defined $beer_name || !defined $method );
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

=head1 DESCRIPTION

This module implements the Untappd API version 4, as specified in
L<https://untappd.com/api/docs/v4>

To use the API you will need to register for a Client ID and Client Secret. 
You can do it for free on L<https://untappd.com/api/register>.

=head2 new

Creates the Untappd::API object. You must pass a hash-ref with client_id and
client_secret or access_token.

If you want to make non-authenticated calls only, you can pass only client_id
and client_secret. If you want to make authenticated calls, you must pass
the access_token too.

=head3 Example:

my $api = Untappd::API->new( client_id     => 'a',
                             client_secret => 'b',
                             access_token  => 'c',);

=head2 user_feed

Returns a JSON with the feed from an user. You must pass the parameter
$username. 

The parameter $max_id is optional and asks the check-in id to
start with your feed. The parameter $limit is also optional and asks for
the number of results to return (maximum 50). Default is 25.

=head3 Example:

my $ret = $api->user_feed('rlopes', 12345, 42);

=head2 user_info

Returns a JSON with the user infos. You must pass the parameter $username.

=head3 Example:

my $ret = $api->user_info('rlopes');

=head2 user_info_compact

Same as user_info, but the JSON gives you less informations.

=head3 Example:

my $ret = $api->user_info_compact('rlopes');

=head2 user_badges

Returns a JSON with the last 50 badges earned by an user. The parameter
$username is mandatory. The parameter $offset is optional and asks
for the numeric offset for your results to start.
    
=head3 Example:

my $ret = $api->user_badges('rlopes', 12345); 

=head2 user_friends

Returns a JSON with the the last 25 friends an user had accepted. The
parameter $username is mandatory. The parameter $offset is optional and
asks a numeric offset for your results to start. The parameter
$limit is also optional and defines the number of records you will
return (max. 25).

=head3 Example:

my $ret = $api->user_friends('rlopes', 12345, 13);

=head2 beer_info

Returns a JSON with all the informations about a beer. The parameter
$beer_id is mandatory.

=head3 Example:

my $ret = $api->beer_info(14564); #Franziskaner Hefe-Weiss ;-D

=head2 beer_info_compact

Same as beer_info, but returns a JSON with compact informations.

=head3 Example:

my $ret = $api->beer_info_compact(671954); #Mistura Classica's Vertigem ;-D

=head2 beer_search_by_name

Returns a JSON with all beers having the string you asked. It sorts the beer
list by name. Parameter $beer_name is mandatory.

=head3 Example:

my $ret = $api->beer_search_by_name('Maracujipa'); 
#You'll get infos about 2Cabeca's MaracujIPA. ;-D

=head2 beer_search_by_count

Same as beer_search_by_name, but it sorts the info my the amount of checkins
the beer has.

=head3 Example:

my $ret = $api->beer_search_by_count('Caipira');
#You'll get infos about Wal's Saison de Caipira. ;-D

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

=head2 TESTS!

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

