# ------------------------------------------------------------------------- #
# This script will be used to extract info from SIMC infile and generate a  #
# CSV report file with necessary information for normalization per job      #
# after all the jobs are finished .                                         #
# ---------                                                                 #
# P. Datta <pdbforce@jlab.org> CREATED 04-20-2023                           #
# ---------                                                                 #
# ** Do not tamper with this sticker! Log any updates to the script above.  #
# ------------------------------------------------------------------------- #

import sys

def read_file(infile):
    '''Reads a file and returns a list'''
    lines = []
    with open(infile, 'r') as f:
        lines = f.readlines()
    return lines

def grab_param_value(infile, param):
    '''Grabs the value of a chosen parameter from SIMC infile'''
    lines = read_file(infile)
    value = -9999
    for line in lines:
        if param in line:
            temp = line.split(";", 1)[0]
            value = temp.split("=", 1)[1].strip()
    return value

def strip_path(filewpath):
    '''Strips the path to the directory or file'''
    lpos = filewpath.strip('/').rfind('/')
    return filewpath[lpos+1:]

def grab_norm_factors(histfile, title_or_data):
    '''Grabs important normalization factors from SIMC .hist file'''
    # Retain the order of paramters in which they appear in .hist file
    params = ['Ngen (request)', 'Ntried', 'charge', 'genvol', 'normfac', 'Random Seed'] 
    titles = ['jobid', 'Nthrown', 'Ntried', 'charge(mC)', 'genvol(sr)', 'normfac(ub^-1*sr)', 'RndmSeed']
    chars_to_strip = ' mC\n' #charecters to strip from the right side of equality
    if int(title_or_data) != 1:
        values = []
        jobid = histfile.split('_job_', 1)[1].strip('.hist')
        lines = read_file(histfile)
        values.append(jobid)
        for line in lines:
            for item in params:
                if item in line:
                    values.append(line.split("=", 1)[1].strip(chars_to_strip))
                    break
    if int(title_or_data) != 1: 
        return ','.join(str(e) for e in values)
    else: # return the title row
        return ','.join(str(e) for e in titles)
        
def main(*arg):
    '''Calls the function of choice depending on its name'''
    if arg[0] == 'grab_param_value':
        print(grab_param_value(arg[1], arg[2]))
    elif arg[0] == 'grab_norm_factors':
        print(grab_norm_factors(arg[1], arg[2]))

if __name__== "__main__":
    main(*sys.argv[1:])

