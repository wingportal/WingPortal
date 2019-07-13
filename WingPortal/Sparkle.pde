public static class Sparkle extends WPPattern {

    public final CompoundParameter density = new CompoundParameter("Dens", 0.15);
    public final CompoundParameter attack = new CompoundParameter("Attack", 0.4);
    public final CompoundParameter decay = new CompoundParameter("Decay", 0.3);
    public final CompoundParameter hue = new CompoundParameter("Hue", 0.5);
    public final CompoundParameter hueVariance = new CompoundParameter("HueVar", 0.25);
    public final CompoundParameter saturation = new CompoundParameter("Sat", 0.5);

    private boolean[] occupied;

    class Spark {
        int index;
        float value, hue;
        boolean hasPeaked;

        Spark() {
            index = (int) Math.floor(LXUtils.random(0, model.points.length));
            hue = (float) LXUtils.random(0, 1);
            boolean infiniteAttack = (attack.getValuef() > 0.999);
            hasPeaked = infiniteAttack;
            value = (infiniteAttack ? 1 : 0);
        }

        // returns TRUE if this should die
        boolean age(double ms) {
            if (!hasPeaked) {
                value = value + (float) (ms / 1000.0f * ((attack.getValuef() + 0.01) * 5));
                if (value >= 1.0) {
                    value = (float)1.0;
                    hasPeaked = true;
                }
                return false;
            } else {
                value = value - (float) (ms / 1000.0f * ((decay.getValuef() + 0.01) * 10));
                return value <= 0;
            }
        }
    }

    private float leftoverMs = 0;
    private LinkedList<Spark> sparks;

    public Sparkle(LX lx) {
        super(lx);
        addParameter("density", density);
        addParameter("attack", attack);
        addParameter("decay", decay);
        addParameter("hue", hue);
        addParameter("hueVariance", hueVariance);
        addParameter("saturation", saturation);
        sparks = new LinkedList<Spark>();
        occupied = new boolean[model.points.length];
        for (int i = 0; i < occupied.length; i++) {
            occupied[i] = false;
        }
    }

    public void run(double deltaMs) {
        setColors(0);

        leftoverMs += deltaMs;
        float msPerSpark = 1000.f / (float)((density.getValuef() + .01) * (model.xRange*10));
        while (leftoverMs > msPerSpark) {
            leftoverMs -= msPerSpark;
            Spark spark = new Spark();
            if (!occupied[spark.index]) {
                sparks.add(spark);
                occupied[spark.index] = true;
            }
        }

        for (Spark spark : sparks) {
            float hueVal = ((float)(hue.getValuef() + (hueVariance.getValuef() * spark.hue))) % 1.0f;
            int c = lx.hsb(hueVal * 360, saturation.getValuef() * 100, (spark.value) * 100);
            colors[spark.index] = c;
        }

        Iterator<Spark> i = sparks.iterator();
        while (i.hasNext()) {
            Spark spark = i.next();
            boolean dead = spark.age(deltaMs);
            if (dead) {
                i.remove();
                occupied[spark.index] = false;
            }
        }
    }
}
