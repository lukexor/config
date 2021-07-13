#!/usr/bin/env python

"""Helper methods used in UltiSnips snippets."""

import string, vim, re

def complete(tab, opts):
    """
    get options that match with tab

    :param tab: query string
    :param opts: list that needs to be completed

    :return: a string that match with tab
    """
    el = [x for x in tab]
    pat = "".join(list(map(lambda x: x + "\w*" if re.match("\w", x) else x,
                           el)))
    try:
        opts = [x for x in opts if re.search(pat, x, re.IGNORECASE)]
    except:
        opts = [x for x in opts if x.startswith(tab)]
    if not len(opts) or str.lower(tab) in list(map(str.lower, opts)):
        return ""
    cads = "|".join(opts[:5])
    if len(opts) > 5: cads += "|..."
    return "({0})".format(cads)

def _parse_comments(s):
    """ Parses vim's comments option to extract comment format """
    i = iter(s.split(","))

    rv = []
    try:
        while True:
            # get the flags and text of a comment part
            flags, text = next(i).split(':', 1)

            if len(flags) == 0:
                rv.append(('OTHER', text, text, text, ""))
            # parse 3-part comment, but ignore those with O flag
            elif 's' in flags and 'O' not in flags:
                ctriple = ["TRIPLE"]
                indent = ""

                if flags[-1] in string.digits:
                    indent = " " * int(flags[-1])
                ctriple.append(text)

                flags, text = next(i).split(':', 1)
                assert flags[0] == 'm'
                ctriple.append(text)

                flags, text = next(i).split(':', 1)
                assert flags[0] == 'e'
                ctriple.append(text)
                ctriple.append(indent)

                rv.append(ctriple)
            elif 'b' in flags:
                if len(text) == 1:
                    rv.insert(0, ("SINGLE_CHAR", text, text, text, ""))
    except StopIteration:
        return rv

def get_comment_format():
    """ Returns a 4-element tuple (first_line, middle_lines, end_line, indent)
    representing the comment format for the current file.

    It first looks at the 'commentstring', if that ends with %s, it uses that.
    Otherwise it parses '&comments' and prefers single character comment
    markers if there are any.
    """
    commentstring = vim.eval("&commentstring")
    if commentstring.endswith("%s"):
        c = commentstring[:-2]
        return (c.rstrip(), c.rstrip(), c.rstrip(), "")
    comments = _parse_comments(vim.eval("&comments"))
    for c in comments:
        if c[0] == "SINGLE_CHAR":
            return c[1:]
    return comments[0][1:]

def display_width(str):
    """Return the required over-/underline length for str."""
    try:
        # Respect &ambiwidth and &tabstop, but old vim may not support this
        return vim.strdisplaywidth(str)
    except AttributeError:
        # Fallback
        from unicodedata import east_asian_width
        result = 0
        for c in str:
            result += 2 if east_asian_width(c) in ('W', 'F') else 1
        return result
