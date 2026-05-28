#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
# 
# See https://cangjie-lang.cn/pages/LICENSE for license information.

import csv
import json
import datetime
import requests
import sys

csv_results = dict()
mem_results = dict()

cj_compile_name = 'cj_compile'

case_suite_info = {
    'benchmarksgame': ['regexredux', 'revcomp', 'knucleotide', 'mandelbrot', 'fannkuchredux', 'fasta', 'nbody',
                       'spectralnorm', 'binarytrees', 'pidigits'],
    'others': ['gameoflive', 'whileloop', 'SplitOnLargeString', 'ReplaceOnLargeString', 'SubstringOnLargeString',
               'ContainsOnLargeString', 'SearchFromLeftOnLargeString', 'SearchFromRightOnLargeString',
               'SplitOnSmallString', 'ReplaceOnSmallString', 'SubstringOnSmallString', 'ContainsOnSmallString',
               'SearchFromLeftOnSmallString', 'SearchFromRightOnSmallString',
               'client_server', 'cookie_tostring', 'header_write', 'binarytrees_single', 'mandelbrot_single',
               'mandelbrot_for', 'regexredux_single', 'spectralnorm_single',
               'hashmap_add','hashmap_del','hashmap_mod','hashmap_search','hashmap_traverse',
               'buffer_add','stringbuilder_add'],
}


def parser_all_measurements_csv(filename="all_measurements.csv"):
    global csv_results, mem_results
    with open(filename) as f:
        render = csv.reader(f)
        for row in render:
            case_name = row[0]
            language = row[1]
            version = row[2]
            args = row[3]
            size = row[4]
            cpu = row[5]
            mem = row[6]
            status = row[7]
            cpu_load = row[8]
            elapsed = row[9]
            print(*row)

            def set_result(n, e, m):
                if n not in csv_results:
                    csv_results[n] = float(e)
                else:
                    csv_results[n] += float(e)

                if n not in mem_results:
                    mem_results[n] = float(m)
                else:
                    mem_results[n] += float(m)

            name = case_name + '.' + language
            if name == 'name.lang':
                continue
            if compile_test:
                if language == cj_compile_name:  # only get compile result.
                    set_result(name, elapsed, mem)
            else:
                if language != cj_compile_name:  # not get compile result.
                    set_result(name, elapsed, mem)

    for i in csv_results.keys():
        csv_results[i] = int(float(csv_results[i]) / 3 * 1000) / 1000  # default run 3 times.
        mem_results[i] = int(float(mem_results[i]) / 3 * 1000) / 1000


def token():
    header = {'Content-Type': 'application/json'}
    r = requests.get(
        url='http://10.50.90.171:8889/cpltp/api/user/user/appToken/getRestAppDynamicToken?uid=s00613938&pwd=cda6045683bb3f3c64fbb959514d90b999708123f0a3a7c8aecfb8ed5112f708',
        headers=header)
    return json.loads(r.content.decode('utf-8'))['data']


def template(level_str, funcName, result, timestamp, summary=""):
    t = {"level_str": level_str, "funcName": funcName,
         "result": result, "timestamp": timestamp,
         "description": "", "summary": summary}
    return t


def parse_result(raw_result, taskName, category):
    raw = []
    result = {}
    case_count = {}
    summary = ""
    if taskName == 'benchmarksgame' and category == 'time':
        summary = post_summary()
    for i in raw_result.keys():
        case, lang = i.split('.')
        if not (taskName == 'compile' or case in case_suite_info[taskName]):
            continue
        if case not in case_count:
            case_count.setdefault(case, 1)
        else:
            case_count[case] += 1
        result[lang] = {'value': raw_result[i]}

        if case_count[case] == lang_number:
            for j in result:
                result[j].setdefault('baseline', result[baseline_lang]['value'])
            raw.append(template(taskName, case, result, category, timestamp, backend, summary))
            result = {}
    return raw


def post_one_url(raw):
    header = {'Content-Type': 'application/json',
              'Authorization': token()}
    data = json.dumps(raw)
    data = bytes(data, 'utf-8')
    print(data)
    r = requests.post(
        url='http://10.50.90.171:3000/api/cpltp/api/tasklog/testcase/api/v1/task/performance/result/daily/CangjieLangV100R001C00B001/testcases',
        headers=header,
        data=data)
    print(r.content.decode('utf-8'))


