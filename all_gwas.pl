#!/usr/bin/perl

my %SNPs;
open(my $file, '<', "/scratch/njacobs/gencode_snps.tsv");
while ($line = <$file>){
	chomp $line;
	my @fields = split(/\t/, $line);
        push(@{$SNPs{$fields[0]}}, $fields[$#fields]);
}
close($file);
my $loc = '/scratch/njacobs/GWAS_UKB/';
opendir(my $dir, $loc);
while (my $filename = readdir($dir)){
	if ($filename !~ m/^(.*)\.gwas.*/){
                next;
        }
	open(my $file, '<', "$loc$filename");
	open(my $out, '>', "/scratch/njacobs/Gene_Stats/$1_genes_stats.tsv");
	print $out "disease\tlocation\tgene_name\tbeta\tse\ttstat\tpval\texpected_case_minor_AC\n";
	$disease = $1;
	my $line = <$file>;
	while ($line = <$file>){
		chomp $line;
		my @fields = split(/\t/, $line);
		foreach my $gene (@{$SNPs{$fields[0]}}){
			print $out "$disease\t$fields[0]\t$gene\t$fields[8]\t$fields[9]\t$fields[10]\t$fields[11]\t$fields[3]\n";
		}
	}
	close($file);
	close($out);
}
closedir($dir);
close($out);
