# my.linux.ini
```
默认配置文件，运行programs目录下面所有用例的cj/go/swift/cj_compile/swift_compile，耗时久。
```

# my.linux.ini_daily
```
建议用于benchmarks-game的daily测试，仅运行原生benchmarks-game测试套中的十个性能用例的cj/go/swift/cj_compile/swift_compile。
```

# my.linux.ini_smoke
```
用于后冒烟，仅运行原生benchmarks-game测试套中的十个性能用例的cj/cj_compile。
```

# _jet文件
```
用于jet后端的测试，由于目前没有相关需求，在daily和ini中没有打开swift_compile；smoke中没有打开cj_compile。
```
