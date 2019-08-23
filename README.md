# stabflex2019
data and analysis scripts for manuscript: Quantifying the subjective cost of cognitive stability and cognitive flexibility
Included: raw data files, analysis code, analysed data and interactive JASP statistics output files. 


## Installation

Get the code as follows:

If you have git installed, open a terminal and run the following command

git clone https://github.com/danae1968/stabflex2019.git

If you don't have git installed, you can also download the code as a ZIP file.


## Data 
Data files are split in two different experiment folders. Experiment 2 is a direct replication of experiment 1 (28 participants) with a higher sample size (62 participants).

**Colorwheel task data structure:** 

Main data file: ColorFun_s_X.mat, where X is subject number.

	Main variables:

	* data.respDif: absolute deviance from correct color; trial accuracy index
	* data.setsize: trial demand level, number of squares
	* data.type: trial condition; 0 for Ignore, 2 for Update
	* data.rt: trial reaction time; registered mouseclick on colorwheel 

Color sensitivity file: ColorTest_sX.mat

Practice file: ColorFun_sX_practice.mat

**COGED data structure:**

Main data file: ColorFunChoice_sX.mat

	Main variables:

	- data.version: index of COGED version. 1 for task vs no effort choices, 2 for ignore vs update choices
	- data.typeTask: 
	- data.easyOffer: amount of money offered for the presumably easy offer (no redo/effort for version 1 and update for version 2)
	- data.choiceRT: reaction time of choice
	- data.condition: 0 for ignore, 2 for update, only relevant for version 1 choices
	- data.choice: trial choice; 1 for easy offer and 2 for hard offer
	- data.sz: trial demand level, number of squares they are choosing for

Practice file: ColorFunChoice_sX_practice.mat

## Analysis scripts

- Main analysis script: CW_analysis.m; change io.projectDir to the directory you cloned the code into
- Mixed models analysis script: mixedModelsAnalysis.R

Output files: 

**Colorwheel:** 	
	- MedianAccOut.csv & MedianAccOut.jasp: deviance analyses files;
	- MedianRTOut.csv & MedianRTOut.jasp: RT analyses files;
	- performanceRBeh.csv: all data trialwise

**COGED:** 
	- IPmatrixOut.csv & IPmatrixOut.jasp: task versus no effort choice analyses files;
	- IPDirectOut.csv & IPDirectOut.jasp: ignore versus update choice analyses files;
	- choicesRNR.csv: task versus no effort data trialwise;
	- choicesRDir.csv: ignore versus update data trialwise

The above csv file names without the -Out (outlier) ending are the derivative analysis files including outliers.
correlationsIPsPooled.csv & correlationsIPsPooled.jasp: data pooled from both experiments for correlation between performance and preference

## Contact

danaepapadopetraki@gmail.com