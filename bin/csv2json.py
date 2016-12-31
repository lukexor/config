#!/usr/bin/env python

##==========================================================================##
#
# NAME: csv2json.py
#
# DESCRIPTION:  Simple CSV to JSON conversion script.
#               Assumes delimiter is | and header contains field names
#
#
##==========================================================================##

import sys
import re
import getopt
import csv
from os.path import dirname
import simplejson

try:
    script, input_file_name, model_name = sys.argv
except ValueError:
    print "\nRun via:\n\n%s input_file_name model_name" % sys.argv[0]
    print "\ne.g. %s airport.csv app_airport.Airport" % sys.argv[0]
    print "\nNote: input_file_name should be a path relative to where this script is."
    sys.exit()

in_file = input_file_name
out_file = input_file_name + ".json"

print "Converting %s from CSV to JSON as %s" % (in_file, out_file)

f = open(in_file, 'r' )
fo = open(out_file, 'w')

reader = csv.reader( f, delimiter="|" )

header_row = []
entries = []
pk = 1

# debugging
# if model_name == 'app_airport.Airport':
#     import pdb ; pdb.set_trace( )

for row in reader:
    if not header_row:
        header_row = row
        continue

    model = model_name
    fields = {}
    for i in range(len(row)):
        active_field = row[i]

        # convert numeric strings into actual numbers by converting to either int or float
        if re.search('m2m', header_row[i]):
            p = re.compile('m2m')
            fields[p.sub('', header_row[i])] = [int(category) for category in active_field.split(',')]
        elif active_field.isdigit():
            try:
                new_number = int(active_field)
            except ValueError:
                new_number = float(active_field)
            fields[header_row[i]] = new_number
        elif active_field == 'null':
            continue
        else:
            fields[header_row[i]] = active_field.strip()

    row_dict = {}
    row_dict["pk"] = int(pk)
    row_dict["model"] = model_name

    row_dict["fields"] = fields
    entries.append(row_dict)
    pk += 1

fo.write("%s" % simplejson.dumps(entries, indent=4))

f.close()
fo.close()
