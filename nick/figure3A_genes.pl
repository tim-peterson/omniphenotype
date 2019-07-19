#!/usr/bin/perl
use IO::Uncompress::Gunzip qw(gunzip $GunzipError);
use LWP::Simple;

my $gene_url = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?api_key=524a51825dea8e8dafc5b3a2762e2af7a909&dbfrom=gene&db=pubmed&id=';
my $homolog_url = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?api_key=524a51825dea8e8dafc5b3a2762e2af7a909&db=gene&retmax=100000&term=ortholog_gene_';
open(my $gene_file, '<', './gene_result.txt');
open(my $out, '>', '/home/nick/ncbi_gene_papers.tsv');
my $line = <$gene_file>;
while ($line = <$gene_file>){
	my @fields = split(/\t/, $line);
	print $out $fields[5];
	my $homolog_output = get("$homolog_url$fields[2]" . "[group]");
	my @homolog_output = split(/\n/, $homolog_output);
	my $homolog_list = "$fields[2]";
	foreach my $homolog_xml (@homolog_output){
		next if (!($homolog_xml =~ /<Id>(.*)<\/Id>/));
		next if ($homolog_xml =~ /<Id>$fields[2]<\/Id>/);
		$homolog_list .= ",$1";
	}
	sleep(.1);
	my $output = get("$gene_url$homolog_list");
	my @output = split(/\n/, $output);
	my $bool = 1;
	foreach my $xml (@output){
		if ($xml =~ /<LinkSetDb>/){
			$bool = 0;
			next;
		}
		last if ($xml =~ /<\/LinkSetDb>/);
        	next if (!($xml =~ /<Id>(.*)<\/Id>/) || $bool);
        	print $out "\t$1";
	}
	print $out "\n";
	sleep(.1);
}
close($out);
close($gene_file);
