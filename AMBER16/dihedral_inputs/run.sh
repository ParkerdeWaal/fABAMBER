export CUDA_VISIBLE_DEVICES=6
../amber16/bin/pmemd.cuda -O -i fAB.in -o fAB.out -p prmtop -c npt.rst -r fAB.rst -x fAB.mdcrd -inf fAB.info -AllowSmallBox & 
