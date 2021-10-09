#!/bin/bash
    

echo "there are $# positional arguments"

while [ "$1" != "" ]; do
    # echo "parameter 1 equals $1; you now have $# positional parameters"
    case $1 in 
        -h | --help )       echo "here's some help..."
                            exit
                            ;;
        -l | --level )      shift
                            echo "level = $1"
                            ;; 
        -p | --pos )        shift
                            echo "part of speech = $1"
                            ;;
        -b | -s )           shift
                            echo "starting with..."
                            ;;
        -e )                shift
                            echo "ending with..."
                            ;;
        -x )                echo "eXact search for this word"
                            ;;
        -* )                echo "this option is not recognized"
                            ;;
        * )                 word=$1
                            echo "looking for: $word"
                            ;;

    esac
    shift
done

