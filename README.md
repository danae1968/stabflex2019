# stabflex2019
data and analysis scripts for manuscript: Quantifying the subjective cost of cognitive stability and cognitive flexibility
Included: raw data files, analysis code, analysed data and interactive JASP statistics output files. 

Data files are split in two different experiment folders. Experiment 2 is a direct replication of experiment 1.

Colorwheel task data structure: 

Main data file: ColorFun_s_X.mat, where X is subject number.
	Main variables:
	data.respDif: absolute deviance from correct color; trial accuracy index
	data.setsize: trial demand level, number of squares
	data.type: trial condition; 0 for Ignore, 2 for Update
	data.rt: trial reaction time; registered mouseclick on colorwheel 
Color sensitivity file: ColorTest_sX.mat
Practice file: ColorFun_sX_practice.mat

COGED data structure:

Main data file: ColorFunChoice_sX.mat
	Main variables:
	data.version: index of COGED version. 1 for task vs no effort choices, 2 for ignore vs update choices
	data.typeTask: 
	data.easyOffer: amount of money offered for the presumably easy offer (no redo/effort for version 1 and update for version 2)
	data.choiceRT: reaction time of choice
	data.condition: 0 for ignore, 2 for update, only relevant for version 1 choices
	data.choice: trial choice; 1 for easy offer and 2 for hard offer
	data.sz: trial demand level, number of squares they are choosing for
Practice file: ColorFunChoice_sX_practice.mat

Analysis scripts

Main analysis script: 
