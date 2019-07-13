LXModel buildModel() {
  return new Model();
}

public static class Model extends LXModel {

  public final ArrayList<Strip> strips;
  
  public Model() {
    super(new Fixture());
    Fixture fixture = (Fixture) this.fixtures.get(0);
    this.strips = fixture.strips;
  }
  
  public static class Fixture extends LXAbstractFixture {

    public final ArrayList<Strip> strips = new ArrayList<Strip>();

    Fixture() {
      final PVector[][] stripVectors = new PVector[][] {
        new PVector[] { new PVector(-40.395, 14.129, 24.531), new PVector(-16.670, 80.741, 39.854) }, // 2
        new PVector[] { new PVector(-66.330, 21.058, 43.320), new PVector(-26.106, 83.268, 41.494) }, // 3
        new PVector[] { new PVector(-89.854, 46.039, 68.163), new PVector(-32.041, 98.049, 48.158) }, // 4
        new PVector[] { new PVector(-100.81, 77.921, 104.04), new PVector(-32.295, 111.83, 57.463) }, // 5
        new PVector[] { new PVector(-109.53, 108.99, 141.93), new PVector(-34.100, 126.01, 63.412) }, // 6
        new PVector[] { new PVector(-119.34, 140.16, 178.44), new PVector(-34.056, 140.28, 69.754) }, // 7
        new PVector[] { new PVector(-130.01, 165.80, 214.62), new PVector(-34.845, 153.43, 75.422) }, // 8
        new PVector[] { new PVector(-36.219, 171.24, 77.759), new PVector(-165.56, 194.75, 218.70) }, // 9
        new PVector[] { new PVector(-38.867, 182.30, 68.484), new PVector(-203.99, 220.76, 201.61) }, // 10
        new PVector[] { new PVector(-42.929, 198.33, 33.391), new PVector(-225.80, 254.02, 147.61) }, // 11
        new PVector[] { new PVector(-47.587, 211.36, 6.2326), new PVector(-264.70, 290.60, 82.820) }, // 12
        new PVector[] { new PVector(-51.519, 224.99, -21.95), new PVector(-307.27, 326.42, 8.9286) }, // 13
        new PVector[] { new PVector(-347.99, 363.29, -60.44), new PVector(-55.735, 237.94, -49.28) }, // 14
        new PVector[] { new PVector(-58.414, 248.75, -72.85), new PVector(-388.31, 398.57, -127.3) }, // 15
        new PVector[] { new PVector(59.1419, 247.16, -72.87), new PVector(387.514, 400.32, -127.3) }, // 59
        new PVector[] { new PVector(347.300, 364.90, -60.41), new PVector(56.5062, 236.17, -49.31) }, // 60
        new PVector[] { new PVector(52.1781, 223.37, -21.98), new PVector(306.547, 328.21, 8.9598) }, // 61
        new PVector[] { new PVector(48.1611, 211.42, 4.5807), new PVector(264.073, 290.53, 84.643) }, // 62
        new PVector[] { new PVector(43.8496, 198.41, 31.905), new PVector(224.788, 253.93, 149.26) }, // 63
        new PVector[] { new PVector(39.9632, 182.40, 67.123), new PVector(202.789, 220.66, 203.12) }, // 64
        new PVector[] { new PVector(34.9525, 171.14, 78.962), new PVector(166.967, 194.86, 217.37) }, // 65
        new PVector[] { new PVector(131.443, 165.91, 213.61), new PVector(33.2711, 153.31, 76.535) }, // 66
        new PVector[] { new PVector(120.703, 140.26, 177.34), new PVector(32.5556, 140.16, 70.964) }, // 67
        new PVector[] { new PVector(110.781, 109.09, 140.71), new PVector(32.7206, 125.90, 64.759) }, // 68
        new PVector[] { new PVector(99.7668, 77.831, 105.44), new PVector(33.4484, 111.93, 55.916) }, // 69
        new PVector[] { new PVector(90.9893, 47.372, 68.187), new PVector(30.7892, 96.578, 48.132) }, // 70
        new PVector[] { new PVector(38.7313, 13.587, 24.521), new PVector(18.5068, 81.340, 39.865) }, // 71
        new PVector[] { new PVector(0.00000, 26.426, 11.163), new PVector(-0.2588, 82.171, 39.466) }, // 72
      };

      for (PVector[] vectors : stripVectors) {
        Strip strip = new Strip(vectors[0], vectors[1]);
        this.strips.add(strip);

        for (LXPoint point : strip.points) {
          this.points.add(point);
        }
      }
    }
  }
}

public static class Strip extends LXModel {

  public final static int PIXEL_PITCH = 1;

  public Strip(PVector start, PVector end) {
    super(new Fixture(start, end));
  }

  private static class Fixture extends LXAbstractFixture {
    Fixture(PVector start, PVector end) {
      PVector diff = new PVector(end.x, end.y, end.z).sub(start);
      int numPoints = ((int)diff.mag()) / PIXEL_PITCH;

      for (int i = 0; i < numPoints; i++) {
        PVector pos = PVector.lerp(start, end, ((float)i) / numPoints).mult(4);
        this.points.add(new LXPoint(pos.x, pos.y-1, pos.z-4));
      }
    }
  }
}
