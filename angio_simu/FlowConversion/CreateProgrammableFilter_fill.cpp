/****************************************************************************
**  This is a part of ParticleTracer                                       **
**  Copyright (C) 2016  Simon Garnotel                                     **
**                                                                         **
**  This program is free software: you can redistribute it and/or modify   **
**  it under the terms of the GNU General Public License as published by   **
**  the Free Software Foundation, either version 3 of the License, or      **
**  (at your option) any later version.                                    **
**                                                                         **
**  This program is distributed in the hope that it will be useful,        **
**  but WITHOUT ANY WARRANTY; without even the implied warranty of         **
**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          **
**  GNU General Public License for more details.                           **
**                                                                         **
**  You should have received a copy of the GNU General Public License      **
**  along with this program.  If not, see <http://www.gnu.org/licenses/>.  **
**                                                                         **
** **************************************************************************
**                                                                         **
** Author: Simon Garnotel                                                  **
** Last update: Alexandre Fortin                                           **
** Contact: simon.garnotel@gmail.com, fortin.alexandre@yahoo.fr            **
** Date: 06/2017                                                           **
** Version: 2.0                                                            **
****************************************************************************/

#include "header.hpp"

bool CreateProgrammableFilter_fill(const string FileName, const double SphereCenter[3]){
	ofstream File(FileName.c_str(), ios::out | ios::trunc);
	if (File){
		File << "# This file is automatically generated" << endl;
		File << "# DO NOT MODIFY" << endl;

		File << "import os" << endl;
		File << "pdi = self.GetPolyDataInput()" << endl;
		File << "pts = pdi.GetPointData()" << endl;
		File << "nbParts = pdi.GetNumberOfPoints()" << endl;
        File << "from mpi4py import MPI"<< endl;
		File << "CPUrank = MPI.COMM_WORLD.Get_rank()"<< endl;
        File << "nbCores = MPI.COMM_WORLD.Get_size()"<< endl;
        File << "if nbCores>nbParts:"<< endl;
        File << "    print 'Warning: more MPI cores than particles for initial filling  (',nbCores,' cores for ', nbParts,' particles)'"<< endl;
        File << "nbPartsPerCPU = int(nbParts/nbCores)"<< endl;
        File << "CPUfirstPart = nbPartsPerCPU*CPUrank"<< endl;
        File << "CPUlastPart = min(nbParts, CPUfirstPart + nbPartsPerCPU - 1)"<< endl;
        File << "#print CPUfirstPart, ' ', CPUlastPart"<< endl;
		File << "ptids = pts.GetArray('ParticleId')" << endl;
		File << "ptage = pts.GetArray('ParticleAge')" << endl;
		File << "if(not os.path.exists('/tmp/PT')):" << endl;
		File << "    os.mkdir('/tmp/PT')" << endl;
		File << "ts = pdi.GetInformation().Get(vtk.vtkDataObject.DATA_TIME_STEP())" << endl;
		//File << "coord = pdi.GetPoint(0)" << endl;
		//File << "x0, y0, z0 = coord[:3]" << endl;
		File << "if nbParts>0 and CPUrank<nbParts :"<< endl;
		File << "    for i in range(CPUfirstPart,CPUlastPart):" << endl;
		File << "        coord = pdi.GetPoint(i)" << endl;
		File << "        x, y, z = coord[:3]" << endl;
		//File << "       if (x0!=x or y0!=y or z0!=z):" << endl;
		File << "        fl = open('/tmp/PT/part.' + str(int(ptids.GetTuple(i)[0])) + '.dat', 'a')" << endl;
		File << "        fl.write(str(1000*ts) + \"\\t\" + str(x-"<<SphereCenter[0]<<") + \"\\t\" + str(y-"<<SphereCenter[1]<<") + \"\\t\" + str(z-"<<SphereCenter[2]<<") + \"\\n\")" << endl;
		File << "        fl.close()" << endl;
		//File << "    else:" << endl;
		//File << "        remove('/tmp/PT/Source" << N << "part.' + str(int(ptids.GetTuple(i)[0])) + '.dat', 'a')" << endl;
		//File << "    x0, y0, z0 = coord[:3]" << endl;
		File.close();
		return true;
	}
	else{
		cout << "ERROR: Unable to write " << FileName << endl;
		return false;
	}
}



