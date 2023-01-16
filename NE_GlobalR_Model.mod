/*********************************************
 * OPL 12.5 Model
 * Author: otsuki
 * Creation Date: 2016/11/15 at 7:00:00
 *********************************************/

//Emission case setting Case0=ref. 
int		CASE = ...;

//Year
int		Yr = ...;

//Tentative parameters
int 	NKSt1 =24;								//Storage
int 	NKSt2 =25;								//Storage
float	FuelingStationCov	= 1.0;
float	Max_Availability	= 0.1;
float	Duration_Pumped 	= 6*0.9/1000;		//hour*availability/unit conversion to TWh
float	Unit_Liion			= 0.9/1000;			//availability/unit conversion to TWh
float	Unit_Molten			= 0.9/1000;			//availability/unit conversion to TWh
float	Unit_H2				= 0.9/1000/11.63;	//availability/unit conversion to TWh to Mtoe
float	CRate_Liion			= 1.0;
float	ReserveMargin	    = 1.05;				//reserve margin
float	DepResource			= 50;				//to avoid exploiting all the depleteable resources [year]
float	Elec_Import			= -1;

//other parameters defined inside the model
//TZD,TZT,NKMO,NKCF,NKSF,IKFG[defined below]

int	ID[0..15]			= ...;
int	ZIT[0..7]			= ...;
int	RGEI[0..1]			= ...;
int	RGE					= ...;

//number of model elements
int	NND = ID[0];	//number of node
int	NRG = ID[1];	//number of region
int	NIT = ID[2];	//number of item
int	NAC = ID[3];	//number of activity
int	NNK = ID[4];	//number of nodal facility
int	NIK = ID[5];	//number of maritime trade facility
int	NIKL= ID[6];	//number of land trade facility
int	NFC = ID[7];	//number of final consumption type
int	NRS = ID[8];	//number of final resource
int	NYR = ID[9];	//number of year
int	NDY = ID[10];	//number of day
int	NWR = ID[11];	//number of weather pattern
int	NTM = ID[12];	//number of time slot per day
int	NTZ = ID[13];	//number of time zone
int	NIT2 = ID[14];	//number of item#2
int	NAC2 = ID[15];	//number of activity#2

//range
range NNDr = 0..NND-1;
range NRGr = 0..NRG-1;
range NITr = 0..NIT-1;
range NACr = 0..NAC-1;
range NNKr = 0..NNK-1;
range NIKr = 0..NIK-1;
range NIKLr= 0..NIKL-1;
range NFCr = 0..NFC-1;
range NRSr = 0..NRS-1;
range NYRr = 0..NYR-1;
range NDYr = 0..NDY-1;
range NWRr = 0..NWR-1;
range NTMr = 0..NTM-1;
range NTZr = 0..NTZ-1;
range NIT2r= 0..NIT2-1;
range NAC2r= 0..NAC2-1;

//string data
string	ID_ND[NNDr]	 = ...;	//node label
string	ID_RG[NRGr]	 = ...;	//region label
string	ID_IT[NITr]	 = ...;	//item label
string	ID_SIG[NITr] = ...;	//balance flag
string	ID_AC[NACr]	 = ...;	//activity label
string	ID_NK[NNKr]	 = ...;	//nodal facility label
string	ID_IK[NIKr]	 = ...;	//inter-nodal facility label [maritime]
string	ID_IKL[NIKLr]= ...;	//inter-nodal facility label [land]
string	ID_YR[NYRr]	 = ...;	//year label

int	RGD[NNDr][NRGr]	= ...;	//node-region definition matrix
int	ID_ITM[NITr]	= ...;	//item balance flag
int	ITMC1[NITr];			//item id -> item2
int	ITMC2[NIT2r];			//item2 range -> item id
int	ACTC1[NACr];			//activity id -> activity2
int	ACTC2[NAC2r];			//activity2 -> activity id
int	ID_NDTY[NNDr]	= ...;	//node type

float	ID_NDPD[NNDr] = ...;	//distance to port
float	ID_YRD[NYRr]  = ...;	//year duration
float	ID_YRD2[NYRr] = ...;	//number of years from the base year
float	ID_WRP[NWRr]  = ...;	//weather probability
float	TW = 24./NTM;
float	DW = 365./NDY;
float	DT = 1./NDY/NTM;
float	DTW[NWRr];				//time slot width ratio
float	DTW2[NWRr];				//day width ratio

//Output activity 2
int	OUT[0..2][0..1]	=...;
int NoYR = OUT[0][0];
int NoND = OUT[1][0];
int NoDY = OUT[2][0];
range	NoYRr = 0..NoYR-1;
range	NoNDr = 0..NoND-1;
range	NoDYr = 0..NoDY-1;

int	OUT_YR[NoYRr]	=...;
int	OUT_ND[NoNDr]	=...;
int	OUT_DY[NoDYr]	=...;

//emission constraint
float	RGE_D[0..RGE-1][NYRr] = ...;	//emission constraint
float	CTAX_D[0..RGE-1][NYRr]= ...;	//carbon tax data
float	CTAX[NRGr];				//carbon tax

//time difference
int		ID_NDTM[NNDr] = ...;
float	ID_TZD[NTZr]  = ...;	//time zone definition
range	TZr = 0..1;
int		TZD[NTZr][NDYr][NTMr][NTZr][TZr];
int		TZT[NTZr][NTMr][NTZr][TZr];
float	TZW[NTZr][NTZr][TZr];

//activity flow [AC]
int		AC[0..9][0..1]		= ...;
int		ACT					= ...;
int		ACI[0..AC[0][1]-1] = ...;					//activity index
int		ACF[0..AC[1][0]-1][0..AC[1][1]-1] = ...;	//activity&item
int		ID_ACM[NACr] = ...;							//item balance flag
float	ACD_1[0..AC[2][0]-1][0..AC[2][1]-1] = ...;	//activity data 1
float	ACD_2[0..AC[3][0]-1][0..AC[3][1]-1] = ...;	//activity data 2
float	ACD_3[0..AC[4][0]-1][0..AC[4][1]-1] = ...;	//activity data 3
int		mat_i[NITr][NACr];
float	mat_c[NITr][NACr];
float	ACCO[0..ACT-1][NNDr];
float	ACCO1[0..ACT-1][NNDr];
int		ACSL[0..NIT];
int		ACSL2[0..NIT2];
int		AC2FLG[0..NIT2-1];
int		ACVR[0..ACT-1];
int		ACVR2[0..ACT-1];
int		NACCO2;

//activity limits
int		AC_LM[0..1][0..1]	= ...;
int		AC_LMI[0..AC_LM[0][1]-1] = ...;
float	AC_LMD[0..AC_LM[1][0]-1][0..AC_LM[1][1]-1] = ...;
float	AC_LMT[NACr][NRGr];

//nodal activity stock [NK]
int		NK[0..27][0..1]		= ...;
int		NKT					= ...;
int		NKI[0..NK[0][1]-1] = ...;
int		NKF[0..NK[1][0]-1][0..NK[1][1]-1] 	= ...;
int		NKD_1[0..NK[2][0]-1][0..NK[2][1]-1] = ...;
float	NKD_2[0..NK[3][0]-1][0..NK[3][1]-1]	= ...;
float	NKD_3[0..NK[4][0]-1][0..NK[4][1]-1] = ...;
float	NK_LAF[0..NK[5][0]-1][0..NK[5][1]-1] = ...;	//location factor for capacity factor
float	NK_LCC[0..NK[6][0]-1][0..NK[6][1]-1] = ...;	//location factor for capital cost
int		NK_KI[0..NK[7][1]-1] = ...;
float	NK_EKD[0..NK[8][0]-1][0..NK[8][1]-1] = ...;	//exogenous capacity
float	NK_MKD[0..NK[9][0]-1][0..NK[9][1]-1] = ...;	//maximum capacity

int		NKTY[NNKr];
int		NKOPI[NNKr];
int		NKSL[0..NNK];
int		NKVR[0..NKT-1];
int		NKVR2[0..NKT-1];
int		mat_k[NNKr][NACr];
int		NKLF[NNKr][NYRr][NYRr];				//lifetime matrix
float	NKAF[NNKr][NNDr];					//availability
float	NKAF2[NNKr][NNDr][NDYr][NWRr][NTMr];//availability
float	NKCC[NNKr][NNDr];					//capital costs
float	NKEK[NNKr][NNDr];					//exogenous capacity
float	NKMK[NNKr][NNDr];					//maximum capacity
float	NKCF[NNKr][NNDr][0..1];				//average capacity factor and max availability
float	NKSF[NWRr];							//stored energy factor

//nodalCapacity_TimeProfile[NK_TP]
int		NK_TPN				= ...;
int		NK_TP[0..1][0..1]	= ...;
int		NK_TPI[0..NK_TP[0][0]-1][0..NK_TP[0][1]-1] = ...;
float	NK_TPD[0..NK_TP[1][0]-1][0..NK_TP[1][1]-1] = ...;
float	NK_TPD2[0..NK_TPN*NND-1][NDYr][NWRr][NTMr];

//NK_Operational_information[NK_OP]
int		NK_OP[0..3][0..1]	= ...;
int		NNKMS  = NK_OP[1][0];	//number of maintenance schedule
range	NNKMSr = 0..NNKMS-1;
int		NNKOP  = NK_OP[2][1];
range	NNKOPr = 0..NNKOP-1;

int		NK_OPI[NNKOPr] = ...;
int		NK_MSI[0..NK_OP[0][1]-1] = ...;
float	NK_MSD[0..NK_OP[1][0]-1][0..NK_OP[1][1]-1] = ...;
float	NK_OPD[0..NK_OP[3][0]-1][0..NK_OP[3][1]-1] = ...;

float	NKRU[NNKOPr];
float	NKRD[NNKOPr];
float	NKMS[NNKMSr][NDYr];
float	NKMSA[NNKMSr];
float	NKMO[NNKOPr][0..1];		//share of DSS and minimum output rate

