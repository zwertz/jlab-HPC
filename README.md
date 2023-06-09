**jlab-HPC** repository contains scripts to submit and run various simulation and analysis jobs for SBS experiments to Jefferson Lab's HPC clusters using the [Scientific Workflow Indefatigable Factotum](https://scicomp.jlab.org/docs/swif2) (SWIF2) system. All the jobs can be chosen to run on ifarm as well for the purpose of debugging.

## Contents
1. Design
2. Processes
3. Prerequisites
4. Quick start
5. Useful SWIF2 commands
6. Contact

## 1. Design: 
There are mainly two different kind of scripts present in this repository: 
1. **Run scripts** (name begins with `run-` keyword): Each of these scripts execute individual processes such as g4sbs simulation, digitization, etc. E.g. `run-g4sbs-simu.sh` executes g4sbs simulation jobs. Users shouldn't have to edit or modify these scripts.
2. **Submit scripts** (name begins with `submit-` keyword): These are essentially wrapper scripts. Every run script has one (or more) corresponding submit script(s). Submit scripts take a few command line arguments and run the corresponding run script(s) accordingly. E.g. `submit-g4sbs-jobs.sh` script executes `run-g4sbs-simu.sh` script, which runs g4sbs simulations, according to the command line arguments (e.g. g4sbs macro name, no. of jobs, etc.) given by the user. They also sets the proper environment variables required by the run scripts. The environment variables are all listed at the beginning of each submit script. Since, environment variables are user specific, a first time user needs to set them properly at the beginning.

## 2. Processes:
Here is a list of processess that can be executed using the scripts present in this repo:
1. raw data reconstruction (replay):
2. g4sbs simulation: ....
3. digitization of simulated data (sbsdig): ....
4. digitized data reconstruction: ....
5. simulation, digitization, & replay in one go (in order): ....
6. simulation using SIMC generator, digitization, & replay in one go (in order): ....

## 3. Prerequisites:
- Most up-to-date build of the following libraries:
  - [simc_gfortran](https://github.com/MarkKJones/simc_gfortran) - Necessary for SIMC simulation jobs. Build from the `bigbite` branch.
  - [g4sbs](https://github.com/JeffersonLab/g4sbs/tree/master) - Necessary for g4sbs simulation jobs. Build from the `uconn_dev` branch.
  - [libsbsdig](https://github.com/JeffersonLab/libsbsdig) - Necessary for digitization (sbsdig) jobs.
  - [analyzer](https://github.com/JeffersonLab/analyzer) - Necessary for replay jobs.
  - [SBS-offline](https://github.com/JeffersonLab/SBS-offline) - Necessary for replay jobs.
  - [SBS-replay](https://github.com/JeffersonLab/SBS-replay) - Necessary for replay jobs.
- `python3` 
 
## 4. Quick start:
....

## 5. Useful SWIF2 commands:
An exhaustive list of all the SWIF2 commands can be found [here](https://scicomp.jlab.org/cli/swif.html). Here is a small list of very useful and common SWIF2 commands:

- `swif2 create <wf_name>` - Creates a SWIF2 workflow with name `wf_name` 
- `swif2 run <wf_name>` - Runs the workflow, `wf_name`
- `swif2 status <wf_name>` - Shows general status of the workflow, `wf_name`
- `swif2 cancel <wf_name> -delete` - Cancels all the jobs in workflow `wf_name` and then deletes it 
- `swif2 retry-jobs <wf_name> -problem <pb_type>` - Reruns all the abandoned jobs in `wf_name` with problem type `pb_type`

## 6. Contact:
In case of any questions or concerns please contact the author(s),
>Authors: Provakar Datta (UConn) <br> 
>Contact: <pdbforce@jlab.org> (Provakar)
