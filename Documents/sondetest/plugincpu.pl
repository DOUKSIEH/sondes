#!/usr/bin/perl

check_win_snmp_cpuload.pl IP COMMUNITY PORT warning critical
sub print_usage {
    print "check_win_snmp_cpuload.pl COMMUNITY IP warning critical\n";


$PROGNAME = "check_win_snmp_cpuload.pl";

if  ( @ARGV[0] eq "" || @ARGV[1] eq "" || @ARGV[2] eq "" ) {
    print_usage();
    exit 0;
}

$STATE_CRITICAL = 2;
$STATE_WARNING = 1;
$STATE_UNKNONW = 3;

$STATE_OK = 0;
#my (ip, community, warning, critical) = @_;
my $IP=@ARGV[0];
my $COMMUNITY=@ARGV[1];
my $warning=@ARGV[2];
my $critical=@ARGV[3];
my $resultat =`snmpwalk -v 2c -c $COMMUNITY $IP 1.3.6.1.2.1.25.3.3.1.2`;
if ( $resultat ) {
    @pourcentage = split (/\n/,$resultat);
    my $i=0;;
    my use_total;
    foreach ( @pourcentage ) {
    s/HOST-RESOURCES-MIB::hrProcessorLoad.\d+ = INTEGER://g;
    $use_total+=$_;
    $i++;
    }
    $use = $use_total / $i +1 ;

    if ( $use < $warning ) {
       print "OK : CPU load:  $use%\n";
       exit $STATE_OK;
    } elsif ( $use < critical ) {
       print "WARNING : CPU load: $use%\n";
       exit $STATE_WARNING;
    } else {
       print "CRITICAL : CPU load: $use%\n";
       exit $STATE_CRITICAL;
    }
} else {
    print "Unkonwn  : No response\n";
    exit $STATE_UNKNONW;
}
}