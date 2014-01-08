#!/usr/bin/env python
# -*- coding: utf-8 -*-

#py2.5 compatibility
from __future__ import with_statement

from os import path, makedirs
from subprocess import call
import sys
import os
import argparse
import string
import datetime
import ConfigParser
import textwrap

from journal import __version__, parse

DEFAULT_JOURNAL = "~/.journal"
DEFAULT_JOURNAL_RC = "~/.journalrc"

def parse_args():
    #parsing
    description = 'A CLI tool to help with keeping a work/personal journal'
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument('--version', action="version", version=__version__)

    config_group = parser.add_argument_group('optional config arguments')
    config_group.add_argument('-c', '--config',
            action="store",
            dest="config_file",
            nargs="?",
            help="load config from [CONFIG_FILE] instead of ~/.journalrc")
    config_group.add_argument('-j', '--journal',
            action="store",
            dest="journal",
            nargs="?",
            help="add entry to [JOURNAL]")
    config_group.add_argument('-l', '--location',
            action="store",
            dest="location",
            nargs="?",
            help="store journal in [LOCATION] instead of ~/.journal")
    # Set defaults here to make interface simpler later
    parser.set_defaults(config_file=DEFAULT_JOURNAL_RC, location=DEFAULT_JOURNAL)

    date_group = parser.add_argument_group('optional viewing arguments')
    date_group.add_argument('-s', '--since',
            action="store",
            metavar="DATE",
            dest="since",
            nargs="?",
            help="find all journal entries since a date")
    date_group.add_argument('-v', '--view',
            action="store",
            metavar="DATE",
            dest="view",
            nargs="?",
            help="view all journal entries on a specific date")

    main_group = parser.add_argument_group('main argument')
    main_group.add_argument('entry',
            nargs="*",
            help="text to make an entry in your journal")

    return parser, parser.parse_args()

def parse_config(args):
    """
    Try to load config, to load other journal locations
    Otherwise, return default location

    Returns journal location
    """
    # Try user config or return default location early
    config_path = path.expanduser(args.config_file)
    if not path.exists(config_path):
        # Complain if they provided non-existant config
        if args.config_file != DEFAULT_JOURNAL_RC:
            print "journal: error: config file '" + args.config_file + "' not found"
            sys.exit()
        else:
            # If no config file, use default journal location
            return DEFAULT_JOURNAL

    # If we get here, assume valid config file
    config = ConfigParser.SafeConfigParser({
        'journal':{'default':'__journal'},
        '__journal':{'location':DEFAULT_JOURNAL}
    })
    config.read(config_path)

    journal_location = config.get(config.get('journal', 'default'), 'location');
    if args.journal:
        journal_location = config.get(args.journal, 'location');
    return journal_location

def check_journal_dest(location):
    journal_path = path.basename(location)
    journal_dir = path.expanduser(journal_path)
    if not path.exists(journal_dir):
        try:
            makedirs(journal_dir)
        except:
            print "journal: error: creating journal storage directory failed"
            sys.exit()

def record_entries(journal_location, entries):
    """
    args
    entry - list of entries to record
    """
    current_date = datetime.datetime.today()
    check_journal_dest(build_journal_path(journal_location, current_date))
    date_header = "[" + current_date.strftime("%Y-%m-%d %a %I:%M:%S") + "]  "
    with open(build_journal_path(journal_location, current_date), "a") as date_file:
        # Start a blank list for all our trimmed lines
        wrapped_lines=[]

        entry_output = "\n" + date_header + "\n"

        # Split any passed newlines into a list
        entry_lines = ''.join(entries).splitlines()

        # Define our global wrap settings
        w = textwrap.TextWrapper(width=80)

        # Iterate over our lines to wrap them
        for entry in entry_lines:
            # If it's a blank line, tack it onto our list
            if entry == '':
                wrapped_lines.append('')
            # Otherwise wrap it to our settings above
            else:
                for line in w.wrap(entry):
                    wrapped_lines.append(line)

        # For each additional line, we append a tab to line things up
        for entry in wrapped_lines:
            entry_output += entry + "\n"

        # A final newline for spacing
        # entry_output += "\n"

        # And write it all out to our log
        date_file.write(entry_output)
        date_file.flush()

def build_journal_path(journal_location, date):
    date_filename = path.expanduser("".join(
        [ journal_location, '/', date.strftime("%Y"), '/', date.strftime("%Y-%m"), ".txt"]
        ))
    return date_filename

def get_entry(journal_location, date):
    """
    args
    date - date object
    returns entry text or None if entry doesn't exist
    """
    if not isinstance(date, datetime.date):
        return None
    try:
        with open(build_journal_path(journal_location, date), "r") as entry_file:
            return entry_file.read()
    except IOError:
        return None

def daterange(start_date, end_date):
    #loop over days + 1 for inclusive behavior
    for n in xrange((end_date - start_date).days + 1):
        yield start_date + datetime.timedelta(n)

def get_entries_since(journal_location, date):
    today = datetime.date.today()
    for single_date in daterange(date, today):
        entry = get_entry(journal_location, single_date)
        if entry:
            print entry

def main():
    #parse args
    parser, args = parse_args()
    journal_location = parse_config(args)
    date_parse = parse.Parse()

    #check args
    if args.location:
        journal_location = args.location
    if args.journal:
        journal_location += '/' + args.journal
    check_journal_dest(journal_location)

    #TODO: better handle program exit flow through exceptions?
    #handle_args
    if args.view:
        date = date_parse.day(args.view)
        if not date:
            print "journal: error: unknown date format"

        entry = get_entry(journal_location, date)
        if entry:
            print entry
        else:
            print "journal: error: entry not found on date %s" % date
    elif args.since:
        date = date_parse.day(args.since)
        if not date:
            print "journal: error: unknown date format"
        get_entries_since(journal_location, date)
    else:
        # Check for no-args and show help then
        if len(args.entry) == 0:
            parser.print_help()

        # Cleanup/check for empty entry list
        entries = filter(string.strip, args.entry)
        if entries:
            record_entries(journal_location, entries)
        else:
            #print "journal: error: missing entry"
            current_date = datetime.datetime.today()
            EDITOR = os.environ.get('EDITOR','vim')
            record_entries(journal_location, "\n")
            call([EDITOR, "+", "-c set formatoptions=tqw2", "-c start", build_journal_path(journal_location, current_date)])


    sys.exit()

if __name__ == "__main__":
    main()
