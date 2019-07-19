#!/usr/bin/perl

my %protein_gene;
open(my $go_protein_file, '<', './goa_human.gaf');
while (my $line = <$go_protein_file>){
        my @fields = split(/\t/, $line);
	$protein_gene{$fields[1]} = $fields[2];
}
close($go_protein_file);
my %go_bio_processes;
my %is_a;
my $go_term;
my $go_name;
open(my $go_names_file, '<', './go-basic.obo');
while (my $line = <$go_names_file>){
        chomp($line);
        my @fields = split(/ /, $line);
        if ($fields[0] =~ /^id:/){
                $go_bio_processes{$fields[1]} = 0;
                $go_term = $fields[1];
	}elsif ($fields[0] =~ /^name:/){
		$go_name = substr($line, 6);
        }elsif ($fields[0] =~ /^namespace:/){
                if ($fields[1] eq "biological_process"){
                        $go_bio_processes{$go_term} = $go_name;
                }
        }elsif ($fields[0] =~ /^is_a:/ && $go_bio_processes{$go_term}){
		push(@{$is_a{$go_term}}, $fields[1]);
	}
}
close($go_names_file);
open(my $out, '>', '~/go_gene.tsv');
open(my $protein_gene_file, '<', './HUMAN_9606_idmapping_selected.tab');
while (my $line = <$protein_gene_file>){
	my @fields = split(/\t/, $line);
	my @go_terms = split(/; /, $fields[6]);
	if (exists($protein_gene{$fields[0]})){
		my %terms = tree_Traverse(@go_terms);
		foreach my $term (keys %terms){
			print $out "$protein_gene{$fields[0]}\t$go_bio_processes{$term}\n";
		}
	}
}
close($protein_gene_file);
close($out);

sub tree_Traverse{
	my %terms;
	for (my $i=0; $i <= $#_; $i++){
		if ($go_bio_processes{$_[$i]}){
			%terms = (%terms, tree_Traverse(@{$is_a{$_[$i]}}));
			$terms{$_[$i]} = 1;
		}
	}
	return %terms;
}
