/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

import java.util.ArrayList;


public class perm {
    ArrayList<ArrayList<Integer>> res = new ArrayList<>();
    public ArrayList<ArrayList<Integer>> permute(ArrayList<Integer> nums) {
        res = new ArrayList<>();
        backtrack(nums, new ArrayList<Integer>());
        return res;
    }

    private void backtrack(ArrayList<Integer> nums, ArrayList<Integer> tmp) {
        if (nums.size() == 0){
                res.add(tmp);
                return;
        }
        for (int i = 0; i < nums.size(); i++){
            ArrayList<Integer> next_nums = (ArrayList)nums.clone();
            ArrayList<Integer> next_temp = (ArrayList)tmp.clone();
            next_nums.remove(i);
            next_temp.add(nums.get(i));
            backtrack( next_nums , next_temp);
        }
    }


    public static void MPermNKL(int M, int N, int K, int L){
        perm solution = new perm();
        ArrayList<ArrayList<Integer>> result = new ArrayList<>();
        ArrayList<Integer> nums = new ArrayList<>();
        for  (int i = 0; i < N; i++) {
            nums.add(i+1);
        }
        for  (int i = 0; i < M; i++) {
            result = solution.permute(nums);
            System.out.println(result.size());
            int delete_nums = result.size() * L / K;
            for (int j = 0; j < delete_nums; j++){
                result.set(j,null);  // garbage collection
            }
        }
    }
    public static void TenPermNineTwoOne(){
        MPermNKL(10,9,2,1);
    }
    public static void main(String[] args) {
    	long	tStart, tFinish, tElapsed;
        tStart = System.currentTimeMillis();
        TenPermNineTwoOne();
        tFinish = System.currentTimeMillis();
		tElapsed = tFinish-tStart;
        System.out.println("Completed in " + tElapsed + "ms.");
    }
}
