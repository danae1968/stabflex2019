# stabflex2019
data and analysis scripts for manuscript: Quantifying the cost of cognitive stability and flexibility
Included: raw data files, analysis code, derivative data and interactive JASP statistic output files. 


## Installation

Get the data and code as follows:

If you have git installed, open a terminal and run the following command

git clone https://github.com/danae1968/stabflex2019.git

If you don't have git installed, you can also download the code as a ZIP file.


## Completely raw Data 
Data files are split in two different experiment folders. Experiment 2 (62 participants) is a direct replication of experiment 1 (28 participants) with a higher sample size.

**Colorwheel task data structure:** 

	Main data file: ColorFun_s_X.mat, where X is subject number.
	
	Main variables:
	 data.respDif: absolute deviance from correct color; trial accuracy index
	 data.setsize: trial demand level, number of squares
	 data.type: trial condition; 0 for Ignore, 2 for Update
	 data.rt: trial reaction time; registered mouseclick on colorwheel 

	Color sensitivity file: ColorTest_sX.mat
	Practice file: ColorFun_sX_practice.mat

**COGED data structure:**

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

## Analysis scripts
	Main analysis script: CW_analysis.m; change io.projectDir to the directory you cloned the code into
	Mixed models analysis script: mixedModelsAnalysis.R

**Colorwheel output files:** 

	MedianAccOut.csv & MedianAccOut.jasp: deviance analyses files
	MedianRTOut.csv & MedianRTOut.jasp: RT analyses files
	performanceRBeh.csv: performance raw data in a matrix per trial

**COGED output files:** 

	IPmatrixOut.csv & IPmatrixOut.jasp: task versus no effort choice analyses files
	IPDirectOut.csv & IPDirectOut.jasp: ignore versus update choice analyses files
	choicesRNR.csv: task versus no effort raw data in a matrix trialwise
	choicesRDir.csv: ignore versus update raw data in a matrix trialwise

The above csv file names without the -Out (outlier) ending are the derivative analysis files including outliers.
correlationsIPsPooled.csv & correlationsIPsPooled.jasp: data pooled from both experiments for correlation between performance and preference

## Contact

danaepapadopetraki@gmail.com
