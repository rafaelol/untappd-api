use strict;
use warnings;
use Test::More;
use Untappd::API;

subtest 'default endpoint' => sub {
    my $api = Untappd::API->new(
        client_id     => '123',
        client_secret => 'abc',
	access_token  => '1a2b3c',
    );;

    is $api->endpoint, 'https://api.untappd.com/v4', 'default endpoint defined';
    is $api->client_id, '123', 'client_id set properly';
    is $api->client_secret, 'abc', 'client_secret set properly';
    is $api->access_token, '1a2b3c', 'access_token set properly';
};

subtest 'custom endpoint' => sub {
    my $api = Untappd::API->new(
        endpoint      => 'http://example.com',
        client_id     => 'def',
        client_secret => '456',
	access_token  => 'a4b2c6',
    );;

    is $api->endpoint, 'http://example.com', 'default endpoint defined';
    is $api->client_id, 'def', 'client_id set properly';
    is $api->client_secret, 456, 'client_secret set properly';
    is $api->access_token, 'a4b2c6', 'access_token set properly';
};

done_testing;
