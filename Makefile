all:
	clang -c Day1.c -o Day1.C.o 
	llc Day1.ll
	clang Day1.s Day1.C.o
	./a.out