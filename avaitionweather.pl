#!/usr/bin/perl
use Fluent::Logger;
use LWP::Simple;
my $logger = Fluent::Logger->new(
    host => '127.0.0.1',
    port => 24224,
    tag_prefix => 'td.test_db',
);
 
$debug = 2;

$time = time;
print "Time: $time\n" if $debug;

# Get the three weather stations temperature...

my $il = get_aviationweather("kpwk"); # Palwaukee Airport
my $il_temp = current_temp($il);
#print "IL: $il_temp\n" if ($debug > 2);  

my $ca = get_aviationweather("KNUQ"); # Moffett Field
my $ca_temp = current_temp($ca);
#print "CA: $ca_temp\n" if ($debug > 2);  

my $jp = get_aviationweather("RJAA"); # Narita Intl
my $jp_temp = current_temp($jp);
#print "JP: $ca_temp\n" if $debug;  

# Prepare and send the weather data

$temp_json = "{\"KPWK\":\"$il_temp\",\"KNUQ\":\"$ca_temp\",\"RJAA\":\"$jp_temp\"} ";
print "$time\n$temp_json\n" if ($debug > 1);
$logger->post("temperature_table", { "time" => "$time", "v" => $temp_json });



sub get_aviationweather {
  # Get the page of current conditions from avaitionweather.gov  
  local $_ = shift;
  my $url = "http://www.aviationweather.gov/adds/metars/?station_ids=".$_.
            "&std_trans=translated&chk_metars=on&hoursStr=most+recent+only&submitmet=Submit";
  print "Getting $url\n" if ($debug > 3);
  my $ua = LWP::UserAgent->new;
  $ua->timeout(10);
  my $response = $ua->get("$url");
  if ($response->is_success) {
      print $response->decoded_content if ($debug > 4); 
      return $response->decoded_content;
  }
  else {
     die $response->status_line;
  }
}

sub current_temp {
  # Parse out the temperature string from the conditions page.
  local $_ = shift;
  #Example:
  # (14&deg;F)
#  /temp_now:\s\'([0-9.]+)\s/ || die "No temp data?";
#  /temp_now:\s\'([0-9.]+)\s/;
   /\(([0-9.-]+)\&deg\;F\)/ || return "na";
  return $1;
}
