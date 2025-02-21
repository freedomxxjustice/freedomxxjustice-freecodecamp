#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

GET_INFO() {
  if [[ $1 ]]
  then
    if [[ $1 =~ ^[A-Z]$|^[A-Z][a-z]$ ]]
    then
      SELECT_BY_FIRST_LETTER=$($PSQL "SELECT atomic_number, symbol, name, type_id, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1'")
      RESULT=$SELECT_BY_FIRST_LETTER
    elif [[ $1 =~ ^[0-9]+$ ]]
    then
      SELECT_BY_ID=$($PSQL "SELECT atomic_number, symbol, name, type_id, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
      RESULT=$SELECT_BY_ID
    else
      SELECT_BY_NAME=$($PSQL "SELECT atomic_number, symbol, name, type_id, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1'")
      RESULT=$SELECT_BY_NAME
    fi
    if [[ -z $RESULT ]]
    then
      echo "I could not find that element in the database."
      return
    fi
    #RESULT=$($PSQL "SELECT atomic_number, type_id FROM properties WHERE atomic_number = $1")
    echo $RESULT | while read NUMBER BAR SYMBOL BAR NAME BAR TYPE_ID BAR MASS BAR MELT BAR BOIL BAR TYPE
    do
      echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
    #echo $RESULT | while read ATOM BAR TYPE
    #do
    #  echo "$TYPE, $ATOM"
    #done
  else
    echo "Please provide an element as an argument."
  fi

} 

GET_INFO $1