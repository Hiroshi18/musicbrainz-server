use utf8;
use strict;
use Test::More;
use XML::SemanticDiff;
use Catalyst::Test 'MusicBrainz::Server';
use MusicBrainz::Server::Test qw( xml_ok v2_schema_validator );
use Test::WWW::Mechanize::Catalyst;

my $c = MusicBrainz::Server::Test->create_test_context;
my $v2 = v2_schema_validator;
my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'MusicBrainz::Server');
my $diff = XML::SemanticDiff->new;

$mech->get_ok('/ws/2/recording/162630d9-36d2-4a8d-ade1-1c77440b34e7', 'basic recording lookup');
&$v2 ($mech->content, "Validate basic recording lookup");

my $expected = '<?xml version="1.0" encoding="UTF-8"?>
<metadata xmlns="http://musicbrainz.org/ns/mmd-2.0#">
    <recording id="162630d9-36d2-4a8d-ade1-1c77440b34e7">
        <title>サマーれげぇ!レインボー</title><length>296026</length>
    </recording>
</metadata>';

is ($diff->compare ($mech->content, $expected), 0, 'result ok');


$mech->get_ok('/ws/2/recording/162630d9-36d2-4a8d-ade1-1c77440b34e7/releases', 'recording lookup with releases');
&$v2 ($mech->content, "Validate basic recording lookup with releases");

$expected = '<?xml version="1.0" encoding="UTF-8"?>
<metadata xmlns="http://musicbrainz.org/ns/mmd-2.0#">
    <recording id="162630d9-36d2-4a8d-ade1-1c77440b34e7">
        <title>サマーれげぇ!レインボー</title><length>296026</length>
        <release-list count="2">
            <release id="b3b7e934-445b-4c68-a097-730c6a6d47e6">
                <title>Summer Reggae! Rainbow</title><status>pseudo-release</status>
                <text-representation>
                    <language>jpn</language><script>Latn</script>
                </text-representation>
                <date>2001-07-04</date><country>JP</country><barcode>4942463511227</barcode>
            </release>
            <release id="0385f276-5f4f-4c81-a7a4-6bd7b8d85a7e">
                <title>サマーれげぇ!レインボー</title><status>official</status>
                <text-representation>
                    <language>jpn</language><script>Jpan</script>
                </text-representation>
                <date>2001-07-04</date><country>JP</country><barcode>4942463511227</barcode>
            </release>
        </release-list>
    </recording>
</metadata>';

is ($diff->compare ($mech->content, $expected), 0, 'result ok');

$mech->get_ok('/ws/2/recording/0cf3008f-e246-428f-abc1-35f87d584d60/artists', 'recording lookup with artist credit');
&$v2 ($mech->content, "Validate basic recording lookup with artist credit");

$expected = '<?xml version="1.0" encoding="UTF-8"?>
<metadata xmlns="http://musicbrainz.org/ns/mmd-2.0#">
    <recording id="0cf3008f-e246-428f-abc1-35f87d584d60">
        <title>the Love Bug</title><length>242226</length>
        <artist-credit>
            <name-credit joinphrase="♥">
                <artist type="group" id="22dd2db3-88ea-4428-a7a8-5cd3acf23175">
                    <name>m-flo</name><sort-name>m-flo</sort-name>
                    <life-span>
                        <begin>1998</begin>
                    </life-span>
                </artist>
            </name-credit>
            <name-credit>
                <artist type="person" id="a16d1433-ba89-4f72-a47b-a370add0bb55">
                    <name>BoA</name><sort-name>BoA</sort-name>
                    <life-span>
                        <begin>1986-11-05</begin>
                    </life-span>
                </artist>
            </name-credit>
        </artist-credit>
    </recording>
</metadata>';

is ($diff->compare ($mech->content, $expected), 0, 'result ok');

done_testing;
