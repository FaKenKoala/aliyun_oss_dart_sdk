/// CRC-64 implementation with ability to combine checksums calculated over
/// different blocks of data. Standard ECMA-182,
/// http://www.ecma-international.org/ations/standards/Ecma-182.htm
class CRC64 implements Checksum {
  static final int POLY = 0xc96c5795d7870f42; // ECMA-182

  /* CRC64 calculation table. */
  static List<int> table = List.filled(256, 0);

  /* Current CRC value. */
  int value;

  _initTable() {
    for (int n = 0; n < 256; n++) {
      int crc = n;
      for (int k = 0; k < 8; k++) {
        if ((crc & 1) == 1) {
          crc = (crc >>> 1) ^ POLY;
        } else {
          crc = (crc >>> 1);
        }
      }
      table[n] = crc;
    }
  }

  CRC64({this.value = 0, List<int>? b, int len = 0}) {
    _initTable();
    if (b != null) {
      updateWithList(b, len);
    }
  }

  /// Construct new CRC64 instance from byte array.
  static CRC64 fromBytes(List<int> b) {
    int l = 0;
    for (int i = 0; i < 4; i++) {
      l <<= 8;
      l ^= b[i] & 0xFF;
    }
    return CRC64(value: l);
  }

  /// Get 8 byte representation of current CRC64 value.
  List<int> getBytes() {
    List<int> b = List.filled(8, 0);
    for (int i = 0; i < 8; i++) {
      b[7 - i] = (value >>> (i * 8));
    }
    return b;
  }

  /// Get long representation of current CRC64 value.
  @override
  int getValue() {
    return value;
  }

  /// Update CRC64 with new byte block.
  void updateWithList(List<int> b, int len) {
    int idx = 0;
    value = ~value;
    while (len > 0) {
      value = table[((value ^ b[idx])) & 0xff] ^ (value >>> 8);
      idx++;
      len--;
    }
    value = ~value;
  }

  /// Update CRC64 with new byte.
  @override
  void update(int b) {
    final byteB = b & 0xFF;
    value = ~value;
    value = table[((value ^ byteB)) & 0xff] ^ (value >>> 8);
    value = ~value;
  }

  @override
  void updateWithListOffset(List<int> b, int off, int len) {
    for (int i = off; len > 0; len--) {
      update(b[i++]);
    }
  }

  @override
  void reset() {
    value = 0;
  }

  /// dimension of GF(2) vectors (length
  /// of CRC)
  static final int GF2_DIM = 64;

  static int gf2MatrixTimes(List<int> mat, int vec) {
    int sum = 0;
    int idx = 0;
    while (vec != 0) {
      if ((vec & 1) == 1) {
        sum ^= mat[idx];
      }
      vec >>>= 1;
      idx++;
    }
    return sum;
  }

  static void gf2MatrixSquare(List<int> square, List<int> mat) {
    for (int n = 0; n < GF2_DIM; n++) {
      square[n] = gf2MatrixTimes(mat, mat[n]);
    }
  }

  /// Return the CRC-64 of two sequential blocks, where summ1 is the CRC-64 of
  /// the first block, summ2 is the CRC-64 of the second block, and len2 is the
  /// length of the second block.
  static CRC64 combine(CRC64 summ1, CRC64 summ2, int len2) {
    // degenerate case.
    if (len2 == 0) {
      return CRC64(value: summ1.getValue());
    }

    int n;
    int row;
    List<int> even =
        List.filled(GF2_DIM, 0); // even-power-of-two zeros operator
    List<int> odd = List.filled(GF2_DIM, 0); // odd-power-of-two zeros operator

    // put operator for one zero bit in odd
    odd[0] = POLY; // CRC-64 polynomial

    row = 1;
    for (n = 1; n < GF2_DIM; n++) {
      odd[n] = row;
      row <<= 1;
    }

    // put operator for two zero bits in even
    gf2MatrixSquare(even, odd);

    // put operator for four zero bits in odd
    gf2MatrixSquare(odd, even);

    // apply len2 zeros to crc1 (first square will put the operator for one
    // zero byte, eight zero bits, in even)
    int crc1 = summ1.getValue();
    int crc2 = summ2.getValue();
    do {
      // apply zeros operator for this bit of len2
      gf2MatrixSquare(even, odd);
      if ((len2 & 1) == 1) {
        crc1 = gf2MatrixTimes(even, crc1);
      }
      len2 >>>= 1;

      // if no more bits set, then done
      if (len2 == 0) {
        break;
      }

      // another iteration of the loop with odd and even swapped
      gf2MatrixSquare(odd, even);
      if ((len2 & 1) == 1) {
        crc1 = gf2MatrixTimes(odd, crc1);
      }
      len2 >>>= 1;

      // if no more bits set, then done
    } while (len2 != 0);

    // return combined crc.
    crc1 ^= crc2;
    return CRC64(value: crc1);
  }

  /// Return the CRC-64 of two sequential blocks, where summ1 is the CRC-64 of
  /// the first block, summ2 is the CRC-64 of the second block, and len2 is the
  /// length of the second block.
  static int combineWithInt(int crc1, int crc2, int len2) {
    // degenerate case.
    if (len2 == 0) {
      return crc1;
    }

    int n;
    int row;
    List<int> even =
        List.filled(GF2_DIM, 0); // even-power-of-two zeros operator
    List<int> odd = List.filled(GF2_DIM, 0); // odd-power-of-two zeros operator

    // put operator for one zero bit in odd
    odd[0] = POLY; // CRC-64 polynomial

    row = 1;
    for (n = 1; n < GF2_DIM; n++) {
      odd[n] = row;
      row <<= 1;
    }

    // put operator for two zero bits in even
    gf2MatrixSquare(even, odd);

    // put operator for four zero bits in odd
    gf2MatrixSquare(odd, even);

    // apply len2 zeros to crc1 (first square will put the operator for one
    // zero byte, eight zero bits, in even)
    do {
      // apply zeros operator for this bit of len2
      gf2MatrixSquare(even, odd);
      if ((len2 & 1) == 1) {
        crc1 = gf2MatrixTimes(even, crc1);
      }
      len2 >>>= 1;

      // if no more bits set, then done
      if (len2 == 0) {
        break;
      }

      // another iteration of the loop with odd and even swapped
      gf2MatrixSquare(odd, even);
      if ((len2 & 1) == 1) {
        crc1 = gf2MatrixTimes(odd, crc1);
      }
      len2 >>>= 1;

      // if no more bits set, then done
    } while (len2 != 0);

    // return combined crc.
    crc1 ^= crc2;
    return crc1;
  }
}
