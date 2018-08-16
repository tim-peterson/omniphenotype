<?php
$servername = "localhost";
$username = "root";
$password = "";
$db = "morpheome";

try {
    $conn = new PDO("mysql:host=$servername;dbname=".$db, $username, $password,
    [PDO::MYSQL_ATTR_LOCAL_INFILE => true]);
    // set the PDO error mode to exception
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );

    }
catch(PDOException $e)
    {
    echo "Connection failed: " . $e->getMessage();
    }

$table = 'gene_disease';
$field = 'disease_type';

$diseases = ['cancer','infection','alzheimer','cardiovascular','diabetes','obesity','depression','inflammation','osteoporosis','hypertension','stroke'];

ini_set('memory_limit','1G');


$insert_db_table = 'gene_disease_copy';
 $query = 'SELECT aliases.* FROM aliases left join '.$insert_db_table.' on aliases.gene_id='.$insert_db_table.'.gene_id where type = "NCBI_official_symbol" and '.$insert_db_table.'.gene_id is null';

   
   $sth = $conn->prepare($query);
    $sth->execute();
    /* Fetch all of the values in form of a numeric array */
    $result = $sth->fetchAll();

$ids = [];
foreach($diseases as $disease){ 

    foreach($result as $row){

        $ids[] = $row['name'];

        // searches PubMed for co-occurrence of gene name and disease name;
        $query2 = 'SELECT count(*) as publication_count FROM publications WHERE match(abstract) against("+'.str_replace(["-", "@"], ["", ""],$row['name']).' +'.$disease.'" IN BOOLEAN MODE);';

        $sth2 = $conn->prepare($query2);
        $sth2->execute();
        
        /* Fetch all of the values in form of a numeric array */
        $result2 = $sth2->fetchAll();

        $query3 = 'INSERT into '.$insert_db_table.' (gene_id,alias_id,disease_type,publication_count) values ("'.$row['gene_id'].'",'.$row['id'].', "'.$disease.'", "'.$result2[0]['publication_count'].'")';
      

        $sth3 = $conn->prepare($query3);
        $sth3->execute();

    }
}


$conn = null;

 ?>

	