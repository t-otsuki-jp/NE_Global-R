# Global Energy System Model "NE_Global-R"
The New Earth_Global-Recursive model (NE_Global-R) is a recursive-dynamic global energy system model, which was developed by OTSUKI Takashi (Associate Professor, Yokohama National University), KOMIYAMA Ryoichi (Professor, The University of Tokyo), and FUJII Yasumasa (Professor, The University of Tokyo). This linear programming model covers the entire energy sector with an hourly temporal resolution for electricity balances (24 hours for consecutive 365 days) for a total of 100 regions in the world. The analysis period is from 2015 to 2050, with five representative years (2015, 2020, 2030, 2040, and 2050). The reference energy system includes 28 types of primary and secondary energy carriers, as well as 250 technologies or processes for energy production, transformation, transportation, and final consumption. This model is written in OPL (Optimization Programming Language), with 510 million variables and 540 million constraints. RAM requirements are 750GB.

## File description
<li>Main.mod: flow control
<li>NE_GlobalR_Model.mod: model code including variables and constraints
<li>NE_GlobalR.ops: settings file for OPL
<li>NE_GlobalR_Data0.dat: data exchange file for the year 2015
<li>NE_GlobalR_Data1.dat: data exchange file for the year 2020
<li>NE_GlobalR_Data2.dat: data exchange file for the year 2030
<li>NE_GlobalR_Data3.dat: data exchange file for the year 2040
<li>NE_GlobalR_Data4.dat: data exchange file for the year 2050
<li>NE_GlobalR_Input.xlsx: input data file
<li>NE_GlobalR_Output_Summary.xlsx: main output file including annual results
<li>NE_GlobalR_Output2_R0: Hourly level power dispatch results at selected times and nodes in 2015
<li>NE_GlobalR_Output2_R4: Hourly level power dispatch results at selected times and nodes in 2050

## DOI
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7553055.svg)](https://doi.org/10.5281/zenodo.7553055)
  
## License
This work is licensed under a
[Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License][cc-by-nc-nd].

The NE_Global-R model is only for non-commercial use (e.g., academic research at universities).
  
[![CC BY-NC-ND 4.0][cc-by-nc-nd-shield]][cc-by-nc-nd]

[![CC BY-NC-ND 4.0][cc-by-nc-nd-image]][cc-by-nc-nd]

[cc-by-nc-nd]: http://creativecommons.org/licenses/by-nc-nd/4.0/
[cc-by-nc-nd-image]: https://licensebuttons.net/l/by-nc-nd/4.0/88x31.png
[cc-by-nc-nd-shield]: https://img.shields.io/badge/License-CC%20BY--NC--ND%204.0-lightgrey.svg
