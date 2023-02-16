#!/bin/sh

# Generate a random ASCII string (Default: 40 printable characters without empty spaces) 
# Usage: ascii-rand-str-gen.sh [LENGTH] [TYPE]

readonly DEFAULT_RANDOM_STR_LENGTH=40

readonly CHARCLASS_LOWER='abcdefghijklmnopqrstuvwxyz'               # all lower case letters    :  abcdefghijklmnopqrstuvwxyz
readonly CHARCLASS_UPPER='ABCDEFGHIJKLMNOPQRSTUVWXYZ'               # all upper case letters    :  ABCDEFGHIJKLMNOPQRSTUVWXYZ
readonly CHARCLASS_DIGIT='0123456789'                               # all digits                :  0123456789
readonly CHARCLASS_ALPHA="${CHARCLASS_LOWER}${CHARCLASS_UPPER}"     # all letters               :  LOWER + UPPER
readonly CHARCLASS_ALNUM="${CHARCLASS_ALPHA}${CHARCLASS_DIGIT}"     # all letters + digit       :  LOWER + UPPER + DIGIT
readonly CHARCLASS_PUNCT='!"#$%&()*+,-./:;<=>?@[\\]^_{|}~'"'"       # all punctuation characters:  !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~
readonly CHARCLASS_PRINT="${CHARCLASS_ALNUM}${CHARCLASS_PUNCT} "    # all printable characters  :  ALNUM + PUNCT (including space)
readonly CHARCLASS_GRAPH="${CHARCLASS_ALNUM}${CHARCLASS_PUNCT}"     # all printable characters  :  ALNUM + PUNCT (not including space)

readonly RC_FAILED=1


ascii_random_str()
{
    local str_length="${1:-$DEFAULT_RANDOM_STR_LENGTH}"
    local str_type=${2:-GRAPH}

    printf %s "$str_length"| grep '^[1-9][0-9]*$' > /dev/null || {
        printf %s\\n "NOT a valid string length: $str_length"
        exit $RC_FAILED
    }

    [ $str_length -le 512 ] && readonly CHARACTERS_SET_SIZE=4096 \
                            || readonly CHARACTERS_SET_SIZE=$((str_length * 8))

    local type_chars=''
    case $str_type in 
        NUM|DIGIT) type_chars="$CHARCLASS_DIGIT";;

        LOWER)     type_chars="$CHARCLASS_LOWER";;

        UPPER)     type_chars="$CHARCLASS_UPPER";;

        PUNCT)     type_chars="$CHARCLASS_PUNCT";;

        ALPHA)     type_chars="$CHARCLASS_ALPHA";;

        ALNUM|ALPHANUM)
                   type_chars="$CHARCLASS_ALNUM";;

        PRINT|ALL) type_chars="$CHARCLASS_PRINT";;

        *|GRAPH)   type_chars="$CHARCLASS_GRAPH";;
    esac

    cat /dev/urandom | tr -cd "$type_chars" | head -c $CHARACTERS_SET_SIZE | tail -c $str_length
    printf \\n
}

ascii_random_str "$@"
