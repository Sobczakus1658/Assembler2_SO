nasm -DN=2 -f elf64 -w+all -w+error -o core.o core.asm
gcc -g -c -Wall -Wextra -std=c17 -O2 -o example.o example.c
gcc -g -z  noexecstack -o example core.o example.o -lpthread