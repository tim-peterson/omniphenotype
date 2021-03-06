from collections import defaultdict
mesh_file = open('~/disease_headers.tsv', 'r')
mesh_dict = defaultdict(list)
line = mesh_file.readline()
while line:
    index = line.split("\t")
    if len(index) > 1:
        mesh_dict[index[0]] = set(index[1:])
    line = mesh_file.readline()
mesh_file.close()
mesh_dict_keys = sorted(mesh_dict.keys())
mesh_dict['Non-Cancer'] = set([])
for key in mesh_dict_keys:
    if (key != 'Neoplasms'):
        mesh_dict['Non-Cancer'] = mesh_dict['Non-Cancer'].union(mesh_dict[key])
mesh_dict_keys = ['Non-Cancer', 'Neoplasms']
mesh_dict['Non-Cancer'] = mesh_dict['Non-Cancer'] - mesh_dict['Neoplasms']
for i in range(1, 31):
    out = open('/home/nick/header_intersection_limited_homolog_filtered' + str(i*1000000) + '.tsv', 'w')
    out.write("Non-Cancer\tNeoplasms\n")
    gene_file = open('/home/nick/ncbi_gene_papers_limited_homolog_filtered.tsv', 'r')
    line = gene_file.readline()
    gene_terms = {}
    while line:
        index = line.split("\t")
        if len(index) > 1 and not index[0] in gene_terms:
            out.write(index[0])
            gene_set = set([j for j in index[1:] if int(j) <= i * 1000000])
            for key in mesh_dict_keys:
                out.write("\t" + str(len(mesh_dict[key].intersection(gene_set))))
            out.write("\n")
        gene_terms[index[0]] = 1
        line = gene_file.readline()
    out.close()
gene_file.close()