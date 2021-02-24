# omniphenotype
Code for the `Cell fitness is an omniphenotype` paper.

Code to generate data for each figure was written in python, R, PHP, or MySQL. The underlying data can be accessed as described in the methods.

### Figure 2

- figure2A.sql has multiple MySQL commands that are needed to generate the data shown in Figure 2A.

- Any gene cluster can be input into the figure2B.py script to yield the data that can be converted into the volcano plot as shown in Figure 2B.

- Figure 2B statistics (enrichment analysis) was performed using SciPy. The code is available via [here](https://colab.research.google.com/drive/17Ib8tomocbfb6Hz8owC-HQwja3uYOciu?usp=sharing) 
### Figure 3

- preceeding this analysis, we dumped all of PubMed into a database table, which we then queried for the co-occurrence of `{gene} AND {condition}`. 

### Figure 4

- [Guzzle](http://docs.guzzlephp.org/en/stable/), which is a PHP library to make HTTP requests, is required to run Figure 4 code. 


