import os
# import re
import sys
import time
# import signal
import argparse
# import colorama
# import threading
# import subprocess
# import numpy as np

import warnings
warnings.filterwarnings('ignore')

parser = argparse.ArgumentParser()
parser.add_argument('--cks', nargs='+',
                    help='Lists all .ck files to be recorded. Classes must be concatenated in sequence and separated by "::". i.e.: clsA.ck::clsB.ck::arq.ck')
parser.add_argument('--name', default='', type=str,
                    help='Defines the file name. If it is not entered the name should be the same of the .ck file.')
parser.add_argument('--gain', default='0.9', type=str,
                    help='Defines the gain of the record')
parser.add_argument('--mono', action='store_true',
                    help='Defines if the output is mono. If note used the output will be stereo')
#parser.add_argument('--dur', default='5', type=str, help='Defines the duration')
#parser.add_argument('--uni', default='sec', type=str, help='Defines time unit [ms|sec|min]')

args = parser.parse_args()

if len(sys.argv) < 2:
    parser.print_help()
    sys.exit(1)

if not args.cks:
    print('No file was selected!')
    sys.exit(1)


def record(ck):
    classes = ck.split('::')
    name = args.name if args.name else classes[-1].split('.')[0]
    print(f'Recording "{name}.ck" ..')
    print('Use ctrl + c to stop recording')
    wavefile = f'{name}.wav'
    try:
        command = 'chuck {0} '.format(' '.join(classes))
        command += 'src/xrec_mono.ck' if args.mono else 'src/xrec_stereo.ck'
        command += ':{0}:{1}'.format(wavefile, args.gain)
        os.system(command)
    except KeyboardInterrupt:
        print('End of recording!\n')
        time.sleep(0.25)
    return wavefile


def main():
    for ck in args.cks:
        if ck.split('::')[-1].find('.ck') != -1:
            wavefile = record(ck)


if __name__ == '__main__':
    main()
