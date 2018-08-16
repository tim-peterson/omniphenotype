# Figure 1

	select count(distinct(`GO term accession`)) from (select `Gene stable ID` from (select * from wang_essential_genes m
	join aliases_ensembl e
	on m.Gene=e.`HGNC_symbol`
	where `KBM7 adjusted p-value` <= 0.1 or `K562 adjusted p-value` <= 0.1 or `Jiyoye adjusted p-value` <= 0.1
	or `Raji adjusted p-value` <= 0.1 group by `Gene`) w
	UNION
	select `Gene stable ID` from (select * from moffat_essential_genes m
	join aliases_ensembl e
	on m.Gene=e.`HGNC_symbol`
	where BF_hela > -8.5071442532871 or BF_dld1 > -2.0668636991133 or BF_hct116 > -17.799982266548 or BF_gbm > -2.7917072423712 or BF_a375 > 0.33046470891417 or BF_rpe1 > -4.8983349441656 group by `Gene`) m
	UNION
	select `Gene stable ID` from (select * from brummelkamp_kbm7_essential_genes m
	where ratio < 0.4167357061454909+0.21036674578874986/2 group by `Gene stable ID`) b1
	UNION
	select `Gene stable ID` from (select * from brummelkamp_hap1_essential_genes m
	where ratio < 0.4167357061454909+0.21036674578874986/2 group by `Gene stable ID`) b2 group by `Gene stable ID`) m
	join gene_ontology g
	on m.`Gene stable ID` = g.`Gene stable ID`;


	select count(distinct(`GO term accession`)) from (select w.`Gene stable ID` from (select * from wang_essential_genes m
	join aliases_ensembl e
	on m.Gene=e.`HGNC_symbol`
	where `KBM7 adjusted p-value` <= 0.1 or `K562 adjusted p-value` <= 0.1 or `Jiyoye adjusted p-value` <= 0.1
	or `Raji adjusted p-value` <= 0.1 group by `Gene`) w
	join (select * from moffat_essential_genes m
	join aliases_ensembl e
	on m.Gene=e.`HGNC_symbol`
	where BF_hela > -8.5071442532871 or BF_dld1 > -2.0668636991133 or BF_hct116 > -17.799982266548 or BF_gbm > -2.7917072423712 or BF_a375 > 0.33046470891417 or BF_rpe1 > -4.8983349441656 group by `Gene`) m
	on w.`Gene stable ID`= m.`Gene stable ID`
	join (select * from brummelkamp_kbm7_essential_genes m
	where ratio < 0.4167357061454909+0.21036674578874986/2 group by `Gene stable ID`) b1
	on w.`Gene stable ID`= b1.`Gene stable ID`
	join (select * from brummelkamp_hap1_essential_genes m
	where ratio < 0.4167357061454909+0.21036674578874986/2 group by `Gene stable ID`) b2 
	on w.`Gene stable ID`= b2.`Gene stable ID` group by w.`Gene stable ID`
	) m
	join gene_ontology g
	on m.`Gene stable ID` = g.`Gene stable ID`;

	select count(distinct(`GO term accession`)) from (select e.* from wang_essential_genes w
	join aliases_ensembl e
	on w.Gene=e.`HGNC_symbol`
	join moffat_essential_genes m
	on m.Gene=e.`HGNC_symbol`
	join brummelkamp_kbm7_essential_genes b1
	on b1.`Gene stable ID`=e.`Gene stable ID`
	join brummelkamp_hap1_essential_genes b2
	on b2.`Gene stable ID`=e.`Gene stable ID`) m
	join gene_ontology g
	on m.`Gene stable ID` = g.`Gene stable ID`;


	select count(distinct(`GO term accession`)) from (
	select `Gene stable ID` from (select e.* from wang_essential_genes w
	join aliases_ensembl e
	on w.Gene=e.`HGNC_symbol`) w
	UNION
	select `Gene stable ID` from ( select * from moffat_essential_genes m
	join aliases_ensembl e
	on m.Gene=e.`HGNC_symbol`) m
	UNION
	select `Gene stable ID` from brummelkamp_kbm7_essential_genes b1
	UNION
	select `Gene stable ID` from brummelkamp_hap1_essential_genes b2) m
	join gene_ontology g
	on m.`Gene stable ID` = g.`Gene stable ID`;

	select count(distinct(`GO term accession`)) from (select * from wang_essential_genes m
	join aliases_ensembl e
	on m.Gene=e.`HGNC_symbol`
	where `KBM7 adjusted p-value` <= 0.1 or `K562 adjusted p-value` <= 0.1 or `Jiyoye adjusted p-value` <= 0.1
	or `Raji adjusted p-value` <= 0.1 group by `Gene`) m
	join gene_ontology g
	on m.`Gene stable ID` = g.`Gene stable ID`;



