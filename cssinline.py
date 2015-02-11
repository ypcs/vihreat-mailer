#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import re
import urllib
import urllib2
import base64
import mimetypes

from HTMLParser import HTMLParser

_ = lambda x: x

SERVICE_URL = 'http://templates.mailchimp.com/resources/inline-css/'
REGEXP = r'<textarea class="form-area">(.*)</textarea>'
#IMAGES_REGEXP = r'<img[^>]{0,}src="(.*)"[^>]{0,}>'
IMAGES_REGEXP = r'<img[^>]{0,}src="([^"]*)"[^>]{0,}>'

def read(filename):
    if filename is None or not os.path.exists(filename):
        raise IOError(_('File not found %s'))
    return open(filename, 'r').read()

def convert_to_inline(html):
    # name = html
    url = SERVICE_URL
    headers = {
        'User-Agent': 'Mozilla/5.0',
    }
    data = urllib.urlencode({
        'html': html,
    })
    req = urllib2.Request(url, data, headers)
    response = urllib2.urlopen(req)
    content = response.read()

    p = re.compile(REGEXP, re.MULTILINE + re.DOTALL)

    matches = p.findall(content)

    if len(matches) == 0:
        return None

    parser = HTMLParser()
    return parser.unescape(unicode(matches[0], 'utf-8'))

def base64_file(filename):
    if not os.path.exists(filename):
        raise IOError('File not found: %s' % filename)

    with open(filename, 'rb') as ofile:
        out = base64.b64encode(ofile.read())
    return out

def images_inline(html):
    p = re.compile(IMAGES_REGEXP)
    #matches = p.findall(html)

    def img_b64(match):
        url = match.group(1)
        if url.startswith('data:'):
            return match.group()
        tag = match.group(0)
        return tag.replace(url, 'data:%(mime)s;base64,%(data)s' % {
            'mime': mimetypes.guess_type(url)[0],
            'data': base64_file(url)    
        })

    nhtml = p.sub(img_b64, html)
    return nhtml

def main(args):
    content = read(args.infile)
    inline = convert_to_inline(content)

    inline = images_inline(inline)

    with open(args.outfile, 'w') as ofile:
        ofile.write(inline.encode('utf-8'))

def run():
    from argparse import ArgumentParser
    parser = ArgumentParser()
    parser.add_argument('-i', '--infile', dest='infile', help=_('HTML template.'), required=True)
    parser.add_argument('-o', '--outfile', dest='outfile', help=_('Output filename'), required=True)
    args = parser.parse_args()
    sys.exit(main(args))

if __name__ == "__main__":
    run()
