#!/bin/bash

usage()
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
	into gobuster and fuzz the domain provided.
       	--f	File with domains you wish to fuzz.
	--d	Dictionary
	--o	Output
	--h	Help"
}

CleanUp()
{
  for Files in $OutFolder ; do
    cat $Files | grep "Size: 0" | sed 's/^.*/''/'
  done > $Files
}

if [ "$#" == "0" ]; then
supplied,
  echo "No Arguements we're provided."
  echo usage
  exit 1
fi
while (( "$#" )); do
  case $1 in
    --f | --file ) SubFile=$2
	    	  shift
		  shift
                  ;;
    --d | --dictionary )
                  Dictionary=$2
                  shift
		  shift
		  ;;
    --o | --output )
                  OutFolder=$2
                  shift
		  shift
		  ;;
    --h | --help ) usage
                  exit
                  ;;
   		  *)
    POSITIONAL+=("$1")
		  shift
		  ;;
  esac
done

echo $OutFolder
echo "Fuzzing behings!!! "
for FileLine in $SubFile ; do
  while IFS= read -r Line ; do
    #echo "$Line" >> grandlist.txt
    gobuster dir -w $Dictionary \
	   -u https://$Line --wildcard -s "200,204,301,302,307,401,403" -l -k -t 60 \
	   -o $OutFolder/$Line -v | tee /dev/stderr | grep Found | sed 's/^.*Found: /''/'
  done < "$FileLine"
done < $SubFile
