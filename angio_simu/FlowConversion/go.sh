#Temp path to store data
PTpath=/home/afortin/particles/FlowConversion

#Compile the project
echo  "——————————————————————"
echo "Compile the project"
echo  "——————————————————————"
make
make clean


#Execute the project using ConfigFile.in
echo  "——————————————————————"
echo "Execute the project"
echo  "——————————————————————"
./CreateParticleTracer ConfigFile.in


#Open paraview
echo "——————————————————————"
echo "Paraview"
echo  "——————————————————————"
if [ -d "$PTpath/PT" ]; then
  echo "rm -R $PTpath/PT"
  rm -R $PTpath/PT
fi
vglrun pvpython ParticleTracer.py


#Convert to JEMRIS
echo  "——————————————————————"
echo "Merge flow data"
echo  "——————————————————————"
python MergeDatJEMRIS.py $PTpath/PT
cat $PTpath/PT/result/particles_fill.dat $PTpath/PT/result/particles_seed.dat > $PTpath/PT/result/particles.dat
rm  $PTpath/PT/result/particles_fill.dat $PTpath/PT/result/particles_seed.dat
mv $PTpath/PT/result/*.dat ./
if [ -d "$PTpath/PT_save" ]; then
  rm -R $PTpath/PT_save
fi
mv $PTpath/PT $PTpath/PT_save
echo  "——————————————————————"
echo "Convert to JEMRIS"
echo  "——————————————————————"
cp CreateSimuFiles.c CreateSimuFiles.cpp
g++ CreateSimuFiles.cpp -o CreateSimuFiles
rm CreateSimuFiles.cpp
./CreateSimuFiles ConfigMRI.in
cp SetSequence.c SetSequence.cpp
g++ SetSequence.cpp -o SetSequence
rm SetSequence.cpp
./SetSequence ConfigMRI.in
rm ../FlowConversion_simu/simu_flowLoop.xml
rm ../FlowConversion_simu/Flow.dat
mv ./simu_flow.xml ../FlowConversion_simu/simu_flowLoop.xml
mv ./Flow.dat ../FlowConversion_simu/Flow.dat
