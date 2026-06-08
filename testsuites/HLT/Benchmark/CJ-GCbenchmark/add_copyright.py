import os
from pathlib import Path

COPYRIGHT_HEADER = """# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
# 
# See https://cangjie-lang.cn/pages/LICENSE for license information.
"""

def add_copyright_to_file(file_path):
    """在cj文件顶部添加版权声明"""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 检查是否已有版权声明
    if 'Copyright' in content:
        print(f'跳过（已有版权）: {file_path}')
        return
    
    # 添加版权声明到文件顶部
    new_content = COPYRIGHT_HEADER + '\n' + content
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print(f'已添加版权: {file_path}')

def batch_add_copyright(directory):
    """批量处理目录下所有cj文件"""
    dir_path = Path(directory)
    
    if not dir_path.exists():
        print(f'目录不存在: {directory}')
        return
    
    # 统计处理数量
    count = 0
    
    # 递归查找所有cj文件
    for cj_file in dir_path.rglob('*.py'):
        add_copyright_to_file(cj_file)
        count += 1
    
    print(f'\n处理完成，共处理 {count} 个文件')

if __name__ == '__main__':
    import sys
    
    # 支持命令行参数或交互式输入
    if len(sys.argv) > 1:
        target_dir = sys.argv[1]
    else:
        target_dir = input('请输入目标目录路径: ').strip()
    
    if target_dir:
        batch_add_copyright(target_dir)
    else:
        print('未提供目录路径')