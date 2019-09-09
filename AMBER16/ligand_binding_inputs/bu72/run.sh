export CUDA_VISIBLE_DEVICES=1
../amber16/bin/pmemd.cuda -O -i prod.in -o abp1.out -p prmtop -c npt.rst -r abp1.rst -x abp1.nc &
