// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %cmp_opt %f -o %output

class B<K, L> where K <: (B<L, L>) -> Unit {}

main() {}

/* SCAN
error: generics type arguments do not match the constraint of 'Class-B<Generics-K, Generics-L>'
 ==> generic_constraint11.cj:9:32:
  | 
9 | class B<K, L> where K <: (B<L, L>) -> Unit {}
  |                                ^ 
  | 
note: 'Generics-L' is not a subtype of '(Class-B<Generics-L, Generics-L>) -> Unit'
 ==> generic_constraint11.cj:9:21:
  | 
9 | class B<K, L> where K <: (B<L, L>) -> Unit {}
  |                     ^ 
  | 

error: the upper bound '(Class-B<Generics-L, Generics-L>) -> Unit' of generic parameter 'Generics-K' must be class or interface
 ==> generic_constraint11.cj:9:9:
  | 
9 | class B<K, L> where K <: (B<L, L>) -> Unit {}
  |         ^ 
  | 

2 errors generated, 2 errors printed.
*/
