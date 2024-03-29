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

#IMAGES_REGEXP = r'<img[^>]{0,}src="(.*)"[^>]{0,}>'
IMAGES_REGEXP = r'<img[^>]{0,}src="([^"]*)"[^>]{0,}>'

class InlinePacker(object):
    def __init__(self, **kwargs):
        self._kwargs = kwargs

    def read(self, filename):
        if filename is None or not os.path.exists(filename):
            raise IOError(_('File not found %s'))
        return open(filename, 'r').read()

    def convert_to_inline(self, html):
        return html

    def base64_file(self, filename, first=True):
        if not os.path.exists(filename):
            pth = self._kwargs.get('path', None)
            if first and pth is not None:
                nfile = os.path.join(pth, filename)
                return self.base64_file(filename=nfile, first=False)
            raise IOError('File not found: %s' % filename)

        with open(filename, 'rb') as ofile:
            out = base64.b64encode(ofile.read())
        return out
    
    def img_b64(self, match):
        url = match.group(1)
        if url.startswith('data:'):
            return match.group()
        tag = match.group(0)
        return tag.replace(url, 'data:%(mime)s;base64,%(data)s' % {
            'mime': mimetypes.guess_type(url)[0],
            'data': self.base64_file(url)    
        })


    def images_inline(self, html, **kwargs):
        p = re.compile(IMAGES_REGEXP)
        nhtml = p.sub(self.img_b64, html)
        return nhtml

def main(args):
    inl = InlinePacker(path=os.path.abspath(os.path.dirname(args.infile)))
    content = inl.read(args.infile)

    inline = inl.images_inline(content)

    with open(args.outfile, 'w') as ofile:
        ofile.write(inline)

def run():
    from argparse import ArgumentParser
    parser = ArgumentParser()
    parser.add_argument('-i', '--infile', dest='infile', help=_('HTML template.'), required=True)
    parser.add_argument('-o', '--outfile', dest='outfile', help=_('Output filename'), required=True)
    args = parser.parse_args()
    sys.exit(main(args))

if __name__ == "__main__":
    run()
