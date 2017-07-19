## Angiography simulations with Jemris

-In the *.xml simu file, provide the path of the flow file containing the Lagrangian spins trajectories, e.g. "<sample name="Flow" FlowTrajectories="Flow.dat" uri="./sample.h5"/>".

-The flow file can be ASCII or HDF5 with the following format (quadruple the indicators for HDF5):

	t0 spin0_x spin0_y spin0_z
	-111				<- SPIN ACTIVATION
	t1 spin0_x spin0_y spin0_z
	t2 spin0_x spin0_y spin0_z
	…
	tN spin0_x spin0_y spin0_z
	-222				<- SPIN DEACTIVATION
	-999999				<- SPIN CHANGE INDICATOR

	t0 spin1_x spin1_y spin1_z
	-111
	t1 spin1_x spin1_y spin1_z
	…

The structure for HDF5 is:
	Group '/flow' 
        Dataset 'trajectories' 
            Size:  4xNtraj
            MaxSize:  4xNtraj
            Datatype:   H5T_IEEE_F64LE (double)
            ChunkSize:  []
            Filters:  none
            FillValue:  0.000000



-Loop trajectories option: the same flow trajectories can be reused periodically to cover the whole sequence duration, e.g. for steady flow or periodic flow (cardiac cycle).
In the *.xml simu files, set e.g. "<sample name="cardiac" FlowTrajectories="Flow.dat" FlowLoopDuration="850" FlowLoopNumber="499" uri="./sample.h5"/>".
'FlowLoopDuration' is the duration of the flow cycle (ms). 'The FlowLoopNumber' N last trajectories will then be reused periodically with a time shift equal to FlowLoopDuration.

-Start the simulation with "jemris <SimuFile>.xml" (use pjemris for parallel)



## Image reconstruction from HDF5 output signal

-For basic sequences, images can be visualized with the JEMRIS_sim Matlab interface.
-For PC sequences and 3D sequences, use the specific Recon_*.m Matlab scripts for image reconstruction.