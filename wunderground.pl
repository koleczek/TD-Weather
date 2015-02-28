#!/usr/bin/perl
use Fluent::Logger;
use LWP::Simple;
my $logger = Fluent::Logger->new(
    host => '127.0.0.1',
    port => 24224,
    tag_prefix => 'td.test_db',
);


$time = time;

print "Time: $time\n";
my $il = get("${url}60004"); # Arlington Heights, IL
#my $il = get_wunderground("60004");
my $il_temp = current_temp($il);
print $il;
print "IL: $il_temp\n";  

##my $ca = get("${url}94040"); # Mountain View, CA`
#my $ca = get_wunderground("94040");
#my $ca_temp = current_temp($ca);
#print "CA: $ca_temp\n";  

$temp_json = "{\"60004\":\"$il_temp\",\"94040\":\"$ca_temp\"} ";
print "$time\n$temp_json\n";
#$logger->post("temp_table", { "time" => "$time", "v" => $temp_json });

sub get_wunderground {
  local $_ = shift;
  my $url = "http://www.wunderground.com/cgi-bin/findweather/getForecast?query=";
  my $ua = LWP::UserAgent->new;
  $ua->timeout(10);
  my $response = $ua->get("$url"."$_");
  return $response;
}

sub current_temp {
  local $_ = shift;
  # Example:
  # temp_now: '6.1 &deg;F',
#  /temp_now:\s\'([0-9.]+)\s/ || die "No temp data?";
  /temp_now:\s\'([0-9.]+)\s/;
  return $1;
}
