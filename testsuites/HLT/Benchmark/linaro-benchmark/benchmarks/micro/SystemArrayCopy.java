/*
 * Copyright (C) 2016 Linaro Limited. All rights reserved.
 *
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
 *
 */

/*
 * Description:     Tracks performance of System.arraycopy intrinsics.
 * Main Focus:      Looped load store for varying copy lengths.
 * Secondary Focus:
 *
 */

package benchmarks.micro;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;
import java.lang.StringBuilder;
import java.lang.System;
import java.util.Random;

public class SystemArrayCopy {
  enum Cases {
    CASE_3,
    CASE_7,
    CASE_9,
    CASE_15,
    CASE_16,
    CASE_17,
    CASE_31,
    CASE_32,
    CASE_128,
    CASE_1024,
    CASE_8192
  }

  private static int[] ARRAY_SIZES = {
    3, 7, 9, 15, 16, 17, 31, 32, 128, 1024, 8192
  };

  private static Random rnd = new Random();
  private static int MAX_BUFFER_BYTES = 8192;
  private static int ARRAY_LENGTH = 8192;

  private static String RANDOM_STRING = generateRandomString(MAX_BUFFER_BYTES);
  private static char[] cbuf = new char[MAX_BUFFER_BYTES];
  private static char arrayCopyCharBufferedReadSmallResult;
  private static char arrayCopyCharBufferedReadMediumResult;
  private static char arrayCopyCharBufferedReadLargeResult;

  private static String[] stringArray = new String[ARRAY_LENGTH];
  private static String[][] stringDstArrays = new String[ARRAY_SIZES.length][];
  
  private static char[] charArray = generateRandomCharArray(ARRAY_LENGTH);
  private static char[][] charDstArrays = new char[ARRAY_SIZES.length][];

  private static byte[] byteArray = generateRandomByteArray(ARRAY_LENGTH);
  private static byte[][] byteDstArrays = new byte[ARRAY_SIZES.length][];

  private static short[] shortArray = generateRandomShortArray(ARRAY_LENGTH);
  private static short[][] shortDstArrays = new short[ARRAY_SIZES.length][];

  private static int[] intArray = generateRandomIntArray(ARRAY_LENGTH);
  private static int[][] intDstArrays = new int[ARRAY_SIZES.length][];

  private static long[] longArray = generateRandomLongArray(ARRAY_LENGTH);
  private static long[][] longDstArrays = new long[ARRAY_SIZES.length][];

