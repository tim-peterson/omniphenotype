# omniphenotype
Code for the `Cell growth is an omniphenotype` paper.

Code to generate data for each figure was written in PHP or MySQL. The underlying data can be accessed as described in the methods.

### Figure 2

- figure2.sql has multiple MySQL commands that are needed to generate the data shown in Figure 2.

### Figure 3

- preceeding this analysis, we dumped all of PubMed into a database table, which we then queried for the co-occurrence of `{gene} AND {condition}`. 

### Figure 4

- [Guzzle](http://docs.guzzlephp.org/en/stable/), which is a PHP library to make HTTP requests, is required to run Figure 4 code. 


