# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
# 
# See https://cangjie-lang.cn/pages/LICENSE for license information.
 
#!/bin/bash
set -xe
# set -e

# 参数
branch="main"
host=""
target=""
system=""
cross_compile=y
type_test="Daily"
cmc_binary_version="Cangjie 1"
snapshot_version="latest"
module=""
concurrency=1
split=""
run_split=""
level=""
upload_cpltp="n"
jenkins_id=""
device=""
test_cfg_O0=""
test_cfg_O2=""
test_cfg_g=""
test_cfg_static=""
test_cfg_objcffi=""
test_cfg_jffi=""
test_cfg_syntax=""
test_cfg_mock=""
test_cfg_asan_O0=""
test_cfg_asan_O2=""
test_cfg_tsan_O0=""
test_cfg_tsan_O2=""
test_cfg_compile_as_exe_lto_full_O2=""
test_cfg_compile_as_exe_lto_thin_O2=""
test_cfg_lto_full_O2=""
test_cfg_lto_thin_O2=""
sdk_name=""
sdk_runtime_name=""
stdx_name=""
stdx_name_cross=""
test_list=""
sanitizer=n
host_stdx_path=""
artget_user=""
artget_pwd=""
common_testlist="${WORKSPACE}/cangjie_test/testsuites/HLT/testlist"
# 看板上的一级目录为Cangjie，二级目录为TestDaily_分支
level_2_directory="DailyTest"
os_type=$(uname)

if [ "${os_type}" == "Darwin" ]; then
    sed=(sed -i "")
    yesterday=$(date -v-1d "+%Y%m%d")
else
    sed=(sed -i)
    yesterday=$(date -d "yesterday" "+%Y%m%d")
fi

if [ "${os_type}" == "Linux" ]; then
    if [ "$(python3 -m pip list | grep "requests")" == "" ]; then
        python3 -m pip install --trusted-host mirrors.tools.huawei.com -i https://mirrors.tools.huawei.com/pypi/simple requests
    fi
    if [ "$(python3 -m pip list | grep "pymysql")" == "" ]; then
        python3 -m pip install --trusted-host mirrors.tools.huawei.com -i https://mirrors.tools.huawei.com/pypi/simple pymysql
    fi
    if [ "$(python3 -m pip list | grep "paramiko")" == "" ]; then
        python3 -m pip install --trusted-host mirrors.tools.huawei.com -i https://mirrors.tools.huawei.com/pypi/simple paramiko
    fi
    if [ "$(python3 -m pip list | grep "fasteners")" == "" ]; then
        python3 -m pip install --trusted-host mirrors.tools.huawei.com -i https://mirrors.tools.huawei.com/pypi/simple fasteners
    fi
fi

if [[ -z ${WORKSPACE_SCRIPTS} ]]; then
    WORKSPACE_SCRIPTS=${WORKSPACE}/Cangjie-test
fi

# 解析命名参数
parse_options() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help)
                echo "$0 参数说明: "
                echo "  --branch"
                echo "    测试分支, 可选参数: dev, main, 默认为 main"
                echo "  --type_test"
                echo "    测试类型, 可选参数: Daily, Bversion, 默认为 Daily, 即默认获取Daily版本, 测试转测版本选择Bversion"
                echo "  --cmc_binary_version"
                echo "    仓颉版本号, 默认为 Cangjie "
                echo "  --snapshot_version"
                echo "   B版本快照, 仅在 --type_test Daily 条件下生效, 默认为 latest, 即默认使用Daily版本中的最新版本"
                echo "  --host"
                echo "    编译环境, 可选参数: linux_aarch64, linux_x64, mac_aarch64, mac_x64, windows_x64, 默认为 linux_aarch64"
                echo "  --target"
                echo "    运行环境, 可选参数: linux_aarch64, linux_x64, euler, mac_aarch64, mac_x64, windows_x64, windows_exe, ohos, android23, android26, android31, android35, ios_aarch64, ios_x64, 默认为linux_aarch64,若选取的包为交叉编译包,执行环境仍为host环境,设置--target参数为交叉编译的target环境,同时设置参数--cross_compile n"
                echo "  --cross_compile"
                echo "    使用交叉编译的包时，是否进行交叉编译, 可选参数: y, n, 默认为 y, 即默认进行交叉编译"
                echo "  --system"
                echo "   特殊环境标注, 体现在看板目录上, 一般无需设置, 默认为空"
                echo "  --module"
                echo "   期望执行的模块及编译选项, 模块_编译选项, 其中工具无需写编译选项, 例: api_O0, 可选模块: api, api_static, api_static_extern, api_asan, api_tsan, runtime, compiler, jffi, objcffi, cjcpl, cjdb, cjcov, cjfmt, cjlint, cjprof, cjtrace, cjpm, cjlsp, hle, 可选编译选项: O0, O2, g, mock, lto"
                echo "  --concurrency"
                echo "   用例执行的并发度, 默认1, 即不并发"
                echo "  --split"
                echo "   模块切片数量, 对指定模块的用例切片执行, 默认为不切分"
                echo "  --run_split"
                echo "   设置--split后, 设置该参数, 可指定跑第几个切片, 例: --run_split 1,3,5, 默认为空, 即跑全部切片"
                echo "  --level"
                echo "   执行的用例等级, 例--level 0,1,2, 默认为全量执行"
                echo "  --upload_cpltp"
                echo "   是否上传cpltp平台, 默认为 n, 即不上传, 若需上传设置参数为 y"
                echo "  --jenkins_id"
                echo "   数据上传至cpltp平台的日期, 例: --jenkins_id 20241024, 默认为当前时间"
                echo "  --device"
                echo "   交叉编译时使用的手机ID, 默认为空"
                exit 0
                ;;
            --branch)
                branch="$2"
                shift 2
                ;;
            --host)
                host="$2"
                shift 2
                ;;
            --target)
                target="$2"
                shift 2
                ;;
            --cross_compile)
                cross_compile="$2"
                shift 2
                ;;
            --system)
                system="$2"
                shift 2
                ;;
            --type_test)
                type_test="$2"
                shift 2
                ;;
            --cmc_binary_version)
                cmc_binary_version="$2"
                shift 2
                ;;
            --snapshot_version)
                snapshot_version="$2"
                shift 2
                ;;
            --level)
                level="$2"
                shift 2
                ;;
            --module)
                module="$2"
                shift 2
                if [[ -z ${module} ]]; then
                    echo "error: 请设置参数 --module"
                    exit 1
                fi
                ;;
            --concurrency)
                concurrency="$2"
                shift 2
                # 检查参数是否为数字
                if ! [[ "$concurrency" =~ ^[0-9]+$ ]]; then
                    echo "error: --concurrency的参数必须是正整数, 输入为${concurrency}"
                    exit 1
                fi
                ;;
            --split)
                split="$2"
                shift 2
                # 检查参数是否为数字
                if ! [[ "$split" =~ ^[0-9]+$ ]]; then
                    echo "error: --split的参数必须是正整数, 输入为${split}"
                    exit 1
                fi
                ;;
            --run_split)
                run_split="$2"
                shift 2
                ;;
            --upload_cpltp)
                upload_cpltp="$2"
                shift 2
                ;;
            --jenkins_id)
                jenkins_id="$2"
                shift 2
                ;;
            --device)
                device="$2"
                shift 2
                ;;
            *)
                echo "未知参数: $1"
                exit 1
                ;;
        esac
    done

}

# 循环多次执行指定语句，直至命令执行成功或超出循环次数
execute_with_retry() {
    # 循环执行的语句
    local command="$1"
    # 循环次数，传入的第二个参数为循环的次数，若未传入，默认循环3次
    local max_attempts="${2:-3}"
    local attempts=0
    while [ $attempts -lt $max_attempts ]
    do
        eval "$command"
        if [ $? -eq 0 ]; then
            return 0
        else
            echo "$command failed. Retrying..."
            attempts=$((attempts + 1))
            sleep 60  # Optional: add a delay between retries
        fi
    done
    echo "Maximum attempts reached. $command execution failed."
    return 1
}

# 创建xml文件用以获取版本包
create_xml() {
    echo '<?xml version="1.0" encoding="UTF-8"?>' > cmc.xml
    echo '<project>' >> cmc.xml
    echo '    <dependencies>' >> cmc.xml
    echo '        <dependency>' >> cmc.xml
    echo '            <versionType>BVersion</versionType>' >> cmc.xml
    echo '            <repoType>Generic</repoType>' >> cmc.xml
    echo '            <id>' >> cmc.xml
    echo '                <offering>Cangjie</offering>' >> cmc.xml
    echo "                <version>${cmc_binary_version}</version>" >> cmc.xml
    if [ "$type_test" = "Daily" ]; then
        echo "                <snapshotVersion>${snapshot_version}</snapshotVersion>" >> cmc.xml
    fi
    echo '            </id>' >> cmc.xml
    echo '            <copies>' >> cmc.xml
    echo '                <copy>' >> cmc.xml
    echo "                    <source>${sdk_name}</source>" >> cmc.xml
    echo "                    <source>${stdx_name}</source>" >> cmc.xml
    if [ "$cross_compile" = "y" ] && [ -n "$stdx_name_cross" ]; then
        echo "                    <source>${stdx_name_cross}</source>" >> cmc.xml
    fi
    if [ "$target" = "euler" ]; then
        echo "                    <source>${sdk_runtime_name}</source>" >> cmc.xml
    fi
    echo '                    <dest></dest>' >> cmc.xml
    echo '                </copy>' >> cmc.xml
    echo '            </copies>' >> cmc.xml
    echo '        </dependency>' >> cmc.xml
    echo '    </dependencies>' >> cmc.xml
    echo '</project>' >> cmc.xml
}