//Maritime trade stock[IK]
int 	IK[0..5][0..1]		= ...;
int		IKI[0..IK[0][1]-1] 	= ...;
int		IKF[0..IK[1][0]-1][0..IK[1][1]-1] = ...;
int		IKF2[0..IK[1][0]-1][0..IK[1][1]-1];
int		IKT[0..IK[2][1]-1] = ...;
int		IKC[0..IK[3][1]-1] = ...;
float	IKD_1[0..IK[4][0]-1][0..IK[4][1]-1] = ...;
float	IKD_2[0..IK[5][0]-1][0..IK[5][1]-1] = ...;

//maritime distance and existing capacity between nodes
int 	IK_DK[0..6][0..1]	= ...;
int		IK_DKI[0..IK_DK[0][0]-1][0..IK_DK[0][1]-1] = ...;
int		IK_EKI[0..IK_DK[3][0]-1] = ...;
int		IK_MKI[0..IK_DK[5][0]-1] = ...;
float	IK_DSD[0..IK_DK[2][0]-1][0..IK_DK[2][1]-1] = ...;
float	IK_EKD[0..IK_DK[4][0]-1][0..IK_DK[4][1]-1] = ...;
float	IK_MKD[0..IK_DK[6][0]-1][0..IK_DK[6][1]-1] = ...;
string	IK_DSI[0..IK_DK[1][0]-1] = ...;

//number of maritime routes
int		NRM	 = IK_DK[0][1];
range	NRMr = 0..NRM-1;

//land trade stock[IKL]
int		IKL[0..5][0..1]		= ...;
int		IKLI	[0..IKL[0][1]-1] = ...;
int		IKLF	[0..IKL[1][0]-1][0..IKL[1][1]-1] = ...;
int		IKLF2	[0..IKL[1][0]-1][0..IKL[1][1]-1];
int		IKLT	[0..IKL[2][1]-1] = ...;
int		IKLC	[0..IKL[3][1]-1] = ...;
float	IKLD_1	[0..IKL[4][0]-1][0..IKL[4][1]-1] = ...;
float	IKLD_2	[0..IKL[5][0]-1][0..IKL[5][1]-1] = ...;
//land Distance and existing capacity between nodes
int		IKL_DK[0..6][0..1]	= ...;
int		IKL_DKI[0..IKL_DK[0][0]-1][0..IKL_DK[0][1]-1] = ...;
int		IKL_EKI[0..IKL_DK[3][0]-1] = ...;
int		IKL_MKI[0..IKL_DK[5][0]-1] = ...;
float	IKL_DSD[0..IKL_DK[2][0]-1][0..IKL_DK[2][1]-1] = ...;
float	IKL_EKD[0..IKL_DK[4][0]-1][0..IKL_DK[4][1]-1] = ...;
float	IKL_MKD[0..IKL_DK[6][0]-1][0..IKL_DK[6][1]-1] = ...;
//number of land routes
int		NRL  = IKL_DK[0][1];
range	NRLr = 0..NRL-1;

//maritime trade
int		IKTY[NIKr];
int		IKT2[NIKr];
int		IKFG[NIKr][NRMr];				//flag
int		IKLFM[NIKr][NYRr][NYRr];		//lifetime matrix
int		MAT[0..1][NRMr][NNDr];
float	IKDS[0..IK_DK[2][0]-1][NRMr]; 	//distance
float	IKEF[NIKr][NRMr];				//efficiency
float	IKAF[NIKr][NRMr];	//availability
float	IKCC[NIKr][NRMr];	//capital cost
float	IKVC[NIKr][NRMr];	//variable cost
float	IKEK[NIKr][NRMr];	//existing capacity
float	IKMK[NIKr][NRMr];	//maximum capacity
//land trade
int		IKLTY[NIKLr];
int		IKLT2[NIKLr];
int		IKLFG[NIKLr][NRLr];		//flag
int		IKLLFM[NIKLr][NYRr][NYRr];	//lifetime matrix
int		MATL[0..1][NRLr][NNDr];
float	IKLDS[0..IKL_DK[2][0]-1][NRLr]; //distance
float	IKLEF[NIKLr][NRLr];	//efficiency
float	IKLAF[NIKLr][NRLr];	//availability
float	IKLCC[NIKLr][NRLr];	//capital cost
float	IKLVC[NIKLr][NRLr];	//variable cost
float	IKLEK[NIKLr][NRLr]; 	//existing capacity
float	IKLMK[NIKLr][NRLr]; 	//maximum capacity

//finalConsumption[FC]
int		FC[0..4][0..1]		= ...;
int		FCI[0..FC[0][1]-1] = ...;
int		FCF[0..FC[1][1]-1] = ...;
int		FCS[0..FC[2][0]-1][0..FC[2][1]-1] = ...;
float	FCD[0..FC[3][0]-1][0..FC[3][1]-1] = ...;
float	FCD_2[0..FC[4][0]-1][0..FC[4][1]-1] = ...;
int		FC_LD[0..2][0..1]	= ...;
int		FC_LDI1[0..FC_LD[0][0]-1][0..FC_LD[0][1]-1] = ...;
int		FC_LDI2[0..FC_LD[1][0]-1][0..FC_LD[1][1]-1] = ...;
float	FC_LDD[0..FC_LD[2][0]-1][0..FC_LD[2][1]-1]  = ...;
float	FC_LDD2[NFCr][NNDr][NYRr][NDYr][NTMr];

//right hand side [RHS] of the constraints
float	RHS0[NITr][NNDr];
float	RHS2[NIT2r][NNDr][NDYr][NWRr][NTMr];

//resource[RS]
int		RS[0..4][0..1]	   = ...;
int		RSI[0..RS[0][1]-1] = ...;
int		RSF[0..RS[1][1]-1] = ...;
int		RST[0..RS[2][1]-1] = ...;
int		RSF0[NRSr];
int		RST0[NRSr];
float	RSD[0..RS[3][0]-1][0..RS[3][1]-1]  = ...;
float	RSD0[NRSr][NNDr];
float	RD_RS[0..RS[4][0]-1][0..RS[4][1]-1]  = ...;

//recursive dynamic [RD]
int		RD[0..5][0..1] = ...;
int		RD_NK[0..RD[0][0]-1][0..RD[0][1]-1] = ...;
float	RD_NKD[0..RD[1][0]-1][0..RD[1][1]-1] = ...;
int		RD_IK[0..RD[2][0]-1][0..RD[2][1]-1] = ...;
float	RD_IKD[0..RD[3][0]-1][0..RD[3][1]-1] = ...;
int		RD_IKL[0..RD[4][0]-1][0..RD[4][1]-1] = ...;
float	RD_IKLD[0..RD[5][0]-1][0..RD[5][1]-1] = ...;
float	RDNK[NNKr][NNDr][NYRr];
float	RDNIK[NIKr][NRMr][NYRr];
float	RDNIKL[NIKLr][NRLr][NYRr];

int 	COST = 6;		//fixed-ik,fixed-nk,fixed-bat,fixed-solar,fixed-wind,fixed-vehicle
string	R_COSTL[0..COST*(NND+NRG)-1];
float	R_COST[0..COST*(NND+NRG)-1][0..NYR-1]=...;


//------------------------------------------------------------------------
//preprocess1
//------------------------------------------------------------------------

execute preprocess1{
	writeln("preprocess1: general settings");
	var i,i2,j,k,r,n,d1,d2,d3,t1,t2,t3,td0,td1,td2,tw1,w1,tz1,tz2;
		
	i2=0;
	for(i in NITr){
		if(ID_ITM[i]!=0){
			ITMC1[i]=i2;
			ITMC2[i2]=i;
			i2+=1;
		}		
		else{
			ITMC1[i]=-1;
		}		
	}	

	i2=0;
	for(i in NACr){
		if(ID_ACM[i]!=0){
			ACTC1[i]=i2;
			ACTC2[i2]=i;
			i2+=1;
		}		
		else{
			ACTC1[i]=-1;
		}
	}	

	for(w1 in NWRr){
		DTW[w1]  = 1.*ID_WRP[w1]/NDY/NTM;
		DTW2[w1] = 1.*ID_WRP[w1]/NDY;
	}

	//carbon tax
	for(r in NRGr){
		CTAX[r]=0;
		if(CTAX_D[CASE*NRG+r][Yr]!=-1) CTAX[r]=CTAX_D[CASE*NRG+r][Yr];
	}

	//time difference
	for(i in TZr)for(tz1 in NTZr)for(t1 in NTMr)for(tz2 in NTZr){
		TZT[tz1][t1][tz2][i]=0;
		for(d1 in NDYr)TZD[tz1][d1][t1][tz2][i]=0;
	}	

	for(tz1 in NTZr)for(d1 in NDYr)for(t1 in NTMr)for(tz2 in NTZr){
		td0=ID_TZD[tz2]-ID_TZD[tz1];
		td1=Math.floor(td0/TW);
		td2=Math.ceil(td0/TW);
		tw1=Math.abs(td0/TW);
		tw1-=Math.floor(tw1);
		t2=t1+td1;
		t3=t1+td2;

		if(t2 >= NTM){
			t2-=NTM;
			d2=d1+1;
			if(d2>=NDY) d2-=NDY;
		}		
		else if(t2<0){
			t2+=NTM;
			d2=d1-1;
			if(d2<0) d2+=NDY;	
		}
		else{		
			d2=d1;
		}		

		if(t3>=NTM){
			t3-=NTM;
			d3=d1+1;
			if(d3>=NDY) d3-=NDY;			
		}		
		else if(t3<0){
			t3+=NTM;
			d3=d1-1;
			if(d3<0) d3+=NDY;	
		}		
		else{
			d3=d1;
		}

		TZD[tz1][d1][t1][tz2][0]=d2;
		TZD[tz1][d1][t1][tz2][1]=d3;
		TZT[tz1][t1][tz2][0]=t2;
		TZT[tz1][t1][tz2][1]=t3;
	
		if(td0>=0){
			TZW[tz1][tz2][0]=1.-tw1;
			TZW[tz1][tz2][1]=tw1;
		}		
		else{
			TZW[tz1][tz2][0]=tw1;
			TZW[tz1][tz2][1]=1.-tw1;
		}		
	}	
}

