**jlab-HPC** repository contains scripts to submit and run various simulation and analysis jobs to Jefferson Lab's HPC clusters using the [Scientific Workflow Indefatigable Factotum](https://scicomp.jlab.org/docs/swif2) (SWIF2) system. All the jobs can be chosen to run on ifarm as well for the purpose of debugging and convenience.

## Contents
1. Design
2. Prerequisites
3. Quick start
4. Useful SWIF2 commands
5. Contact

## 1. Design: 

## 2. Prerequisites:
- Most up-to-date build of the following libraries:
 - [g4sbs]() - Necessary for g4sbs simulation jobs
 - [LIBSBSDIG]() - Necessary for digitization (sbsdig) jobs
 - [analyzer]() - Necessary for replay jobs
 - [SBS-offline]() - Necessary for   
 
## 3. Quick start:

## 4. Useful SWIF2 commands:
An exhaustive list of all the SWIF2 commands can be found [here](https://scicomp.jlab.org/cli/swif.html). Here is a small list of very useful and common SWIF2 commands:

- `swif2 create <wf_name>` - Creates a SWIF2 workflow with name `wf_name` 
- `swif2 run <wf_name>` - Runs the workflow, `wf_name`
- `swif2 status <wf_name>` - Shows general status of the workflow, `wf_name`
- `swif2 cancel <wf_name> -delete` - Cancels all the jobs in workflow `wf_name` and then deletes it 
- `swif2 retry-jobs <wf_name> -problem <pb_type>` - Reruns all the abandoned jobs in `wf_name` with problem type `pb_type`

## 5. Contact:
In case of any questions or concerns please contact the author(s),
>Authors: Provakar Datta (UConn) <br> 
>Contact: <pdbforce@jlab.org> (Provakar)
