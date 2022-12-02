#include <stdio.h>
#include <stdlib.h>

// Feels like cheating :P
char* read_file(char* path) {
    FILE *file_pointer;
    long file_size;
    char *buffer;
    file_pointer = fopen ( path, "rb" );
    fseek(file_pointer, 0L, 2);
    file_size = ftell(file_pointer);
    rewind(file_pointer);
    buffer = malloc(file_size+1);
    fread(buffer, file_size,1, file_pointer);
    fclose(file_pointer);
    return buffer;
}

void print_int(long x) {
    printf("%ld\n", x);
}