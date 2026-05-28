#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
# 
# See https://cangjie-lang.cn/pages/LICENSE for license information.

import json
import os
import time

import requests

csv_results = dict()
mem_results = dict()


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


def post_one_url(raw, version_json=None):
    cmc_version = "CangjieLangV100R001C00B001"
    if version_json is not None and os.path.exists(version_json):
        with open(version_json, encoding='utf-8') as fp:
            version_data = json.load(fp)
        cmc_version = version_data.get("bundle")[0].get("version") + "-" + version_data.get("bundle")[0].get("serial")
    header = {'Content-Type': 'application/json',
              'Authorization': token()}
    data = json.dumps(raw)
    data = bytes(data, 'utf-8')
    print(data)
    r = requests.post(
        url='http://10.50.90.171:3000/api/cpltp/api/tasklog/testcase/api/v1/task/performance/result/daily/{}/testcases'.format(
            cmc_version),
        headers=header,
        data=data)
    print(r.content.decode('utf-8'))
    if json.loads(r.content.decode('utf-8')).get("code") == '406':
        updata_version()
        time.sleep(300)
        post_one_url(raw, version_json)


def updata_version():
    header = {'Content-Type': 'application/json',
              'Authorization': token()}
    r = requests.post(
        url="http://10.50.90.171:3000/api/cpltp/api/task/cmc/cmcversion/refresh/76",
        headers=header
    )
    print(r.content.decode('utf-8'))
