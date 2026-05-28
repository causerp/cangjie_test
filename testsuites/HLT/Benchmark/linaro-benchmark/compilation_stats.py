#! /usr/bin/env python3

# Copyright (C) 2021 Linaro Limited. All rights received.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import argparse
import os
import sys
import json
import tempfile
import shutil

from collections import OrderedDict

dir_benchs = os.path.dirname(os.path.realpath(__file__))
dir_tools = os.path.join(dir_benchs, '..')
sys.path.insert(0, dir_tools)

from tools import utils, utils_adb, utils_print, utils_stats

def BuildOptions():
    parser = argparse.ArgumentParser(
        description = "Collect compilation statistics.",
        # Print default values.
        formatter_class = argparse.ArgumentDefaultsHelpFormatter)
    utils.AddCommonRunOptions(parser)
    utils.AddOutputFormatOptions(parser, utils.default_output_formats)
    args = parser.parse_args()
    return args

def SaveAndPrintResults(target_file_key,
                        compilation_times,
                        section_sizes,
                        output_json_filename):
    output_obj = utils.ReadJSON(output_json_filename)
    output_obj[target_file_key] = dict()

    output_obj[target_file_key].update(compilation_times)
    print("Compilation times (seconds):")
    utils.PrintData(compilation_times)

    output_obj[target_file_key]["Executable size"] = section_sizes
    print("Executable sizes (bytes):")
    utils.PrintData(section_sizes)

    with open(output_json_filename, "w") as fp:
        json.dump(output_obj, fp, indent=2)

if __name__ == "__main__":
    # create temp directory to pull executables from the device
    # to measure their size
    work_dir = tempfile.mkdtemp()
    try:
        args = BuildOptions()
        input_filename = args.add_pathname[0]
        # command is used to call a shell script using chroot
        # this script calls dex2oat on a given APK and prints
        # before/after timestamps
        # after command is executed we pull the executable from the device
        # and measure its size
        if 'ART_COMMAND' in os.environ:
            command = os.getenv('ART_COMMAND')
        else:
            utils.Error("ART_COMMAND is not set.")

        if input_filename != "boot.oat":
            apk_name = utils.TargetPathJoin(args.target_copy_path, input_filename)
            format_data = {'workdir': os.path.dirname(apk_name)}
            command = command.format(**format_data)

        compilation_times = []
        for i in range(args.iterations):
            print("Compiling APK")
            results = utils_adb.shell(command, args.target, exit_on_error=False)
            lines = results[1]
            compilation_time = utils.ExtractCompilationTimeFromOutput(lines)
            compilation_times += [compilation_time]
            print("Compilation took {:.2f}s\n".format(compilation_time))

        compile_time_dict = OrderedDict([("Time", compilation_times)])

        # Pull the executable and get its size
        for output_oat in args.output_oat:
            print("Getting size for {}".format(output_oat))
            output_filename = os.path.basename(output_oat)
            local_oat = os.path.join(work_dir, output_filename)
            utils_adb.pull(output_oat, local_oat, args.target)
            section_sizes = utils.GetSectionSizes(local_oat)

            SaveAndPrintResults(output_filename, compile_time_dict, section_sizes, args.output_json)
    finally:
        shutil.rmtree(work_dir)