//------------------------------------------------------------------------
//preprocess2
//------------------------------------------------------------------------
execute preprocess2a{
	writeln("preprocess2a: activity");
	
	var i,i2,i3,j,v,n;
	for(i in NITr)for(j in NACr){
		mat_i[i][j]=0;
		mat_c[i][j]=0;
	}

	for(i in NIT2r) AC2FLG[i]=0;
	
	i2=0;
	for(j=0;j<AC[1][1];j++)for(i=1;i<AC[1][0];i++){
		i2=ACF[i][j];
		if(i2!=-1)mat_i[i2][ACI[j]]=1;
	}	

	i2=0;
	for(i=0;i<NIT;i++){
		ACSL[i]=i2;
		for(j in NACr){
			if(mat_i[i][j]==1){
				ACVR[i2]=j;
				i2+=1;
 			}			
		}	
	}	
	ACSL[NIT]=i2;

	i2=0;
	for(i=0;i<NIT2;i++){
		ACSL2[i]=i2;
		for(j in NACr){
			if(mat_i[ITMC2[i]][j]==1 && ID_ACM[j]!=0){
				AC2FLG[i]=1;
				ACVR2[i2]=ACTC1[j];
				i2+=1;
 			}
		}
	}
	ACSL2[NIT2]=i2;
	NACCO2=i2;

}



float	ACCO2[0..NACCO2-1][NNDr];
	
execute preprocess2b{
	writeln("preprocess2b: activity");
	var i,i2,i3,j,v,n;
	for(n in NNDr){
		for(j=0;j<AC[1][1];j++){
			for(i=1;i<AC[1][0];i++){
				if((i2=ACF[i][j])!=-1){
					if(i==AC[1][0]-1){ 
						mat_c[i2][ACI[j]]=ACD_3[Yr*NND+n][j];}					
					else if(i==AC[1][0]-2){
					  	mat_c[i2][ACI[j]]=ACD_2[Yr][j];}
					else{
					  	mat_c[i2][ACI[j]]=ACD_1[i-1][j];}
  				}				
 			}			

			v=1.;
		  	if((i2=ACF[0][j])!=-1){
				v=Math.abs(mat_c[i2][ACI[j]]);
				for(i=1;i<AC[1][0];i++){
					if((i3=ACF[i][j])!=-1) mat_c[i3][ACI[j]]=mat_c[i3][ACI[j]]/v;
  				}
 			}		
		}	

		for(i=0;i<NIT;i++)for(j=ACSL[i];j<ACSL[i+1];j++){
			ACCO[j][n]=mat_c[i][ACVR[j]]; 
			if(ID_ACM[ACVR[j]]!=0){
				ACCO1[j][n]=0;}
			else{
				ACCO1[j][n]=mat_c[i][ACVR[j]];
			}
		}

		for(i=0;i<NIT2;i++)for(j=ACSL2[i];j<ACSL2[i+1];j++)
			ACCO2[j][n]=mat_c[ITMC2[i]][ACTC2[ACVR2[j]]];
		
	}	
}

//------------------------------------------------------------------------
//preprocess3
//------------------------------------------------------------------------
execute preprocess3{
	var i,r;
	writeln("preprocess3: activity limit");
	for(i in NACr)for(r in NRGr) AC_LMT[i][r]=-1;
	for(i=0;i<AC_LM[0][1];i++)for(r in NRGr) AC_LMT[AC_LMI[i]][r]=AC_LMD[Yr*NRG+r][i];
}

//------------------------------------------------------------------------
//preprocess4
//------------------------------------------------------------------------
execute preprocess4{
	writeln("preprocess4: nodal capacity");
	var i,i2,j,v,y,y2,d,t,n,w;
	for(i in NNKr){
		NKTY[i]=0;
		NKOPI[i]=-1;
		for(n in NNDr){
			NKEK[i][n]=0;
			NKMK[i][n]=-1;
		}
		//initialize lifetime matrix
		for(y in NYRr)for(y2 in NYRr){
  			if(y <= y2)	NKLF[i][y][y2]=1;
	 		else NKLF[i][y][y2]=0;
  		}
	}

	//output profile
	for(i=0;i<NK_TPN;i++)for(n in NNDr)for(j=0;j<NK_TP[1][1];j++)
	  NK_TPD2[i*NND+n][NK_TPI[0][j]][NK_TPI[1][j]][NK_TPI[2][j]]=NK_TPD[i*NND+n][j];

	//plant availability, annualized capital cost, NKAF2
	for(j=0;j<NK[1][1];j++){
		for(i=0;i<NK[1][0];i++){
		   	if((i2=NKF[i][j])!=-1){
		   		mat_k[NKI[j]][i2]=1;
	   			if(ID_ACM[i2]!=0) NKTY[NKI[j]]=1; //matrix about NK&AC	     			
  			} 			
		}

		for(n in NNDr){
			NKAF[NKI[j]][n]=NKD_2[0][j]*NKD_2[1][j]*NK_LAF[n][NKD_2[3][j]];
			NKCC[NKI[j]][n]=NKD_2[2][j]*NKD_3[Yr][j]*NK_LCC[n][NKD_2[4][j]];
		}		
		
		if((i2=NKD_1[0][j])==0){
			NKTY[NKI[j]]=2;
			NKOPI[NKI[j]]=NKD_1[1][j];
			for(n in NNDr){
				NKCF[NKI[j]][n][0]=NKD_2[1][j];
				NKCF[NKI[j]][n][1]=Math.min(1.,NKCF[NKI[j]][n][0]+Max_Availability);
				if(NKI[j]==NK[23][0]) NKCF[NKI[j]][n][1]=NKCF[NKI[j]][n][0]; //availability for nuclear
  			} 						
		}		

		for(n in NNDr)for(d in NDYr)for(w in NWRr)for(t in NTMr){
			if(i2>0) NKAF2[NKI[j]][n][d][w][t]=NK_TPD2[NND*(i2-1)+n][d][w][t]*NKD_2[0][j];
			else if(i2==0) NKAF2[NKI[j]][n][d][w][t]=NKD_2[0][j];
			else NKAF2[NKI[j]][n][d][w][t]=NKD_2[0][j]*NKD_2[1][j]*NK_LAF[n][NKD_2[3][j]];
		}		
	}	

	i2=0;
	for(i=0;i<NNK;i++){
		NKSL[i]=i2;
		for(j=0;j<NAC;j++){
			if(mat_k[i][j]==1){
				NKVR[i2]=j;
				NKVR2[i2]=ACTC1[j];
				i2+=1;
 			}	
		}	
	}
	NKSL[NNK]=i2;

	//exogenous capacity, maximum capacity
	for(n in NNDr)for(i=0;i<NK[7][1];i++){
		NKEK[NK_KI[i]][n]=NK_EKD[Yr*NND+n][i];
		NKMK[NK_KI[i]][n]=NK_MKD[Yr*NND+n][i];
	}
	
	//stored enegy factor
	for(j in NWRr) NKSF[j]=1/DW/ID_WRP[j];

	//lifetime matrix
	for(j=0;j<NK[0][1];j++){
		if(NKD_2[5][j]!=-1){
			for(y=0;y<NYR;y++)for(y2=y;y2<NYR;y2++){
				v = ID_YRD2[y2]-ID_YRD2[y];
				if(NKD_2[5][j]<=v) NKLF[NKI[j]][y][y2]=0;
 			}			
		}		
	}	
}


//------------------------------------------------------------------------
//preprocess5
//------------------------------------------------------------------------
execute preprocess5{
	writeln("preprocess5: nodal capacity operation");
	var i,j,k;
	
	for(i in NNKOPr){
 		NKRU[i]=NK_OPD[0][i]*TW;
		NKRD[i]=NK_OPD[1][i]*TW;
		NKMO[i][0]=NK_OPD[2][i];
		NKMO[i][1]=NK_OPD[3][i];
	}	

	for(i=0;i<NNKMS;i++){
  		k=0.;
  		for(j=0;j<NK_OP[1][1];j++){
  			NKMS[i][NK_MSI[j]]=NK_MSD[i][j];
  			k+=NKMS[i][NK_MSI[j]];
  		} 	 	
  		NKMSA[i]=k/NK_OP[1][1];
	}	
}

