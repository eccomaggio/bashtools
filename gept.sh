#!/bin/bash


help_func()
{
    cat << EOF
This script looks up words/patterns in the GEPT wordlist.
    gept word-to-look-up [-option]
       -l <elem/int/hi>    Level
       -p <adj/verb...>    Part of speech
       -s                  Starting with...
       -b                  (same as -s)
       -e                  Ending with...
       -x                  eXact search
       -h / --help         this Help info
EOF
}

list_pos()
{
    echo "currently nn, aj, av, vb, ar, nu, cj, pr, de... i think."
}
start=
endline=
context="all words like "

## find directory of script (assume the wordlist is in the same dir)
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ -z "$1" ]; then
    help_func
   exit 1
fi 

while [ "$1" != "" ]; do
    # echo "parameter 1 equals $1; you now have $# positional parameters"
    case $1 in
    -h | --help )       help_func
                        exit
                        ;;
    -l | --level )      shift
                        level="$1"
                        ;;
    -p | --pos )        shift
                        pos="$1"
                        ;;
    -b | -s )           start="^"
                        context="all words starting with "
                        ;;
    -e )                endline="$"
                        context="all words ending with "
                        ;;
    -x )                start="^"
                        endline="$"
                        context="the exact word "
                        ;;
    -* )                echo "the option $1 is not recognized"
                        ;;
    * )                 word=$1
                        echo "looking for: $word"
                        ;;
    esac
    shift
done

# msg="Find ${context}<$word> "
msg="\033[34mFind ${context}<\033[37m$word\033[34m> \033[0m"
## add in option flags and include optional underscore
## (which distinguishes homonyms in the word list)

awk_1="${start}${word}_?${endline}"
awk_2=".*"
awk_3=".*"
if [[ -n "$pos" ]]; then
    msg+="as a <$pos> "
    awk_2="$pos"
fi
if [[ -n "$level" ]]; then
    msg+="at <$level> level"
    awk_3="$level"
fi
echo
echo -e "$msg"
# echo ">>>>>$word [$start,$endline]"
awk -v word=$awk_1 -v pos=$awk_2 -v level=$awk_3 -F '\t' \
    'BEGIN{count=0} tolower($1) ~ word && $2 ~ pos && $3 ~ level \
     {print "\t" $1,"\033[32m[" $2 "]\033[36m", $3, "\033[33m" $4 "\033[0m"; count++} \
     END{ print "\033[34m" count " match(es)\033[0m"}' \
     ${DIR}/words_gept_l.tsv | sed 's/_//'
