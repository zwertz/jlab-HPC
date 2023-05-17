**jlab-HPC** repository contains scripts to submit and run various simulation and analysis jobs to Jefferson Lab's HPC clusters using Scientific Workflow Indefatigable Factotum (SWIF2) system. All the jobs can be chosen to run on ifarm as well for the purpose of debugging and convenience.

## Contents
1. Design
2. Prerequisites
3. Quick start
4. Useful SWIF2 commands
5. Contact

## 1. Design: 

## 2. Prerequisites:
 
## 3. Quick start:

## 4. Useful SWIF2 commands:
- `swif2 create <wf_name>` - Creates a SWIF2 workflow with name `wf_name` 
- `swif2 run <wf_name>` - Runs the workflow, `wf_name`
- `swif2 status <wf_name>` - Shows general status of the workflow, `wf_name`
- `swif2 cancel <wf_name> -delete` - Cancels all the jobs in workflow `wf_name` and then deletes it 

## 5. Contact:
In case of any questions or concerns please contact the authors,
>Authors: Provakar Datta (UConn) <br> 
>Contact: <pdbforce@jlab.org> (Provakar)
