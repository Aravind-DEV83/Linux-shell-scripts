# !bin/bash

echo "Hello World"

<<comment
This
is a multi line comment
comment

#Array Operations

myArray=(3 2 Hello "Hey Man" true)

echo ${myArray[2]}
echo ${myArray[3]}
echo "The length of the array is ${#myArray[*]}"
echo "Slicing ${myArray[*]:2}"
echo "Slicing ${myArray[*]::4}"

myArray+=(New 30 50)

echo "Values of new array are ${myArray[*]}"

declare Array2=( [name]=Aravind [age]=23 )
echo "Name is ${Array2[name]}"


#String Operations

myVar="Hello World!"
length=${#myVar}
replace=${myVar/World/Buddy}
echo "Replaced string is ${replace}"
echo "Slicing a string ${replace:2:9}"


#Aithimetic Operations

x=2
y=10

let result=x*y
let sum=$x+$y
echo "The result is ${result}"
echo "The sum is ${sum}"

#Conditional Statements

read -p "Enter your marks": marks

if [[ $marks -ge 80 ]]
then 
    echo "Grade - A"
elif [[ $marks -ge 60 ]]
then
    echo "Grade - B"
else
    echo "You're failed"
fi

echo "Hey choose an option"
echo "a = To see the current date"
echo "b = list of all files in the current directory"

read choice

case $choice in 
a) date;;
b) ls;;
c) pwd;;
*) echo "Not a valid input"
esac

#Logical Operators

read -p "What is your age?" age
read -p "Your Country?" country
if [[ $age -ge 18 ]] && [[ $country == "India" ]] 
then 
    echo "You can vote"
else
    echo "You can't vote"
fi
