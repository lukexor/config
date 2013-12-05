#!/usr/bin/python

"""
image_sort

SYNOPSIS
    python image_sort [options]

DESCRIPTION
    TODO: This describes the functionality of this script/module.

METHODS
    TODO:

AUTHOR
    Lucas Petherbridge <lukexor@gmail.com>
"""

import pyexiv2
import sys
import shutil
import os, errno, time
import datetime

def getTimestamp(f):
    metadata = pyexiv2.ImageMetadata(f)
    metadata.read()
    try:
        d = metadata['Exif.Photo.DateTimeOriginal']
        return d.value
    except Exception as e:
        try:
            mtime = int(os.path.getmtime(f))
            return datetime.datetime.fromtimestamp(mtime)
        except Exception as e:
            return "0000_00_00"

def main():
    """
    @param: sys.argv()
    """

    if len(sys.argv) > 1:

        if os.path.isdir(sys.argv[1]):
            # Build file list
            file_list = []
            rootdir = sys.argv[1]
            for root, folders, files in os.walk(rootdir):
                for file in files:
                    file_list.append(os.path.join(root,file))
        else:
            file_list = sys.argv[1:]

        for f in file_list:
            try:
                timestamp = getTimestamp(f)
                dir = timestamp.strftime('%Y/%Y_%m_%d/')
                if f[0:len(dir)] == dir:
                    print "File %s was already renamed, not renaming again" % (f)
                else:
                    nn = "%s%s" % (dir, os.path.basename(f))
                    try:
                        os.makedirs(dir)
                    except OSError as exc:
                        if exc.errno == errno.EEXIST and os.path.isdir(dir):
                            pass
                        else: raise
                    shutil.move(f, nn)
                    print "File %s renamed to %s" % (f, nn)
            except Exception as e:
                print "File %s not renamed (%s)" % (f, e)
    else:
        print "Usage: %s <JPG files with Exif tags>" % (sys.argv[0])

if __name__ == '__main__':
    main()