  private static String generateRandomString(int sz) {
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < sz; i++) {
      sb.append((char)rnd.nextInt());
    }
    return sb.toString();
  }

  private static char[] generateRandomCharArray(int sz) {
    char[] result = new char[sz];
    for (int i = 0; i < sz; i++) {
      result[i] = (char)rnd.nextInt();
    }
    return result;
  }

  private static byte[] generateRandomByteArray(int sz) {
    byte[] result = new byte[sz];
    for (int i = 0; i < sz; i++) {
      result[i] = (byte)rnd.nextInt();
    }
    return result;
  }

  private static short[] generateRandomShortArray(int sz) {
    short[] result = new short[sz];
    for (int i = 0; i < sz; i++) {
      result[i] = (short)rnd.nextInt();
    }
    return result;
  }

  private static int[] generateRandomIntArray(int sz) {
    int[] result = new int[sz];
    for (int i = 0; i < sz; i++) {
      result[i] = (int)rnd.nextInt();
    }
    return result;
  }

  private static long[] generateRandomLongArray(int sz) {
    long[] result = new long[sz];
    for (int i = 0; i < sz; i++) {
      result[i] = rnd.nextLong();
    }
    return result;
  }

  static {
    for (int i = 0; i < ARRAY_LENGTH; i++) {
      stringArray[i] = String.valueOf(i);
    }

    for (int i = 0; i < ARRAY_SIZES.length; i++) {
      charDstArrays[i] = new char[ARRAY_SIZES[i]];
      byteDstArrays[i] = new byte[ARRAY_SIZES[i]];
      shortDstArrays[i] = new short[ARRAY_SIZES[i]];
      intDstArrays[i] = new int[ARRAY_SIZES[i]];
      longDstArrays[i] = new long[ARRAY_SIZES[i]];
      stringDstArrays[i] = new String[ARRAY_SIZES[i]];
    }
  }

  private void bufferedReadLoop(char[] cbuf, int copyLength) throws IOException {
    BufferedReader reader = new BufferedReader(new StringReader(RANDOM_STRING));
    int offset = 0;
    String s;
    /* Read 16Kb RANDOM_STRING in chunks of copyLength chars until EOF */
    while (offset < MAX_BUFFER_BYTES && (reader.read(cbuf, offset, copyLength)) != -1) {
      offset += copyLength;
    }
  }

  public boolean verifyCharArrays(char[] src, char[] dst) {
    boolean result = true;
    for (int i = 0; i < dst.length; i++) {
      result &= src[i] == dst[i];
    }
    return result;
  }

  public boolean verifyByteArrays(byte[] src, byte[] dst) {
    boolean result = true;
    for (int i = 0; i < dst.length; i++) {
      result &= src[i] == dst[i];
    }
    return result;
  }

  public boolean verifyShortArrays(short[] src, short[] dst) {
    boolean result = true;
    for (int i = 0; i < dst.length; i++) {
      result &= src[i] == dst[i];
    }
    return result;
  }

  public boolean verifyIntArrays(int[] src, int[] dst) {
    boolean result = true;
    for (int i = 0; i < dst.length; i++) {
      result &= src[i] == dst[i];
    }
    return result;
  }

  public boolean verifyLongArrays(long[] src, long[] dst) {
    boolean result = true;
    for (int i = 0; i < dst.length; i++) {
      result &= src[i] == dst[i];
    }
    return result;
  }

  public boolean verifyStringArrays(String[] src, String[] dst) {
    boolean result = true;
    for (int i = 0; i < dst.length; i++) {
      result &= src[i].equals(dst[i]);
    }
    return result;
  }

  public boolean verify() throws IOException {
    boolean result = true;

    timeArrayCopyString0016(1);
    result &= verifyStringArrays(stringArray, stringDstArrays[Cases.CASE_16.ordinal()]);

    timeArrayCopyString0032(1);
    result &= verifyStringArrays(stringArray, stringDstArrays[Cases.CASE_32.ordinal()]);

    timeArrayCopyString0128(1);
    result &= verifyStringArrays(stringArray, stringDstArrays[Cases.CASE_128.ordinal()]);

    timeArrayCopyString1024(1);
    result &= verifyStringArrays(stringArray, stringDstArrays[Cases.CASE_1024.ordinal()]);

    timeArrayCopyString8192(1);
    result &= verifyStringArrays(stringArray, stringDstArrays[Cases.CASE_8192.ordinal()]);

    // char
    timeArrayCopyChar0003(1);
    result &= verifyCharArrays(charArray, charDstArrays[Cases.CASE_3.ordinal()]);

    timeArrayCopyChar0007(1);
    result &= verifyCharArrays(charArray, charDstArrays[Cases.CASE_7.ordinal()]);

    timeArrayCopyChar0009(1);
    result &= verifyCharArrays(charArray, charDstArrays[Cases.CASE_9.ordinal()]);

    timeArrayCopyChar0015(1);
    result &= verifyCharArrays(charArray, charDstArrays[Cases.CASE_15.ordinal()]);
  
    timeArrayCopyChar0016(1);
    result &= verifyCharArrays(charArray, charDstArrays[Cases.CASE_16.ordinal()]);

    timeArrayCopyChar0017(1);
    result &= verifyCharArrays(charArray, charDstArrays[Cases.CASE_17.ordinal()]);

    timeArrayCopyChar0031(1);
    result &= verifyCharArrays(charArray, charDstArrays[Cases.CASE_31.ordinal()]);

    timeArrayCopyChar0032(1);
    result &= verifyCharArrays(charArray, charDstArrays[Cases.CASE_32.ordinal()]);

    timeArrayCopyChar0128(1);
    result &= verifyCharArrays(charArray, charDstArrays[Cases.CASE_128.ordinal()]);

    timeArrayCopyChar1024(1);
    result &= verifyCharArrays(charArray, charDstArrays[Cases.CASE_1024.ordinal()]);

    timeArrayCopyChar8192(1);
    result &= verifyCharArrays(charArray, charDstArrays[Cases.CASE_8192.ordinal()]);

    // byte
    timeArrayCopyByte0016(1);
    result &= verifyByteArrays(byteArray, byteDstArrays[Cases.CASE_16.ordinal()]);

    timeArrayCopyByte0032(1);
    result &= verifyByteArrays(byteArray, byteDstArrays[Cases.CASE_32.ordinal()]);

    timeArrayCopyByte0128(1);
    result &= verifyByteArrays(byteArray, byteDstArrays[Cases.CASE_128.ordinal()]);

    timeArrayCopyByte1024(1);
    result &= verifyByteArrays(byteArray, byteDstArrays[Cases.CASE_1024.ordinal()]);

    timeArrayCopyByte8192(1);
    result &= verifyByteArrays(byteArray, byteDstArrays[Cases.CASE_8192.ordinal()]);

    // short
    timeArrayCopyShort0016(1);
    result &= verifyShortArrays(shortArray, shortDstArrays[Cases.CASE_16.ordinal()]);

    timeArrayCopyShort0032(1);
    result &= verifyShortArrays(shortArray, shortDstArrays[Cases.CASE_32.ordinal()]);

    timeArrayCopyShort0128(1);
    result &= verifyShortArrays(shortArray, shortDstArrays[Cases.CASE_128.ordinal()]);

    timeArrayCopyShort1024(1);
    result &= verifyShortArrays(shortArray, shortDstArrays[Cases.CASE_1024.ordinal()]);

    timeArrayCopyShort8192(1);
    result &= verifyShortArrays(shortArray, shortDstArrays[Cases.CASE_8192.ordinal()]);

    // int
    timeArrayCopyInt0016(1);
    result &= verifyIntArrays(intArray, intDstArrays[Cases.CASE_16.ordinal()]);

    timeArrayCopyInt0032(1);
    result &= verifyIntArrays(intArray, intDstArrays[Cases.CASE_32.ordinal()]);

    timeArrayCopyInt0128(1);
    result &= verifyIntArrays(intArray, intDstArrays[Cases.CASE_128.ordinal()]);

    timeArrayCopyInt1024(1);
    result &= verifyIntArrays(intArray, intDstArrays[Cases.CASE_1024.ordinal()]);

    timeArrayCopyInt8192(1);
    result &= verifyIntArrays(intArray, intDstArrays[Cases.CASE_8192.ordinal()]);

    // long
    timeArrayCopyLong0016(1);
    result &= verifyLongArrays(longArray, longDstArrays[Cases.CASE_16.ordinal()]);

    timeArrayCopyLong0032(1);
    result &= verifyLongArrays(longArray, longDstArrays[Cases.CASE_32.ordinal()]);

    timeArrayCopyLong0128(1);
    result &= verifyLongArrays(longArray, longDstArrays[Cases.CASE_128.ordinal()]);

    timeArrayCopyLong1024(1);
    result &= verifyLongArrays(longArray, longDstArrays[Cases.CASE_1024.ordinal()]);

    timeArrayCopyLong8192(1);
    result &= verifyLongArrays(longArray, longDstArrays[Cases.CASE_8192.ordinal()]);

    result &= arrayCopyCharBufferedReadSmallResult == RANDOM_STRING.charAt(MAX_BUFFER_BYTES - 1);
    result &= arrayCopyCharBufferedReadMediumResult == RANDOM_STRING.charAt(MAX_BUFFER_BYTES - 1);
    result &= arrayCopyCharBufferedReadLargeResult == RANDOM_STRING.charAt(MAX_BUFFER_BYTES - 1);
    return result;
  }

  public void timeArrayCopyCharBufferedReadSmall(int iterations) throws IOException {
    for (int i = 0; i < iterations; i++) {
      bufferedReadLoop(cbuf, ARRAY_SIZES[Cases.CASE_32.ordinal()]);
      arrayCopyCharBufferedReadSmallResult = cbuf[MAX_BUFFER_BYTES - 1];
    }
  }

  public void timeArrayCopyCharBufferedReadMedium(int iterations) throws IOException {
    for (int i = 0; i < iterations; i++) {
      bufferedReadLoop(cbuf, ARRAY_SIZES[Cases.CASE_128.ordinal()]);
      arrayCopyCharBufferedReadMediumResult = cbuf[MAX_BUFFER_BYTES - 1];
    }
  }

  public void timeArrayCopyCharBufferedReadLarge(int iterations) throws IOException {
    for (int i = 0; i < iterations; i++) {
      bufferedReadLoop(cbuf, ARRAY_SIZES[Cases.CASE_1024.ordinal()]);
      arrayCopyCharBufferedReadLargeResult = cbuf[MAX_BUFFER_BYTES - 1];
    }
  }

  // String
  public void timeArrayCopyString0016(int iterations) {
    String[] dstArray = stringDstArrays[Cases.CASE_16.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(stringArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyString0032(int iterations) {
    String[] dstArray = stringDstArrays[Cases.CASE_32.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(stringArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyString0128(int iterations) {
    String[] dstArray = stringDstArrays[Cases.CASE_128.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(stringArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyString1024(int iterations) {
    String[] dstArray = stringDstArrays[Cases.CASE_1024.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(stringArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyString8192(int iterations) {
    String[] dstArray = stringDstArrays[Cases.CASE_8192.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(stringArray, 0, dstArray, 0, dstArray.length);
    }
  }

  // char
  public void timeArrayCopyChar0003(int iterations) {
    char[] dstArray = charDstArrays[Cases.CASE_3.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(charArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyChar0007(int iterations) {
    char[] dstArray = charDstArrays[Cases.CASE_7.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(charArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyChar0009(int iterations) {
    char[] dstArray = charDstArrays[Cases.CASE_9.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(charArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyChar0015(int iterations) {
    char[] dstArray = charDstArrays[Cases.CASE_15.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(charArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyChar0016(int iterations) {
    char[] dstArray = charDstArrays[Cases.CASE_16.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(charArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyChar0017(int iterations) {
    char[] dstArray = charDstArrays[Cases.CASE_17.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(charArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyChar0032(int iterations) {
    char[] dstArray = charDstArrays[Cases.CASE_32.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(charArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyChar0031(int iterations) {
    char[] dstArray = charDstArrays[Cases.CASE_31.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(charArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyChar0128(int iterations) {
    char[] dstArray = charDstArrays[Cases.CASE_128.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(charArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyChar1024(int iterations) {
    char[] dstArray = charDstArrays[Cases.CASE_1024.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(charArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyChar8192(int iterations) {
    char[] dstArray = charDstArrays[Cases.CASE_8192.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(charArray, 0, dstArray, 0, dstArray.length);
    }
  }

  // byte
  public void timeArrayCopyByte0016(int iterations) {
    byte[] dstArray = byteDstArrays[Cases.CASE_16.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(byteArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyByte0032(int iterations) {
    byte[] dstArray = byteDstArrays[Cases.CASE_32.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(byteArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyByte0128(int iterations) {
    byte[] dstArray = byteDstArrays[Cases.CASE_128.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(byteArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyByte1024(int iterations) {
    byte[] dstArray = byteDstArrays[Cases.CASE_1024.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(byteArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyByte8192(int iterations) {
    byte[] dstArray = byteDstArrays[Cases.CASE_8192.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(byteArray, 0, dstArray, 0, dstArray.length);
    }
  }

  // short
  public void timeArrayCopyShort0016(int iterations) {
    short[] dstArray = shortDstArrays[Cases.CASE_16.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(shortArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyShort0032(int iterations) {
    short[] dstArray = shortDstArrays[Cases.CASE_32.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(shortArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyShort0128(int iterations) {
    short[] dstArray = shortDstArrays[Cases.CASE_128.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(shortArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyShort1024(int iterations) {
    short[] dstArray = shortDstArrays[Cases.CASE_1024.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(shortArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyShort8192(int iterations) {
    short[] dstArray = shortDstArrays[Cases.CASE_8192.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(shortArray, 0, dstArray, 0, dstArray.length);
    }
  }

  // int
  public void timeArrayCopyInt0016(int iterations) {
    int[] dstArray = intDstArrays[Cases.CASE_16.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(intArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyInt0032(int iterations) {
    int[] dstArray = intDstArrays[Cases.CASE_32.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(intArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyInt0128(int iterations) {
    int[] dstArray = intDstArrays[Cases.CASE_128.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(intArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyInt1024(int iterations) {
    int[] dstArray = intDstArrays[Cases.CASE_1024.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(intArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyInt8192(int iterations) {
    int[] dstArray = intDstArrays[Cases.CASE_8192.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(intArray, 0, dstArray, 0, dstArray.length);
    }
  }

  // long
  public void timeArrayCopyLong0016(int iterations) {
    long[] dstArray = longDstArrays[Cases.CASE_16.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(longArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyLong0032(int iterations) {
    long[] dstArray = longDstArrays[Cases.CASE_32.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(longArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyLong0128(int iterations) {
    long[] dstArray = longDstArrays[Cases.CASE_128.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(longArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyLong1024(int iterations) {
    long[] dstArray = longDstArrays[Cases.CASE_1024.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(longArray, 0, dstArray, 0, dstArray.length);
    }
  }

  public void timeArrayCopyLong8192(int iterations) {
    long[] dstArray = longDstArrays[Cases.CASE_8192.ordinal()];
    for (int i = 0; i < iterations; i++) {
      System.arraycopy(longArray, 0, dstArray, 0, dstArray.length);
    }
  }


  private static final int ITER_COUNT = 4000;

  public static void main(String[] args) {
    int result = 0;
    SystemArrayCopy obj = new SystemArrayCopy();
    final long before = System.currentTimeMillis();
    try {
      obj.timeArrayCopyString0016(ITER_COUNT);
      obj.timeArrayCopyString0032(ITER_COUNT);
      obj.timeArrayCopyString0128(ITER_COUNT);
      obj.timeArrayCopyString1024(ITER_COUNT);
      obj.timeArrayCopyString8192(ITER_COUNT);

      obj.timeArrayCopyChar0003(ITER_COUNT);
      obj.timeArrayCopyChar0007(ITER_COUNT);
      obj.timeArrayCopyChar0009(ITER_COUNT);
      obj.timeArrayCopyChar0015(ITER_COUNT);
      obj.timeArrayCopyChar0016(ITER_COUNT);
      obj.timeArrayCopyChar0017(ITER_COUNT);
      obj.timeArrayCopyChar0032(ITER_COUNT);
      obj.timeArrayCopyChar0031(ITER_COUNT);
      obj.timeArrayCopyChar0128(ITER_COUNT);
      obj.timeArrayCopyChar1024(ITER_COUNT);
      obj.timeArrayCopyChar8192(ITER_COUNT);

      obj.timeArrayCopyByte0016(ITER_COUNT);
      obj.timeArrayCopyByte0032(ITER_COUNT);
      obj.timeArrayCopyByte0128(ITER_COUNT);
      obj.timeArrayCopyByte1024(ITER_COUNT);
      obj.timeArrayCopyByte8192(ITER_COUNT);

      obj.timeArrayCopyShort0016(ITER_COUNT);
      obj.timeArrayCopyShort0032(ITER_COUNT);
      obj.timeArrayCopyShort0128(ITER_COUNT);
      obj.timeArrayCopyShort1024(ITER_COUNT);
      obj.timeArrayCopyShort8192(ITER_COUNT);

      obj.timeArrayCopyInt0016(ITER_COUNT);
      obj.timeArrayCopyInt0032(ITER_COUNT);
      obj.timeArrayCopyInt0128(ITER_COUNT);
      obj.timeArrayCopyInt1024(ITER_COUNT);
      obj.timeArrayCopyInt8192(ITER_COUNT);

      obj.timeArrayCopyLong0016(ITER_COUNT);
      obj.timeArrayCopyLong0032(ITER_COUNT);
      obj.timeArrayCopyLong0128(ITER_COUNT);
      obj.timeArrayCopyLong1024(ITER_COUNT);
      obj.timeArrayCopyLong8192(ITER_COUNT);

      obj.timeArrayCopyCharBufferedReadSmall(ITER_COUNT);
      obj.timeArrayCopyCharBufferedReadMedium(ITER_COUNT);
      obj.timeArrayCopyCharBufferedReadLarge(ITER_COUNT);
      if (!obj.verify()) {
        result++;
        System.out.println("ERROR: verify() failed.");
      }
    } catch (IOException ex) {
      System.out.println("ERROR: benchmarks/micro/SystemArrayCopy: " + ex.getMessage());
    }
    final long after = System.currentTimeMillis();
    System.out.println("benchmarks/micro/SystemArrayCopy: " + (after - before));
    System.exit(result);
  }
}
