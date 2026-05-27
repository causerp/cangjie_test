/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

class Morph {
    public static final int NX_NUMBER = 120;
    public static final int LOOP_COUNT = 15;
    public static final int NUM_EIGHT = 8;
    public static final int NUM_TWO = 2;
    public static final int NUM_THREE = 3;
    public static final int MAGNIFICATION = 50;
    public static final int TEST_COUNT = 80;
    public int loops = LOOP_COUNT;
    public int nx = NX_NUMBER;
    public int nz = NX_NUMBER;

    public void morph(double[] arr, double f) {
        double pI2nx = Math.PI * NUM_EIGHT / this.nx;
        double f30 = -(MAGNIFICATION * Math.sin(f * Math.PI * NUM_TWO));
        for (int i = 0; i < this.nz; i++) {
            for (int j = 0; j < this.nx; j++) {
                int index = NUM_THREE * (i * this.nx + j) + 1;
                double x = (j - 1) * pI2nx;
                arr[index] = Math.sin(x) * (-f30);
            }
        }
    }

    public void  runTest() {
        double[] a = new double[this.nx * this.nx * NUM_THREE];
        for (int index = 0; index < this.nx * this.nx * NUM_THREE; index++) {
            a[index] = 0;
          }

        for (int i = 0; i < loops; i++) {
            morph(a, ((double) i) / ((double) loops));
        }
        double testOutput = 0;
        for (int i = 0; i < this.nx; i++) {
            int index = NUM_THREE * (i * this.nx + 1) + 1;
            if (index >= a.length) {
                break;
            }
            testOutput += a[index];
        }
        //System.out.print("testOutput value is" + testOutput);

        double epsilon = 1e-13;
        if (Math.abs(testOutput) >= epsilon) {
            System.out.print("Error: bad test output: expected magnitude below" + epsilon + "but got" + testOutput);
        }
    }
}

/*
 * @State
 * @Tags Jetstream2
 */
class Morph1 {

    public static void main(String[] args) {
        run();
    }
	/*
     * @Morph1
     */
    public static void run() {
        long start = System.nanoTime();
        Morph morph = new Morph();
        for (int i = 0; i < Morph.TEST_COUNT; i++) {
            morph.runTest();
        }
        long end = System.nanoTime();
    	System.out.println("Morph1: ms = " + (end - start) / 1_000_000.0);
    }

}