/*********************************************
 * OPL 12.5 Model
 * Author: otsuki
 * Creation Date: 2018/12/24 at 8:10:48
 *********************************************/
main {
	var y;
	var Yr1	 = 0; //0=2015, 1=2020, 2=2030, 3=2040, 4=2050
	var Yr2  = 4; //0=2015, 1=2020, 2=2030, 3=2040, 4=2050

	for(y=Yr1;y<Yr2+1;y++){
		writeln("Yr=",y," calculation started");
		//----------------
		var SOURCEmap_rd	=	new IloOplModelSource("NE_GlobalR_Model.mod");
		
		if(y==0){var DATAmap_rd	= new IloOplDataSource("NE_GlobalR_Data0.dat");}
		if(y==1){var DATAmap_rd	= new IloOplDataSource("NE_GlobalR_Data1.dat");}
		if(y==2){var DATAmap_rd	= new IloOplDataSource("NE_GlobalR_Data2.dat");}
		if(y==3){var DATAmap_rd	= new IloOplDataSource("NE_GlobalR_Data3.dat");}
		if(y==4){var DATAmap_rd	= new IloOplDataSource("NE_GlobalR_Data4.dat");}
		
		//----------------
		var DEFmap_rd		=	new IloOplModelDefinition(SOURCEmap_rd);
		var map_rd			=	new IloOplModel(DEFmap_rd,cplex); 
		var DATA2map_rd		=	new IloOplDataElements(); 

		DATA2map_rd.Yr  = y;		

		map_rd.settings.mainEndEnabled = true;
		map_rd.addDataSource(DATAmap_rd); 	
		map_rd.addDataSource(DATA2map_rd);
		map_rd.generate();

		if(cplex.solve()){
			var obj = cplex.getObjValue();	
			writeln("Solved ", y, "-th: ", obj );
			map_rd.postProcess();
			writeln("Post process finished");
 		}else{
			writeln("No solution");
			break; 		  
 		}
				
		map_rd.end();
		DATAmap_rd.end();
		DATA2map_rd.end();
		DEFmap_rd.end();
		SOURCEmap_rd.end();

		writeln("Yr=",y," calculation finished");	
	}		
}