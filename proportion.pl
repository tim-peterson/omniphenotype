#!/usr/bin/perl

my $loc = '/home/nick/Gene_Stats/';
my %beta_num_cancer;
my %pval_num_cancer;
my %beta_num_non;
my %pval_num_non;
my %both_num_cancer;
my %both_num_non;
my $bool = 1;
my %cancer_diseases;
my %non_cancer_diseases;
#open(my $file, '<', "/home/nick/cancer_diseases.txt");
open(my $file, '<', "/home/nick/cancer_drugs.txt");
while ($line = <$file>){
        chomp $line;
        $cancer_diseases{$line} = 1;
}
close($file);
#open(my $file, '<', "/home/nick/non_cancer_diseases.txt");
open(my $file, '<', "/home/nick/non_cancer_drugs.txt");
while ($line = <$file>){
        chomp $line;
        $non_cancer_diseases{$line} = 1;
}
close($file);
opendir(my $dir, $loc);
while (my $filename = readdir($dir)){
	my %gene;
	my %beta_boo;
	my %pval_boo;
	my %both_boo;
	$total = 0;
	$counter = 0;
	open(my $file, '<', "$loc$filename");
	$filename =~ m/^(.*)_genes_stats\.tsv/;
	if (exists($cancer_diseases{$1})){
		$bool = 1;
	}elsif (exists($non_cancer_diseases{$1})){
		$bool = 0;
	}else{
		next;
	}
	my $line = <$file>;
	while ($line = <$file>){
		chomp $line;
		my @fields = split(/\t/, $line);
		if (!exists($beta_num_cancer{$fields[2]})){
			$beta_num_cancer{$fields[2]} = 0;
			$beta_num_non{$fields[2]} = 0;
                        $pval_num_cancer{$fields[2]} = 0;
			$pval_num_non{$fields[2]} = 0;
			$both_num_cancer{$fields[2]} = 0;
			$both_num_non{$fields[2]} = 0;
                }
		if (!exists($gene{$fields[2]})){
			$gene{$fields[2]} = 1;
			$beta_boo{$fields[2]} = 0;
			$pval_boo{$fields[2]} = 0;
			$both_boo{$fields[2]} = 0;
		}
		if (abs($fields[3]) > .0031 && !$beta_boo{$fields[2]} && $fields[7] > 10){
			if ($bool){
				$beta_num_cancer{$fields[2]}++;
			}else{
				$beta_num_non{$fields[2]}++;
			}
			$beta_boo{$fields[2]} = 1;
		}
		if ($fields[6] < 1e-03 && !$pval_boo{$fields[2]} && $fields[7] > 10){
			if ($bool){
                                $pval_num_cancer{$fields[2]}++;
                        }else{
                               $pval_num_non{$fields[2]}++;
                        }
                        $pval_boo{$fields[2]} = 1;
                }
                if ($fields[6] < 1e-03 && abs($fields[3]) > .0031 && !$both_boo{$fields[2]} && $fields[7] > 10){
                        if ($bool){
                                $both_num_cancer{$fields[2]}++;
                        }else{
                                $both_num_non{$fields[2]}++;
                        }
                        $both_boo{$fields[2]} = 1;
                }
	}
	close($file);
}
closedir($dir);
#open(my $out, '>', '/home/nick/proportion_diseases.tsv');
open(my $out, '>', '/home/nick/proportion_drugs.tsv');
print $out "Gene\tpval_cancer\tpval_non_cancer\tbeta_cancer\tbeta_non_cancer\tboth_cancer\tboth_non_cancer\n";
foreach my $key (sort {uc($a) cmp uc($b)} keys %beta_num_cancer){
	print $out "$key\t$pval_num_cancer{$key}\t$pval_num_non{$key}\t$beta_num_cancer{$key}\t$beta_num_non{$key}\t$both_num_cancer{$key}\t$both_num_non{$key}\n";
}
close($out);
