#!/bin/bash

rm heterodimer_*/interface_*.txt


##change directory and model
for data in `(ls -d heterodimer_*/)` ; do
	datatmp=${data#heterodimer_}
	dataname=${datatmp%/}

##get list of chain A and B residues that form interface (BSA)
	pisa name -analyse heterodimer_*/*unrelaxed_model_1.pdb
	interfaceA=$(pisa name -detail interface 1 | fgrep "|I| A:" | awk '{print $4}')
	interfaceB=$(pisa name -detail interface 1 | fgrep "|I| B:" | awk '{print $4}')
	
##find interface residues for chains A and B
	for residue in $interfaceA ; do
		echo $residue >> heterodimer_$dataname/interfaceA_$dataname.txt
	done
	
	for residue in $interfaceB ; do
		echo $residue >> heterodimer_$dataname/interfaceB_$dataname.txt
	done
	
	sed -i 's/^[ \t]*//' heterodimer_$dataname/interfaceA_$dataname.txt
	sed -i 's/^[ \t]*//' heterodimer_$dataname/interfaceB_$dataname.txt

##add chain A or B designation to column 1
	for line in heterodimer_$dataname/interfaceA_$dataname.txt ; do
		sed -i "s/^/A /" $line
	done

	for line in heterodimer_$dataname/interfaceB_$dataname.txt ; do
		sed -i "s/^/B /" $line
	done

	cat heterodimer_$dataname/interfaceA_$dataname.txt heterodimer_$dataname/interfaceB_$dataname.txt > heterodimer_$dataname/interfaceTemp.txt

##remove white space then remove duplicate lines
	awk '{$1=$1};1' heterodimer_$dataname/interfaceTemp.txt
	awk '!seen[$0]++' heterodimer_$dataname/interfaceTemp.txt > heterodimer_$dataname/interface_$dataname.txt


	
##change model
	awk 'BEGIN { FS = " "}' heterodimer_$dataname/*unrelaxed_model_1.pdb
	pLDDT_dup=$(awk '{print $5, $6, $11}' heterodimer_$dataname/*unrelaxed_model_1.pdb)

##remove white space then remove duplicate lines
	echo "$pLDDT_dup" > heterodimer_$dataname/pLDDT.tmp
	awk 'BEGIN { FS = " "}' heterodimer_$dataname/pLDDT.tmp
	awk '{$1=$1};1' heterodimer_$dataname/pLDDT.tmp
	awk '!seen[$0]++' heterodimer_$dataname/pLDDT.tmp > heterodimer_$dataname/pLDDT_$dataname.txt

##set data in interface files to variable in order to compare
	interface_residue=$(awk '{print $1, $2}' heterodimer_$dataname/interface_$dataname.txt)
	
##format pLDDT-interface file
	grep "$interface_residue" heterodimer_$dataname/pLDDT_$dataname.txt > heterodimer_$dataname/pLDDTinterface.tmp
	awk 'BEGIN { FS = " "}' heterodimer_$dataname/pLDDTinterface.tmp
	awk '{$1=$1};1' heterodimer_$dataname/pLDDTinterface.tmp
	awk '!seen[$0]++' heterodimer_$dataname/pLDDTinterface.tmp > heterodimer_$dataname/pLDDTinterface_$dataname.txt


##calculate average pLDDT for interface residues
awk '{print $3}' heterodimer_$dataname/pLDDTinterface_$dataname.txt > heterodimer_$dataname/pLDDTint_only.txt
awk '{Total=Total+$1} END { if (NR > 0) print Total / NR}' heterodimer_$dataname/pLDDTint_only.txt > heterodimer_$dataname/pLDDTintAvg_$dataname.txt

##output all averages to same file
average=$(cat heterodimer_$dataname/pLDDTintAvg_$dataname.txt)
echo $dataname $average >> all_interface_pLDDT.txt


done



##remove temporary files
rm heterodimer_*/interfaceA_*.txt
rm heterodimer_*/interfaceB_*.txt
rm heterodimer_*/interfaceTemp.txt
rm heterodimer_*/pLDDT.tmp
rm heterodimer_*/pLDDTinterface.tmp
rm heterodimer_*/pLDDTint_only.txt
