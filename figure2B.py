#from pydoc import help
import time
import csv
import sys
import numpy as np
import scipy
from scipy.stats.stats import pearsonr

from rpy2.robjects.packages import importr
from rpy2.robjects.vectors import FloatVector

stats = importr('stats')

path = "/scratch/timrpeterson/OneDrive-v2/Data/MORPHEOME/" #  - Washington University in St. Louis

#input_genes = ["TGFBR2", "TGFBR1", "SMAD3", "FBN1"]
input_genes = ["MTOR", "RPTOR"]

dataset_type = sys.argv[1]
#input_genes = sys.argv[2:]
#dataset_type = "2019q2"

#input_genes_str = '_'.join(input_genes)

if "depmap_broad_sanger" in dataset_type:
	datasets = [path + 'DepMap/gene_effect_corrected_t_clean_gene_name.csv', path + 'DepMap/qbf_Avanadata_2018.csv', path + 'DepMap/02a_BayesianFactors.csv']
elif "2019q2" in dataset_type:
	datasets = [path + 'DepMap/broad_2019q2_t.csv']
elif "2018" in dataset_type:
	datasets = [path + 'DepMap/qbf_Avanadata_2018.csv'] # path + 'DepMap/gene_effect_corrected_output.csv', 
else:
	datasets = [path + 'DepMap/qbf_Avanadata_2018.csv', path + 'DepMap/gene_effect_corrected_output.csv'] # path + 'DepMap/gene_effect_corrected_output.csv', 
output = {}

with open('/scratch/timrpeterson/OneDrive-v2/Data/MORPHEOME/interaction_correlations_basal/MTOR_RPTOR-2019q2-pearsons-python.csv') as csv_file:
	csv_reader = csv.reader(csv_file, delimiter=',')
	line_count = 0
	for row in csv_reader:
		#if line_count == 0:
		input_genes = [row[0]]
		input_genes_str = '_'.join(input_genes)

		time.sleep(1) 

		for x in input_genes:

			for y in datasets:

				delimiter = ','

				if "2019q2" in y:
					#age = '2018q4'
					#delimiter = '\t'
					remove_gene_id = True 
				else:
					#age = '2019q1'
					#delimiter = ','
					remove_gene_id = False 

				with open(y) as csv_file:
					csv_reader = csv.reader(csv_file, delimiter=delimiter)
					next(csv_reader)

					genes = {}
					for row in csv_reader:
						gene = row[0]
						row.pop(0)

						if remove_gene_id is True:
							arr = gene.split()

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

		output2 = []
		for key, value in output.items():

			if "pval" in value:

				if len(value["pval"]) > 1:
					p_adjust = stats.p_adjust(FloatVector(value["pval"]), method = 'BH')
					pval = scipy.stats.stats.combine_pvalues(p_adjust)
				else:
					pval = [0, value["pval"][0]]

				result = (sum(value["pearsons"])/len(value["pearsons"]), pval[1])

				output2.append(list((key,) + result)) 
			else:
				output2.append(list((key,) + (1,0))) 

		# adding citation counts to a volcano plot
		citation_counts = {}
		with open("/scratch/timrpeterson/Downloads/gene_gene_paper_count_greater_than_0.csv") as csv_file:
			csv_reader = csv.reader(csv_file, delimiter=",")

			for row in csv_reader:
				for x in input_genes:
					if row[0] in x:
						citation_counts[row[1]] = row[2]
					elif row[1] in x:
						citation_counts[row[0]] = row[2]

		temp = {}
		for row in output2:
			temp[row[0]] = [row[1], row[2]]

		output2_plus_citation_counts = []

		for key, value in temp.items():

			if key in citation_counts:
				output2_plus_citation_counts.append(list((key,) + (value[0], value[1], int(citation_counts[key])))) 
			else:
				output2_plus_citation_counts.append(list((key,) + (value[0], value[1], 0))) 
		#sort the output desc

		output3 = sorted(output2_plus_citation_counts, key=lambda x: x[1], reverse=True)
		#output3 = sorted(output2, key=lambda x: x[1], reverse=True)

		path = "/scratch/timrpeterson/MORPHEOME/"

		with open(path + 'interaction_correlations_basal/' + input_genes_str + '-' + dataset_type + '-pearsons-python.csv', 'w') as csvfile:
			spamwriter = csv.writer(csvfile, delimiter=',')

			for row in output3:
				#if row[2] < .00000001:
				#if any(field.strip() for field in row):
				spamwriter.writerow(row)

			csvfile.close()

