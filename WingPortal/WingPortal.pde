/** 
 * By using LX Studio, you agree to the terms of the LX Studio Software
 * License and Distribution Agreement, available at: http://lx.studio/license
 *
 * Please note that the LX license is not open-source. The license
 * allows for free, non-commercial use.
 *
 * HERON ARTS MAKES NO WARRANTY, EXPRESS, IMPLIED, STATUTORY, OR
 * OTHERWISE, AND SPECIFICALLY DISCLAIMS ANY WARRANTY OF
 * MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR A PARTICULAR
 * PURPOSE, WITH RESPECT TO THE SOFTWARE.
 */

// ---------------------------------------------------------------------------
//
// Welcome to LX Studio! Getting started is easy...
// 
// (1) Quickly scan this file
// (2) Look at "Model" to define your model
// (3) Move on to "Patterns" to write your animations
// 
// ---------------------------------------------------------------------------

import java.util.*;

// Reference to top-level LX instance
heronarts.lx.studio.LXStudio lx;

// Configuration flags
final static boolean MULTITHREADED = true;
final static boolean RESIZABLE = true;

// Helpful global constants
final static float INCHES = 1;
final static float IN = INCHES;
final static float FEET = 12 * INCHES;
final static float FT = FEET;
final static float CM = IN / 2.54;
final static float MM = CM * .1;
final static float M = CM * 100;
final static float METER = M;


void setup() {
  // Processing setup, constructs the window and the LX instance
  size(800, 720, P3D);
  lx = new heronarts.lx.studio.LXStudio(this, buildModel(), MULTITHREADED);
  lx.ui.setResizable(RESIZABLE);

  lx.ui.preview.addComponent(new UIGround());
  lx.ui.preview.addComponent(new UIObjComponent("WingPortal.obj"));
}

void initialize(final heronarts.lx.studio.LXStudio lx, heronarts.lx.studio.LXStudio.UI ui) {
  // Add custom components or output drivers here
}

void onUIReady(heronarts.lx.studio.LXStudio lx, heronarts.lx.studio.LXStudio.UI ui) {
  // Add custom UI components here
}

void draw() {
  // All is handled by LX Studio
}

class UIGround extends UI3dComponent {
	protected void onDraw(UI ui, PGraphics pg) {
		pg.beginShape();
		pg.fill(0xff654321);
		pg.vertex(-100*FEET, 0, -100*FEET);
		pg.vertex( 100*FEET, 0, -100*FEET);
		pg.vertex( 100*FEET, 0,  100*FEET);
		pg.vertex(-100*FEET, 0,  100*FEET);
		pg.endShape();
	}
}

class UIObjComponent extends UI3dComponent {
	PShape shape;

	UIObjComponent(String fileName) {
		shape = loadShape(fileName);
		shape.scale(4);
		shape.rotateY(PI);
		shape.rotateX(PI/2);
		shape.setFill(0xff222222);
	}

    protected void onDraw(UI ui, PGraphics pg) {
        pg.beginShape();
        pg.lights();
        pg.shape(shape);
        pg.endShape();
    }
}
