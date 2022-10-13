echo off 
echo y | plink.exe -ssh -pw %3 %2@%1 "exit"