<?php

    $client = new \GuzzleHttp\Client;

    $search_term = 'human lymphoblastoid cell lines proliferation';


    $response =  $client->request('GET', 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi', [
        'query' => [
            'db' => 'pubmed',
            'term' => $search_term,
            'retmode' => 'json',
        ]
    ]);

    $response = json_decode($response->getBody(), true);

    $count = $response['esearchresult']['count'];

    $retmax = 200;

    $num_loops = ceil($count/$retmax);

    $retstart = 0;
  

    $cnt = 0;
    for($i = 0; $i < $num_loops; $i++){

       $response =  $client->request('GET', 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi', [
            'query' => [
                'db' => 'pubmed',
                'term' => $search_term,
                'retmode' => 'json',
                'retmax' => $retmax,
                'retstart' => $retmax*$i

            ]
        ]);

        $response = json_decode($response->getBody(), true);

        $idlist_arr = $response['esearchresult']['idlist'];
        
        $idlist = implode(',', $idlist_arr);

        $response =  $client->request('GET', 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi', [
            'query' => [
                'db' => 'pubmed',
                'id' => $idlist,
                'rettype'=> 'abstract',
                'retmode' => 'XML',
            ]
        ]);

        $xml = simplexml_load_string($response->getBody());
        $json = json_encode($xml);
        $array = json_decode($json,TRUE);

        if(isset($array['PubmedArticle'])) $articles = $array['PubmedArticle'];
        else $articles = [$array['MedlineCitation']];

        $output_dir = base_path()."/bio_data/morpheome";

        $cnt0 = 0;

        foreach($articles as $article){

            $abstract_txt = "";

            $pmid = $article['MedlineCitation']['PMID'];

            if(isset($article['MedlineCitation']['Article']['Abstract'])){
               $abstract = $article['MedlineCitation']['Article']['Abstract']['AbstractText']; 
            }
            else{
                $abstract = '';
            }


            if(is_array($abstract)){

                array_walk_recursive($abstract, function ($item, $key) use(&$abstract_txt){

                    $abstract_txt = $abstract_txt . $item;
                });
                
            }
            else{              
                $abstract_txt = $abstract;
            }

            if ( ($handle1 = fopen($output_dir."/all_patient_abstracts.csv", "a") ) !== FALSE) {

                    fputcsv($handle1, [$pmid, $abstract_txt]);

            }
            fclose($handle1);

        }

?>

	