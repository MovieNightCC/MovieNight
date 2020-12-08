import 'dart:math';

List shuffle(List listA, List listB, List listC, List listD, List listE,
    List listF, List listG) {
  var random = new Random();

  // Go through all elements.
  for (var i = listA.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = listA[i];
    var temp2 = listB[i];
    var temp3 = listC[i];
    var temp4 = listD[i];
    var temp5 = listE[i];
    var temp6 = listF[i];
    var temp7 = listG[i];
    // var temp8 = listH[i];
    // var temp9 = listI[i];
    // var temp10 = listJ[i];
    // var temp11 = listK[i];

    listA[i] = listA[n];
    listB[i] = listB[n];
    listC[i] = listC[n];
    listD[i] = listD[n];
    listE[i] = listE[n];
    listF[i] = listF[n];
    listG[i] = listG[n];
    // listH[i] = listH[n];
    // listI[i] = listI[n];
    // listJ[i] = listJ[n];
    // listK[i] = listK[n];

    listA[n] = temp;
    listB[n] = temp2;
    listC[n] = temp3;
    listD[n] = temp4;
    listE[n] = temp5;
    listF[n] = temp6;
    listG[n] = temp7;
    // listH[n] = temp8;
    // listI[n] = temp9;
    // listJ[n] = temp10;
    // listK[n] = temp11;
  }
  return listA;
}
