#! /bin/bash

function GET_QUERY_FIELD() {
  re_number="^[0-9]+$"
  re_symbol="^[A-Z][a-z]{0,2}$"

  if [[ $USER_INPUT =~ $re_number ]]
  then
    FIELD_TO_QUERY="atomic_number"
  elif [[ $USER_INPUT =~ $re_symbol ]]
  then
    FIELD_TO_QUERY="symbol"
  else
    FIELD_TO_QUERY="name"
  fi

}

PSQL='psql -U freecodecamp -d periodic_table --tuples-only --no-align --csv  -c'

USER_INPUT=$1

if [[ -z $1 ]]
then

  echo "Please provide an element as an argument."

else

  GET_QUERY_FIELD
  VALIDATE_QUERY_VALUE $FIELD_TO_QUERY $USER_INPUT

  if [[ $IS_VALID_VALUE != '1' ]]
  then
    echo "I could not find that element in the database."
  else

  QUERY_ALL_INFO $FIELD_TO_QUERY $USER_INPUT
  UNPACK_QUERY_RESULT $ALL_INFO

  OUTPUT_MESSAGE="The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."

  echo $OUTPUT_MESSAGE
  fi
fi
