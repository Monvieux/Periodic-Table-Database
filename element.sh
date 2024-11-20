#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ -z $1 ]]
then
  # if no parameter
  echo "Please provide an element as an argument."
else
  # if parameter is number
    if [[  $1 =~ ^[0-9]+$ ]]
    then
      # if parameter is a number
      ATOMIC_NUMBER=$1
    else
        # if parameter is a character
        if [[ $1 =~ ^[a-zA-Z]+$ ]]
        then
            # test if symbol or name
            if [[ ${#1} > 2 ]]
            then
              ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
            else
              ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
            fi
        fi
    fi
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    DATA=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e, properties AS p, types AS t WHERE e.atomic_number=p.atomic_number AND  p.type_id=t.type_id AND e.atomic_number=$ATOMIC_NUMBER")
    echo "$DATA" | while read ATOMIC BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING BAR BOILLING
    do
      echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILLING celsius." 
    done
  fi
fi
