public class Rings extends LXPattern {

  float dx, dy, dz;
  float angleParam, spacingParam;
  float dzParam, centerParam;

  BoundedParameter pDepth = new BoundedParameter("DEPTH", 0.6);
  BoundedParameter pBright = new BoundedParameter("BRT", 0.75);    
  BoundedParameter pHue = new BoundedParameter("HUE", 0.39);
  BoundedParameter pSaturation = new BoundedParameter("SAT", 0.5);

  BoundedParameter pSpeed1 = new BoundedParameter("SPD1", 0.2);
  BoundedParameter pSpeed2 = new BoundedParameter("SPD2", 0.4);
  BoundedParameter pScale = new BoundedParameter("SCALE", 0.15);

  public Rings(LX lx) {
    super(lx);
    addParameter(pDepth);
    addParameter(pBright);
    addParameter(pHue);
    addParameter(pSaturation);

    addParameter(pSpeed1);
    addParameter(pSpeed2);
    addParameter(pScale);
  }

  public void run(double deltaMs) {

    float xyspeed = pSpeed1.getValuef() * 0.01;
    float zspeed = pSpeed1.getValuef() * 0.08;
    float scale = pScale.getValuef() * 20.0;
    float br = pBright.getValuef() * 3.0;
    float gamma = 3.0;
    float depth = 1.0 - pDepth.getValuef();
    float hue = pHue.getValuef() * 360.0;
    float saturation = pSaturation.getValuef() * 100;

    float angleSpeed = pSpeed1.getValuef() * 0.002;
    angleParam = (float)((angleParam + angleSpeed * deltaMs) % (2*PI));
    float angle = sin(angleParam);

    spacingParam += deltaMs * pSpeed2.getValuef() * 0.001;
    dzParam += deltaMs * 0.000014;
    centerParam += deltaMs * pSpeed2.getValuef() * 0.001;

    float spacing = noise(spacingParam) * 50;

    dx += cos(angle) * xyspeed;
    dy += sin(angle) * xyspeed;
    dz += (pow(noise(dzParam), 1.8) - 0.5) * zspeed;

    float centerx = map(noise(centerParam, 100), 0, 1, -0.1, 1.1);
    float centery = map(noise(centerParam, 200), 0, 1, -0.1, 1.1);
    float centerz = map(noise(centerParam, 300), 0, 1, -0.1, 1.1);

    float coordMin = min(model.xMin, min(model.yMin, model.zMin));
    float coordMax = max(model.xMax, max(model.yMax, model.zMax));

    noiseDetail(4);
    for (LXPoint p : model.points) {
      // Scale while preserving aspect ratio
      float x = map(p.x, coordMin, coordMax, 0, 1);
      float y = map(p.y, coordMin, coordMax, 0, 1);
      float z = map(p.z, coordMin, coordMax, 0, 1);

      float dist = sqrt(sq(x - centerx) + sq(y - centery) + sq(z - centerz));
      float pulse = (sin(dz + dist * spacing) - 0.3) * 0.6;

      float n = map(noise(dx + (x - centerx) * scale + centerx + pulse,
                          dy + (y - centery) * scale + centery,
                          dz + (z - centerz) * scale + centerz)
                    - depth, 0, 1, 0, 2.0);
      float brightness = 100 * constrain(pow(br * n, gamma), 0, 1.0);
      if (brightness == 0) {
        colors[p.index] = LXColor.BLACK;
        continue;
      }

      float m = map(noise(dx + (x - centerx) * scale + centerx,
                          dy + (y - centery) * scale + centery,
                          dz + (z - centerz) * scale + centerz),
                    0, 1, 0, 300);

      colors[p.index] = lx.hsb(
        hue + m,
        saturation,
        brightness
        );
    }
    noiseDetail(1);
  }
};
