use Moose::Util::TypeConstraints;
use MooseX::Declare;
use Method::Signatures::Modifiers;

class Test::FileCheck extends FileCheck with Logger {

use FindBin qw($Bin);
use Test::More;

#####/////}}}}}

method BUILD ($args) {
	if ( defined $args ) {
		foreach my $arg ( $args ) {
			$self->$arg($args->{$arg}) if $self->can($arg);
		}
	}
	$self->logDebug("args", $args);
}

method testCheck {
	diag("check");
	
	my $tests = [
		{
			name			=>	"simple pass",
			args			=> 	{
				inputfile		=>	"$Bin/inputs/filecheck.tsv",
				outputfile		=>	"$Bin/outputs/filecheck.tsv"
			},
			expectedfile	=>	"$Bin/inputs/FileCheck.csv"
		}
		#,
		#{
		#	name			=>	"simple conversion",
		#	args			=> 	{
		#		inputfile		=>	"$Bin/inputs/FileCheckOrig.csv",
		#		outputfile		=>	"$Bin/outputs/FileCheck.csv",
		#		fcid			=> 	"C6FG8ANXX"		,
		#		sampleref		=> 	"hg19"			,
		#		control			=> 	"N"				,
		#		recipe			=> 	"PE_indexing"	,
		#		operator		=> 	"AP"			,
		#		sampleproject	=>	"WgsTestRun1" 	
		#	},
		#	expectedfile	=>	"$Bin/inputs/FileCheck.csv"
		#}
		#,
		#{
		#	name			=>	"replace inplace",
		#	args			=> 	{
		#		inputfile		=>	"$Bin/inputs/FileCheckOrig2.csv",
		#		fcid			=> 	"C6FG8ANXX"		,
		#		sampleref		=> 	"hg19"			,
		#		control			=> 	"N"				,
		#		recipe			=> 	"PE_indexing"	,
		#		operator		=> 	"AP"			,
		#		sampleproject	=>	"WgsTestRun1" 	
		#	},
		#	expectedfile	=>	"$Bin/inputs/FileCheck2.csv"
		#}
	];
	
	foreach my $test ( @$tests ) {
		my $name 		= 	$test->{name};
		my $args 		= 	$test->{args};
		my $inputfile	=	$args->{inputfile};
		my $outputfile	=	$args->{outputfile};
		my $expectedfile=	$test->{expectedfile};

		$self->logDebug("inputfile", $inputfile);
		$self->logDebug("outputfile", $outputfile);
		
		$self->check($inputfile, $outputfile);
		

		##### COPY TO outputs IF NO outputfile
		#if ( not defined $outputfile ) {
		#	my $inputfile = $args->{inputfile};
		#	$outputfile = $inputfile;
		#	$outputfile =~ s/inputs/outputs/;
		#	`cp $inputfile $outputfile`;
		#	$args->{inputfile} = $outputfile;			
		#}
		#
		#$self->logDebug("name", $name);
		#$self->logDebug("args", $args);
		#$self->check($filepath, $min, $max);
		#
		#my $diff = $self->diff($outputfile, $expectedfile);
		#$self->logDebug("diff", $diff);
		#
		#ok($diff, $name);
	}
}



}	