# 确定测试包及cfg
prepare_operation() {
    # linux_aarch64编译环境
    if [ "$host" = "linux_aarch64" ]; then
        test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_aarch64-linux_aarch64/basic.cfg
        test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_aarch64-linux_aarch64/O2.cfg
        test_list=${common_testlist},${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/exclude_common,${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/linux_aarch64-linux_aarch64/exclude_common
        
        if [ ${system} = "linux_aarch64_kylin" ]; then
            export LIBRARY_PATH=/opt/buildtools/openssl-3.0.9/lib:$LIBRARY_PATH
            # export OPENSSL_PATH=/opt/buildtools/openssl-3.0.9
            export OPENSSL_PATH=$WORKSPACE_SCRIPTS/toolchains/kylin_x64/lib
            export OPENSSL_ROOT_DIR=/opt/buildtools/openssl-3.0.9
        else
            if [ -d /opt/buildtools/openssl-3.0.9/lib ]; then
                export LD_LIBRARY_PATH=/opt/buildtools/openssl-3.0.9/lib:${LD_LIBRARY_PATH}
                export LIBRARY_PATH=/opt/buildtools/openssl-3.0.9/lib:$LIBRARY_PATH
                export OPENSSL_PATH=/opt/buildtools/openssl-3.0.9/lib
                export OPENSSL_ROOT_DIR=/opt/buildtools/openssl-3.0.9/lib
            elif [ -d /opt/buildtools/openssl-3.0.7/lib ]; then
                export LD_LIBRARY_PATH=/opt/buildtools/openssl-3.0.7/lib:${LD_LIBRARY_PATH}
                export LIBRARY_PATH=/opt/buildtools/openssl-3.0.7/lib:$LIBRARY_PATH
                export OPENSSL_PATH=/opt/buildtools/openssl-3.0.7/lib
                export OPENSSL_ROOT_DIR=/opt/buildtools/openssl-3.0.7/lib
            fi
        fi
        
        if [ "$target" = "linux_aarch64" ]; then
            sanitizer=y
            sdk_name=/cjnative/linux/cangjie-sdk-linux-aarch64-1.*.tar.gz
            stdx_name=/libs/stdx/cjnative/cangjie-stdx-linux-aarch64-1.*.zip
            test_cfg_g=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_aarch64-linux_aarch64/g.cfg
            test_cfg_static=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_aarch64-linux_aarch64/static_O2.cfg
            test_cfg_mock=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_aarch64-linux_aarch64/mock_on_O2.cfg
            test_cfg_asan_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_aarch64-linux_aarch64/asan.cfg
            test_cfg_asan_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_aarch64-linux_aarch64/asan_O2.cfg
            test_cfg_tsan_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_aarch64-linux_aarch64/tsan.cfg
            test_cfg_tsan_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_aarch64-linux_aarch64/tsan_O2.cfg
            test_cfg_compile_as_exe_lto_full_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_aarch64-linux_aarch64/compile_as_exe_lto_full_O2.cfg
            test_cfg_compile_as_exe_lto_thin_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_aarch64-linux_aarch64/compile_as_exe_lto_thin_O2.cfg
            test_cfg_lto_full_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_aarch64-linux_aarch64/lto_full_O2.cfg
            test_cfg_lto_thin_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_aarch64-linux_aarch64/lto_thin_O2.cfg
            
        elif [ "$target" = "euler" ]; then
            sanitizer=y
            sdk_name=/euler/cjnative/linux/cangjie-sdk-euler-linux-aarch64-1.*.tar.gz
            sdk_runtime_name=/euler/cjnative/linux/cangjie-runtime-euler-linux-aarch64-1.*.tar.gz
            stdx_name=/euler/libs/stdx/cjnative/cangjie-stdx-euler-linux-aarch64-1.*.zip
        else
            echo "error: --target $target 参数错误, 请使用--help查看可选参数"
            exit 1
        fi
    # linux_x64编译环境
    elif [ "$host" = "linux_x64" ]; then
        test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_x64-linux_x64/basic.cfg
        test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_x64-linux_x64/O2.cfg
        test_cfg_g=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_x64-linux_x64/g.cfg
        test_cfg_static=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_x64-linux_x64/static_O2.cfg
        test_cfg_mock=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_x64-linux_x64/mock_on_O2.cfg
        test_cfg_asan_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_x64-linux_x64/asan.cfg
        test_cfg_asan_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_x64-linux_x64/asan_O2.cfg
        test_cfg_tsan_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_x64-linux_x64/tsan.cfg
        test_cfg_tsan_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/linux_x64-linux_x64/tsan_O2.cfg
        test_list=${common_testlist},${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/exclude_common,${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/linux_x64-linux_x64/exclude_common
        stdx_name=/libs/stdx/cjnative/cangjie-stdx-linux-x64-1.*.zip
    
        if [ ${system} = "linux_x64_kylin" ]; then
            export LIBRARY_PATH=/opt/buildtools/openssl-3.0.9/lib64:$LIBRARY_PATH
            # export OPENSSL_PATH=/opt/buildtools/openssl-3.0.9
            export OPENSSL_PATH=$WORKSPACE_SCRIPTS/toolchains/kylin_aarch64/lib

        else
            if [ -d /opt/buildtools/openssl-3.0.9/lib ]; then
                export LD_LIBRARY_PATH=/opt/buildtools/openssl-3.0.9/lib:${LD_LIBRARY_PATH}
                export LIBRARY_PATH=/opt/buildtools/openssl-3.0.9/lib:$LIBRARY_PATH
                export OPENSSL_PATH=/opt/buildtools/openssl-3.0.9/lib
            elif [ -d /opt/buildtools/openssl-3.0.7/lib ]; then
                export LD_LIBRARY_PATH=/opt/buildtools/openssl-3.0.7/lib:${LD_LIBRARY_PATH}
                export LIBRARY_PATH=/opt/buildtools/openssl-3.0.7/lib:$LIBRARY_PATH
                export OPENSSL_PATH=/opt/buildtools/openssl-3.0.7/lib
            elif [ -d /opt/buildtools/openssl-3.0.9/lib64 ]; then
                export LD_LIBRARY_PATH=/opt/buildtools/openssl-3.0.9/lib64:${LD_LIBRARY_PATH}
                export LIBRARY_PATH=/opt/buildtools/openssl-3.0.9/lib64:$LIBRARY_PATH
                export OPENSSL_PATH=/opt/buildtools/openssl-3.0.9/lib64
            elif [ -d /opt/buildtools/openssl-3.0.7/lib64 ]; then
                export LD_LIBRARY_PATH=/opt/buildtools/openssl-3.0.7/lib64:${LD_LIBRARY_PATH}
                export LIBRARY_PATH=/opt/buildtools/openssl-3.0.7/lib64:$LIBRARY_PATH
                export OPENSSL_PATH=/opt/buildtools/openssl-3.0.7/lib64
            fi
        fi
        
        if [ "$target" = "linux_x64" ]; then
            sanitizer=y
            sdk_name=/cjnative/linux/cangjie-sdk-linux-x64-1.*.tar.gz

        elif [ "$target" = "euler" ]; then
            sanitizer=y
            sdk_name=/euler/cjnative/linux/cangjie-sdk-euler-linux-x64-1.*.tar.gz
            sdk_runtime_name=/euler/cjnative/linux/cangjie-runtime-euler-linux-x64-1.*.tar.gz
            stdx_name=/euler/libs/stdx/cjnative/cangjie-stdx-euler-linux-x64-1.*.zip
        elif [ "$target" = "android26" ] || [ "$target" = "android31" ] || [ "$target" = "android35" ] || [ "$target" = "android" ]; then
            if [ "$cross_compile" = "n" ]; then
                sdk_name=/cjnative/linux/cangjie-sdk-linux-x64-android-1.*.tar.gz
            elif [ "$cross_compile" = "y" ]; then
                echo "error: 脚本不适用于host为linux_x64的交叉编译执行, 设置 --cross_compile n 可测试android包的native功能"
                exit 1
            else
                echo "error: --cross_compile $cross_compile 参数错误, 请使用--help查看可选参数"
                exit 1
            fi
        elif [ "$target" = "ohos" ]; then
            if [ "$cross_compile" = "n" ]; then
                sdk_name=/cjnative/linux/cangjie-sdk-linux-x64-ohos-1.*.tar.gz
            elif [ "$cross_compile" = "y" ]; then
                echo "error: 脚本不适用于host为linux_x64的交叉编译执行, 设置 --cross_compile n 可测试ohos包的native功能"
                exit 1
            else
                echo "error: --cross_compile $cross_compile 参数错误, 请使用--help查看可选参数"
                exit 1
            fi
        else
            echo "error: --target $target 参数错误, 请使用--help查看可选参数"
            exit 1
        fi
    # mac_aarch64编译环境
    elif [ "$host" = "mac_aarch64" ]; then
        test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-mac_aarch64/basic.cfg
        test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-mac_aarch64/O2.cfg
        test_cfg_static=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-mac_aarch64/static_O2.cfg
        test_list=${common_testlist},${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/exclude_common,${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/mac_aarch64-mac_aarch64/exclude_common
        stdx_name=/libs/stdx/cjnative/cangjie-stdx-mac-aarch64-1.*.zip
        if [ "$target" = "mac_aarch64" ]; then
            sdk_name=/cjnative/darwin/cangjie-sdk-mac-aarch64-1.*.tar.gz
        elif [ "$target" = "android23" ]; then
            sdk_name=/cjnative/darwin/cangjie-sdk-mac-aarch64-android-1.*.tar.gz
            if [ "$cross_compile" = "n" ]; then
                echo "native测试, 非交叉编译执行"
            elif [ "$cross_compile" = "y" ]; then
                test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch32/android_arm32.cfg
                test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch32/android_arm32_O2.cfg
                test_cfg_static=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch32/android_arm32_static_O2.cfg
                test_cfg_jffi=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch32/android_arm32_jffi.cfg
                stdx_name_cross=/libs/stdx/cjnative/cangjie-stdx-android-arm32-1.*.zip
            else
                echo "error: --cross_compile $cross_compile 参数错误, 请使用--help查看可选参数"
                exit 1
            fi
        elif [ "$target" = "android26" ]; then
            sdk_name=/cjnative/darwin/cangjie-sdk-mac-aarch64-android-1.*.tar.gz
            if [ "$cross_compile" = "n" ]; then
                echo "native测试, 非交叉编译执行"
            elif [ "$cross_compile" = "y" ]; then
                test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch64/android26.cfg
                test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch64/android26_O2.cfg
                test_cfg_static=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch64/android26_static_O2.cfg
                test_cfg_jffi=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch64/android26_jffi.cfg
                stdx_name_cross=/libs/stdx/cjnative/cangjie-stdx-android-aarch64-1.*.zip
            else
                echo "error: --cross_compile $cross_compile 参数错误, 请使用--help查看可选参数"
                exit 1
            fi
        elif [ "$target" = "android31" ] || [ "$target" = "android" ]; then
            sdk_name=/cjnative/darwin/cangjie-sdk-mac-aarch64-android-1.*.tar.gz
            if [ "$cross_compile" = "n" ]; then
                echo "native测试, 非交叉编译执行"
            elif [ "$cross_compile" = "y" ]; then
                test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch64/android31.cfg
                test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch64/android31_O2.cfg
                test_cfg_static=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch64/android31_static_O2.cfg
                test_cfg_jffi=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch64/android31_jffi.cfg
                stdx_name_cross=/libs/stdx/cjnative/cangjie-stdx-android-aarch64-1.*.zip
            else
                echo "error: --cross_compile $cross_compile 参数错误, 请使用--help查看可选参数"
                exit 1
            fi
        elif [ "$target" = "android35" ]; then
            sdk_name=/cjnative/darwin/cangjie-sdk-mac-aarch64-android-1.*.tar.gz
            if [ "$cross_compile" = "n" ]; then
                echo "native测试, 非交叉编译执行"
            elif [ "$cross_compile" = "y" ]; then
                test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch64/android35.cfg
                test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch64/android35_O2.cfg
                test_cfg_static=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch64/android35_static_O2.cfg
                test_cfg_jffi=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-android_aarch64/android35_jffi.cfg
                stdx_name_cross=/libs/stdx/cjnative/cangjie-stdx-android-aarch64-1.*.zip
            else
                echo "error: --cross_compile $cross_compile 参数错误, 请使用--help查看可选参数"
                exit 1
            fi
        elif [ "$target" = "ios_aarch64" ]; then
            sdk_name=/cjnative/darwin/cangjie-sdk-mac-aarch64-ios-1.*.tar.gz
            test_list=$test_list,${WORKSPACE}/Cangjie-test/testsuites/HLT/configs/cjnative/exclude_cjnative_mac_arm_ios_arm
            if [ "$cross_compile" = "n" ]; then
                echo "native测试, 非交叉编译执行"
            elif [ "$cross_compile" = "y" ]; then
                if [ "$branch_cfg" = "_main" ]; then
                    test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-ios_simulator_aarch64/lto.cfg
                    test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-ios_simulator_aarch64/lto.cfg
                    test_cfg_static=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-ios_simulator_aarch64/lto.cfg
                else
                    test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-ios_simulator_aarch64/basic.cfg
                    test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-ios_simulator_aarch64/O2.cfg
                    test_cfg_static=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-ios_simulator_aarch64/static_O2.cfg
                fi
                test_cfg_objcffi=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-ios_simulator_aarch64/objc_O2.cfg

                stdx_name_cross=/libs/stdx/cjnative/cangjie-stdx-ios-simulator-aarch64-1.*.zip
            else
                echo "error: --cross_compile $cross_compile 参数错误, 请使用--help查看可选参数"
                exit 1
            fi
        elif [ "$target" = "ios_x64" ]; then
            sdk_name=/cjnative/darwin/cangjie-sdk-mac-aarch64-ios-1.*.tar.gz
            test_list=$test_list,${WORKSPACE}/Cangjie-test/testsuites/HLT/configs/cjnative/exclude_cjnative_mac_arm_ios_arm
            if [ "$cross_compile" = "n" ]; then
                echo "native测试, 非交叉编译执行"
            elif [ "$cross_compile" = "y" ]; then
                test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-ios_simulator_x64/basic.cfg
                test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-ios_simulator_x64/O2.cfg
                test_cfg_static=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-ios_simulator_x64/static_O2.cfg
                test_cfg_objcffi=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-ios_simulator_x64/objc_O2.cfg
                stdx_name_cross=/libs/stdx/cjnative/cangjie-stdx-ios-simulator-x64-1.*.zip
            else
                echo "error: --cross_compile $cross_compile 参数错误, 请使用--help查看可选参数"
                exit 1
            fi
        elif [ "$target" = "ohos" ]; then
            sdk_name=/cjnative/darwin/cangjie-sdk-mac-aarch64-ohos-1.*.tar.gz
            if [ "$cross_compile" = "n" ]; then
                echo "native测试, 非交叉编译执行"
            elif [ "$cross_compile" = "y" ]; then
                test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-ohos_aarch64/basic.cfg
                test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-ohos_aarch64/O2.cfg
                test_cfg_static=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_aarch64-ohos_aarch64/static_O2.cfg
                stdx_name_cross=/libs/stdx/cjnative/cangjie-stdx-ohos-aarch64-*.zip
            else
                echo "error: --cross_compile $cross_compile 参数错误, 请使用--help查看可选参数"
                exit 1
            fi
        else
            echo "error: --target $target 参数错误, 请使用--help查看可选参数"
            exit 1
        fi
    # mac_x64编译环境
    elif [ "$host" = "mac_x64" ]; then
        stdx_name=/libs/stdx/cjnative/cangjie-stdx-mac-x64-1.*.zip
        test_list=${common_testlist},${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/exclude_common,${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/mac_x64-mac_x64/exclude_common
        if [ "$target" = "mac_x64" ]; then
            sdk_name=/cjnative/darwin/cangjie-sdk-mac-x64-1.*.tar.gz
            test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_x64-mac_x64/basic.cfg
            test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_x64-mac_x64/O2.cfg
        elif [ "$target" = "ohos" ]; then
            if [ "$cross_compile" = "y" ]; then
                sdk_name=/cjnative/darwin/cangjie-sdk-mac-x64-ohos-1.*.tar.gz
                stdx_name_cross=/libs/stdx/cjnative/cangjie-stdx-ohos-aarch64-*.zip
                test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_x64-ohos_aarch64/basic.cfg
                test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_x64-ohos_aarch64/O2.cfg
                test_cfg_static=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/mac_x64-ohos_aarch64/static_O2.cfg
            elif [ "$cross_compile" = "n" ]; then
                echo "error: 脚本不适用于host为mac x64的native执行, 设置 --cross_compile y 可测试ohos包的交叉编译执行功能"
                exit 1
            else
                echo "error: --cross_compile $cross_compile 参数错误, 请使用--help查看可选参数"
                exit 1
            fi
        else
            echo "error: --target $target 参数错误, 请使用--help查看可选参数"
            exit 1
        fi
    # windows_x64编译环境
    elif [ "$host" = "windows_x64" ]; then
        test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/windows_x64-windows_x64/basic.cfg
        test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/windows_x64-windows_x64/O2.cfg
        test_cfg_static=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/windows_x64-windows_x64/static_O2.cfg
        test_list=${common_testlist},${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/exclude_common,${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/windows_x64-windows_x64/exclude_common,${WORKSPACE}/Cangjie-test/scripts/exclude_tmp
        stdx_name=/libs/stdx/cjnative/cangjie-stdx-windows-x64-1.*.zip
        if [ "$target" = "windows_x64" ]; then
            sdk_name=/cjnative/windows/cangjie-sdk-windows-x64-1.*.zip
        elif [ "$target" = "windows_exe" ]; then
            sdk_name=/cjnative/windows/cangjie-sdk-windows-x64-1.*.exe
        elif [ "$target" = "android26" ]; then
            sdk_name=/cjnative/windows/cangjie-sdk-windows-x64-android-1.*.zip
            if [ "$cross_compile" = "n" ]; then
                echo "native测试, 非交叉编译执行"
            elif [ "$cross_compile" = "y" ]; then
                test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/windows_x64-android_aarch64/android26.cfg
                test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/windows_x64-android_aarch64/android26_O2.cfg
                test_cfg_static=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/windows_x64-android_aarch64/android26_static_O2.cfg
                test_cfg_jffi=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/windows_x64-android_aarch64/android26_jffi.cfg
                stdx_name_cross=/libs/stdx/cjnative/cangjie-stdx-android-aarch64-1.*.zip
            else
                echo "error: --cross_compile $cross_compile 参数错误, 请使用--help查看可选参数"
                exit 1
            fi
        elif [ "$target" = "android31" ]  || [ "$target" = "android" ]; then
            sdk_name=/cjnative/windows/cangjie-sdk-windows-x64-android-1.*.zip
            if [ "$cross_compile" = "n" ]; then
                echo "native测试, 非交叉编译执行"
            elif [ "$cross_compile" = "y" ]; then
                test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/windows_x64-android_aarch64/android31.cfg
                test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/windows_x64-android_aarch64/android31_O2.cfg
                test_cfg_static=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/windows_x64-android_aarch64/android31_static_O2.cfg
                test_cfg_jffi=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/windows_x64-android_aarch64/android35_jffi.cfg
                stdx_name_cross=/libs/stdx/cjnative/cangjie-stdx-android-aarch64-1.*.zip
            else
                echo "error: --cross_compile $cross_compile 参数错误, 请使用--help查看可选参数"
                exit 1
            fi
        elif [ "$target" = "ohos" ]; then
            sdk_name=/cjnative/windows/cangjie-sdk-windows-x64-ohos-1.*.zip
            if [ "$cross_compile" = "n" ]; then
                echo "native测试, 非交叉编译执行" 
            elif [ "$cross_compile" = "y" ]; then
                test_cfg_O0=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/windows_x64-ohos_aarch64/basic.cfg
                test_cfg_O2=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative${branch_cfg}/windows_x64-ohos_aarch64/O2.cfg
                stdx_name_cross=/libs/stdx/cjnative/cangjie-stdx-ohos-aarch64-*.zip
            else
                echo "error: --cross_compile $cross_compile 参数错误, 请使用--help查看可选参数"
                exit 1
            fi
        else
            echo "error: --target $target 参数错误, 请使用--help查看可选参数"
            exit 1
        fi
    else
        echo "error: --host $host 参数错误, 请使用--help查看可选参数"
        exit 1
    fi
}

filter_out_files() {
    tools_name="$1"
    unzip_file="$2"
    loop_name="$3"
    for file in ${unzip_file}; do
        filename=$(basename "$file")
        number_part=$(echo "$filename" | sed -E "s/${loop_name}/\1/")
        if [[ "$number_part" =~ ^[0-9.]+(-(alpha|beta)([.-][0-9]+)*)?$ ]]; then
            :
        else
            rm -rf "$file"
        fi
    done
    if [ "$tools_name" = "tar" ]; then
        tar -zxf ${unzip_file}
    elif [ "$tools_name" = "unzip" ]; then
        unzip -o ${unzip_file} > /dev/null
    else
        echo "error: filter_out_files函数的第一个参数仅可选tar或unzip, 传入的参数为$tools_name"
        exit 1
    fi
    rm -rf ${unzip_file}
}

# 解压版本包
decompress_file() {
    cd ${WORKSPACE}/cangjie_source
    # linux_aarch64编译环境
    if [ "$host" = "linux_aarch64" ]; then
        if [ "$target" = "linux_aarch64" ]; then
            # 解压sanitizer包，API使用
            tar -zxf cangjie-sdk-linux-aarch64-1.*-sanitizer.tar.gz
            mv cangjie cangjie_sanitizer
            # 解压cangjie包
            filter_out_files 'tar' 'cangjie-sdk-linux-aarch64-*.tar.gz' 'cangjie-sdk-linux-aarch64-(.+)\.tar\.gz'
            # 解压stdx包
            filter_out_files 'unzip' 'cangjie-stdx-linux-aarch64-*.zip' 'cangjie-stdx-linux-aarch64-(.+)\.zip'
        elif [ "$target" = "euler" ]; then
            tar -zxf cangjie-sdk-euler-linux-aarch64-*.tar.gz
            tar -zxf cangjie-runtime-euler-linux-aarch64-*.tar.gz
            unzip -o -q cangjie-stdx-euler-linux-aarch64-*.zip
            source cangjie/envsetup.sh
            source runtime/envsetup.sh
        fi
        export CANGJIE_LOCAL_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/dynamic/stdx/
        export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/dynamic/stdx/
    # linux_x64编译环境
    elif [ "$host" = "linux_x64" ]; then
        export CANGJIE_LOCAL_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/dynamic/stdx/
        export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/dynamic/stdx/
        if [ "$target" = "linux_x64" ]; then
            tar -zxf cangjie-sdk-linux-x64-1.*-sanitizer.tar.gz
            mv cangjie cangjie_sanitizer
            filter_out_files 'tar' 'cangjie-sdk-linux-x64-*.tar.gz' 'cangjie-sdk-linux-x64-(.+)\.tar\.gz'
            filter_out_files 'unzip' 'cangjie-stdx-linux-x64-*.zip' 'cangjie-stdx-linux-x64-(.+)\.zip'
        elif [ "$target" = "euler" ]; then
            tar -zxf cangjie-sdk-euler-linux-x64-*.tar.gz
            tar -zxf cangjie-runtime-euler-linux-x64-*.tar.gz
            unzip -o -q cangjie-stdx-euler-linux-x64-*.zip
            source cangjie/envsetup.sh
            source runtime/envsetup.sh
        elif [ "$target" = "android26" ] || [ "$target" = "android31" ] || [ "$target" = "android35" ] || [ "$target" = "android" ]; then
            tar -zxf cangjie-sdk-linux-x64-android-1.*.tar.gz
            rm -rf cangjie-sdk-linux-x64-android-1.*.tar.gz
            filter_out_files 'unzip' 'cangjie-stdx-linux-x64-*.zip' 'cangjie-stdx-linux-x64-(.+)\.zip'
        elif [ "$target" = "ohos" ]; then
            tar -zxf cangjie-sdk-linux-x64-ohos-1.*.tar.gz
            rm -rf cangjie-sdk-linux-x64-ohos-1.*.tar.gz
            filter_out_files 'unzip' 'cangjie-stdx-linux-x64-*.zip' 'cangjie-stdx-linux-x64-(.+)\.zip'
        fi
    # mac_aarch64编译环境
    elif [ "$host" = "mac_aarch64" ]; then
        unzip -o cangjie-stdx-mac-aarch64-1.*.zip > /dev/null
        rm -rf cangjie-stdx-mac-aarch64-1.*.zip
        export CANGJIE_LOCAL_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/dynamic/stdx/
        export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/dynamic/stdx/
        if [ "$target" = "mac_aarch64" ]; then
            tar -zxf cangjie-sdk-mac-aarch64-1.*.tar.gz
            rm -rf cangjie-sdk-mac-aarch64-1.*.tar.gz
        elif [ "$target" = "android23" ]; then
            tar -zxf cangjie-sdk-mac-aarch64-android-1.*.tar.gz
            rm -rf cangjie-sdk-mac-aarch64-android-1.*.tar.gz
            if [ "$cross_compile" = "y" ]; then
                export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/linux_android23_arm_cjnative/dynamic/stdx/
                target_stdx_path=linux_android23_arm_cjnative
                unzip -o cangjie-stdx-android-arm32-1.*.zip > /dev/null
                rm -rf cangjie-stdx-android-arm32-1.*.zip
                cd cangjie/runtime/lib
                adb -s ${device} push linux_android23_arm_cjnative /data/local/tmp/
                adb -s ${device} push ${WORKSPACE}/cangjie_source/linux_android23_arm_cjnative/dynamic/stdx/* /data/local/tmp/linux_android23_arm_cjnative
                adb -s ${device} shell "chmod -R a+x /data/local/tmp"
                export DEVICE_ID=${device}
            fi
        elif [ "$target" = "android26" ] || [ "$target" = "android31" ] || [ "$target" = "android35" ] || [ "$target" = "android" ]; then
            tar -zxf cangjie-sdk-mac-aarch64-android-1.*.tar.gz
            rm -rf cangjie-sdk-mac-aarch64-android-1.*.tar.gz
            if [ "$cross_compile" = "y" ]; then
                export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/linux_android_aarch64_cjnative/dynamic/stdx/
                target_stdx_path=linux_android_aarch64_cjnative
                unzip -o cangjie-stdx-android-aarch64-1.*.zip > /dev/null
                rm -rf cangjie-stdx-android-aarch64-1.*.zip
                cd cangjie/runtime/lib
                adb -s ${device} push linux_android_aarch64_cjnative /data/local/tmp/
                adb -s ${device} push ${WORKSPACE}/cangjie_source/linux_android_aarch64_cjnative/dynamic/stdx/* /data/local/tmp/linux_android_aarch64_cjnative
                adb -s ${device} shell "chmod -R a+x /data/local/tmp"
                export DEVICE_ID=${device}
            fi
        elif [ "$target" = "ios_aarch64" ]; then
            tar -zxf cangjie-sdk-mac-aarch64-ios-1.*.tar.gz
            rm -rf cangjie-sdk-mac-aarch64-ios-1.*.tar.gz
            source ${WORKSPACE}/cangjie_source/cangjie/envsetup.sh
            export CANGJIE_LOCAL_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/static/stdx/
            export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/static/stdx/
            if [ "$cross_compile" = "y" ]; then
                export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/ios_simulator_aarch64_cjnative/static/stdx/
                target_stdx_path=ios_simulator_aarch64_cjnative
                unzip -o cangjie-stdx-ios-simulator-aarch64-1.*.zip > /dev/null
                rm -rf cangjie-stdx-ios-simulator-aarch64-1.*.zip
                cp -r ${WORKSPACE_SCRIPTS}/testsuites/HLT/configs/cjnative/ios/xcode_project_of_cangjie_ios_test ${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/ios/
                cp -r ${WORKSPACE_SCRIPTS}/testsuites/HLT/configs/cjnative/ios/objc_ffi_test ${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/ios/
                export XCODEPROJ_PATH_OF_CANGJIE_IOS_TEST=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/ios/xcode_project_of_cangjie_ios_test/test_cangjie_ios_175.xcodeproj
                export XCODE_DEVICE_TYPE_OF_CANGJIE_IOS_TEST=simulator
                export XCODE_DEVICE_UDID_OF_CANGJIE_IOS_TEST="${device}"
                xcrun simctl boot ${XCODE_DEVICE_UDID_OF_CANGJIE_IOS_TEST} && sleep 60
                export XCODE_BRIDGE_CANGJIE_DIR_OF_CANGJIE_IOS_TEST=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/ios/xcode_project_of_cangjie_ios_test/test_cangjie_ios_175/bridge_cangjie
                cp -r ${CANGJIE_HOME}/lib/ios_simulator_aarch64_cjnative/* ${XCODE_BRIDGE_CANGJIE_DIR_OF_CANGJIE_IOS_TEST}/
                cp -r ${CANGJIE_STDX_PATH}/*.a ${XCODE_BRIDGE_CANGJIE_DIR_OF_CANGJIE_IOS_TEST}/
            fi
        elif [ "$target" = "ios_x64" ]; then
            tar -zxf cangjie-sdk-mac-aarch64-ios-1.*.tar.gz
            rm -rf cangjie-sdk-mac-aarch64-ios-1.*.tar.gz
            source ${WORKSPACE}/cangjie_source/cangjie/envsetup.sh
            export CANGJIE_LOCAL_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/static/stdx/
            export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/static/stdx/
            if [ "$cross_compile" = "y" ]; then
                export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/ios_simulator_x86_64_cjnative/static/stdx/
                target_stdx_path=ios_simulator_x86_64_cjnative
                unzip -o cangjie-stdx-ios-simulator-x64-1.*.zip > /dev/null
                rm -rf cangjie-stdx-ios-simulator-x64-1.*.zip
                cp -r ${WORKSPACE_SCRIPTS}/testsuites/HLT/configs/cjnative/ios/xcode_project_of_cangjie_ios_test_x64 ${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/ios/xcode_project_of_cangjie_ios_test
                export XCODEPROJ_PATH_OF_CANGJIE_IOS_TEST=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/ios/xcode_project_of_cangjie_ios_test/test_cangjie_ios_175.xcodeproj
                export XCODE_DEVICE_TYPE_OF_CANGJIE_IOS_TEST=simulator
                export XCODE_DEVICE_UDID_OF_CANGJIE_IOS_TEST="${device}"
                xcrun simctl boot ${XCODE_DEVICE_UDID_OF_CANGJIE_IOS_TEST} && sleep 60
                export XCODE_BRIDGE_CANGJIE_DIR_OF_CANGJIE_IOS_TEST=${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/ios/xcode_project_of_cangjie_ios_test/test_cangjie_ios_175/bridge_cangjie
                cp -r ${CANGJIE_HOME}/lib/ios_simulator_x86_64_cjnative/* ${XCODE_BRIDGE_CANGJIE_DIR_OF_CANGJIE_IOS_TEST}/
                cp -r ${CANGJIE_STDX_PATH}/*.a ${XCODE_BRIDGE_CANGJIE_DIR_OF_CANGJIE_IOS_TEST}/
            fi
        elif [ "$target" = "ohos" ]; then
            tar -zxf cangjie-sdk-mac-aarch64-ohos-1.*.tar.gz
            rm -rf cangjie-sdk-mac-aarch64-ohos-1.*.tar.gz
            if [ "$cross_compile" = "y" ]; then
                export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/linux_ohos_aarch64_cjnative/dynamic/stdx/
                target_stdx_path=linux_ohos_aarch64_cjnative
                unzip -o cangjie-stdx-ohos-aarch64-*.zip > /dev/null
                rm -rf cangjie-stdx-ohos-aarch64-*.zip
                cd cangjie/runtime/lib
                hdc file send linux_ohos_aarch64_cjnative/ /data/local/tmp/
                hdc file send ${WORKSPACE}/cangjie_source/linux_ohos_aarch64_cjnative/dynamic/stdx /data/local/tmp/linux_ohos_aarch64_cjnative/
                hdc shell "mv /data/local/tmp/linux_ohos_aarch64_cjnative/stdx/* /data/local/tmp/linux_ohos_aarch64_cjnative"
                hdc shell "chmod -R a+x /data/local/tmp"
                export DEVICE_ID=${device}
            fi
        fi
    # mac_x64编译环境
    elif [ "$host" = "mac_x64" ]; then
        unzip -o cangjie-stdx-mac-x64-1.*.zip > /dev/null
        rm -rf cangjie-stdx-mac-x64-1.*.zip
        export CANGJIE_LOCAL_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/dynamic/stdx/
        export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/dynamic/stdx/
        if [ "$target" = "mac_x64" ]; then
            tar -zxf cangjie-sdk-mac-x64-1.*.tar.gz
            rm -rf cangjie-sdk-mac-x64-1.*.tar.gz
        elif [ "$target" = "ohos" ]; then
            if [ "$cross_compile" = "y" ]; then
                export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/linux_ohos_aarch64_cjnative/dynamic/stdx/
                target_stdx_path=linux_ohos_aarch64_cjnative
                tar -zxf cangjie-sdk-mac-x64-ohos-1.*.tar.gz
                rm -rf cangjie-sdk-mac-x64-ohos-1.*.tar.gz
                unzip -o cjnative/cangjie-stdx-ohos-aarch64-*.zip > /dev/null
                rm -rf cjnative/cangjie-stdx-ohos-aarch64-*.zip
            fi
        fi
    # windows_x64编译环境
    elif [ "$host" = "windows_x64" ]; then
        unzip -o cangjie-stdx-windows-x64-1.*.zip > /dev/null
        rm -rf cangjie-stdx-windows-x64-1.*.zip
        export CANGJIE_LOCAL_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/dynamic/stdx/
        export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/dynamic/stdx/
        if [ "$target" = "windows_x64" ]; then
            unzip -o cangjie-sdk-windows-x64-1.*.zip > /dev/null
            rm -rf cangjie-sdk-windows-x64-1.*.zip
        elif [ "$target" = "windows_exe" ]; then
            7z -y x cangjie-sdk-windows-x64-1.*.exe -o${WORKSPACE}/cangjie_source/cangjie/
            rm -rf cangjie-sdk-windows-x64-1.*.exe
        elif [ "$target" = "android26" ]; then
            unzip -o cangjie-sdk-windows-x64-android-1.*.zip > /dev/null
            rm -rf cangjie-sdk-windows-x64-android-1.*.zip
            if [ "$cross_compile" = "y" ]; then
                export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/linux_android_aarch64_cjnative/dynamic/stdx/
                target_stdx_path=linux_android_aarch64_cjnative
                unzip -o cangjie-stdx-android-aarch64-1.*.zip > /dev/null
                rm -rf cangjie-stdx-android-aarch64-1.*.zip
                cd cangjie/runtime/lib/linux_android_aarch64_cjnative
                for file in .* *; do
                    if [ -f "$file" ] && [ "$file" != "." ] && [ "$file" != ".." ]; then
                        adb -s ${device} push ${file} //data/local/tmp/
                    fi
                done
                cd ${WORKSPACE}/cangjie_source/linux_android_aarch64_cjnative/dynamic/stdx
                for file in .* *; do
                    if [ -f "$file" ] && [ "$file" != "." ] && [ "$file" != ".." ]; then
                        adb -s ${device} push ${file} //data/local/tmp/
                    fi
                done
                adb -s ${device} shell "chmod -R a+x /data/local/tmp"
                export DEVICE_ID=${device}
            fi
        elif [ "$target" = "android31" ]  || [ "$target" = "android" ]; then
            unzip -o cangjie-sdk-windows-x64-android-1.*.zip > /dev/null
            rm -rf cangjie-sdk-windows-x64-android-1.*.zip
            if [ "$cross_compile" = "y" ]; then
                export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/linux_android_aarch64_cjnative/dynamic/stdx/
                target_stdx_path=linux_android_aarch64_cjnative
                unzip -o cangjie-stdx-android-aarch64-1.*.zip > /dev/null
                rm -rf cangjie-stdx-android-aarch64-1.*.zip
                cd cangjie/runtime/lib
                tar -cvf linux_android_aarch64_cjnative.tar linux_android_aarch64_cjnative
                adb -s ${device} push linux_android_aarch64_cjnative.tar //data/local/tmp/
                adb -s ${device} shell "cd /data/local/tmp/ && tar -xvf linux_android_aarch64_cjnative.tar"
                cd ${WORKSPACE}/cangjie_source/linux_android_aarch64_cjnative/dynamic/
                tar -cvf stdx.tar stdx
                adb -s ${device} push stdx.tar //data/local/tmp/
                adb -s ${device} shell "cd /data/local/tmp/ && tar -xvf stdx.tar && cp stdx/* linux_android_aarch64_cjnative/"
                adb -s ${device} shell "chmod -R a+x /data/local/tmp"
                export DEVICE_ID=${device}
            fi
        elif [ "$target" = "ohos" ]; then
            target_stdx_path=linux_ohos_aarch64_cjnative
            unzip -o cangjie-sdk-windows-x64-ohos-1.*.zip > /dev/null
            rm -rf cangjie-sdk-windows-x64-ohos-1.*.zip
            if [ "$cross_compile" = "y" ]; then
                export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/linux_ohos_aarch64_cjnative/dynamic/stdx/
                unzip -o cangjie-stdx-ohos-aarch64-*.zip > /dev/null
                rm -rf cangjie-stdx-ohos-aarch64-*.zip
                cd cangjie/runtime/lib
                powershell.exe -Command "hdc file send linux_ohos_aarch64_cjnative /data/local/tmp/"
                cd ${WORKSPACE}
                cd cangjie_source/linux_ohos_aarch64_cjnative/dynamic
                powershell.exe -Command "hdc file send stdx /data/local/tmp/linux_ohos_aarch64_cjnative/"
                hdc shell "mv /data/local/tmp/linux_ohos_aarch64_cjnative/stdx/* /data/local/tmp/linux_ohos_aarch64_cjnative"
                hdc shell "chmod -R a+x /data/local/tmp"
                export DEVICE_ID=${device}
            fi
        fi
    fi
    cd ${WORKSPACE}
}

# 执行用例
run_tests() {
    local temp_module_name=$1
    local option=$2
    local cfg=$3
    # 执行的特殊环境标注，体现在看板的目录上
    run_system=""
    if [[ -n ${system} ]]; then
        run_system="_${system}"
    else
        run_system="_${host}"
    fi
    # 执行的用例等级
    run_level=""
    if [[ -n ${level} ]]; then
        run_level="--level=${level}"
    fi
    # 如果并发度为1，在看板目录上标注串行
    concurrency_path=""
    if [ "$concurrency" -eq 1 ]; then
        concurrency_path="_serial"
    fi
    # 若未设置切片数量，默认为1，即不切分
    if [[ -z ${split} ]]; then
        split=1
    fi
    IFS=',' read -r -a run_split_list <<< "${run_split// /}"
    # 按切片数量循环
    for ((i=1; i<=split; i++))
    do
        # 执行第几个切片，如果不设置run_split则所有切片均执行
        if [ -z ${run_split} ] || [[ " ${run_split_list[@]} " =~ " ${i} " ]]; then
            local module_name=${temp_module_name}_${i}
            if [ "$split" -eq 1 ]; then
                module_name=${temp_module_name}
            fi
            temp_cross=""
            if [ "$cross_compile" = "n" ]; then
                temp_cross="_native"
            fi
            local job_name="${host}_to_${target}${temp_cross}_${branch}"
            local node_name=${temp_module_name}_${option}_${branch}
            local log_dir=${WORKSPACE}/cangjie_test_framework/framework/${module_name}/${option}/log
            local json_name=${module_name}_${option}${concurrency_path}${run_system}
            local json_path=${WORKSPACE}/test_result/${json_name}.json
            local REMOTE_LOG_DIR="/home/whoami/tools/apache-tomcat/webapps/whoami/${job_name}/${current_time}/${json_name}/"
            local join_log_path="/home/jenkins/workspace/daily_version/result_json/${cmc_binary_version// /_}_${snapshot_version}/${job_name}/"
            local health_json_path="/home/jenkins/workspace/daily_version/result_json/"
            local health_json_name="${cmc_binary_version// /_}_${snapshot_version}.json"
            
            local run_split=""
            if [ "$split" -ne 1 ]; then
                run_split="--run_split=${i}/${split}"
            fi

            # MAC上使用,防止系统进入休眠
            local temp_caffeinate=""
            if [ "${os_type}" = "Darwin" ]; then
                temp_caffeinate="caffeinate -u -t 14400"
            fi
            
            ${temp_caffeinate} python3 ${WORKSPACE}/cangjie_test_framework/main.py ${run_level} -pFAIL --progress=silent -j${concurrency} --debug --json_output=${json_path} --log_dir=${log_dir} --test_cfg=${cfg} --test_list=${test_list} ${run_split}
            
            # 上传看板
            unset HTTPS_PROXY
            unset HTTP_PROXY
            if [ ${upload_cpltp}  = "y" ]; then
                if [ "${os_type}" == "Darwin" ]; then
                    set +e
                fi
                python3 ${WORKSPACE_SCRIPTS}/scripts/get_fail_log.py "${json_path}" "${log_dir}"
                python3 ${WORKSPACE_SCRIPTS}/scripts/updata_cpltp.py --action=delete --time_flag=${time_flag} --path=Cangjie-${level_2_directory}_${branch}-${job_name}-${node_name}-${json_name} || true
                python3 ${WORKSPACE_SCRIPTS}/.cloudbuild/test/analyze.py "${json_path}" --start_time=${current_time} --jenkins_id=${jenkins_id} --job_name=${job_name} --node_name=${node_name}
                if [ "$(echo ${docker_image} | grep "kylin")" != "" ] || [ "$host" = "windows_x64" ] || [ "$target" = "euler" ]; then
                    python3 ${WORKSPACE_SCRIPTS}/scripts/sshpass.py x.x.x.x 22 whoami "xxx" upload ${log_dir} ${REMOTE_LOG_DIR}/log
                    python3 ${WORKSPACE_SCRIPTS}/scripts/sshpass.py x.x.x.x 22 whoami "xxx" upload ${json_path} ${REMOTE_LOG_DIR}/${json_name}.json
                    python3 ${WORKSPACE_SCRIPTS}/scripts/sshpass.py x.x.x.x 22 whoami "xxx" upload ${json_path} ${join_log_path}/${json_name}.json
                    python3 ${WORKSPACE_SCRIPTS}/scripts/sshpass.py x.x.x.x 22 whoami "xxx" download ${health_json_path}/${health_json_name} ${WORKSPACE_SCRIPTS}/scripts/${health_json_name}
                    python3 ${WORKSPACE_SCRIPTS}/scripts/project_health_check.py --function update_data --health_data_path ${WORKSPACE_SCRIPTS}/scripts/${health_json_name} --job_name ${job_name} --json_name ${json_name} --json_path ${json_path}
                    python3 ${WORKSPACE_SCRIPTS}/scripts/sshpass.py x.x.x.x 22 whoami "xxx" upload ${WORKSPACE_SCRIPTS}/scripts/${health_json_name} ${health_json_path}/${health_json_name}
                else
                    execute_with_retry 'sshpass -p xxx ssh -o StrictHostKeyChecking=no whoami@x.x.x.x "mkdir -p ${REMOTE_LOG_DIR}"'
                    execute_with_retry 'sshpass -p xxx scp -o StrictHostKeyChecking=no -r ${log_dir} ${json_path} whoami@x.x.x.x:${REMOTE_LOG_DIR}'
                    execute_with_retry 'sshpass -p xxx ssh -o StrictHostKeyChecking=no xxx@x.x.x.x "mkdir -p ${join_log_path}"'
                    execute_with_retry 'sshpass -p xxx scp -o StrictHostKeyChecking=no -r ${json_path} xxx@x.x.x.x:${join_log_path}'
                    execute_with_retry 'sshpass -p xxx scp -o StrictHostKeyChecking=no -r whoami@x.x.x.x:${health_json_path}/${health_json_name} ${WORKSPACE_SCRIPTS}/scripts/' || true
                    python3 ${WORKSPACE_SCRIPTS}/scripts/project_health_check.py --function update_data --health_data_path ${WORKSPACE_SCRIPTS}/scripts/${health_json_name} --job_name ${job_name} --json_name ${json_name} --json_path ${json_path}
                    execute_with_retry 'sshpass -p xxx scp -o StrictHostKeyChecking=no -r ${WORKSPACE_SCRIPTS}/scripts/${health_json_name} whoami@x.x.x.x:${health_json_path}'
                fi
                if [ "${os_type}" == "Darwin" ]; then
                    set -e
                fi
            fi
        fi
    done
}

run_testlist() {
    if echo "${module}" | grep -q "runtime"; then
        echo '[ALL-TEST-CASE]' > ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'Runtime/' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '[EXCLUDE-TEST-CASE]' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        if echo "${module}" | grep -q "runtime_O0"; then
            echo "Run runtime_O0"
            run_tests runtime O0 ${test_cfg_O0} 
        fi
        if echo "${module}" | grep -q "runtime_O2"; then
            echo "Run runtime_O2"
            run_tests runtime O2 ${test_cfg_O2} 
        fi
        if echo "${module}" | grep -q "runtime_lto"; then
            echo "Run runtime_lto"
            run_tests runtime compile_as_exe_lto_full_O2 ${test_cfg_compile_as_exe_lto_full_O2} 
            run_tests runtime compile_as_exe_lto_thin_O2 ${test_cfg_compile_as_exe_lto_thin_O2} 
            run_tests runtime lto_full_O2 ${test_cfg_lto_full_O2} 
            run_tests runtime lto_thin_O2 ${test_cfg_lto_thin_O2} 
        fi
    fi
    
    if echo "${module}" | grep -q "compiler"; then
        echo '[ALL-TEST-CASE]' > ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'compiler/' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'regression/' >> ${WORKSPACE}/cangjie_test/testsuites//HLT/testlist
        echo '[EXCLUDE-TEST-CASE]' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'compiler/cjnative/stable_abi' >> ${WORKSPACE}/cangjie_test/testsuites//HLT/testlist
        # 用例里面写明了只能在iOSNative场景下生效，iOSNative场景下需要此句
        echo 'compiler/cjnative/FFI/objcffi' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        # exclude_cjnative屏蔽列表里屏蔽了该目录，此处不添加亦可
        echo 'compiler/cjnative/FFI/jffi/android' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        if echo "${module}" | grep -q "compiler_O0"; then
            echo "Run compiler_O0"
            run_tests compiler O0 ${test_cfg_O0} 
        fi
        if echo "${module}" | grep -q "compiler_O2"; then
            echo "Run compiler_O2"
            run_tests compiler O2 ${test_cfg_O2} 
        fi
        if echo "${module}" | grep -q "compiler_g"; then
            echo "Run compiler_g"
            run_tests compiler g ${test_cfg_g} 
        fi
        if echo "${module}" | grep -q "compiler_mock"; then
            echo "Run compiler_mock"
            run_tests compiler mock ${test_cfg_mock} 
        fi
        if echo "${module}" | grep -q "compiler_lto"; then
            echo "Run compiler_lto"
            run_tests compiler compile_as_exe_lto_full_O2 ${test_cfg_compile_as_exe_lto_full_O2} 
            run_tests compiler compile_as_exe_lto_thin_O2 ${test_cfg_compile_as_exe_lto_thin_O2} 
            run_tests compiler lto_full_O2 ${test_cfg_lto_full_O2} 
            run_tests compiler lto_thin_O2 ${test_cfg_lto_thin_O2} 
        fi
    fi
    
    if echo "${module}" | grep -q "jffi_O2"; then
        echo "Run jffi_O2"
        cp -r ${WORKSPACE_SCRIPTS}/testsuites/HLT/configs/cjnative/android/MyApplication ${WORKSPACE}/cangjie_test/testsuites/HLT/configs/cjnative/android/
        echo '[ALL-TEST-CASE]' > ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'compiler/cjnative/FFI/jffi/android/' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '[EXCLUDE-TEST-CASE]' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        # java不支持native
        echo 'compiler/cjnative/FFI/jffi/android/native' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        # objc不支持native
        echo 'compiler/cjnative/FFI/objcffi/glue_code/cj_impl' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        # 指定了目录，test_list不用包含屏蔽列表，屏蔽列表中屏蔽了jffi目录
        temp_test_list=${test_list}
        test_list=${common_testlist}
        run_tests jffi O2 ${test_cfg_jffi} 
        test_list=${temp_test_list}
    fi
    if echo "${module}" | grep -q "objcffi_O2"; then
        echo "Run objcffi_O2"
        echo '[ALL-TEST-CASE]' > ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'compiler/cjnative/FFI/objcffi/' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '[EXCLUDE-TEST-CASE]' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        # 指定了目录，test_list不用包含屏蔽列表，屏蔽列表中屏蔽了jffi目录
        temp_test_list=${test_list}
        test_list=${common_testlist}
        run_tests objcffi O2 ${test_cfg_objcffi}
        test_list=${temp_test_list}
    fi
    if echo "${module}" | grep -q "cjcpl"; then
        if [ "${branch_cfg}" == "_main" ]; then
            if [ "${os_type}" == "Darwin" ]; then
                find ${WORKSPACE}/cangjie_test/testsuites/HLT/compiler/cjnative/stable_abi -type f -exec sed -i '' 's/E-EXEC-PIPE/EXEC-PIPE/g' {} +
            elif [ "$host" = "windows_x64" ]; then
                echo "执行cjcpl前，请自行执行bash -c 'find cangjie_test/testsuites/HLT/compiler/cjnative/stable_abi -type f -exec sed -i 's/E-EXEC-PIPE/EXEC-PIPE/g' {} \\;'"
            else 
                find ${WORKSPACE}/cangjie_test/testsuites/HLT/compiler/cjnative/stable_abi -type f -exec sed -i 's/E-EXEC-PIPE/EXEC-PIPE/g' {} \; 
            fi
        fi
        echo '[ALL-TEST-CASE]' > ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        if [ "${branch}" == "main" ]; then
            echo 'Tools/cjcpl' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        fi
        echo 'compiler/cjnative/stable_abi' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '[EXCLUDE-TEST-CASE]' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        run_tests cjcpl O0 ${test_cfg_O0} 
    fi
    if echo "${module}" | grep -q "cjcov"; then
        echo '[ALL-TEST-CASE]' > ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'Tools/cjcov' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '[EXCLUDE-TEST-CASE]' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        run_tests cjcov O0 ${test_cfg_O0} 
    fi
    if echo "${module}" | grep -q "cjdb"; then
        echo '[ALL-TEST-CASE]' > ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'Tools/cjdb' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '[EXCLUDE-TEST-CASE]' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        run_tests cjdb O0 ${test_cfg_O0} 
    fi
    if echo "${module}" | grep -q "cjfmt"; then
        echo '[ALL-TEST-CASE]' > ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'Tools/cjfmt' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '[EXCLUDE-TEST-CASE]' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        run_tests cjfmt O0 ${test_cfg_O0} 
    fi
    if echo "${module}" | grep -q "cjlint"; then
        echo '[ALL-TEST-CASE]' > ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'Tools/cjlint' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '[EXCLUDE-TEST-CASE]' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        run_tests cjlint O0 ${test_cfg_O0} 
    fi
    if echo "${module}" | grep -q "cjpm"; then
        export CANGJIE_REPO_TOKEN="xxx=="
        git config --global user.name "xxx"
        git config --global http.sslVerify false
        git config --global xxx
        rm ${WORKSPACE}/cangjie_test/testsuites/HLT/Tools/cjpm/repo/publish/error_publish_01/error_publish_01.info || true
        rm ${WORKSPACE}/cangjie_test/testsuites/HLT/Tools/cjpm/repo/publish/error_publish_04/error_publish_04.info || true
        if [ "${os_type}" == "Darwin" ]; then
            find ${WORKSPACE}/cangjie_test/testsuites/HLT/Tools/cjpm -type f -exec sed -i '' 'xx#g' {} + || true
            find ${WORKSPACE}/cangjie_test/testsuites/HLT/Tools/cjpm -type f -exec sed -i '' 's#xx#g' {} + || true
        elif [ "$host" = "windows_x64" ]; then
            echo "执行cjpm前，请自行替换Tools/cjpm/repo目录下的代码仓地址"
        else 
            find ${WORKSPACE}/cangjie_test/testsuites/HLT/Tools/cjpm -type f -exec sed -i 's##g' {} \; || true
            find ${WORKSPACE}/cangjie_test/testsuites/HLT/Tools/cjpm -type f -exec sed -i 's##g' {} \; || true
        fi
        echo '[ALL-TEST-CASE]' > ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'Tools/cjpm' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '[EXCLUDE-TEST-CASE]' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        run_tests cjpm O0 ${test_cfg_O0} 
    fi
    if echo "${module}" | grep -q "cjprof"; then
        echo '[ALL-TEST-CASE]' > ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'Tools/cjprof' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '[EXCLUDE-TEST-CASE]' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        run_tests cjprof O0 ${test_cfg_O0} 
    fi
    if echo "${module}" | grep -q "cjtrace"; then
        echo '[ALL-TEST-CASE]' > ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'Tools/cjtrace-recover' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '[EXCLUDE-TEST-CASE]' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        run_tests cjtrace O0 ${test_cfg_O0} 
    fi
    if echo "${module}" | grep -q "cjlsp"; then
        if [ "$host" = "windows_x64" ]; then
            CANGJIE_HOME_WIN=$(cygpath -w ${CANGJIE_HOME} | sed 's/\\/\\\\/g')
            "${sed[@]}" "s|linux_path = \${linux_lsp_server_path}|linux_path = ${CANGJIE_HOME_WIN}/tools/bin|g" ${WORKSPACE}/cangjie_test/testsuites/HLT/Tools/cjlsp/lsp_config.txt
            "${sed[@]}" "s|win_path = \${win_lsp_server_path}|win_path = ${CANGJIE_HOME_WIN}/tools/bin|g" ${WORKSPACE}/cangjie_test/testsuites/HLT/Tools/cjlsp/lsp_config.txt
        else 
            "${sed[@]}" "s|linux_path = \${linux_lsp_server_path}|linux_path = ${CANGJIE_HOME}/tools/bin|g" ${WORKSPACE}/cangjie_test/testsuites/HLT/Tools/cjlsp/lsp_config.txt
            "${sed[@]}" "s|win_path = \${win_lsp_server_path}|win_path = ${CANGJIE_HOME}/tools/bin|g" ${WORKSPACE}/cangjie_test/testsuites/HLT/Tools/cjlsp/lsp_config.txt
        fi
        echo '[ALL-TEST-CASE]' > ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'Tools/cjlsp' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '[EXCLUDE-TEST-CASE]' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        run_tests cjlsp O0 ${test_cfg_O0} 
    fi
    if echo "${module}" | grep -q "hle"; then
        echo "strict-ssl=false" > ~/.npmrc
        echo "registry=http://mirrors.tools.huawei.com/npm" >> ~/.npmrc
        echo "noproxy=.huawei.com" >> ~/.npmrc
        echo "proxy=" >> ~/.npmrc
        echo "https-proxy=" >> ~/.npmrc
        export HTTPS_PROXY=
        export HTTP_PROXY=
        cd ${WORKSPACE}/cangjie_source/cangjie/tools/dtsparser
        npm install
        cd ${WORKSPACE}
        echo '[ALL-TEST-CASE]' > ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'Tools/hle' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '[EXCLUDE-TEST-CASE]' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        run_tests hle O0 ${test_cfg_O0} 
    fi
    # 执行API
    if echo "${module}" | grep -q "api"; then
        echo '[ALL-TEST-CASE]' > ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo 'API/' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist
        echo '[EXCLUDE-TEST-CASE]' >> ${WORKSPACE}/cangjie_test/testsuites/HLT/testlist

        if echo "${module}" | grep -q "api_O0"; then
            echo "Run api_O0"
            run_tests api O0 ${test_cfg_O0} 
        fi
        if echo "${module}" | grep -q "api_O2"; then
            echo "Run api_O2"
            run_tests api O2 ${test_cfg_O2} 
        fi
        if echo "${module}" | grep -q "api_g"; then
            echo "Run api_g"
            run_tests api g ${test_cfg_g} 
        fi
        if echo "${module}" | grep -q "api_mock"; then
            echo "Run api_mock"
            run_tests api mock ${test_cfg_mock} 
        fi
        if echo "${module}" | grep -q "api_lto"; then
            echo "Run api_lto"
            run_tests api compile_as_exe_lto_full_O2 ${test_cfg_compile_as_exe_lto_full_O2} 
            run_tests api compile_as_exe_lto_thin_O2 ${test_cfg_compile_as_exe_lto_thin_O2} 
            run_tests api lto_full_O2 ${test_cfg_lto_full_O2} 
            run_tests api lto_thin_O2 ${test_cfg_lto_thin_O2} 
        fi
        if echo "${module}" | grep -q "api_static_O2"; then
            echo "Run api_static_O2"
            export CANGJIE_LOCAL_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/static/stdx/
            export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/${target_stdx_path}/static/stdx/
            run_tests api_static O2 ${test_cfg_static} 
            export CANGJIE_LOCAL_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/dynamic/stdx/
            export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/${target_stdx_path}/dynamic/stdx/
        fi
        if echo "${module}" | grep -q "api_static_extern_O2"; then
            echo "Run api_static_extern_O2"
            export CANGJIE_LOCAL_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/static-static-link-extern/stdx/
            export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/${target_stdx_path}/static-static-link-extern/stdx/
            run_tests api_static_extern O2 ${test_cfg_static} 
            export CANGJIE_LOCAL_STDX_PATH=${WORKSPACE}/cangjie_source/${host_stdx_path}/dynamic/stdx/
            export CANGJIE_STDX_PATH=${WORKSPACE}/cangjie_source/${target_stdx_path}/dynamic/stdx/
        fi
        if echo "${module}" | grep -q "api_asan_O0"; then
            echo "Run api_asan_O0"
            source ${WORKSPACE}/cangjie_source/cangjie_sanitizer/envsetup.sh
            run_tests api_asan O0 ${test_cfg_asan_O0} 
            source ${WORKSPACE}/cangjie_source/cangjie/envsetup.sh
        fi
        if echo "${module}" | grep -q "api_asan_O2"; then
            echo "Run api_asan_O2"
            source ${WORKSPACE}/cangjie_source/cangjie_sanitizer/envsetup.sh
            run_tests api_asan O2 ${test_cfg_asan_O2} 
            source ${WORKSPACE}/cangjie_source/cangjie/envsetup.sh
        fi
        if echo "${module}" | grep -q "api_tsan_O0"; then
            echo "Run api_tsan_O0"
            source ${WORKSPACE}/cangjie_source/cangjie_sanitizer/envsetup.sh
            run_tests api_tsan O0 ${test_cfg_tsan_O0} 
            source ${WORKSPACE}/cangjie_source/cangjie/envsetup.sh
        fi
        if echo "${module}" | grep -q "api_tsan_O2"; then
            echo "Run api_tsan_O2"
            source ${WORKSPACE}/cangjie_source/cangjie_sanitizer/envsetup.sh
            run_tests api_tsan O2 ${test_cfg_tsan_O2} 
            source ${WORKSPACE}/cangjie_source/cangjie/envsetup.sh
        fi
    fi
}


# 解析参数
parse_options "$@"

if [ "$host" = "linux_aarch64" ]; then
    host_stdx_path="linux_aarch64_cjnative"
    target_stdx_path="linux_aarch64_cjnative"
elif [ "$host" = "linux_x64" ]; then
    host_stdx_path="linux_x86_64_cjnative"
    target_stdx_path="linux_x86_64_cjnative"
elif [ "$host" = "mac_aarch64" ]; then
    host_stdx_path="darwin_aarch64_cjnative"
    target_stdx_path="darwin_aarch64_cjnative"
elif [ "$host" = "mac_x64" ]; then
    host_stdx_path="darwin_x86_64_cjnative"
    target_stdx_path="darwin_x86_64_cjnative"
elif [ "$host" = "windows_x64" ]; then
    host_stdx_path="windows_x86_64_cjnative"
    target_stdx_path="windows_x86_64_cjnative"
fi

branch_cfg=""

if [ "$branch" = "main" ]; then
    branch_cfg="_main"
fi

if [ "$branch" = "release/1.0" ]; then
    branch_cfg="_release1.0"
    branch="main"
fi

if [ "$branch" = "release/1.1" ]; then
    branch_cfg="_release1.1"
    branch="main"
fi

if [ "$branch" = "release_jd" ]; then
    branch_cfg="_jd"
    branch="main"
fi

# 数据上传至看板的日期
if [ -z "${jenkins_id}" ]; then
	jenkins_id=$(date +%Y%m%d)
fi
current_time="${jenkins_id}$(date +%H%M%S)"
time_flag="${jenkins_id:0:4}-${jenkins_id:4:2}-${jenkins_id:6:2}"

# 确定要使用的包和cfg
prepare_operation
cp -r ${WORKSPACE_SCRIPTS}/scripts/configs/* ${WORKSPACE}/cangjie_test/testsuites/HLT/configs/
# 生成拉包的xml文件
create_xml
# cangjie_source为版本包的放置目录
rm -rf ${WORKSPACE}/cangjie_source || true
mkdir -p ${WORKSPACE}/cangjie_source || true
# test_result为执行结果json存放路径
mkdir -p ${WORKSPACE}/test_result
# 拉取版本包
if [ "${os_type}" = "Darwin" ]; then
    # execute_with_retry 'sshpass -p jenkins ssh -o StrictHostKeyChecking=no xxxx@x.x.x.x "rm -rf /home/jenkins/workspace/daily_version/${yesterday}* && mkdir -p /home/jenkins/workspace/daily_version/$current_time/"'
    # execute_with_retry 'sshpass -p jenkins scp -o StrictHostKeyChecking=no cmc.xml xxx@x.x.x.x:"/home/jenkins/workspace/daily_version/$current_time/"'
    # execute_with_retry 'sshpass -p jenkins ssh -o StrictHostKeyChecking=no xxx@x.x.x.x "/home/jenkins/workspace/artget pull -d /home/jenkins/workspace/daily_version/$current_time/cmc.xml -ru software -user $artget_user -pwd $artget_pwd -ap /home/jenkins/workspace/daily_version/$current_time"'
    # execute_with_retry 'sshpass -p jenkins scp -o StrictHostKeyChecking=no -r xxx@x.x.x.x:"/home/jenkins/workspace/daily_version/$current_time/cangjie-*" $WORKSPACE/cangjie_source'
    ${WORKSPACE_SCRIPTS}/scripts/artget_darwin pull -d cmc.xml -ru software -user $artget_user -pwd $artget_pwd -ap ${WORKSPACE}/cangjie_source
else
    ${WORKSPACE_SCRIPTS}/scripts/artget pull -d cmc.xml -ru software -user $artget_user -pwd $artget_pwd -ap ${WORKSPACE}/cangjie_source
fi
# 解压版本包
decompress_file
source ${WORKSPACE}/cangjie_source/cangjie/envsetup.sh
cjc -v
# 拷贝huawei_secure_c文件
execute_with_retry 'python3 ${WORKSPACE_SCRIPTS}/scripts/sshpass.py x.x.x.x 22 xxxx xxxx download /home/jenkins/workspace/daily_version/huawei_secure_c ${WORKSPACE_SCRIPTS}/scripts/huawei_secure_c'
# 设置huawei_secure_c环境变量
export TERM=xterm
export C_INCLUDE_PATH=${WORKSPACE_SCRIPTS}/scripts/huawei_secure_c:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=${WORKSPACE_SCRIPTS}/scripts/huawei_secure_c:$CPLUS_INCLUDE_PATH
export CANGJIE_TEST=${WORKSPACE}/cangjie_test
# 将不开源的用例复制过去
cp -r ${WORKSPACE_SCRIPTS}/testsuites/HLT/Tools/* ${WORKSPACE}/cangjie_test/testsuites/HLT/Tools
cp -r ${WORKSPACE_SCRIPTS}/testsuites/HLT/regression/* ${WORKSPACE}/cangjie_test/testsuites/HLT/regression
"${sed[@]}" "s#:../../cangjie_test/testsuites/LLT##g" ${WORKSPACE}/cangjie_test_framework/maple_test/maple_test.cfg
# 执行用例
run_testlist