//------------------------------------------------------------------------
//preprocess6
//------------------------------------------------------------------------
execute preprocess6{
	writeln("preprocess6: inter-nodal capacity");
	var i,j,v,r,n,y,y2,ds1,ds2,ef2,cc2,vc2;
	
	for(i in NIKr){
		IKTY[i]=0;
		IKF2[0][i]=ACTC1[IKF[0][i]];
		IKF2[1][i]=ACTC1[IKF[1][i]];
		
		if(IKF[2][i]==-1) IKF2[2][i]=-1;
		else IKF2[2][i]=ACTC1[IKF[2][i]];
		
		if(ID_ACM[IKF[0][i]]!=0){
			IKTY[i]=1;
			IKT2[i]=0;
		}		
					
		for(r in NRMr){
			IKAF[i][r]=0;
			IKFG[i][r]=0;
			IKEF[i][r]=0;
			IKCC[i][r]=0;
			IKEK[i][r]=0;
			IKMK[i][r]=-1;
		}		
		//initialize lifetime matrix
		for(y in NYRr)for(y2 in NYRr){
			if(y <= y2)	IKLFM[i][y][y2] = 1;
			else IKLFM[i][y][y2] = 0;
		}		
	}	


	for(i in NIKLr){
		IKLTY[i]=0;
		IKLF2[0][i]=ACTC1[IKLF[0][i]];
		IKLF2[1][i]=ACTC1[IKLF[1][i]];
		
		if(IKLF[2][i]==-1) IKLF2[2][i]=-1;
		else IKLF2[2][i]=ACTC1[IKLF[2][i]];
		
		if(ID_ACM[IKLF[0][i]]!=0){
			IKLTY[i]=1;
			IKLT2[i]=0;
		}		
		
		for(r in NRLr){
			IKLAF[i][r]=0;
			IKLFG[i][r]=0;
			IKLEF[i][r]=0;
			IKLCC[i][r]=0;
			IKLEK[i][r]=0;
			IKLMK[i][r]=-1;
		}		
		//initialize lifetime matrix
		for(y in NYRr)for(y2 in NYRr){
			if(y <= y2)	IKLLFM[i][y][y2] = 1;
			else IKLLFM[i][y][y2] = 0;
		}		
	}	

	for(r in NRMr)for(n in NNDr){
		MAT[0][r][n]=0;
		MAT[1][r][n]=0;
	}	
	for(r in NRMr){
		MAT[0][r][IK_DKI[1][r]]=1;
		MAT[1][r][IK_DKI[0][r]]=1;
	}	
	for(r in NRLr)for(n in NNDr){
		MATL[0][r][n]=0;
		MATL[1][r][n]=0;
	}	
	for(r in NRLr){
		MATL[0][r][IKL_DKI[1][r]]=1;
		MATL[1][r][IKL_DKI[0][r]]=1;
	}	

	for(i=0;i<IK[0][1];i++) IKT2[IKI[i]]=IKT[i];
	for(i=0;i<IKL[0][1];i++)IKLT2[IKLI[i]]=IKLT[i];

	for(i=0;i<IK_DK[2][0];i++)for(r in NRMr)IKDS[i][r]=-1;
	for(i=0;i<IKL_DK[2][0];i++)for(r in NRLr)IKLDS[i][r]=-1;

	for(j=0;j<IK_DK[2][1];j++){
		for(i=0;i<IK_DK[2][0];i++)IKDS[i][j]=IK_DSD[i][j];
		for(i=0;i<IK_DK[4][0];i++)IKEK[IK_EKI[i]][j]=IK_EKD[i][j];
		for(i=0;i<IK_DK[6][0];i++)IKMK[IK_MKI[i]][j]=IK_MKD[i][j];
	}	

	for(j=0;j<IKL_DK[2][1];j++){
		for(i=0;i<IKL_DK[2][0];i++)IKLDS[i][j]=IKL_DSD[i][j];
		for(i=0;i<IKL_DK[4][0];i++)IKLEK[IKL_EKI[i]][j]=IKL_EKD[i][j];
		for(i=0;i<IKL_DK[6][0];i++)IKLMK[IKL_MKI[i]][j]=IKL_MKD[i][j];
	}	

	for(i=0;i<IK[0][1];i++){
		for(r in NRMr){
		  	if((ds1=IKDS[IKT[i]][r]/1000)>0){
				IKAF[IKI[i]][r]=IKD_1[2][i]/(2*ds1+IKD_1[3][i]);
		  		//connecting land transport (for maritime transport)
	  			ds2=0.;
	  			ef2=1.;
		  		cc2=0.;
		  		vc2=0.;
	  			if(IKC[i]!=-1){ //for conneccting transport from the port
	  				ds2=(Math.max(0,ID_NDPD[IK_DKI[0][r]])+Math.max(0,ID_NDPD[IK_DKI[1][r]]))/1000;
	  				ef2=Math.pow(1-IKD_1[0][IKC[i]],ds2)*Math.pow(1-IKD_1[1][IKC[i]],2);
		  			cc2=(IKD_2[2][IKC[i]]*ds2+IKD_2[3][IKC[i]])*IKD_2[4][IKC[i]];
		  			vc2=IKD_2[0][IKC[i]]*ds2+IKD_2[1][IKC[i]];
		  		}
	  			IKFG[IKI[i]][r]=1;
		  		IKEF[IKI[i]][r]=Math.pow(1-IKD_1[0][i],ds1)*Math.pow(1-IKD_1[1][i],ds1)*ef2;
				IKCC[IKI[i]][r]=(IKD_2[2][i]*ds1+IKD_2[3][i])*IKD_2[4][i]+cc2;
				IKVC[IKI[i]][r]=IKD_2[0][i]*ds1+IKD_2[1][i]+vc2;
 			}
		}	
		//lifetime matrix
		if(IKD_2[4][i]!=-1){
			for(y=0;y<NYR;y++)for(y2=y;y2<NYR;y2++){
				v = ID_YRD2[y2]-ID_YRD2[y];
				if(IKD_1[4][i] <= v) IKLFM[IKI[i]][y][y2]=0;
 			}
		}		
	}	

	for(i=0;i<IKL[0][1];i++){
		for(r in NRLr){
	  		ds1=IKLDS[IKLT[i]][r]/1000;
		  	if(ds1>0){
				IKLAF[IKLI[i]][r]=IKLD_1[2][i]*IKLD_1[3][i];
	  			IKLFG[IKLI[i]][r]=1;
	  			IKLEF[IKLI[i]][r]=Math.pow(1-IKLD_1[0][i],ds1)*Math.pow(1-IKLD_1[1][i],ds1);
				IKLCC[IKLI[i]][r]=(IKLD_2[2][i]*ds1+IKLD_2[3][i])*IKLD_2[4][i];
				IKLVC[IKLI[i]][r]=IKLD_2[0][i]*ds1+IKLD_2[1][i];
  			}
		}
		//lifetime matrix
		if(IKLD_2[4][i]!=-1){
			for(y=0;y<NYR;y++)for(y2=y;y2<NYR;y2++){
				v = ID_YRD2[y2]-ID_YRD2[y];
				if(IKLD_1[4][i] <= v) IKLLFM[IKLI[i]][y][y2]=0;
 			}			
		}		
	}	
}

//------------------------------------------------------------------------
//preprocess7
//------------------------------------------------------------------------
execute preprocess7{
	writeln("preprocess7: demand");
	var i,j,n,y,d,t,w;
	for(i in NITr)for(n in NNDr)RHS0[i][n]=0.;
	for(i in NIT2r)for(n in NNDr)for(d in NDYr)for(w in NWRr)for(t in NTMr)RHS2[i][n][d][w][t]=0.;
	for(i in NFCr)for(n in NNDr)for(y in NYRr)for(d in NDYr)for(t in NTMr)FC_LDD2[i][n][y][d][t]=1./NDY/NTM;
	for(i=0;i<FC_LD[1][0];i++)for(j=0;j<FC_LD[0][1];j++){
		FC_LDD2[FC_LDI2[i][0]][FC_LDI2[i][2]][FC_LDI2[i][1]][FC_LDI1[0][j]][FC_LDI1[1][j]]=FC_LDD[i][j];
	}	
	for(j=0;j<FC[3][1];j++)for(n in NNDr){
		if(ID_ITM[FCF[j]]==0) RHS0[FCF[j]][n]=FCD[Yr*NND+n][j];
		else for(d in NDYr)for(w in NWRr)for(t in NTMr)RHS2[ITMC1[FCF[j]]][n][d][w][t]=FCD[Yr*NND+n][j]*FC_LDD2[FCI[j]][n][Yr][d][t]*ID_WRP[w];		
	}	
}


//------------------------------------------------------------------------
//preprocess8
//------------------------------------------------------------------------
execute preprocess8{
	writeln("preprocess8: resource");
	var i,n,v;
	for(i in NRSr)RSF0[i]=-1;
	for(i in NRSr)for(n in NNDr)RSD0[i][n]=0;
	for(i=0;i<RS[1][1];i++){
		RSF0[RSI[i]]=RSF[i];
		RST0[RSI[i]]=RST[i];
	}	
	for(i=0;i<RS[3][1];i++)for(n in NNDr)RSD0[RSI[i]][n]=RSD[Yr*NND+n][i];

	//recursive
	v=0.;
	for(n in NNDr)for(i in NRSr){
		if(Yr==0){
			RD_RS[n][i] = 0.;}
		else if(RSD0[i][n]>0){ 
			if((v=RD_RS[n][i]-RSD0[i][n])>0){
				RD_RS[n][i]=RSD0[i][n];
				if(v>0.0001) writeln("resource...","n=",ID_ND[n]," RS=",i," Gap=",v);
 			}			
		}
 	}
	
}


//------------------------------------------------------------------------
//preprocess9
//------------------------------------------------------------------------
execute preprocess9{
	writeln("preprocess9: recursive dynamic");
	
	var i,j,n,r,y;
	if(Yr==0){
		for(i=0;i<RD[1][0];i++)for(j=0;j<RD[1][1];j++) RD_NKD[i][j]=0.;	
		for(i=0;i<RD[3][0];i++)for(j=0;j<RD[3][1];j++) RD_IKD[i][j]=0.;	
		for(i=0;i<RD[5][0];i++)for(j=0;j<RD[5][1];j++) RD_IKLD[i][j]=0.;
		for(i in NNKr)for(n in NNDr)for(y in NYRr) RDNK[i][n][y]=0.;
		for(i in NIKr)for(r in NRMr)for(y in NYRr) RDNIK[i][r][y]=0.;
		for(i in NIKLr)for(r in NRLr)for(y in NYRr) RDNIKL[i][r][y]=0.;
	}else{
		for(i=0;i<RD[1][0];i++)for(j=0;j<RD[1][1];j++){
			RDNK[RD_NK[i][1]][RD_NK[i][0]][j]=Math.max(0.,RD_NKD[i][j]); }	
		for(i=0;i<RD[3][0];i++)for(j=0;j<RD[3][1];j++){
			RDNIK[RD_IK[i][1]][RD_IK[i][0]][j]=Math.max(0.,RD_IKD[i][j]); }	
		for(i=0;i<RD[5][0];i++)for(j=0;j<RD[5][1];j++){
			RDNIKL[RD_IKL[i][1]][RD_IKL[i][0]][j]=Math.max(0.,RD_IKLD[i][j]); }	
	}	

}

execute parameters{
	cplex.solutiontype = 2;  
  	writeln("preprocess: done");
  
}

//------------------------------------------------------------------------
//constraints and variables
//------------------------------------------------------------------------

