#Temp path to store data
PTpath=/tmp

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
pvbatch ParticleTracer.py  #If problems, use pvpyhton instead of pvbatch


#Convert to JEMRIS
echo  "——————————————————————"
echo "Merge flow data"
echo  "——————————————————————"
python MergeDatJEMRIS.py $PTpath/PT
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
rm ../simu/simu_flow.xml
rm ../simu/Flow.dat
mv ./simu_flow.xml ../simu/simu_flow.xml
mv ./Flow.dat ../simu/Flow.dat
