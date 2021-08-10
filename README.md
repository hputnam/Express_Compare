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


Plug_ID| Ribofree_ID |NCBI PolyA| NCBI RiboFree | Raw Reads RiboFree |Raw Reads PolyA|Ribofree trimmomatic|Riobfree fastp |PolyA trimmomatic|PolyA fastp
---|---|---|---|---|---|---|---|---|---|
1041|Sample1|SRR15089756  |SRR15089763 |16487768 |18637582|15373749|x|11415345|x|
1471|Sample2|	SRR15089755  |SRR15089762 |10755630|7350473|10040582|x|8494238|x|
1637|Sample3|	SRR15089764  |SRR15089761 |13534820 |7188549|12530595|x|9124785|x|
1101|Sample4|	SRR15089757  |SRR15089760 |10275396 |21636831|9444420|x|14279432|x|
1548|Sample5|	SRR15089754  |SRR15089759 |16601774 |17651137|15532372|x|11642352|x|
1628|Sample6|	SRR15089765  |SRR15089758 |13440121 |21647915|12585896|x|13860676|x|



