#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
# 
# See https://cangjie-lang.cn/pages/LICENSE for license information.


if [ -z "$JAVA_DIR" ]; then
  JAVA_DIR=
fi

$JAVA_DIR/bin/javac SynchProdCons.java

rm -f run.log

args=$@

$JAVA_DIR/bin/java SynchProdCons $args 2>&1 | tee -a run.log
