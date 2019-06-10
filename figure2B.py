#from pydoc import help
import csv
import sys
import numpy as np
import scipy
from scipy.stats.stats import pearsonr

from rpy2.robjects.packages import importr
from rpy2.robjects.vectors import FloatVector

stats = importr('stats')

path = "/Users/timrpeterson/OneDrive - Washington University in St. Louis/Data/MORPHEOME/"

input_genes = ["TGFBR2", "TGFBR1", "SMAD3", "FBN1"]
input_genes = ["MTOR", "RPTOR"]

dataset_type = sys.argv[1]
input_genes = sys.argv[2:]

input_genes_str = '_'.join(input_genes)


if "depmap_broad_sanger" in dataset_type:
	datasets = [path + 'DepMap/gene_effect_corrected_output.csv', path + 'Hart-Moffat/qbf_Avanadata_2018.csv', path + 'DepMap/02a_BayesianFactors.csv']

else:
	datasets = [path + 'DepMap/gene_effect_corrected_output.csv', path + 'Hart-Moffat/qbf_Avanadata_2018.csv']

output = {}
for x in input_genes:

	for y in datasets:

		delimiter = ','

		if "gene_effect" not in y:
			#age = '2018q4'
			#delimiter = '\t'
			remove_gene_id = False 
		else:
			#age = '2019q1'
			#delimiter = ','
			remove_gene_id = True 

		with open(y) as csv_file:
			csv_reader = csv.reader(csv_file, delimiter=delimiter)
			next(csv_reader)

			genes = {}
			for row in csv_reader:
				gene = row[0]
				row.pop(0)

				if remove_gene_id is True:
					arr = gene.split()
				#row_temp.pop(0)
					genes[arr[0]] = row
				else:
					genes[gene] = row

			for key, value in genes.items(): 

				if x not in genes:

					continue

				result = pearsonr(np.array(value).astype(np.float), np.array(genes[x]).astype(np.float))

				if key in output:

					output[key]["pearsons"].append(result[0])

					if "pval" in output[key] and result[1]!=0:

						output[key]["pval"].append(result[1])

					elif "pval" not in output[key] and result[1]!=0: 

						output[key]["pval"] = [result[1]]
				else:

					if result[1]!=0: 

						output[key] = {"pearsons" : [result[0]], "pval" : [result[1]]}
					else:
						output[key] = {"pearsons" : [result[0]]}
				#output.append(list((key,) + result)) 

				#sort the output desc
			#output2 = sorted(output, key=lambda x: x[1], reverse=True)

output2 = []
for key, value in output.items():
	p_adjust = stats.p_adjust(FloatVector(value["pval"]), method = 'BH')
	pval = scipy.stats.stats.combine_pvalues(p_adjust)
	#pval = np.prod(value["pval"])/len(value["pval"])
	result = (sum(value["pearsons"])/len(value["pearsons"]), pval[1])

	output2.append(list((key,) + result)) 

#sort the output desc
output3 = sorted(output2, key=lambda x: x[1], reverse=True)


with open(path + 'interaction_correlations_basal/' + input_genes_str + '-' + dataset_type + '-pearsons-python.csv', 'w') as csvfile:
	spamwriter = csv.writer(csvfile, delimiter=',')

	for row in output3:
		#if any(field.strip() for field in row):
		spamwriter.writerow(row)

	csvfile.close()

