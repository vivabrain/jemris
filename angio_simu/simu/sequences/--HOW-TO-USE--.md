### Sequences indications ###

# Here are some sequences examples for angiography.
# The number of spins flow rapidly increases for long sequences duration. However, sequences with short TR and spoiling usually require a high density of spins to get realistic results. Thus, to reduce computation time, an expedient is to shorten artificially the T2 relaxation time of the spins to 1/4 of the TR (only for sequences based on T1 contrast or phase value).


### 2D sequences ###


*GRE_2D_tra: 
- The number of slices is Nz
- The slice thickness (mm) is the "Aux1" parameter in the "Slice" tag
(Interslice =  FOVz/Nz - SliceThickness)


*TOF_2D:
- The number of slices is Nz
- The slice thickness (mm) is the "Aux1" parameter in the "Slice" tag
(Interslice =  FOVz/Nz - SliceThickness)
- NO SPOILING ! Reduce the T2 to 1/4 of the TR


*PC_2D_tra_1dV*:
- The 1d velocity encoding (mm/s) is the "Aux1" parameter in the "Venc" tag
- NO SPOILING ! Reduce the T2 to 1/4 of the TR
- Image reconstruction with ReconPhaseContrast_2D_v1d.m


### 3D sequences ###


*GRE_3D_tra: 
- The number of 3D slices is Nz
- NO SPOILING ! Reduce the T2 to 1/4 of the TR
- Image reconstruction with ReconSimple_3D.xml


*PC_3D_tra_3dV:
- The 3d velocity encoding (mm/s) is the "Aux1" parameter in the "Venc" tag
- NO SPOILING ! Reduce the T2 to 1/4 of the TR
- Image reconstruction with ReconPhaseContrast_3D_v3d.m
