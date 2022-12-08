# interface-plddt

This script can be implemented to calculate the pLDDT scores of protein-protein interfaces found in dimeric AlphaFold models.

Requires Ccp4 PISA to determine interface residues.

Written as a bash script. Formatted to run in the parent directory that contains heterodimer_* directories in which the model pdbs are located. The format of the model name in the script may need to be adjusted for your needs. Additionally, if predicting interface pLDDTs for multiple models of a single heterodimer, you'll likely need to create a "rank" variable to include in the prediction names. This rank variable will also need to be echoed into the output files.

This script can be used to sort dimeric AlphaFold predictions based on interface pLDDT scores. The models with higher interface pLDDT scores will have higher confidence of physical significance.

Beware that it's possible for one subunit of the dimer may have a larger pLDDT than the other, in which case the average interface pLDDT score found here will be biased. To avoid this, it would be a good idea to look at each subunit's pLDDT scores for better confidence that the average interface pLDDT score found here is reliable.
