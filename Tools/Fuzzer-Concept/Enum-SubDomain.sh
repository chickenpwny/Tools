#!/bin/bash
Usage()
{
  echo "
       ▒▒▒▒░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓
       ▒▒▒░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓
       ▒▒░▐▌░▒░░░░░░▒▒▒▒▒▒▒▒▒
       ▒▒░▐▌░▒░░░░░░▒▒▒▒▒▒▒▒▒
       ▒▒▒▒░░░░░░░░░░░░▓▓▓▒▒▒
       ▒▒▒▒▒▒░░▀▀███░░░░▓▒▒▒▓
       ▒▒▒▒▒▒░░▀▀███░░░░▓▒▒▒▓
       ▒▒▒▒▒▒░▌▄████▌░░░▓▒▒▒▓
       ▒▒▒▒▒░░███▄█▌░░░▓▓▒▓▓▓
       ▒▒▒▒▒▒▒▒░░░░░░░░░▓▓▓▓▓
       ▒▒▒▒▒▒▒▒░░░░░░░░░▓▓▓▓▓
       ▒▒▒▒▒▒░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓

     HELP: Compile a list of domains to fuzz. it will enter the domains
     into gobuster and fuzz for sub-domain provided.
     --f | --file The list of domains you would like to fuzz.
     --w | --wildcard Incase you need the wildcard extention."
}
WildCard()
{
 if [[ -z "$WildCard" ]]; then
  echo ""
 else
  echo '--wildcard'
 fi
}
while (( "$#" )); do
  case $1 in
    --f | --file ) File=$2
    		shift
		shift
		;;
    --w | --wildcard ) WildCard=$1
	    	shift
		shift
		;;
    --h | --help ) Usage
		exit
		;;
		*)
    POSITIONAL+=("$1")
		shift
		;;
  esac
done

echo "Lets Fuzz these subdomains!!"
echo $(WildCard)

for FileLine in $File ; do
  while IFS= read -r Line ; do
    gobuster dns -w /root/Desktop/tools/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -d $Line -o gobuster/$Line -t 60 $(WildCard)
  done < $FileLine
done < $File 