//variables
dvar float+ obj;				//million USD	
dvar float+ fx_cst;				//fixed cost (capital+fixed O&M)
dvar float+ fxnk_cst[NNDr];		//fixed(NK)
dvar float+ fxik_cst[NRMr];		//fixed(IK)
dvar float+ fxikl_cst[NRLr];	//fixed(IK)
dvar float+ fu_cst;			//fuel cost
dvar float+ ov_cst;			//other variable cost
dvar float+	sv_cst;			//penalty for energy saving (loss of consumer utility)
dvar float+	cx_cst;			//carbon tax

dvar float  z0[NITr][NNDr];
dvar float  z2[NIT2r][NNDr][NDYr][NWRr][NTMr];
dvar float  a2[NIT2r][NNDr][NDYr][NWRr][NTMr];
dvar float  ze[NRGr];							  //emissions
dvar float	ztec[NRGr];							  //total electricity consumption (including net exports)
dvar float	zelcim[NRGr];						  //electricity net imports)
dvar float+ xac0[NACr][NNDr];				  	  //activity 
dvar float+ xac2[NAC2r][NNDr][NDYr][NWRr][NTMr];  //activity (activity type 2)
dvar float+ xmx2[NNKOPr][NNDr][NDYr];		  	  //maximum output 
dvar float+ ank[NNKOPr][NNDr][NDYr]; 			  //available capacity 
dvar float+ xnk[NNKr][NNDr];					  //total nodal capacity
dvar float+ xnnk[NNKr][NNDr];					  //newly added nodal capacity

dvar float+ xtp0[NIKr][NRMr];	  		  		  //inter-nodal activity
dvar float+ xtn0[NIKr][NRMr];	  		  		  //inter-nodal activity
dvar float+ xtp2[NIKr][NRMr][NDYr][NTMr]; 		  //inter-nodal activity (activity type 2)
dvar float+ xtn2[NIKr][NRMr][NDYr][NTMr];	 	  //inter-nodal activity (activity type 2)
dvar float+ xik[NIKr][NRMr];				
dvar float+ xeik[NIKr][NRMr];				
dvar float+ xnik[NIKr][NRMr];				

dvar float+ xtpl0[NIKLr][NRLr];	  		  	   //inter-nodal activity
dvar float+ xtnl0[NIKLr][NRLr];	  		  	   //inter-nodal activity
dvar float+ xtpl2[NIKLr][NRLr][NDYr][NTMr];      //inter-nodal activity (activity type 2)
dvar float+ xtnl2[NIKLr][NRLr][NDYr][NTMr];      //inter-nodal activity (activity type 2)
dvar float+ xikl[NIKLr][NRLr];					   
dvar float+ xnikl[NIKLr][NRLr];				   

constraint  eqcx[NRGr];
constraint  eqcx2[NRGr];
constraint  eqsv[NFCr][NNDr];
constraint  eqit0[NITr][NNDr];
constraint  eqit2[NIT2r][NNDr][NDYr][NWRr][NTMr];
constraint  eqnk[NNKr][NNDr];
constraint  eqik[NIKr][NRMr];
constraint  eqikl[NIKLr][NRLr];

//------------------------------------------------------------------------
//objective function
//------------------------------------------------------------------------
minimize obj;

