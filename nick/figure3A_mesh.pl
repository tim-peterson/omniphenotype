#!/usr/bin/perl
use IO::Uncompress::Gunzip qw(gunzip $GunzipError);
use LWP::Simple;

my $url = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?api_key=524a51825dea8e8dafc5b3a2762e2af7a909&db=pubmed&retmax=100000&term=';
open(my $out, '>', "/home/nick/ncbi_mesh_papers.tsv");
open(my $mesh_file, '<', './2019New_Mesh_Tree_Hierarchy.txt');
while ($line = <$mesh_file>){
	my @fields = split(/ /, $line);
	$fields[1] =~ tr/ /_/;
	print $out $fields[0];
        $fields[0] =~ tr/ /+/;
        my $retstart = 0;
	my $bool;
        do{
		$bool = 0;
                $output = get("$url$fields[0]" . "[mesh]" . "&retstart=$retstart");
                @output = split(/\n/, $output);
                foreach $xml (@output){
                        next if (!($xml =~ /<Id>(.*)<\/Id>/));
                        $bool = 1;
                        print $out "\t$1";
                }
                $retstart += 100000;
		sleep(.1);
        }while ($bool);
        print $out "\n";
}
close($mesh_file);
close($out);
