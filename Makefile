all:
	clang -c Day2.c -o Day2.C.o 
	llc Day2.ll
	clang Day2.s Day2.C.o
	./a.out