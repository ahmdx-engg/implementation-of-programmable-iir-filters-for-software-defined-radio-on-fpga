@echo off
iverilog -o output_file *.v
vvp output_file