def post_summary():
    total = 0
    summary = {}
    for x in csv_results.keys():
        suffix = x[str(x).rfind('.') + 1:]
        case_name = x[:str(x).rfind('.')]
        if case_name in case_suite_info['benchmarksgame']:
            if suffix == baseline_lang or suffix == 'cj':
                print(x, csv_results[x], suffix)
                if case_name not in summary:
                    summary[case_name] = {suffix: csv_results[x]}
                else:
                    summary[case_name].update({suffix: csv_results[x]})
            # if str(x).endswith('cj'):
    print(json.dumps(summary, indent=4))
    better = 0
    close = 0
    tolerance = 0.02
    mean_cj = 1
    mean_base = 1
    for x in summary:
        if len(summary[x]) == 2:
            total += 1
            gap_date = abs(
                (float(summary[x][baseline_lang]) - float(summary[x]['cj'])) / float(summary[x][baseline_lang]))
            if gap_date <= tolerance:
                close += 1
            elif gap_date > tolerance and float(summary[x]['cj']) < float(summary[x][baseline_lang]):
                better += 1
            mean_cj *= (1 / float(summary[x]['cj']))
            mean_base *= (1 / float(summary[x][baseline_lang]))
    mean_cj = pow(mean_cj, 1 / total)
    mean_base = pow(mean_base, 1 / total)
    summary = """Benchmarks Game 测试套执行了{}个用例，其中[cj]相比[{}]，有{}个用例较优，有{}个用例持平，有{}个用例较差。
性能几何平均值比为{}(越大越好)。
Benchmarks Game have {} cases, compare to [{}], [cj] has {} better cases, {} close cases, {} worse case.
Rate of performance geometric mean is {}(bigger is better).""".format(total, baseline_lang, better, close,
                                                                      total - better - close, mean_cj / mean_base,
                                                                      total, baseline_lang, better, close,
                                                                      total - better - close, mean_cj / mean_base)
    print(summary)

    return summary


if __name__ == '__main__':
    bs = ['llvmgc', 'js', 'jet', 'llvmgc_compile', 'jet_compile', 'llvmgc_aarch64', 'jet_aarch64', 'llvmgc_aarch64_compile', 'jet_aarch64_compile']
    compile_test = False
    debug = False  # debug will not post url to CPLT.
    i = sys.argv
    backend = 'llvmgc'
    if len(i) != 2:
        print('[ERROR]print give one input in : {}!'.format(bs))
        sys.exit(1)
    elif len(i) == 2:
        backend = i[1]
        if backend == 'debug':
            backend = 'js'  # let`s use js version for debug.
            debug = True
        elif backend not in bs:
            print('[ERROR]backend should in {}!'.format(bs))
            sys.exit(1)

    baseline_lang = 'go'
    lang_number = 2  # default run cj, go.
    if backend == 'js':
        baseline_lang = 'js'
        lang_number = 2  # only run cj, js for js.
    elif backend == 'llvmgc_aarch64':
        baseline_lang = 'go'
        lang_number = 2
    elif backend == 'jet_aarch64':
        baseline_lang = 'go'
        lang_number = 2
    elif backend == 'jet':
        baseline_lang = 'go'
        lang_number = 2
    elif backend == 'llvmgc_compile':
        backend = 'llvmgc'
        baseline_lang = cj_compile_name
        lang_number = 1
        compile_test = True
    elif backend == 'jet_compile':
        backend = 'jet'
        baseline_lang = cj_compile_name
        lang_number = 1
        compile_test = True
    elif backend == 'llvmgc_aarch64_compile':
        backend = 'llvmgc_aarch64'
        baseline_lang = cj_compile_name
        lang_number = 1
        compile_test = True
    elif backend == 'jet_aarch64_compile':
        backend = 'jet_aarch64'
        baseline_lang = cj_compile_name
        lang_number = 1
        compile_test = True

    parser_all_measurements_csv()
    timestamp = int(datetime.datetime.now().strftime('%Y%m%d%H%M'))
    if compile_test:  # we consider all cases compile result together.
        raw = parse_result(csv_results, 'compile', 'time')
        if not debug:
            post_one_url(raw)
        raw = parse_result(mem_results, 'compile', 'memory')
        if not debug:
            post_one_url(raw)
    else:
        for title in case_suite_info:  # display different cases here.
            # we care about Time and Mem.
            raw = parse_result(csv_results, title, 'time')
            if not debug:
                post_one_url(raw)
            raw = parse_result(mem_results, title, 'memory')
            if not debug:
                post_one_url(raw)