subject to {
	obj == fx_cst + ov_cst + fu_cst + sv_cst + cx_cst;

	fx_cst == sum(r in NRMr)fxik_cst[r]+sum(r in NRLr)fxikl_cst[r]+sum(n in NNDr)fxnk_cst[n];
	fu_cst == sum(n in NNDr)z0[ZIT[0]][n];
	ov_cst == sum(n in NNDr)z0[ZIT[1]][n]
							+sum(i in NIKr,r in NRMr)(xtp0[i][r]+xtn0[i][r])*IKVC[i][r]
							+sum(i in NIKLr,r in NRLr)(xtpl0[i][r]+xtnl0[i][r])*IKLVC[i][r];
	sv_cst == sum(n in NNDr)z0[ZIT[2]][n];
	cx_cst == sum(r in NRGr)ze[r]*CTAX[r];

	forall(n in NNDr) fxnk_cst[n] == sum(i in NNKr)xnnk[i][n]*NKCC[i][n];
	forall(r in NRMr) fxik_cst[r] == sum(i in NIKr)xnik[i][r]*IKCC[i][r];
	forall(r in NRLr) fxikl_cst[r]== sum(i in NIKLr)xnikl[i][r]*IKLCC[i][r];

	//CO2 emissions
	forall(r in NRGr) eqcx[r]:sum(n in NNDr)RGD[n][r]*z0[ZIT[3]][n] == ze[r];
	forall(r in NRGr) if(RGE_D[CASE*NRG+r][Yr]!=-1) eqcx2[r]:ze[r] <= RGE_D[CASE*NRG+r][Yr];

	//item balances
	forall(i in NACr,n in NNDr) 
		if(ID_ACM[i]!=0) xac0[i][n] == sum(d in NDYr,w in NWRr,t in NTMr) xac2[ACTC1[i]][n][d][w][t];
		
	forall(i in NACr,r in NRGr)
		if(AC_LMT[i][r]>=0) sum(n in NNDr)RGD[n][r]*xac0[i][n] <= AC_LMT[i][r];	

	forall(i in NITr,n in NNDr){
		if(ID_ITM[i] == 0){
			eqit0[i][n]:sum(m in ACSL[i]..ACSL[i+1]-1) ACCO[m][n]*xac0[ACVR[m]][n] == z0[i][n];
			if(ID_SIG[i]=="E")		z0[i][n] == RHS0[i][n];
			else if(ID_SIG[i]=="G")	z0[i][n] >= RHS0[i][n];
			else if(ID_SIG[i]=="L")	z0[i][n] <= RHS0[i][n];
			else if(ID_SIG[i]=="CL")if(ID_NDTY[n]!=0) z0[i][n] <= RHS0[i][n];
		}		
		else z0[i][n] == sum(d in NDYr,w in NWRr,t in NTMr)z2[ITMC1[i]][n][d][w][t];			
	}	


	forall(i in NIT2r,n in NNDr,d in NDYr,w in NWRr,t in NTMr){
		eqit2[i][n][d][w][t]:sum(m in ACSL[ITMC2[i]]..ACSL[ITMC2[i]+1]-1)ACCO1[m][n]*xac0[ACVR[m]][n]*DTW[w] 
																				+ a2[i][n][d][w][t] == z2[i][n][d][w][t];

		if(AC2FLG[i]!=0) a2[i][n][d][w][t] == sum(m in ACSL2[i]..ACSL2[i+1]-1)ACCO2[m][n]*xac2[ACVR2[m]][n][d][w][t];
		else			 a2[i][n][d][w][t] == 0;

		if(ID_SIG[ITMC2[i]]=="E")		z2[i][n][d][w][t] == RHS2[i][n][d][w][t];
		else if(ID_SIG[ITMC2[i]]=="G")	z2[i][n][d][w][t] >= RHS2[i][n][d][w][t];
		else if(ID_SIG[ITMC2[i]]=="L")	z2[i][n][d][w][t] <= RHS2[i][n][d][w][t];
		else if(ID_SIG[ITMC2[i]]=="CL") if(ID_NDTY[n]!=0) z2[i][n][d][w][t] <= RHS2[i][n][d][w][t];
	}	


	//inter-nodal balance
	forall(i in NIKr,n in NNDr)
		if(IKTY[i]==0){
			xac0[IKF[0][i]][n] == sum(r in NRMr)(xtp0[i][r]*MAT[0][r][n]+xtn0[i][r]*MAT[1][r][n])*IKEF[i][r];
			xac0[IKF[1][i]][n] == sum(r in NRMr)(xtp0[i][r]*MAT[1][r][n]+xtn0[i][r]*MAT[0][r][n]);
			if(IKF[2][i]!=-1) xac0[IKF[2][i]][n] == sum(r in NRMr)(xtp0[i][r]*MAT[0][r][n]+xtn0[i][r]*MAT[1][r][n])*(1.-IKEF[i][r]);
		}		

	forall(i in NIKLr,n in NNDr)
		if(IKLTY[i]==0){
			xac0[IKLF[0][i]][n] == sum(r in NRLr)(xtpl0[i][r]*MATL[0][r][n]+xtnl0[i][r]*MATL[1][r][n])*IKLEF[i][r];
			xac0[IKLF[1][i]][n] == sum(r in NRLr)(xtpl0[i][r]*MATL[1][r][n]+xtnl0[i][r]*MATL[0][r][n]);
			if(IKLF[2][i]!=-1) xac0[IKLF[2][i]][n] == sum(r in NRLr)(xtpl0[i][r]*MATL[0][r][n]+xtnl0[i][r]*MATL[1][r][n])*(1.-IKLEF[i][r]);
		}		

	forall(i in NIKr,n in NNDr,d in NDYr,w in NWRr,t in NTMr){
		if(IKTY[i]!=0){
			//For8760Model
			xac2[IKF2[0][i]][n][d][w][t] == 
					sum(r in NRMr)(	sum(z in TZr)TZW[ID_NDTM[n]][ID_NDTM[IK_DKI[0][r]]][z]*xtp2[i][r][TZD[ID_NDTM[n]][d][t][ID_NDTM[IK_DKI[0][r]]][z]][TZT[ID_NDTM[n]][t][ID_NDTM[IK_DKI[0][r]]][z]]*MAT[0][r][n] 
									+ xtn2[i][r][d][t]*MAT[1][r][n]	)*IKEF[i][r]*ID_WRP[w];
			xac2[IKF2[1][i]][n][d][w][t] == 
					sum(r in NRMr)(	xtp2[i][r][d][t]*MAT[1][r][n] 
									+ sum(z in TZr)TZW[ID_NDTM[n]][ID_NDTM[IK_DKI[0][r]]][z]*xtn2[i][r][TZD[ID_NDTM[n]][d][t][ID_NDTM[IK_DKI[0][r]]][z]][TZT[ID_NDTM[n]][t][ID_NDTM[IK_DKI[0][r]]][z]]*MAT[0][r][n]	)*ID_WRP[w];
			if(IKF2[2][i]!=-1) xac2[IKF2[2][i]][n][d][w][t] == 
					sum(r in NRMr)(	sum(z in TZr)TZW[ID_NDTM[n]][ID_NDTM[IK_DKI[0][r]]][z]*xtp2[i][r][TZD[ID_NDTM[n]][d][t][ID_NDTM[IK_DKI[0][r]]][z]][TZT[ID_NDTM[n]][t][ID_NDTM[IK_DKI[0][r]]][z]]*MAT[0][r][n] 
									+ xtn2[i][r][d][t]*MAT[1][r][n]	)*(1.-IKEF[i][r])*ID_WRP[w];
		}		
	}	

	forall(i in NIKLr,n in NNDr,d in NDYr,w in NWRr,t in NTMr){
		if(IKLTY[i]!=0){
			//For8760Model
			xac2[IKLF2[0][i]][n][d][w][t] == 
					sum(r in NRLr)(	sum(z in TZr)TZW[ID_NDTM[n]][ID_NDTM[IKL_DKI[0][r]]][z]*xtpl2[i][r][TZD[ID_NDTM[n]][d][t][ID_NDTM[IKL_DKI[0][r]]][z]][TZT[ID_NDTM[n]][t][ID_NDTM[IKL_DKI[0][r]]][z]]*MATL[0][r][n] 
								   	+ xtnl2[i][r][d][t]*MATL[1][r][n]	)*IKLEF[i][r]*ID_WRP[w];
			xac2[IKLF2[1][i]][n][d][w][t] == 
					sum(r in NRLr)(	xtpl2[i][r][d][t]*MATL[1][r][n] 
									+ sum(z in TZr)TZW[ID_NDTM[n]][ID_NDTM[IKL_DKI[0][r]]][z]*xtnl2[i][r][TZD[ID_NDTM[n]][d][t][ID_NDTM[IKL_DKI[0][r]]][z]][TZT[ID_NDTM[n]][t][ID_NDTM[IKL_DKI[0][r]]][z]]*MATL[0][r][n]  )*ID_WRP[w];
			if(IKLF2[2][i]!=-1) xac2[IKLF2[2][i]][n][d][w][t] == 
					sum(r in NRLr)(	sum(z in TZr)TZW[ID_NDTM[n]][ID_NDTM[IKL_DKI[0][r]]][z]*xtpl2[i][r][TZD[ID_NDTM[n]][d][t][ID_NDTM[IKL_DKI[0][r]]][z]][TZT[ID_NDTM[n]][t][ID_NDTM[IKL_DKI[0][r]]][z]]*MATL[0][r][n] 
								   	+ xtnl2[i][r][d][t]*MATL[1][r][n]	)*(1.-IKLEF[i][r])*ID_WRP[w];
		}		
	}		

	forall(i in NIKr,r in NRMr){
		if(IKTY[i]!=0){
			xtp0[i][r] == sum(d in NDYr,t in NTMr)xtp2[i][r][d][t];
			xtn0[i][r] == sum(d in NDYr,t in NTMr)xtn2[i][r][d][t];
		}		
	}	
	
	forall(i in NIKLr,r in NRLr){
		if(IKLTY[i]!=0){
		  	xtpl0[i][r] == sum(d in NDYr,t in NTMr)xtpl2[i][r][d][t];
			xtnl0[i][r] == sum(d in NDYr,t in NTMr)xtnl2[i][r][d][t];
		}
	}	

	forall(i in NIKr,r in NRMr,d in NDYr,t in NTMr){
		if(IKTY[i]==0){
		  	xtp2[i][r][d][t] == xtp0[i][r]*DT;
			xtn2[i][r][d][t] == xtn0[i][r]*DT;
		}		
	}	

	forall(i in NIKLr,r in NRLr,d in NDYr,t in NTMr){
		if(IKLTY[i]==0){
			xtpl2[i][r][d][t] == xtpl0[i][r]*DT;
			xtnl2[i][r][d][t] == xtnl0[i][r]*DT;
		}		
	}	

	//inter-nodal facility
	forall(i in NIKr,r in NRMr)
		if(IKTY[i]==0) xtp0[i][r] + xtn0[i][r] <= xik[i][r]*IKAF[i][r];

	forall(i in NIKr,r in NRMr,d in NDYr,t in NTMr)//maritime transport (activity type != 0)
		if(IKTY[i]!=0) xtp2[i][r][d][t]+xtn2[i][r][d][t] <= xik[i][r]*IKAF[i][r]*DT;
	
	forall(i in NIKLr,r in NRLr)
		if(IKLTY[i]==0) xtpl0[i][r] + xtnl0[i][r] <= xikl[i][r]*IKLAF[i][r];

	forall(i in NIKLr,r in NRLr,d in NDYr,t in NTMr)//land transport (activity type != 0)
		if(IKLTY[i]!=0) xtpl2[i][r][d][t]+xtnl2[i][r][d][t] <= xikl[i][r]*IKLAF[i][r]*DT;


	//resource constraints	//depletable if(RST0(i)=0) //renewables if(RST0(i)!=0)
	forall(i in NRSr,n in NNDr)
		if(RSD0[i][n]>=0 && RST0[i]==0) RD_RS[n][i] + z0[RSF0[i]][n]*DepResource <= RSD0[i][n];

	forall(i in NRSr,n in NNDr)
		if(RSD0[i][n]>=0 && RST0[i]!=0) z0[RSF0[i]][n] <= RSD0[i][n];

	//plant output constraint
	forall(i in NNKr,n in NNDr)
		if(NKTY[i]==0) sum(j in NKSL[i]..NKSL[i+1]-1) xac0[NKVR[j]][n] <= xnk[i][n]*NKAF[i][n];

	forall(i in NK[22][0]..NK[22][1],n in NNDr,d in NDYr,w in NWRr,t in NTMr)
		sum(m in NKSL[i]..NKSL[i+1]-1) xac2[NKVR2[m]][n][d][w][t] <= xnk[i][n]*NKAF2[i][n][d][w][t]*DTW[w]; //solar wind

	forall(i in NNKr,n in NNDr,d in NDYr,w in NWRr,t in NTMr)
		if(NKTY[i] == 1){
			sum(m in NKSL[i]..NKSL[i+1]-1) xac2[NKVR2[m]][n][d][w][t] <= xnk[i][n]*NKAF2[i][n][d][w][t]*DTW[w];}
		else if(NKTY[i] == 2){
			sum(m in NKSL[i]..NKSL[i+1]-1) xac2[NKVR2[m]][n][d][w][t] <= ank[NKOPI[i]][n][d]*NKAF2[i][n][d][w][t]*DTW[w];}

	//operational constraints(power plants)
	forall(i in NNKOPr,n in NNDr){
		//available capacity
		forall(d in NDYr) ank[i][n][d] <= xnk[NK_OPI[i]][n]*NKCF[NK_OPI[i]][n][0];

		forall(d in NDYr,w in NWRr,t in NTMr)
			xmx2[i][n][d]*(NKAF2[NK_OPI[i]][n][d][w][t]*DTW[w]) >= sum(m in NKSL[NK_OPI[i]]..NKSL[NK_OPI[i]+1]-1)xac2[NKVR2[m]][n][d][w][t];
		forall(d in NDYr,w in NWRr,t in NTMr)
			sum(m in NKSL[NK_OPI[i]]..NKSL[NK_OPI[i]+1]-1) xac2[NKVR2[m]][n][d][w][t] >= (xmx2[i][n][d]-NKMO[i][0]*ank[i][n][d])*NKMO[i][1]*NKAF2[NK_OPI[i]][n][d][w][t]*DTW[w];

		//ramping capability for power plants
		forall(m in NKSL[NK_OPI[i]]..NKSL[NK_OPI[i]+1]-1, w in NWRr){
			xac2[NKVR2[m]][n][0][w][0] <= xac2[NKVR2[m]][n][NDY-1][w][NTM-1]+ank[i][n][NDY-1]*NKAF2[NK_OPI[i]][n][NDY-1][w][NTM-1]*DTW[w]*NKRU[i];
			xac2[NKVR2[m]][n][0][w][0] >= xac2[NKVR2[m]][n][NDY-1][w][NTM-1]-ank[i][n][NDY-1]*NKAF2[NK_OPI[i]][n][NDY-1][w][NTM-1]*DTW[w]*NKRD[i];

			forall(d in 1..NDY-1){
				xac2[NKVR2[m]][n][d][w][0] <= xac2[NKVR2[m]][n][d-1][w][NTM-1]+ank[i][n][d-1]*NKAF2[NK_OPI[i]][n][d-1][w][NTM-1]*DTW[w]*NKRU[i];
				xac2[NKVR2[m]][n][d][w][0] >= xac2[NKVR2[m]][n][d-1][w][NTM-1]-ank[i][n][d-1]*NKAF2[NK_OPI[i]][n][d-1][w][NTM-1]*DTW[w]*NKRD[i];
 			}			

			forall(d in NDYr,t in 1..NTM-1){
				xac2[NKVR2[m]][n][d][w][t] <= xac2[NKVR2[m]][n][d][w][t-1]+ank[i][n][d]*NKAF2[NK_OPI[i]][n][d][w][t-1]*DTW[w]*NKRU[i];
				xac2[NKVR2[m]][n][d][w][t] >= xac2[NKVR2[m]][n][d][w][t-1]-ank[i][n][d]*NKAF2[NK_OPI[i]][n][d][w][t-1]*DTW[w]*NKRD[i];
 			}
		}
	}	

	//electricity storage balance
	//balance between t and t-1
	forall(n in NNDr, w in NWRr){
		//For 8760 Model
		xac2[ACTC1[AC[5][0]]][n][0][w][0] == xac2[ACTC1[AC[5][1]]][n][NDY-1][w][NTM-1];
		xac2[ACTC1[AC[6][0]]][n][0][w][0] == xac2[ACTC1[AC[6][1]]][n][NDY-1][w][NTM-1];
		xac2[ACTC1[AC[7][0]]][n][0][w][0] == xac2[ACTC1[AC[7][1]]][n][NDY-1][w][NTM-1];
		xac2[ACTC1[AC[8][0]]][n][0][w][0] == xac2[ACTC1[AC[8][1]]][n][NDY-1][w][NTM-1];

		forall(d in 1..NDY-1){
			xac2[ACTC1[AC[5][0]]][n][d][w][0] == xac2[ACTC1[AC[5][1]]][n][d-1][w][NTM-1];
			xac2[ACTC1[AC[6][0]]][n][d][w][0] == xac2[ACTC1[AC[6][1]]][n][d-1][w][NTM-1];
			xac2[ACTC1[AC[7][0]]][n][d][w][0] == xac2[ACTC1[AC[7][1]]][n][d-1][w][NTM-1];
			xac2[ACTC1[AC[8][0]]][n][d][w][0] == xac2[ACTC1[AC[8][1]]][n][d-1][w][NTM-1];
		}		

		forall(d in NDYr,t in 1..NTM-1){
			xac2[ACTC1[AC[5][0]]][n][d][w][t] == xac2[ACTC1[AC[5][1]]][n][d][w][t-1];
			xac2[ACTC1[AC[6][0]]][n][d][w][t] == xac2[ACTC1[AC[6][1]]][n][d][w][t-1];
		    xac2[ACTC1[AC[7][0]]][n][d][w][t] == xac2[ACTC1[AC[7][1]]][n][d][w][t-1];
		    xac2[ACTC1[AC[8][0]]][n][d][w][t] == xac2[ACTC1[AC[8][1]]][n][d][w][t-1];
		}		

		//energy capacity constraint
		forall(d in NDYr,t in NTMr){
			xac2[ACTC1[AC[5][1]]][n][d][w][t]*NKSF[w] <= xnk[NK[24][0]][n]*Duration_Pumped;
			xac2[ACTC1[AC[6][1]]][n][d][w][t]*NKSF[w] <= xnk[NK[25][1]][n]*Unit_Liion;
			xac2[ACTC1[AC[7][1]]][n][d][w][t]*NKSF[w] <= xnk[NK[26][1]][n]*Unit_Molten;
			xac2[ACTC1[AC[8][1]]][n][d][w][t]*NKSF[w] <= xnk[NK[27][1]][n]*Unit_H2;
		}		
	}

	//international electricity net imports
	forall(r in RGEI[0]..RGEI[1]) sum(n in NNDr)RGD[n][r]*z0[ZIT[7]][n] == zelcim[r];
	forall(r in RGEI[0]..RGEI[1]) sum(n in NNDr)RGD[n][r]*z0[ZIT[4]][n] == ztec[r];
	forall(r in RGEI[0]..RGEI[1]) if(Elec_Import!=-1) zelcim[r] <= Elec_Import*(zelcim[r]+ztec[r]);

	//power capacity constraint for battery
	forall(n in NNDr){
		xnk[NK[25][0]][n] <= xnk[NK[25][1]][n]*CRate_Liion;
	}	

	//BEV charging activity
	forall(n in NNDr,d in NDYr,w in NWRr)
		z0[ZIT[5]][n] + z0[ZIT[6]][n] == sum(t in NTMr)xac2[ACTC1[AC[9][0]]][n][d][w][t]/DTW2[w];

	//energy saving constraint
	forall(i in NFCr,n in NNDr){
		eqsv[i][n]:sum(j in FCS[1][i]..FCS[2][i])xac0[j][n] == xac0[FCS[0][i]][n];
		if(CASE == 0) forall(j in FCS[1][i]..FCS[2][i]) xac0[j][n] == 0;
	}	

	//nodal facilities
	forall(i in NNKr,n in NNDr){
		if(Yr>0){
			xnk[i][n] == NKEK[i][n] + sum(y2 in 0..Yr-1)RDNK[i][n][y2]*NKLF[i][y2][Yr] + xnnk[i][n]; }		
		else{
			xnk[i][n] == NKEK[i][n] + xnnk[i][n]; }
	}	

	forall(i in NNKr,n in NNDr)
		if(NKMK[i][n]!=-1) eqnk[i][n]:xnk[i][n] <= NKMK[i][n];

	//electricity reserve margin constraint
	forall(n in NNDr,d in NDYr,w in NWRr,t in NTMr)
		if(ReserveMargin!=-1) sum(i in NNKOPr)ank[i][n][d]*NKAF2[NK_OPI[i]][n][d][w][t] 
								+ sum(i in NK[21][0]..NK[21][1])xnk[i][n]*NKAF2[i][n][d][w][t] 
								+ sum(i in NKSt1..NKSt2)xnk[NK[i][0]][n]*NKAF2[NK[i][0]][n][d][w][t] 
								>= z2[ITMC1[ZIT[4]]][n][d][w][t]*ReserveMargin/DTW[w];


	//transport fueling station
	forall(i in 0..NK[10][1]-NK[10][0],n in NNDr)
		sum(j in NK[11+i][0]..NK[11+i][1])xnk[j][n]
					+sum(m in NK[16+i][0]..NK[16+i][1])xnk[m][n] <= FuelingStationCov*xnk[NK[10][0]+i][n];

	//maritime trade
	forall(i in NIKr){
		if(Yr>0) sum(r in NRMr)xeik[i][r] == sum(r in NRMr)(IKEK[i][r] + sum(y2 in 0..Yr-1)RDNIK[i][r][y2]*IKLFM[i][y2][Yr]);
		else  forall(r in NRMr)xeik[i][r] == IKEK[i][r]; 
	}	

	forall(i in NIKr, r in NRMr) xik[i][r] == xeik[i][r] + xnik[i][r];

	forall(i in NIKr,r in NRMr)
		if(IKMK[i][r]!=-1)	eqik[i][r]:xik[i][r] <= IKMK[i][r];

	forall(i in NIKr,r in NRMr)
		if(IKFG[i][r]==0)	xik[i][r] == 0;

	//land trade
	forall(i in NIKLr,r in NRLr){
		if(Yr>0) xikl[i][r] == IKLEK[i][r] + sum(y2 in 0..Yr-1)RDNIKL[i][r][y2]*IKLLFM[i][y2][Yr] + xnikl[i][r];
		else xikl[i][r] == IKLEK[i][r] + xnikl[i][r];
	}	

	forall(i in NIKLr,r in NRLr)
		if(IKLMK[i][r]!=-1)	eqikl[i][r]:xikl[i][r] <= IKLMK[i][r];

	forall(i in NIKLr,r in NRLr)
		if(IKLFG[i][r]==0)	xikl[i][r] == 0;

}



