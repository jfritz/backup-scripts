#!/usr/bin/env perl
# Script to tweet status of a backup to myself.
# written by Jeff Fritz jefffritz @gmail.com
 
# Initialization and such. Variables starting in 't_' are relevant to twitter.
my $logname = $ARGV[0];
my $t_app   = '/home/jeff/backup-scripts/ttytter.pl';
 
# Some basic checks
(-f $logname) or die ("Unable to open log $logname !");
 
# Twitter variables.
my $t_dest_acct = 'jsfritz';
 
# Status messages and such.
my @nicknames = (
    'Jeff',
    'Jeffster',
    'Jeffykins',
    'J-Dawg'
);
my @good = (
    'Backup looks good',
    'Peachy keen',
    'Status is nominal',
    'Backup went smoothly',
    'Backup A-OK'
);
my @bad = (
    'Something bad happened',
    'Abnormal backup status',
    'Error in backup',
    'Backups need your attention'
);
# ----------- User serviceable parts end here ! -------------
 
# Slurp in the log. (as one big chunk)
open(my $LOG, '< ', $logname) or die $!;
undef $/;
my $LOG_DATA = <$LOG>;
close $LOG;
 
# Grab some variables from the log.
my @errors      = ($LOG_DATA =~ m/Errors ([0-9]+)/);
my @delta       = ($LOG_DATA =~ m/TotalDestinationSizeChange [0-9]+ \((.*)\)/);
my @duration    = ($LOG_DATA =~ m/ElapsedTime (.*) \(/);
my @bucket      = ($logname =~ m/backup\.([a-zA-Z-]+)\./);
 
# Build tweet, good or bad.
my $stats = "Delta=$delta[0] Dur=$duration[0] Bucket=$bucket[0]";
my $status;
my $message;
if ($errors[0] > 0 || $errors[0] eq '') {
    $status = "FAIL. ";
    $message = $bad[int(rand(@bad))] . ', ' . $nicknames[int(rand(@nicknames))] . '. ';
}
else {
    $status = "OK. ";
    $message = $good[int(rand(@good))] . ', ' . $nicknames[int(rand(@nicknames))] . '. ';
}
 
my $statusLine = '@' . $t_dest_acct . ' ' . $message . '(' . $status . $stats . ')';
 
# If the tweet > 140chars, don't send the spiffy message part of the status.
if (length($statusLine) > 140) {
    $statusLine = '@' . $t_dest_acct . ' ' . '(' . $status . $stats . ')';
}
 
# Send out tweet.
exec("$t_app -status=\"$statusLine\"");
 
return 0;
