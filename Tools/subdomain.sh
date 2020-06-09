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
        -f     File with domains you wish to fuzz.
        -h     Hostname / domain name
        --h     Help"
}

if [ "$#" == "0" ]; then
supplied,
  echo "No Arguements we're provided."
  echo usage
  exit 1
fi
while (( "$#" )); do
  case $1 in
    -f | --file ) SubFile=$2
                  shift
                  shift
                  ;;
    -h | --host ) Host=$1
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

for FileLine in $SubFile ; do
  while IFS= read -r Line ; do
    nslookup $Line | grep -n "Address:" | awk '{if(NR>1)print}' | sed 's/^.*Address: //'
    echo $Line
    curltext=$(curl --silent -I -X $'GET' \
                -H $'Host: '$Host'' -H $'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:77.0) Gecko/20100101 Firefox/77.0' \
                $'https://'$Line'/')
    echo -e "\e[95m$curltext\e[0m"
  done < "$FileLine"
done
