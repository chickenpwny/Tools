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

       HALP:  
       --u The target domain you wish to test
       --auto Pull in from a file where full urls are stored
       --tls When no value is supplied defaults http.
       --t The crossite domain you wish to see if if you
	 can establish a relationship with.
       --verb The http verb (GET,POST,PUT,DELETE,PATCH)
       --av Access-Control-Allow-Method provide http verb.
       --ah Access-Control-Allow-Header"
}
AccessVerb()
{
  if [[ "$AccessVerb" =~ ^(GET|POST|PUT|DELETE|PATCH|OPTIONS)$ ]]; then
    echo "-H Access-Control-Request-Method: $AccessVerb"
  else
    printf ''
  fi
}
AccessHeader()
{
  if [[ -z "$AccessHeader" ]]; then
    echo ''
  else
    echo \
      "-H Access-Control-Request-Headers: $AccessHeader"
  fi
}
AutoBasher()
{
  if [[ -z "$AutoBasher" ]]; then
    echo ''
  else  
      while IFS= read -r Line; do
	echo ${Line}
      done < "$AutoBasher" 
  fi
}
if [ "$#" == "0" ]; then
  echo "Please, provide arguements"
  echo usage
  exit 1
fi
while (( "$#" )); do
  case $1 in
    --auto | autobasher ) AutoBasher=$2
		 shift
		 shift
		 ;;
    --u | --url ) URL=$2
	         shift
		 shift
		 ;;
    --t | --test ) TestDomain=$2
	         shift
		 shift
		 ;;
    --vi | --verb ) Verb=$2
	         shift
		 shift
		 ;;
    --av | --averb ) AccessVerb=$2
	         shift
		 shift
		 ;;
    --ah | --aheader ) AccessHeader=$2
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
echo $AutoBasher
printf %s $FileLine
printf %s ${Line}
echo ${meow}
curl -i -I -s -o -w "\n%{Access-Control-Allow-Credentials: true}" -k -X $Verb \
   -H "Origin: $TestDomain" \
   $(AccessVerb) \
   $(AccessHeader) \
   $URL $(AutoBasher) | grep Access-Control 
