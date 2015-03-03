#!/usr/bin/perl
use Fluent::Logger;
use LWP::Simple;
my $logger = Fluent::Logger->new(
    host => '127.0.0.1',
    port => 24224,
    tag_prefix => 'td.test_db',
);
 
$debug = 3;

$time = time;
print "Time: $time\n" if $debug;

# Get the three weather stations temperature...

my $stations = "KPWK".   # Palwaukee Airport
               ",KNUQ".   # Moffett Field, Mountain View
               ",RJAA" ;  # Narita Airport

# Fetch the page of METAR 
my $metars = get_aviationweather("$stations");

print $metars if $debug;


#$temp_json = "{\"KPWK\":\"$il_temp\",\"KNUQ\":\"$ca_temp\",\"RJAA\":\"$jp_temp\"} ";
#print "$time\n$temp_json\n" if ($debug);
#$logger->post("temperature_table", { "time" => "$time", "v" => $temp_json });



sub get_aviationweather {
  # Get the page of current conditions from avaitionweather.gov  
  local $_ = shift;
  my $url = "http://www.aviationweather.gov/adds/metars/?station_ids=".$_.
            "&std_trans=standard&chk_metars=on&hoursStr=most+recent+only&submitmet=Submit";
  # my $URL = "http://www.aviationweather.gov/adds/metars/?station_ids=KPWK,KNUQ,RJAA&std_trans=standard&chk_metars=on&hoursStr=most+recent+only&submitmet=Submit";
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
  # Example html from aviationweather.gov:   (14&deg;F)
   /\(([0-9.-]+)\&deg\;F\)/ || return "na";
  return $1;
}
