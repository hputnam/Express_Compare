### Samples

Plug_ID| Collection Date |Species|
---|---|---|
1041|	20180922	|Pocillopora acuta|
1471|	20180922	|Pocillopora acuta|
1637|	20180922	|Pocillopora acuta|
1101|	20180922	|Montipora capitata|
1548|	20180922	|Montipora capitata|
1628|	20180922	|Montipora capitata|

# RNA Extraction
[Ext 1](https://emmastrand.github.io/EmmaStrand_Notebook/Holobiont-Integration-August-DNA-RNA-Extractions/)

[Ext 2](https://emmastrand.github.io/EmmaStrand_Notebook/Holobiont-Integration-July-DNA-RNA-Extractions/)

[Ext 3](https://emmastrand.github.io/EmmaStrand_Notebook/Holobiont-Integration-September-DNA-RNA-Extractions/)

# Library Prep

## RiboFree

[Zymo-Seq RiboFree Total RNA Library Prep Kit](https://meschedl.github.io/MESPutnam_Open_Lab_Notebook/zribo-lib-RNA-second/) Sequenced by Zymo


## PolyA

Prepared using polyA enrichment with the [Illumina TruSeq Stranded mRNA Sample Preparation Protocol](https://github.com/hputnam/Express_Compare/blob/main/truseq_stranded_mrna_protocol.pdf) by Genewiz and sequenced by Genewiz

## Sequencing

Plug_ID| Ribofree_ID | Raw Reads RiboFree |Raw Reads PolyA|
---|---|---|---|
1041|	1 | 16487768	|18637582|
1471|	2 | 10755630	|7350473|
1637|	3 | 13534820	|7188549|
1101|	4 | 10275396	|21636831|
1548|	5 | 16601774	|17651137|
1628|	6 | 13440121	|21647915|

# cleaning/trimming  

##fastp  
Plug_ID| Ribofree_ID | Raw Reads RiboFree |Raw Reads PolyA|cleaned reads
---|---|---|---|---|
1041|	1 | 16487768	|18637582|x|
1471|	2 | 10755630	|7350473|x|
1637|	3 | 13534820	|7188549|x|
1101|	4 | 10275396	|21636831|x|
1548|	5 | 16601774	|17651137|x|
1628|	6 | 13440121	|21647915|x|


##trimmomatic  
Plug_ID| Ribofree_ID | Raw Reads RiboFree |Raw Reads PolyA|cleaned reads
---|---|---|---|---|
1041|	1 | 16487768	|18637582|x|
1471|	2 | 10755630	|7350473|x|
1637|	3 | 13534820	|7188549|x|
1101|	4 | 10275396	|21636831|x|
1548|	5 | 16601774	|17651137|x|
1628|	6 | 13440121	|21647915|x|



