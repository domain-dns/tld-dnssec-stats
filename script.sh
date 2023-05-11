#!/bin/bash
#dnssec_algo=(1,"RSA/MD5" 2,"Diffie-Hellman" 3,"DSA/SHA1" 5,"RSA/SHA-1" 6,"DSA-NSEC3-SHA1" 7,"RSASHA1-NSEC3-SHA1" 8,"RSA/SHA-256" 10,"RSA/SHA-512" 13,"ECDSA Curve P-256 with SHA-256" 14,"ECDSA Curve P-384 with SHA-384" 15,"Ed25519" 16,"Ed448");

dnssec_algo[1]="RSA/MD5";
dnssec_algo[2]="Diffie-Hellman";
dnssec_algo[3]="DSA/SHA1";
dnssec_algo[5]="RSA/SHA-1";
dnssec_algo[6]="DSA-NSEC3-SHA1";
dnssec_algo[7]="RSASHA1-NSEC3-SHA1";
dnssec_algo[8]="RSA/SHA-256";
dnssec_algo[10]="RSA/SHA-512";
dnssec_algo[13]="ECDSA Curve P-256 with SHA-256";
dnssec_algo[14]="ECDSA Curve P-384 with SHA-384";
dnssec_algo[15]="Ed25519";
dnssec_algo[16]="Ed448";

date=$(date '+%Y-%m-%d')
FILE="root-zone".$date
if [ ! -f $FILE ]; then
dig axfr . @lax.xfr.dns.icann.org > "root-zone".$date
fi
cat $FILE | grep DS | grep -v "RRSIG" | awk -F " " '{print $6}' | sort | uniq -c | sort -nk2 | awk '{print $2" "$1}' > temp.12
while read -r line
do
	algo=` echo $line | awk '{print $1}'`
	occurence=` echo $line | awk '{print $2}'`
	algo_name=${dnssec_algo[$algo]}
	echo $algo " " $algo_name " " $occurence
done < temp.12
rm temp.12 2> /dev/null
