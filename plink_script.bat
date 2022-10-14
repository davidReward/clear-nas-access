echo off 
cd %1
echo y | plink_ct.exe -ssh -pw %4 %3@%2 "exit"
echo Done register host
pause
