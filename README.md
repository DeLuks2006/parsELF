<h1 align=center>parsELF</h1>
<p align=center>An ELF parser written fully in NASM.</p>

> [!CAUTION]
> im still learning, i got no idea what im doing, this is a WORK IN PROGRESS
>

## TODO:

- [X] ITOA but convert to hexadecimal
- [X] Actually open a file and read it for once
- [ ] Parse ELF header
- [ ] ...

## Function List 

- ITOA      - converts num to ASCII (decimal, hex)
- PRINT     - prints some text
- PRINTN    - prints some text and a newline
- PRINTC    - calls print and then printn

## About:

This *bombastic ELF parser* is just a little project to get comfortable with assembly and ELF files. 
Also this kind of project was suggested for me to do by vrzh and other members of tmpout!

## Credit:

Big thanks to polprog for helping out with the project and vrzh for getting me to do this!

## Issues
- PRINTH stuck in infinite loop and ITOA fails, needs proper error handling and stuff
