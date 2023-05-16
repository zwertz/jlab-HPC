# ------------------------------------------------------------------------- #
# This is a multi-purpose utility script. FOr instance it contains methods  #
# to create job summary files for SIMC and g4sbs jobs.                      #
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

def grab_simc_param_value(infile, param):
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

def grab_simc_norm_factors(histfile, title_or_data):
    '''Grabs important normalization factors from SIMC .hist file'''
    # Retain the order of paramters in which they appear in .hist file
    params = ['Ngen (request)', 'Ntried', 'charge', 'luminosity', 'genvol', 'Random Seed'] 
    titles = ['jobid', 'Nthrown', 'Ntried', 'charge(mC)', 'luminosity(ub^-1)', 'genvol(MeV*sr^2)', 'RndmSeed']
    chars_to_strip = ' mCub\n' #charecters to strip from the right side of equality
    if int(title_or_data) != 1:
        values = []
        jobid = histfile.split('_job_', 1)[1].strip('.hist')
        lines = read_file(histfile)
        values.append(jobid)
        for line in lines:
            for item in params:
                if (item in line) and ('GeV' not in line):
                    values.append(line.split("=", 1)[1].split("^")[0].strip(chars_to_strip))
                    break
    if int(title_or_data) != 1: 
        return ','.join(str(e) for e in values)
    else: # return the title row
        return ','.join(str(e) for e in titles)

def grab_g4sbs_norm_factors(csvfile, title_or_data):
    '''Grabs important normalization factors from G4SBS .csv file'''
    # Retain the order of paramters in which they appear in .hist file
    params = ['N_generated', 'N_tries', 'Beam_Energy', 'Beam_Current', 'Generation_Volume', 'Luminosity'] 
    titles = ['jobid', 'Nthrown', 'Ntried', 'Ebeam(GeV)', 'Ibeam(muA)', 'genvol(sr)', 'luminosity(s^-1cm^-2)']
    chars_to_strip = ' \n' #charecters to strip from the right side of equality
    if int(title_or_data) != 1:
        values = []
        jobid = csvfile.split('_job_', 1)[1].strip('.csv')
        lines = read_file(csvfile)
        values.append(jobid)
        for line in lines:
            for item in params:
                if item in line:
                    values.append(line.split(",", 1)[1].strip(chars_to_strip))
                    break
    if int(title_or_data) != 1: 
        return ','.join(str(e) for e in values)
    else: # return the title row
        return ','.join(str(e) for e in titles)

# def keep_unique_lines(infile):
#     '''Modifies a file to keep just its unique lines'''
#     htable = {}
#     with open(infile, 'r') as f:
#         line = f.readlines()
#         if str(line) not in htable:
#             htable[str(line)] = True
#     with open(infile, 'w') as f:
#         for key in htable.keys():
#             f.write(key)
        
def main(*arg):
    '''Calls the function of choice depending on its name'''
    if arg[0] == 'grab_simc_param_value':
        print(grab_simc_param_value(arg[1], arg[2]))
    elif arg[0] == 'grab_simc_norm_factors':
        print(grab_simc_norm_factors(arg[1], arg[2]))
    elif arg[0] == 'grab_g4sbs_norm_factors':
        print(grab_g4sbs_norm_factors(arg[1], arg[2]))
    elif arg[0] == 'keep_unique_lines':
        print(keep_unique_lines(arg[1]))

if __name__== "__main__":
    main(*sys.argv[1:])

