all:
	clear
	bison src/*.y -d
	flex src/*.l
	mv *.c src
	mv *.h src
	gcc src/*.c -lm -o calc
clear:
	rm calc -f
	rm src/mfcalc.t* -f
	rm src/lex* -f
