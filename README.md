<h1 align=center>parsELF</h1>
<p align=center>A simple ELF parser written fully in NASM.</p>

It parses a little endian ELF64. (will change soon)

## Function List 

- ITOA       - converts num to ASCII (decimal, hex)
- PRINT      - prints some text
- PRINTLN    - prints some text and a newline
- PRINTC     - calls print and then println

## About:

This *bombastic ELF parser* is just a little project to get comfortable with assembly and ELF files. 
Also this kind of project was suggested for me to do by vrzh and other members of tmpout!

## Credit:

Big thanks to polprog for helping out with the project and vrzh for getting me to do this!

## Issues
- PRINTH stuck in infinite loop and ITOA fails, needs proper error handling and stuff
