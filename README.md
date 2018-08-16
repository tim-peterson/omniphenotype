# omniphenotype
For the `Cell growth is an omniphenotype` paper.

Code for to generate data for each figure written in PHP or MySQL. The underlying data can be accessed as described in the methods.

### Figure 1

- figure1.sql has multiple MySQL commands that are needed to generate the data shown in Figure 1.

### Figure 2

- preceeding this analysis, we dumped all of PubMed into a database table, which we then queried for the co-occurrence of `{gene} AND {condition}`. 

### Figure 3

- Guzzle, which is a PHP library to make HTTP requests, is required to run Figure 3 code. 