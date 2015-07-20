use MooseX::Declare;
use Method::Signatures::Simple;

=head2

	PACKAGE		FileCheck

    PURPOSE
    
        1. CHECK FILE EXISTS AND FILESIZE IS WITHIN MINIMUM 		

        AND MAXIMUM LIMITS

=cut

class FileCheck with Logger {

use FindBin qw($Bin);

####///}}} 
=head2

	SUBROUTINE 		check
	
	PURPOSE

        1. VALIDATE FILE EXISTS AND IS WITHIN FILESIZE LIMITS
        
    INPUT
    
        1. TAB-DELIMITED FILE LISTING FILE LOCATION AND MIN/MAX SIZE
        
    OUTPUTS
    
        1. TAB-DELIMITED FILE WITH 1 OR O DENOTING FILECHECK PASS/FAIL

=cut

method check ($inputfile, $outputfile) {
   
    my $contents = $self->getFileContents($inputfile);
    $self->logDebug("contents", $contents);
  
    my $lines = [ split "\n", $contents ];
    $self->logDebug("lines", $lines);

    my $outputs = [];  
    foreach my $line ( @$lines ) {
        next if $line =~ /^\s*$/;
        my $elements = [ split "\t", $line ];
        my $filepath = $$elements[0];
        my $min = $$elements[1];
        my $max = $$elements[2];
        $self->logDebug("filepath", $filepath);
        $self->logDebug("min", $min);
        $self->logDebug("max", $max);
        
        $filepath = "$Bin/$filepath" if $filepath !~ /^\//;
        $self->logDebug("filepath", $filepath);
        
        if ( not -f $filepath ) {
            $self->logDebug("inputFile DOES NOT EXIST: $filepath");
            push @$outputs, "$filepath\t0";
            next;
        }
    
        my $filesize = (-s "$filepath");
        $self->logDebug("***filesize", $filesize);
        
        if ( $filesize < $min ) {
            push @$outputs, "$filepath\t0\tmin\t$min\t$filesize";
        }            
        elsif ( $filesize > $max ) {
            push @$outputs, "$filepath\t0\tmax\t$max\t$filesize";
        }
        else {
            push @$outputs, "$filepath\t1";
        }
    }
    $self->logDebug("outputs", $outputs);

    #my $output = join "\n", @$outputs;
    #$self->printToFile($outputfile, $output);
}

sub getFileContents {
	my $self		=	shift;
	my $file		=	shift;
	
	$self->logNote("file", $file);
	open(FILE, $file) or $self->logCritical("Can't open file: $file") and exit;
	my $temp = $/;
	$/ = undef;
	my $contents = 	<FILE>;
	close(FILE);
	$/ = $temp;

	return $contents;
}




}