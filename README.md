# reorganize-results
## Introduction
Tabulates list of lab results to an n x m array of result where n is the number of patients and m is the number of different study types

The latter is easier to import for statistical analysis.

This is written in ruby

## Format of data file to be imported
```
PATIENT_ID,STUDY_NAME,RESULT_VALUE
1,Hb,9.1
1,Plt,130
1,WBC,2.0
2,Hb,11.1
2,Plt,210
2,WBC,4.0
```

## Format of output
```
PATIENT_ID,Hb,Plt,WBC
1,9.1,130,2.0
2,11.1,210,4.0
```

## Getting started
1. Clone the script main.rb
2. Place in same directory as csv file to be imported
3. Update the filenames
4. Open the terminal
5. run '''ruby main.rb'''
