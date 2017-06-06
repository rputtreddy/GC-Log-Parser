use strict;
use POSIX;

my $serverName=<STDIN>;
my $start_time=time();
my $sourceFileName = "filepath\\gc.log";
my $accessLogFileName = "destinationfilepath\\output.csv";
open(FILE, "<$sourceFileName") || die "File not found";
my @lines = <FILE>;
close(FILE);

my @fullGCLines;
my @minorGCLines;

foreach(@lines) {
	if($_ =~ /Full GC/){
		$_ =~ s/ /,/g;
		$_ =~ s/Full,GC/FullGC/g;
		$_ =~ s/\(/,/g;
		$_ =~ s/\)/,/g;
   		$_ =~ s/\]//g;
   		$_ =~ s/\[//g;
   		$_ =~ s/->/,/g;
   		$_ =~ s/=/,/g;
   		$_ =~ s/\+0530://g;
   		$_ =~ s/PSYoungGen:/PSYoungGen/g;
   		$_ =~ s/ParOldGen:/ParOldGen/g;
   		$_ =~ s/PSPermGen:/PSPermGen/g;
   		$_ =~ s/Times:/Times/g;
   		$_ =~ s/,,/,/g;
   		push(@fullGCLines,$_);
	}
	else{
		$_ =~ s/ /,/g;
		$_ =~ s/\(/,/g;
		$_ =~ s/\)/,/g;
   		$_ =~ s/\]//g;
   		$_ =~ s/\[//g;
   		$_ =~ s/->/,/g;
   		$_ =~ s/=/,/g;
   		$_ =~ s/\+0530://g;
   		$_ =~ s/PSYoungGen:/PSYoungGen/g;
   		$_ =~ s/Times:/Times/g;
   		$_ =~ s/,,/,/g;
   		push(@minorGCLines,$_);
}
}
my (@tempValues,@GCLines);
my $calcValue;
my $len;
my $temp;

my ($timestamp,$beforeYoungGCSize,$afterYoungGCSize,$YoungGCAllocatedSize,
		$totalHeapMemoryBeforeGC,$totalHeapMemoryAfterGC,$totalHeapMemoryAllocated,
		$beforeOldGCSize,$afterOldGCSize,$OldGCAllocatedSize,
		$beforePermGCSize,$afterPermGCSize,$PermGenAllocatedSize,$gcType);

my ($minorGCMergeOp,$majorGCMergeOp);

foreach(@minorGCLines){
	@tempValues = split /,/,$_;
	$temp = $tempValues[4];
	$beforeYoungGCSize = &convertToValue($temp);
	$temp = $tempValues[5];
	$afterYoungGCSize = &convertToValue($temp);
	$temp = $tempValues[6];
	$YoungGCAllocatedSize = &convertToValue($temp);
	$temp = $tempValues[7];
	$totalHeapMemoryBeforeGC = &convertToValue($temp);
	$temp = $tempValues[8];
	$totalHeapMemoryAfterGC = &convertToValue($temp);
	$temp = $tempValues[9];
	$totalHeapMemoryAllocated = &convertToValue($temp);
	$minorGCMergeOp = join(",",$tempValues[0],'MinorGC',$beforeYoungGCSize,$afterYoungGCSize,$YoungGCAllocatedSize,0,0,0,
											$totalHeapMemoryBeforeGC,$totalHeapMemoryAfterGC,$totalHeapMemoryAllocated,0,0,0,
											$tempValues[15],$tempValues[17],$tempValues[19],$serverName);
	push(@GCLines,$minorGCMergeOp);		
}

foreach(@fullGCLines){
	@tempValues = split /,/,$_;
	$temp = $tempValues[4];
	$beforeYoungGCSize = &convertToValue($temp);
	$temp = $tempValues[5];
	$afterYoungGCSize = &convertToValue($temp);
	$temp = $tempValues[6];
	$YoungGCAllocatedSize = &convertToValue($temp);
	$temp = $tempValues[8];
	$beforeOldGCSize = &convertToValue($temp);
	$temp = $tempValues[9];
	$afterOldGCSize = &convertToValue($temp);
	$temp = $tempValues[10];
	$OldGCAllocatedSize = &convertToValue($temp);
	$temp = $tempValues[11];
	$totalHeapMemoryBeforeGC = &convertToValue($temp);
	$temp = $tempValues[12];
	$totalHeapMemoryAfterGC = &convertToValue($temp);
	$temp = $tempValues[13];
	$totalHeapMemoryAllocated = &convertToValue($temp);
	$temp = $tempValues[15];
	$beforePermGCSize = &convertToValue($temp);
	$temp = $tempValues[16];
	$afterPermGCSize = &convertToValue($temp);
	$temp = $tempValues[17];
	$PermGenAllocatedSize = &convertToValue($temp);
	$majorGCMergeOp = join(",",$tempValues[0],'MajorGC',$beforeYoungGCSize,$afterYoungGCSize,$YoungGCAllocatedSize,
											$beforeOldGCSize,$afterOldGCSize,$OldGCAllocatedSize,$totalHeapMemoryBeforeGC,$totalHeapMemoryAfterGC,
											$totalHeapMemoryAllocated,$beforePermGCSize,$afterPermGCSize,$PermGenAllocatedSize,
											$tempValues[23],$tempValues[25],$tempValues[27],$serverName);
	push(@GCLines,$majorGCMergeOp);
}

my $strLength;
my $extractedValue;

sub convertToValue(){
	my $value = $_[0];
	if($value =~ /\d+K$/){
		$strLength = length($value);
		$extractedValue = substr($value,0,$strLength-1);
		$calcValue = $extractedValue * 1024;
		return $calcValue;
	} 
	elsif($value =~ /\d+M$/){
		$strLength = length($value);
		$extractedValue = substr($value,0,$strLength-1);
		$calcValue = $extractedValue * 1024*1024;
		return $calcValue;
	}
}

open(FILE, ">$accessLogFileName") || die "File not found";
print FILE "timestamp,gcType,beforeYGGCSize,afterYGGCSize,YoungGenSpaceAllocated,beforeOldGCSize,afterOldGCSize,OldGenAllocatedSize,TotalHeapMemoryBeforeGC,TotalHeapMemoryAfterGC,TotalHeapMemoryAllocated,beforePermGenSize,afterPermGenSize,PermGenAllocatedSize,userTime,SysTime,RealTime,ServerName\n";
print FILE @GCLines;
close(FILE);
my $end_time=time();
my $run_time = $end_time - $start_time;
print "Task Completed in $run_time seconds";