//result exports
int	OTH = 8;		
int	CPR = 8;


//Result summary file
string	ID_NDRG[0..NND+NRG-1];
string	R_Z0L[0..(OTH+NIT)*(NND+NRG)-1];
float	R_Z0[0..(OTH+NIT)*(NND+NRG)-1];
string	R_ACL[0..NAC*(NND+NRG)-1];
float	R_AC[0..NAC*(NND+NRG)-1];
string	R_NKL[0..NNK*(NND+NRG)-1];
float	R_NK[0..NNK*(NND+NRG)-1];
string	R_ZL_Dual[0..NND*NIT-1];
float	R_Z_Dual[0..NND*NIT-1];

//Result each-year file
string	R_ACL2[0..NAC2*NoND-1];
float	R_AC2[0..NAC2*NoND-1][0..NoDY*NWR*NTM-1];

//report write
execute reportwrite{
  	var i,y,y2,r,r1,n1,v;
	writeln("reportwrite:started");
  
  	if(Yr==0)for(i=0;i<COST*(NND+NRG);i++)for(y=0;y<NYR;y++) R_COST[i][y]=0.;
  
	for(r1 in NRGr){
		ID_NDRG[r1]=ID_RG[r1];
		R_Z0L[0+r1*(OTH+NIT)+NND*(OTH+NIT)]=ID_RG[r1]+"-"+"FXC_IK";
		R_Z0L[1+r1*(OTH+NIT)+NND*(OTH+NIT)]=ID_RG[r1]+"-"+"FXC_NK";
		R_Z0L[2+r1*(OTH+NIT)+NND*(OTH+NIT)]=ID_RG[r1]+"-"+"FXC_BT";
		R_Z0L[3+r1*(OTH+NIT)+NND*(OTH+NIT)]=ID_RG[r1]+"-"+"FXC_SPG";
		R_Z0L[4+r1*(OTH+NIT)+NND*(OTH+NIT)]=ID_RG[r1]+"-"+"FXC_WND";
		R_Z0L[5+r1*(OTH+NIT)+NND*(OTH+NIT)]=ID_RG[r1]+"-"+"FXC_DV";
		R_Z0L[6+r1*(OTH+NIT)+NND*(OTH+NIT)]=ID_RG[r1]+"-"+"OVC_IK";
		R_Z0L[CPR-1+r1*(OTH+NIT)+NND*(OTH+NIT)]=ID_RG[r1]+"-"+"CPR";	  
		for(i in NITr) R_Z0L[OTH+i+r1*(OTH+NIT)+NND*(OTH+NIT)]=ID_RG[r1]+"-"+ID_IT[i];

		R_COSTL[0+r1*COST+NND*COST]=ID_RG[r1]+"-"+"FXC_IK";
		R_COSTL[1+r1*COST+NND*COST]=ID_RG[r1]+"-"+"FXC_NK";
		R_COSTL[2+r1*COST+NND*COST]=ID_RG[r1]+"-"+"FXC_BT";
		R_COSTL[3+r1*COST+NND*COST]=ID_RG[r1]+"-"+"FXC_SPG";
		R_COSTL[4+r1*COST+NND*COST]=ID_RG[r1]+"-"+"FXC_WND";
		R_COSTL[5+r1*COST+NND*COST]=ID_RG[r1]+"-"+"FXC_DV";
	}
		
	for(n1 in NNDr){
		ID_NDRG[n1+NRG]=ID_ND[n1];
		R_Z0L[0+n1*(OTH+NIT)]=ID_ND[n1]+"-"+"FXC_IK";
		R_Z0L[1+n1*(OTH+NIT)]=ID_ND[n1]+"-"+"FXC_NK";
		R_Z0L[2+n1*(OTH+NIT)]=ID_ND[n1]+"-"+"FXC_BT";
		R_Z0L[3+n1*(OTH+NIT)]=ID_ND[n1]+"-"+"FXC_SPG";
		R_Z0L[4+n1*(OTH+NIT)]=ID_ND[n1]+"-"+"FXC_WND";
		R_Z0L[5+n1*(OTH+NIT)]=ID_ND[n1]+"-"+"FXC_DV";
		R_Z0L[6+n1*(OTH+NIT)]=ID_ND[n1]+"-"+"OVC_IK";
		R_Z0L[CPR-1+n1*(OTH+NIT)]=ID_ND[n1]+"-"+"CPR";	  
		for(i in NITr) R_Z0L[OTH+i+n1*(OTH+NIT)]=ID_ND[n1]+"-"+ID_IT[i];

		R_COSTL[0+n1*COST]=ID_ND[n1]+"-"+"FXC_IK";
		R_COSTL[1+n1*COST]=ID_ND[n1]+"-"+"FXC_NK";
		R_COSTL[2+n1*COST]=ID_ND[n1]+"-"+"FXC_BT";
		R_COSTL[3+n1*COST]=ID_ND[n1]+"-"+"FXC_SPG";
		R_COSTL[4+n1*COST]=ID_ND[n1]+"-"+"FXC_WND";
		R_COSTL[5+n1*COST]=ID_ND[n1]+"-"+"FXC_DV";
	}

	

	for(r in NRMr){
		//FXC_IK
		R_Z0[0+IK_DKI[0][r]*(OTH+NIT)]+=fxik_cst[r]*0.5;
		R_Z0[0+IK_DKI[1][r]*(OTH+NIT)]+=fxik_cst[r]*0.5;

		for(y=Yr;y<NYR;y++)for(i in NIKr){
	 		R_COST[0+IK_DKI[0][r]*COST][y]+=xnik[i][r]*IKCC[i][r]*IKLFM[i][Yr][y]*0.5;
			R_COST[0+IK_DKI[1][r]*COST][y]+=xnik[i][r]*IKCC[i][r]*IKLFM[i][Yr][y]*0.5;		
		}		

		//OVC_IK
		for(i in NIKr){
			R_Z0[6+IK_DKI[0][r]*(OTH+NIT)]+=(xtp0[i][r]+xtn0[i][r])*IKVC[i][r]*0.5;
			R_Z0[6+IK_DKI[1][r]*(OTH+NIT)]+=(xtp0[i][r]+xtn0[i][r])*IKVC[i][r]*0.5;
 		} 		
	}

	for(r in NRLr){
		//FXC_IK
		R_Z0[0+IKL_DKI[0][r]*(OTH+NIT)]+=fxikl_cst[r]*0.5;
		R_Z0[0+IKL_DKI[1][r]*(OTH+NIT)]+=fxikl_cst[r]*0.5;

		for(y=Yr;y<NYR;y++)for(i in NIKLr){
	 		R_COST[0+IKL_DKI[0][r]*COST][y]+=xnikl[i][r]*IKLCC[i][r]*IKLLFM[i][Yr][y]*0.5;
			R_COST[0+IKL_DKI[1][r]*COST][y]+=xnikl[i][r]*IKLCC[i][r]*IKLLFM[i][Yr][y]*0.5;		
		}		

		//OVC_IK
		for(i in NIKLr){
			R_Z0[6+IKL_DKI[0][r]*(OTH+NIT)]+=(xtpl0[i][r]+xtnl0[i][r])*IKLVC[i][r]*0.5;
			R_Z0[6+IKL_DKI[1][r]*(OTH+NIT)]+=(xtpl0[i][r]+xtnl0[i][r])*IKLVC[i][r]*0.5;
 		}			
	}		

	for(n1 in NNDr){
		//total nk
		R_Z0[1+n1*(OTH+NIT)]=fxnk_cst[n1];
		for(y=Yr;y<NYR;y++)for(i in NNKr) R_COST[1+n1*COST][y]+=xnnk[i][n1]*NKCC[i][n1]*NKLF[i][Yr][y];

		//battery
		v = 0.;
		for(i=NKSt1+1;i<=NKSt2;i++)	v += xnnk[NK[i][1]][n1]*NKCC[NK[i][1]][n1];
		R_Z0[2+n1*(OTH+NIT)]=v;
		for(y=Yr;y<NYR;y++)for(i=NKSt1+1;i<=NKSt2;i++) R_COST[2+n1*COST][y]+=xnnk[NK[i][1]][n1]*NKCC[NK[i][1]][n1]*NKLF[NK[i][1]][Yr][y];

		//solar power
		R_Z0[3+n1*(OTH+NIT)] = xnnk[NK[22][0]][n1]*NKCC[NK[22][0]][n1];
		for(y=Yr;y<NYR;y++) R_COST[3+n1*COST][y]+=xnnk[NK[22][0]][n1]*NKCC[NK[22][0]][n1]*NKLF[NK[22][0]][Yr][y];

		//wind power
		v = 0.
		for(i=NK[22][0]+1;i<=NK[22][1];i++)	v += xnnk[i][n1]*NKCC[i][n1];
 		R_Z0[4+n1*(OTH+NIT)]=v;
		for(y=Yr;y<NYR;y++)for(i=NK[22][0]+1;i<=NK[22][1];i++) R_COST[4+n1*COST][y]+=xnnk[i][n1]*NKCC[i][n1]*NKLF[i][Yr][y];

		//road transport vehicle
		v = 0.;
		for(i=NK[11][0];i<=NK[20][1];i++) v += xnnk[i][n1]*NKCC[i][n1];
		R_Z0[5+n1*(OTH+NIT)]=v;
		for(y=Yr;y<NYR;y++)for(i=NK[11][0];i<=NK[20][1];i++) R_COST[5+n1*COST][y]+=xnnk[i][n1]*NKCC[i][n1]*NKLF[i][Yr][y];

		R_Z0[CPR-1+n1*(OTH+NIT)]=0;

		for(i in NITr) R_Z0[OTH+i+n1*(OTH+NIT)]=z0[i][n1];

		for(i in NACr){
			R_ACL[i+n1*NAC]=ID_ND[n1]+"-"+ID_AC[i];
			R_AC[i+n1*NAC]=xac0[i][n1];
		}			

		for(i in NNKr){
			R_NKL[i+n1*NNK]=ID_ND[n1]+"-"+ID_NK[i];
			R_NK[i+n1*NNK]=xnk[i][n1];
 		}			
 		
	}		


	if(OUT_YR[Yr]==1){
		for(n1 in NoNDr){
			for(i in NAC2r){
				R_ACL2[i+n1*NAC2]=ID_ND[OUT_ND[n1]]+"-"+ID_AC[ACTC2[i]];
				for(d in NoDYr)for(w in NWRr)for(t in NTMr) R_AC2[i+n1*NAC2][t+w*NTM+d*NWR*NTM]=xac2[i][OUT_ND[n1]][OUT_DY[d]][w][t]/8.76/DTW[w];
 			}			
		}	
	}	

	//RecursiveDynamic:Capacity
 	for(i=0;i<RD[0][0];i++) RD_NKD[i][Yr]=xnnk[RD_NK[i][1]][RD_NK[i][0]];
 	for(i=0;i<RD[2][0];i++) RD_IKD[i][Yr]=xnik[RD_IK[i][1]][RD_IK[i][0]];
 	for(i=0;i<RD[4][0];i++) RD_IKLD[i][Yr]=xnikl[RD_IKL[i][1]][RD_IKL[i][0]]; 	
	for(n in NNDr)for(i in NRSr) if(RSD0[i][n]>=0 && RST0[i]==0) RD_RS[n][i]+=z0[RSF0[i]][n]*ID_YRD[Yr];
	
	//marginal cost
	for(n1 in NNDr)for(i in NITr){
	  	R_ZL_Dual[i+n1*NIT]=ID_ND[n1]+"-"+ID_IT[i];

		if(ID_ITM[i]==0){
			R_Z_Dual[i+n1*NIT]=eqit0[i][n1].dual;
		}			
		else{
			v=0.;
			v2=0.;
			for(d in NDYr)for(w in NWRr)for(t in NTMr){
				v2 = eqit2[ITMC1[i]][n1][d][w][t].dual;
				v += v2*DTW[w];
 			}				
		  	R_Z_Dual[i+n1*NIT]= v;
 		}			
	}

	if(CASE==0) for(n1 in NNDr)for(i in NFCr) FCD_2[n1+Yr*NND][i]=eqsv[i][n1].dual;
	else for(n1 in NNDr)for(i in NFCr) FCD_2[n1+Yr*NND][i]=FCD_2[n1+Yr*NND][i];

	//aggregated results by region
	for(r1 in NRGr){
		for(i=0;i<OTH+NIT;i++){
			v=0.;
			if(i==CPR-1) v=-eqcx[r1].dual;
			else for(n1 in NNDr) v+=RGD[n1][r1]*R_Z0[i+n1*(OTH+NIT)];				
			R_Z0[i+r1*(OTH+NIT)+NND*(OTH+NIT)]=v;
		}	
		
		for(i=0;i<COST;i++)for(y=Yr;y<NYR;y++){
			v=0.;
			for(n1 in NNDr) v+=RGD[n1][r1]*R_COST[i+n1*COST][y];
			R_COST[i+r1*COST+NND*COST][y]=v;
		}		

		for(i in NACr){
			R_ACL[i+r1*NAC+NND*NAC]=ID_RG[r1]+"-"+ID_AC[i];
			v=0.;
			for(n1 in NNDr) v+=RGD[n1][r1]*xac0[i][n1];
			R_AC[i+r1*NAC+NND*NAC]=v;
		}			

		for(i in NNKr){
			R_NKL[i+r1*NNK+NND*NNK]=ID_RG[r1]+"-"+ID_NK[i];
			v=0.;
			for(n1 in NNDr) v+=RGD[n1][r1]*xnk[i][n1];
			R_NK[i+r1*NNK+NND*NNK]=v;
					
		}
	}			
	writeln("reportwrite:finished");
}
