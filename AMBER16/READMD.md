# fABAMBER16
fast adaptive biasing for AMBER16 (fABAMBER) built into the pmemd.cuda engine using a mollified adaptive biasing potential (mABP). For a detailed explanation of parameters and output files please refer to the [fABMACS github page](https://github.com/BradleyDickson/fABMACS)

## Installation and quick start
Unpack and update Amber16 and AmberTools17 to the latest version. **fABAMBER16 requires Amber version 16.15**.

An example installation for a dihedral CV:
```bash
untar -xvjf AmberTools17.tar.bz
untar -xvjf Amber16.tar.bz
cd amber16
export AMBERHOME=$pwd
./update_amber --update
patch -p0 -i dihedral.diff # found in the fABAMBER16 repo
./configure -cuda gnu
make -j8
```

## Dihedral CV
This modification is hardcoded the alanine dipeptide. To patch,	copy `dihedral.diff` into your `$AMBERHOME` direction and run `patch -p0 -i dihedral.diff`. Inputs for alanine dipeptide can be found in [dihedral_inputs](./dihedral_inputs) folder.

## RMSD CV
Patches AMBER for ligand binding simulations described in this manuscript. The default atoms provided here are for the mu opioid receptor and fentanyl. Install as above, but patch with `patch -p0 -i fentanyl.diff`. Inputs for these systems can be found in [ligand_binding_inputs](./ligand_binding_inputs).

To run, `fABAMBER_home/bin/pmemd.cuda -O -i prod.in -o oABP1.out -p prmtop -c npt.rst -r oABP1.rst -x oABP1.mdcrd -inf oABP1.info`.

**To switch between receptors and ligands you may need to modify which atoms are being tracked in $AMEBRHOME/src/pmemd/src/cuda/kForcesUpdate.cu. These sections are highlighed below.** 

```cpp
$AMEBRHOME/src/pmemd/src/cuda/kForcesUpdate.cu

// Fentanyl
kCollectCvCrd_kernel()
{
...
    unsigned int myatoms [] = {4673, 4671, 4669, 4667, 4678, 4657, 4661}; // Fentanyl
...
    unsigned int COM1 [] = {795,805,817,827,846,856,870,881,895,916,928,1233,1252,1268,1287,1298,1317,1329,1350,1371,1385,1402,1422,1436,1447,1466,4066,4077,4096,4106,4125,4132,4153,4167,4181,4192}; // mOR CV1 reference
    unsigned int COM2 [] = {1233,1252,1268,1287,1298,1317,1329,1350,1371,1385,1402,1422,1436,1447,1466,2761,2777,2797,2816,2836,2846,2866,2885,2904,2916,2932,3522,3542,3561,3577,3588,3612,3628,3640,3659}; // mOR CV2 reference
...
}
...
kAddCvFrc_kernel()
{
    unsigned int myatoms [] = {4673, 4671, 4669, 4667, 4678, 4657, 4661}; // Fentanyl
}
```

```cpp
//other receptor/ligand atom indexes
unsigned int myatoms [] = {4673, 4671, 4669, 4667, 4678, 4657, 4661}; // Fentanyl
unsigned int myatoms [] = {4666, 4672, 4682, 4683, 4661, 4670, 4681}; // carfentanil
unsigned int myatoms [] = {4666, 4672, 4682, 4683, 4661, 4670, 4681}; // lofentail
unsigned int myatoms [] = {4658, 4687, 4673, 4683, 4675, 4659}; // bu72
unsigned int myatoms [] = {4911, 4908, 4906, 4894, 4896, 4901, 4903}; // carazol
...
// mOR
unsigned int COM1 [] = {795,805,817,827,846,856,870,881,895,916,928,1233,1252,1268,1287,1298,1317,1329,1350,1371,1385,1402,1422,1436,1447,1466,4066,4077,4096,4106,4125,4132,4153,4167,4181,4192}; // mOR CV1 reference
unsigned int COM2 [] = {1233,1252,1268,1287,1298,1317,1329,1350,1371,1385,1402,1422,1436,1447,1466,2761,2777,2797,2816,2836,2846,2866,2885,2904,2916,2932,3522,3542,3561,3577,3588,3612,3628,3640,3659}; // mOR CV2 reference
// b2ar
// attention! kCollectCvCrd_kernel needs to be modified to calcualte averages from 15 and 17 atoms. 
unsigned int COM1 [] = {1264,1284,1308,1322,1333,1352,1364,1380,4097,4116,4130,4154,4173,4180,4201}; // b2ar CV1 reference
unsigned int COM2 [] = {2777,2787,2798,2809,2828,2844,2855,2875,2896,3617,3636,3647,3671,3692,3704,3724,3744}; // b2ar CV2 reference

```
