# Copyright 2016 leftcoast.io, inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
#
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# I chose Python 3 as the scripting language given it can run commands
# on any major operating system.

import argparse
import subprocess


def build_tag(tag, rebuild):
    command_str = "docker build -t gordonff/dev:{0} {0}".format(tag)

    if rebuild:
        command_str = command_str.replace('build', 'build --no-cache')

    for line in subprocess.Popen(
            command_str,
            shell=True,
            stdout=subprocess.PIPE,
            universal_newlines=True).stdout:
        print(line.replace("\n", ""))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
            prog='build.py',
            usage='build.py',
            description='Remove exited containers',
            allow_abbrev=True)

    parser.add_argument(
            '--rebuild',
            dest='rebuild',
            action='store_true',
            default=False,
            help='rebuild the images instead of using the cache')

    args = parser.parse_args()

    build_tag("latest", args.rebuild)
    build_tag("user", args.rebuild)
