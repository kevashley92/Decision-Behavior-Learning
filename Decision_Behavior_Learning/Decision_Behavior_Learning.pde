import sprites.utils.*;
import sprites.maths.*;
import sprites.*;

import processing.core.*;
import java.util.*;
import sprites.*;

public class KinMotionData {
  private float[] position = new float[2];
  private float orientation;
  private float[] velocity = new float[2];
  private float rotation;
  private float[] linear = new float[2];
  private float angular;
  private float maxVel;
  public KinMotionData() {
    this.position[0] = 325;
    this.position[1] = 50;
    this.orientation = 0;
    this.velocity[0] = 0;
    this.velocity[1] = 0;
    this.rotation = 0.05;
    this.linear[0] = 0;
    this.linear[1] = 0;
    this.angular = 2;
    this.maxVel = 0;
  }
  public float[] getPosition() {
    return this.position;
  }
  public void setPosition(float x, float y) {
    this.position[0] = x;
    this.position[1] = y;
  }
  public float getOrientation() {
    return this.orientation;
  }
  public void setOrientation(float x) {
    this.orientation = x;
  }
  public float[] getVelocity() {
    return this.velocity;
  }
  public float getVelocityLength() {
    return sqrt((this.velocity[0]*this.velocity[0]) + (this.velocity[1]*this.velocity[1]));
  }
  public void setVelocity(float x, float y) {
    this.velocity[0] = x;
    this.velocity[1] = y;
  }
  public float getRotation() {
    return this.rotation;
  }
  public void setRotation(float x) {
    this.rotation = x;
  }
  public float[] getLinear() {
    return this.linear;
  }
  public float getLinearLength() {
    return sqrt((this.linear[0]*this.linear[0]) + (this.linear[1]*this.linear[1]));
  }
  public void setLinear(float x, float y) {
    this.linear[0] = x;
    this.linear[1] = y;
  }
  public float getAngular() {
    return this.angular;
  }
  public void setAngular(float x) {
    this.angular = x;
  }
   public float getMaxVel() {
    return this.maxVel;
  }
  public void setMaxVel(float v) {
    this.maxVel = v;
  }
}

public class Edge {
  public int cost;
  public int fromNode;
  public int toNode;
  public Edge(int c, int start, int finish) {
    this.cost = c;
    this.fromNode = start;
    this.toNode = finish;
  }
  public int getCost() {
    return this.cost;
  }
  public void setCost(int c) {
    this.cost = c;
  }
  public int getFromNode() {
    return this.fromNode;
  }
  public void setFromNode(int n) {
    this.fromNode = n;
  }
  public int getToNode() {
    return this.toNode;
  }
  public void setToNode(int n) {
    this.toNode = n;
  }
}

public class Node {
  public int[] location = new int[2];
  public int name;
  public boolean visited;
  public Node(int x, int y, int n) {
    this.location[0] = x;
    this.location[1] = y;
    this.name = n;
    this.visited = false;
  }
  public void setLocation(int[] loc) {
    this.location[0] = loc[0];
    this.location[1] = loc[1];
  }
  public int[] getLocation() {
    return this.location;
  }
  public void setNodeName(int n) {
    this.name = n;
  }
  public int getNodeName() {
    return this.name;
  }
}

public class Graph {
  public List<Edge> edges;
  public List<Node> nodes;
  int nodesVisited = 0;
  public Graph() {
    edges = new ArrayList<Edge>();
    nodes = new ArrayList<Node>();
  }
  public void addEdge(Edge e) {
    edges.add(e);
  }
  public void addNode(Node n) {
    nodes.add(n);
  }
  public List getEdges(int fNode) {
    List<Edge> list = new ArrayList<Edge>();
    for (int i = 0; i < edges.size(); i++) {
      if (edges.get(i).fromNode == fNode)
        list.add(edges.get(i));
    }
    return list;
  }
  public Node getNode(int i) {
    return this.nodes.get(i-1);
  }
}

public class Heuristic {
  public Node goalNode;
  public Heuristic(Node goal) {
    goalNode = goal;
  }
  public float estimateEuclidean(Node node) {
    float x = (float)Math.pow(goalNode.location[0] - node.location[0], 2.0);
    float y = (float)Math.pow(goalNode.location[1] - node.location[1], 2.0);
    return sqrt(x+y)/2;
  }
  public float estimateRandom(Node node) {
    float random =  25 + (float)(Math.random() * ((775 - 25) + 1));
    return random;
  }
  public float estimateManhattan(Node node) {
    float p = 1/1000;
    float d = 1.0 + p;
    float x = (float)Math.pow(goalNode.location[0] - node.location[0], 2.0);
    float y = (float)Math.pow(goalNode.location[1] - node.location[1], 2.0);
    return d*(x+y);
  }
}


void drawEnvironment() {
  fill(40, 40, 40);
  // UPPER LEFT SHAPE
  shape(createShape(RECT, 0, 0, 275, 50), 0, 0);
  shape(createShape(RECT, 0, 50, 125, 150), 0, 0);
  shape(createShape(RECT, 0, 200, 75, 250), 0, 0);
  // WALL IN UPPER MIDDLE
  shape(createShape(RECT, 475, 0, 50, 275), 0, 0);
  // TABLE IN BOTTOM LEFT
  shape(createShape(RECT, 75, 550, 150, 150), 0, 0);
  // WALL IN LEFT MIDDLE
  shape(createShape(RECT, 225, 400, 300, 50), 0, 0);
  shape(createShape(RECT, 325, 450, 100, 150), 0, 0);
  // WALLS IN MIDDLE
  shape(createShape(RECT, 675, 100, 100, 100), 0, 0);
  shape(createShape(RECT, 675, 350, 100, 300), 0, 0);
  // ROOM IN UPPER RIGHT
  shape(createShape(RECT, 925, 0, 50, 400), 0, 0);
  shape(createShape(RECT, 1125, 350, 175, 50), 0, 0);
  // ROOM IN LOWER RIGHT
  shape(createShape(RECT, 925, 600, 50, 200), 0, 0);
  shape(createShape(RECT, 1125, 600, 175, 50), 0, 0);
}

void createGraph() {
  int n = 1;
  // LIVING ROOM
  n = nodeSquare(3, 0, 325, 50, n);
  n = nodeSquare(6, 2, 175, 100, n);
  n = nodeSquare(7, 2, 125, 250, n);
  n = nodeSquare(2, 1, 125, 400, n);

  // DINING ROOM
  n = nodeSquare(6, 0, 25, 500, n);
  n = nodeSquare(1, 3, 25, 550, n);
  n = nodeSquare(1, 3, 275, 550, n);
  n = nodeSquare(6, 0, 25, 750, n);

  // FOYER
  n = nodeSquare(7, 2, 325, 650, n);
  n = nodeSquare(4, 2, 475, 500, n);

  // HALLWAY 1
  n = nodeSquare(2, 1, 575, 400, n);
  n = nodeSquare(4, 0, 475, 350, n);
  
  // BOTTOM HALWAY
  n = nodeSquare(3, 1, 675, 700, n);

  // KITCHEN
  n = nodeSquare(7, 0, 575, 50, n);
  n = nodeSquare(2, 4, 575, 100, n);
  n = nodeSquare(2, 4, 825, 100, n);
  n = nodeSquare(3, 1, 675, 250, n);
  
  // HALLWAY 2
  n = nodeSquare(2, 8, 825, 350, n);
  n = nodeSquare(8, 2, 925, 450, n);
  
  // BEDROOM 1
  n = nodeSquare(6, 5, 1025, 50, n);
  n = nodeSquare(2, 1, 1025, 350, n);
  
  // BEDROOM 2
  n = nodeSquare(2, 1, 1025, 600, n);
  n = nodeSquare(6, 1, 1025, 700, n);
  
  for (int i = 0; i < graph.nodes.size(); i++) {
    int spacex = graph.nodes.get(i).location[0]+50;
    int spacey = graph.nodes.get(i).location[1]+50;
    for (int j = 0; j < graph.nodes.size(); j++) {
      if (spacex == graph.nodes.get(j).location[0] && graph.nodes.get(i).location[1] == graph.nodes.get(j).location[1])
        graphAddEdgeFinal(1, graph.nodes.get(i).name, graph.nodes.get(j).name);
      if (spacey == graph.nodes.get(j).location[1] && graph.nodes.get(i).location[0] == graph.nodes.get(j).location[0])
        graphAddEdgeFinal(1, graph.nodes.get(i).name, graph.nodes.get(j).name);
    }
  }
}

int nodeSquare(int columns, int rows, int startx, int starty, int n) {
  int originaly = starty;
  for (int i = 0; i < columns; i++) {
    graphAddNodeFinal(startx, starty, n);
    starty += 50;
    for (int j = 0; j < rows; j++) {
      n++;
      graphAddNodeFinal(startx, starty, n);
      starty += 50;
    }
    starty = originaly;
    startx += 50;
    n++;
  }
  return n;
}

void graphAddNodeFinal(int x, int y, int i) {
  Node n = new Node(x, y, i);
  graph.addNode(n);
}

void graphAddEdgeFinal(int c, int s, int f) {
  Edge e = new Edge(c, s, f);
  graph.addEdge(e);
  e = new Edge(c, f, s);
  graph.addEdge(e);
}

void drawEdgeFinal(int i1, int i2) {
  Node n1 = graph.nodes.get(i1-1);
  Node n2 = graph.nodes.get(i2-1);
  edge = createShape(LINE, n1.getLocation()[0], n1.getLocation()[1], n2.getLocation()[0], n2.getLocation()[1]);
  shape(edge, 0, 0);
}

void drawNode(Node n) {
  shape(node, n.getLocation()[0], n.getLocation()[1]);
  text(n.name, n.getLocation()[0]-5, n.getLocation()[1]+5);
}

public abstract class DecisionTreeNode {
  public DecisionTreeNode trueNode;
  public DecisionTreeNode falseNode;
  public DecisionTreeNode() { }
  abstract void makeDecision();
  public void setTrue(DecisionTreeNode t) {
    this.trueNode = t;
  }
  public void setFalse(DecisionTreeNode f) {
    this.falseNode = f;
  }
  DecisionTreeNode getTrue() {
    return this.trueNode;
  }
  DecisionTreeNode getFalse() {
    return this.falseNode;
  }
}

public class Action extends DecisionTreeNode {
  boolean completed;
  public Action() {
    completed = false;
  }
  public void makeDecision() { }
}
// Makes the player wander around
int timePassed = 0;
public class ActionWanderPlayer extends Action {
  void makeDecision() {
    if (timePassed == 75) {
      int randomNum = (int)(Math.random()*graph.nodes.size());
      findPoint(graph.nodes.get(randomNum).location[0], graph.nodes.get(randomNum).location[0]);
      timePassed = 0;
    }
    timePassed++;
  }
}
// Makes the player seek it's starting point
public class ActionSeekStart extends Action {
  void makeDecision() {
    findPoint(playerStart[0], playerStart[1]);
  }
}
// Makes the player seek the safe room
public class ActionSeekSafeRoom extends Action {
  void makeDecision() {
    findPoint(1250, 275);
  }
}
public class Decision extends DecisionTreeNode {
  public DecisionTreeNode trueNode;
  public DecisionTreeNode falseNode;
  public boolean testValue;
  public int type = -1;
  public Decision() {
    super.trueNode = this.trueNode;
    super.falseNode = this.falseNode;
    this.testValue = false;
  }
  public DecisionTreeNode getBranch() {
    if (this.testValue) {
      return trueNode;
    } else {
      return falseNode;
    }
  }
  public void makeDecision() {
    if (sqrt((float)Math.pow(playerInfo.getPosition()[0] - xenoInfo.getPosition()[0], 2.0)
      +(float)Math.pow(playerInfo.getPosition()[1] - xenoInfo.getPosition()[1], 2.0)) < 100) {
      xenoInfo.setPosition(xenoStart[0], xenoStart[1]);
      xList = null;
      findTarget(graph.nodes.get(87).location[0], graph.nodes.get(87).location[1]);
      playerInfo.setPosition(playerStart[0], playerStart[1]);
      aList = null;
      findPoint(graph.nodes.get(1).location[0], graph.nodes.get(1).location[1]);
    }
    DecisionTreeNode branch = this.getBranch();
    branch.makeDecision();
  }
}
// Test how far the alien is away from player
public class DecisionDistance extends Decision {
  void setTrue(DecisionTreeNode t) {
    super.trueNode = t;
  }
  void setFalse(DecisionTreeNode f) {
    super.falseNode = f;
  }
  DecisionTreeNode getTrue() {
    return super.trueNode;
  }
  DecisionTreeNode getFalse() {
    return super.falseNode;
  }
  void makeDecision() {
    super.type = 0;
    if (sqrt((float)Math.pow(playerInfo.getPosition()[0] - xenoInfo.getPosition()[0], 2.0)
      +(float)Math.pow(playerInfo.getPosition()[1] - xenoInfo.getPosition()[1], 2.0)) < 200) {
      super.testValue = true;
      attackMode = true;
    } else {
      super.testValue = false;
      attackMode = false;
    }
    super.makeDecision();
  }
}
// Test if player is REALLY close
public class DecisionClose extends Decision {
  void setTrue(DecisionTreeNode t) {
    super.trueNode = t;
  }
  void setFalse(DecisionTreeNode f) {
    super.falseNode = f;
  }
  DecisionTreeNode getTrue() {
    return super.trueNode;
  }
  DecisionTreeNode getFalse() {
    return super.falseNode;
  }
  void makeDecision() {
    super.type = 0;
    if (sqrt((float)Math.pow(playerInfo.getPosition()[0] - xenoInfo.getPosition()[0], 2.0)
      +(float)Math.pow(playerInfo.getPosition()[1] - xenoInfo.getPosition()[1], 2.0)) < 200)
      super.testValue = true;
    else
      super.testValue = false;
    super.makeDecision();
  }
}
// Test if player is in the hive
public class DecisionHivePlayer extends Decision {
  void setTrue(DecisionTreeNode t) {
    super.trueNode = t;
  }
  void setFalse(DecisionTreeNode f) {
    super.falseNode = f;
  }
  DecisionTreeNode getTrue() {
    return super.trueNode;
  }
  DecisionTreeNode getFalse() {
    return super.falseNode;
  }
  void makeDecision() {
    super.type = 2;
    if (playerInfo.getPosition()[0] > 700 || playerInfo.getPosition()[1] < 375)
      super.testValue = false;
    else
      super.testValue = true;
    super.makeDecision();
  }
}

// Test if player is in safe room
public class DecisionSafeRoom extends Decision {
  void setTrue(DecisionTreeNode t) {
    super.trueNode = t;
  }
  void setFalse(DecisionTreeNode f) {
    super.falseNode = f;
  }
  DecisionTreeNode getTrue() {
    return super.trueNode;
  }
  DecisionTreeNode getFalse() {
    return super.falseNode;
  }
  void makeDecision() {
    super.type = 1;
    if (playerInfo.getPosition()[0] > 1000 && playerInfo.getPosition()[1] < 350)
      super.testValue = true;
    else
      super.testValue = false;  
    super.makeDecision();
  }  
}

public class Task {
  List<Task> children;
  public Task () {
    children = new ArrayList();
  }
  public List<Task> getChildList() {
    return this.children;
  }
  public void addTask(Task t) {
    this.children.add(t);
  }
  public boolean run() {
    boolean value = false;
    return value;
  }
}
public class Selector extends Task {
  List<Task> getChildList() {
    return this.children;
  }
  public boolean run() {
    for (int i = 0; i < this.children.size(); i++) {
      if (this.children.get(i).run())
        return true;
    }
    return false;
  }
}
public class Sequence extends Task {
  List<Task> getChildList() {
    return this.children;
  }
  public boolean run() {
    for (int i = 0; i < this.children.size(); i++) {
      if (!this.children.get(i).run())
        return false;
    }
    return true;
  }
}
public class RandomSelector extends Task {
  List<Task> getChildList() {
    return this.children;
  }
  public boolean run() {
    while (true) {
      int randomNum = (int)(Math.random()*this.children.size()); 
      Task child = this.children.get(randomNum);
      if (child.run())
        return true;
      else
        return false;
    }
  }
}
// Tests if the Xeno is outside the hive
public class TaskOutsideHive extends Task {
  public boolean run() {
    if (xenoInfo.getPosition()[0] > 700 || xenoInfo.getPosition()[1] < 375)
      return true;
    else
      return false;
  }  
}
// Tests if the Xeno is near the player
public class TaskPlayerNear extends Task {
  public boolean run() {
    if (sqrt((float)Math.pow(playerInfo.getPosition()[0] - xenoInfo.getPosition()[0], 2.0)
        +(float)Math.pow(playerInfo.getPosition()[1] - xenoInfo.getPosition()[1], 2.0)) < 450) {
      attackMode = true;
      return true;
    } else {
      attackMode = false;
      return false;
    }
  }
}
// Makes the Xeno follow a specified path
boolean started = false;
public class ActionFollowPath extends Task {
  public boolean run() {
    if (!started || isNear(graph.nodes.get(96))) {
      findTarget(graph.nodes.get(46).location[0], graph.nodes.get(46).location[1]);
      started = true;
    } else if (isNear(graph.nodes.get(46)))
      findTarget(graph.nodes.get(60).location[0], graph.nodes.get(60).location[1]);
    else if (isNear(graph.nodes.get(60)))
      findTarget(graph.nodes.get(86).location[0], graph.nodes.get(86).location[1]);
    else if (isNear(graph.nodes.get(86)))
      findTarget(graph.nodes.get(96).location[0], graph.nodes.get(96).location[1]);
    
    return true;
  }
  public boolean isNear(Node n) {
    if (sqrt((float)Math.pow(xenoInfo.getPosition()[0] - n.location[0], 2.0)
      +(float)Math.pow(xenoInfo.getPosition()[1] - n.location[1], 2.0)) < 75)
      return true;
    else
      return false;
  }
}
// Makes the Xeno seek the hive
public class ActionSeekHive extends Task {
  public boolean run() {
    findTarget(xenoStart[0], xenoStart[1]);
    return true;
  }
}
// Makes the Xeno chase the player
public class ActionChase extends Task {
  public boolean run() {
    findTarget(playerInfo.getPosition()[0], playerInfo.getPosition()[1]);
    return true;
  }
}
// Makes the Xeno wander around
int taskTimePassed = 0;
public class ActionWander extends Task {
  public boolean run() {
    if (taskTimePassed == 50) {
      int randomNum = (int)(Math.random()*graph.nodes.size());
      findTarget(graph.nodes.get(randomNum).location[0], graph.nodes.get(randomNum).location[0]);
      taskTimePassed = 0;
    }
    taskTimePassed++;
    return true;
  }
}

Decision pN;
void generatePlayerTree() {
  pN = new DecisionHivePlayer();
  pN.setTrue(new ActionSeekSafeRoom());
  pN.setFalse(new DecisionDistance());
  pN.getFalse().setFalse(new ActionWanderPlayer());
  pN.getFalse().setTrue(new DecisionSafeRoom());
  pN.getFalse().getTrue().setFalse(new ActionSeekSafeRoom());
  pN.getFalse().getTrue().setTrue(new ActionSeekStart());
}
Task aN;
void generateXenoTree() {
  aN = new Selector();
  aN.addTask(new Sequence());
  aN.addTask(new Sequence());
  aN.addTask(new ActionFollowPath());
  aN.getChildList().get(0).addTask(new TaskPlayerNear());
  aN.getChildList().get(0).addTask(new RandomSelector());
  aN.getChildList().get(0).getChildList().get(1).addTask(new ActionChase());
  aN.getChildList().get(0).getChildList().get(1).addTask(new ActionWander());
  aN.getChildList().get(1).addTask(new TaskOutsideHive());
  aN.getChildList().get(1).addTask(new ActionSeekHive());
}

void findTarget(float x, float y) {
  int s = 0;
  int f = 0;
  targetInfo.setPosition(x, y);
  float smallestDistance = Float.POSITIVE_INFINITY;
  for (int i = 0; i < graph.nodes.size(); i++) {
    float floatDistance = sqrt((float)Math.pow(xenoInfo.getPosition()[0] - graph.nodes.get(i).location[0], 2.0) + 
      (float)Math.pow(xenoInfo.getPosition()[1] - graph.nodes.get(i).location[1], 2.0));
    if (floatDistance < smallestDistance) {
      smallestDistance = floatDistance;
      s = i+1;
    }
  }
  smallestDistance = Float.POSITIVE_INFINITY;
  for (int i = 0; i < graph.nodes.size(); i++) {
    float floatDistance = sqrt((float)Math.pow(targetInfo.getPosition()[0] - graph.nodes.get(i).location[0], 2.0) + 
                          (float)Math.pow(targetInfo.getPosition()[1] - graph.nodes.get(i).location[1], 2.0));
    if (floatDistance < smallestDistance) {
      smallestDistance = floatDistance;
      f = i+1;
    }
  }
  if (s != f) {
    xList = pathFindAStar(graph, graph.nodes.get(s-1), graph.nodes.get(f-1), new Heuristic(graph.nodes.get(f-1)));
    xList = reverseList(xList);
  }
}

void findPoint(float x, float y) {
  int s = 0;
  int f = 0;
  KinMotionData target = new KinMotionData();
  target.setPosition(x, y);
  float smallestDistance = Float.POSITIVE_INFINITY;
  for (int i = 0; i < graph.nodes.size(); i++) {
    float floatDistance = sqrt((float)Math.pow(playerInfo.getPosition()[0] - graph.nodes.get(i).location[0], 2.0) + 
      (float)Math.pow(playerInfo.getPosition()[1] - graph.nodes.get(i).location[1], 2.0));
    if (floatDistance < smallestDistance) {
      smallestDistance = floatDistance;
      s = i+1;
    }
  }
  smallestDistance = Float.POSITIVE_INFINITY;
  for (int i = 0; i < graph.nodes.size(); i++) {
    float floatDistance = sqrt((float)Math.pow(target.getPosition()[0] - graph.nodes.get(i).location[0], 2.0) + 
                          (float)Math.pow(target.getPosition()[1] - graph.nodes.get(i).location[1], 2.0));
    if (floatDistance < smallestDistance) {
      smallestDistance = floatDistance;
      f = i+1;
    }
  }
  if (s != f) {
    aList = pathFindAStar(graph, graph.nodes.get(s-1), graph.nodes.get(f-1), new Heuristic(graph.nodes.get(f-1)));
    aList = reverseList(aList);
  }
}

List<Edge> aList = new ArrayList<Edge>();
List<Edge> xList = new ArrayList<Edge>();
Path p = new Path();
PImage background;
Sprite xeno;
PShape player, view, light, body, xenoS, breadCrumb, crumbTrail, breadCrumbA, crumbTrailA, node, edge;
float [] playerStart = new float[2];
float [] xenoStart = new float[2];
boolean attackMode;
PrintWriter output;

void setup() {
  playerInfo = new KinMotionData();
  playerInfo.setMaxVel(maxVelocity);
  playerStart = playerInfo.getPosition();
  targetInfo = new KinMotionData();
  xenoInfo = new KinMotionData();
  xenoInfo.setMaxVel(xenoMaxVelocity);
  xenoInfo.setPosition(500, 650);
  xenoStart = xenoInfo.getPosition();
  size(1300, 800, P2D);
  smooth();
  background(255);
  noStroke();
  player = createShape(GROUP);
  body = createShape(ELLIPSE, -20, -20, 40, 40);
  body.setFill(color(119, 136, 153));
  view = createShape();
  view.beginShape(TRIANGLES);
  view.vertex(5, 20);
  view.vertex(5, -20);
  view.vertex(40, 0);
  view.endShape(CLOSE);
  view.setFill(color(0, 0, 255));
  light = createShape();
  light.beginShape(TRIANGLES);
  light.vertex(80, 40);
  light.vertex(80, -40);
  light.vertex(5, 0);
  light.endShape(CLOSE);
  light.setFill(color(255, 255, 255, 128));
  player.addChild(light);
  player.addChild(view);
  player.addChild(body);
  xenoS = createShape(GROUP);

  crumbTrail = createShape(GROUP);  
  breadCrumb = createShape(ELLIPSE, -5, -5, 10, 10);
  breadCrumb.setFill(color(0, 0, 255));
  
  crumbTrailA = createShape(GROUP);  
  breadCrumbA = createShape(ELLIPSE, -5, -5, 10, 10);
  breadCrumbA.setFill(color(255, 0, 0));

  node = createShape(ELLIPSE, -10, -10, 20, 20);

  graph = new Graph();
  createGraph();
  
  xeno = new Sprite(this, "AlienSpriteNormal.gif", 1);
  xeno.setXY(xenoInfo.getPosition()[0], xenoInfo.getPosition()[1]);
  
  background = loadImage("SpaceshipFloor.jpg");
  
  attackMode = false;
  
  generatePlayerTree();
  generateXenoTree();
  
  output = createWriter("log.txt");
}

void draw() {
  background(255);
  image(background, 650, 400, 1300, 800);
  drawEnvironment();
  xeno.draw();
  
  //drawGraph();

  shape(player, playerInfo.getPosition()[0], playerInfo.getPosition()[1]);
  
  if (aList.size() > 1) {
    List<Node> path = new ArrayList<Node>();
    for (int i = 0; i < aList.size(); i++) {
      path.add(graph.nodes.get(aList.get(i).fromNode-1));
    }
    path.add(graph.nodes.get(aList.get(aList.size()-1).toNode-1));
    playerInfo = pathFollow(path, playerInfo, player);
  }
  
  pN.makeDecision();
  aN.run();
  
  //Log information
  String result;
  // Distance from player
  if (sqrt((float)Math.pow(playerInfo.getPosition()[0] - xenoInfo.getPosition()[0], 2.0)
      +(float)Math.pow(playerInfo.getPosition()[1] - xenoInfo.getPosition()[1], 2.0)) < 400)
    result = "near";
  else
    result = "far";
  output.println("Distance from player: " + result);
  // In or out of hive
  if (xenoInfo.getPosition()[0] > 700 || xenoInfo.getPosition()[1] < 375)
    result = "oustide";
  else
    result = "inside";
  output.println("In or out of hive:    " + result);
  // Reset or not
  if (sqrt((float)Math.pow(playerInfo.getPosition()[0] - playerStart[0], 2.0)
      +(float)Math.pow(playerInfo.getPosition()[1] - playerStart[1], 2.0)) < 100
      && sqrt((float)Math.pow(xenoInfo.getPosition()[0] -xenoStart[0], 2.0)
      +(float)Math.pow(xenoInfo.getPosition()[1] - xenoStart[1], 2.0)) < 100)
    result = "reset";
  else
    result = "not reset";
  output.println("Reset or not:         " + result);
  
  if (attackMode)
    xeno = new Sprite(this, "AlienSpriteChase.gif", 1);
  else
    xeno = new Sprite(this, "AlienSpriteNormal.gif", 1);
    
  if (xList.size() > 1) {
    List<Node> path = new ArrayList<Node>();
    for (int i = 0; i < xList.size(); i++) {
      path.add(graph.nodes.get(xList.get(i).fromNode-1));
    }
    path.add(graph.nodes.get(xList.get(xList.size()-1).toNode-1));
    xenoInfo = pathFollow(path, xenoInfo, xenoS);
  }
  xeno.setXY(xenoInfo.getPosition()[0], xenoInfo.getPosition()[1]);
  xeno.setRot(-xenoInfo.getOrientation());
  
  /*breadCrumbDrop++;
  if (breadCrumbDrop == 5) {
    breadCrumb = createShape(ELLIPSE, playerInfo.getPosition()[0]-5, playerInfo.getPosition()[1]-5, 10, 10);
    breadCrumb.setFill(color(0, 0, 255));
    crumbTrail.addChild(breadCrumb);
    breadCrumbDrop = 0;
  }
  shape(crumbTrail, 0, 0);
  
  breadCrumbDropA++;
  if (breadCrumbDropA == 5) {
    breadCrumbA = createShape(ELLIPSE, xenoInfo.getPosition()[0]-5, xenoInfo.getPosition()[1]-5, 10, 10);
    breadCrumbA.setFill(color(255, 0, 0));
    crumbTrailA.addChild(breadCrumbA);
    breadCrumbDropA = 0;
  }
  shape(crumbTrail, 0, 0);*/
}

void drawGraph() {
  for (int i = 0; i < graph.nodes.size(); i++)
    //if (graph.nodes.get(i).visited)
      drawNode(graph.nodes.get(i));
  for (int i = 0; i < graph.edges.size(); i++)
    drawEdgeFinal(graph.edges.get(i).fromNode, graph.edges.get(i).toNode);
}

void mousePressed() {
  targetInfo.setPosition(mouseX, mouseY);
  int s = 0;
  int f = 0;
  float smallestDistance = Float.POSITIVE_INFINITY;
  for (int i = 0; i < graph.nodes.size(); i++) {
    float floatDistance = sqrt((float)Math.pow(playerInfo.getPosition()[0] - graph.nodes.get(i).location[0], 2.0) + 
      (float)Math.pow(playerInfo.getPosition()[1] - graph.nodes.get(i).location[1], 2.0));
    if (floatDistance < smallestDistance) {
      smallestDistance = floatDistance;
      s = i+1;
    }
  }
  smallestDistance = Float.POSITIVE_INFINITY;
  for (int i = 0; i < graph.nodes.size(); i++) {
    float floatDistance = sqrt((float)Math.pow(targetInfo.getPosition()[0] - graph.nodes.get(i).location[0], 2.0) + 
                          (float)Math.pow(targetInfo.getPosition()[1] - graph.nodes.get(i).location[1], 2.0));
    if (floatDistance < smallestDistance) {
      smallestDistance = floatDistance;
      f = i+1;
    }
  }
  
  if (s != f) {
    aList = pathFindAStar(graph, graph.nodes.get(s-1), graph.nodes.get(f-1), new Heuristic(graph.nodes.get(f-1)));
    aList = reverseList(aList);
  }
}

public List<Edge> reverseList(List<Edge> list) {
  List<Edge> newList = new ArrayList<Edge>(list.size());
  for (int i = list.size()-1; i >= 0; i--)
    newList.add(list.get(i));
  return newList;
}

public class Path {
  int finalIndex = 0;
  public int getParam(List<Node> list, float[] current, float[] future) {
    float smallestDistance1 = 900;
    int index = 0;
    for (int i = 0; i < list.size(); i++) {
      float floatDistance = sqrt((float)Math.pow(list.get(i).location[0] - future[0], 2.0) + 
                            (float)Math.pow(list.get(i).location[1] - future[1], 2.0));
      if (floatDistance < smallestDistance1) {
        smallestDistance1 = floatDistance;
        index = i;
        if (floatDistance <= 10 && index + 1 < list.size())
          index++;
      }
    }
    return index;
  }
}

KinMotionData pathFollow(List<Node> path, KinMotionData player, PShape object) {
  int pathOffset = 2;
  float predictTime = 0.1;
  float[] futurePos = new float[2];
  futurePos[0] = player.position[0] + (player.velocity[0]*predictTime);
  futurePos[1] = player.position[1] + (player.velocity[1]*predictTime);
  int currentParam = p.getParam(path, player.getPosition(), futurePos);
  int targetParam = currentParam + pathOffset;
  float[] targetPos = new float[2];
  if (targetParam < path.size()-1) {
    targetPos[0] = path.get(targetParam).location[0];
    targetPos[1] = path.get(targetParam).location[1];
  } else {
    targetPos[0] = path.get(path.size()-1).location[0];
    targetPos[1] = path.get(path.size()-1).location[1];
  }
  return seek(player, targetPos, object);
}

class NodeRecord {
  public Node node;
  public Edge edge;
  public float costSoFar;
  public float estimatedTotalCost;
}

List pathFindAStar(Graph g, Node s, Node f, Heuristic h) {
  for (int i = 0; i < g.nodes.size(); i++)
    g.nodes.get(i).visited = false;
  List path = new ArrayList();
  NodeRecord startRecord = new NodeRecord();
  startRecord.node = s;
  startRecord.edge = null;
  startRecord.costSoFar = 0;
  startRecord.estimatedTotalCost = h.estimateEuclidean(s);
  List<NodeRecord> open = new ArrayList<NodeRecord>();
  open.add(startRecord);
  List<NodeRecord> closed = new ArrayList<NodeRecord>();
  NodeRecord current = new NodeRecord();
  while (open.size() > 0) {
    current = open.get(smallestElementA(open));
    List<Edge> edges = new ArrayList<Edge>();
    if (current.node.name == f.name) {
      break;
    } else {
      edges = g.getEdges(current.node.name);
    }
    float endNodeHeuristic;
    for (int i = 0; i < edges.size(); i++) {
      Node endNode = g.nodes.get(edges.get(i).getToNode()-1);
      float endNodeCost = current.costSoFar + edges.get(i).getCost();
      NodeRecord endNodeRecord;
      if (closed.contains(endNode)/*isInList(endNode, closed)*/) {
        endNodeRecord = closed.get(getNodeInList(closed, endNode.name));
        if (endNodeRecord.costSoFar > endNodeCost)
          break;
        else
          closed.remove(endNodeRecord);
        endNodeHeuristic = endNodeRecord.estimatedTotalCost - endNodeRecord.costSoFar;
      } else if (open.contains(endNode)/*isInList(endNode, open)*/) {
        endNodeRecord = open.get(getNodeInList(open, endNode.name));
        if (endNodeRecord.costSoFar > endNodeCost)
          break;
        endNodeHeuristic = endNodeRecord.edge.cost - endNodeRecord.costSoFar;
      } else {
        endNodeRecord = new NodeRecord();
        endNodeRecord.node = endNode;
        endNodeHeuristic = h.estimateEuclidean(endNode);
        g.nodes.get(endNode.name-1).visited = true;
      }
      endNodeRecord.costSoFar = endNodeCost;
      endNodeRecord.edge = edges.get(i);
      endNodeRecord.estimatedTotalCost = endNodeRecord.costSoFar + endNodeHeuristic;
      if (!isInList(endNode, open))
        open.add(endNodeRecord);
    }
    open.remove(current);
    closed.add(current);
  }
  if (current.node.name != f.name) {
    System.out.println("GOAL NODE NOT REACHED!");
  } else {
    while (current.edge.fromNode != s.name) {
      path.add(current.edge);
      current = closed.get(getNodeInList(closed, current.edge.getFromNode()));
    }
    path.add(current.edge);
  }
  return path;
}

boolean isInList(Node n, List<NodeRecord> list) {
  boolean inList = false;
  for (int i = 0; i < list.size(); i++) {
    if (list.get(i).node.name == n.name)
      inList = true;
  }
  return inList;
}

int getNodeInList(List<NodeRecord> list, int n) {
  int location = 0;
  for (int i = 0; i < list.size(); i++) {
    if (list.get(i).node.name == n) {
      location = i;
      break;
    }
  }
  return location;
}

int smallestElementA(List<NodeRecord> list) {
  float lowestCost = list.get(0).estimatedTotalCost;
  int indexOfLow = 0;
  for (int i = 1; i < list.size(); i++) {
    if (lowestCost > list.get(i).estimatedTotalCost) {
      lowestCost = list.get(i).estimatedTotalCost;
      indexOfLow = i;
    }
  }
  return indexOfLow;
}

KinMotionData playerInfo, targetInfo, xenoInfo;
Graph smallGraph, bigGraph, graph;

int breadCrumbDrop = 0;
int breadCrumbDropA = 0;
int minX = 20;
int maxX = 1280;
int minY = 20;
int maxY = 780;
float x = 770;
float y = 30;
float maxVelocity = 8;
float xenoMaxVelocity = 4;
float maxAccel = 2;
float maxRot = PI/2;
float maxAngular = PI/8;
float radiusOfSat = 5;
float radiusDecel = 100;
float wanderRate = PI/7;
float wanderOffset = 100;
float wanderRadius = 20;
float wanderOrientation = 0;
float goalRotation = 0;
float timeToTargetVelocity = 0.1;

KinMotionData orientPlayer(KinMotionData boid, PShape object) {
  KinMotionData result = new KinMotionData();
  float currentOrientation = boid.getOrientation();
  float finalOrientation = getNewOrientation(currentOrientation, boid);
  float newFinal = 0;
  float newCurrent = abs(currentOrientation);
  if (currentOrientation > 0)
    newFinal = mapToRange(finalOrientation - newCurrent);
  else if (currentOrientation < 0)
    newFinal = mapToRange(finalOrientation + newCurrent);
  else if (currentOrientation == 0)
    newFinal = finalOrientation;
  if (newFinal > 0) {
    object.rotate(-abs(newFinal*result.getRotation()));
    result.setOrientation(mapToRange(currentOrientation + abs(newFinal*boid.getRotation())));
  } 
  else if (newFinal < 0) {
    object.rotate(abs(newFinal*result.getRotation()));
    result.setOrientation(mapToRange(currentOrientation - abs(newFinal*boid.getRotation())));
  } 
  else if (newFinal == 0) {
    result.setOrientation(currentOrientation);
  }
  return result;
}

void align(KinMotionData player, KinMotionData target) {
  float currentOrientation = player.getOrientation();
  float rotation = target.getOrientation() - player.getOrientation();
  rotation = mapToRange(rotation);
  float rotSize = abs(rotation);
  if (rotSize < radiusOfSat) {
    goalRotation = currentOrientation;
  } 
  else if (rotSize > radiusDecel) {
    goalRotation = maxRot;
  } 
  else {
    goalRotation = maxRot*(rotSize/radiusDecel);
  }
  goalRotation *= rotation/abs(rotation);
  player.setAngular(goalRotation - player.getRotation());
  player.setAngular(player.getAngular()/timeToTargetVelocity);
  player.setAngular(player.getAngular()/abs(player.getAngular()));
  player.setAngular(player.getAngular()*maxAngular);
}

float mapToRange(float currentOrientation) {
  float fixedOrientation = currentOrientation;
  if (currentOrientation <= -PI)
    fixedOrientation += 2*PI;
  else if (currentOrientation > PI)
    fixedOrientation -= 2*PI;
  return fixedOrientation;
}

float getNewOrientation(float currentOrientation, KinMotionData player) {
  if (player.getVelocityLength() > 0)
    return atan2(-player.getVelocity()[1], player.getVelocity()[0]);
  else
    return currentOrientation;
}

void arrive(KinMotionData boid, float[] target) {
  float [] direction = new float[2];
  direction[0] = target[0] - boid.getPosition()[0];
  direction[1] = target[1] - boid.getPosition()[1];
  float distance = sqrt((direction[0]*direction[0]) + (direction[1]*direction[1]));
  float goalSpeed = 0;
  float [] goalVelocity = new float[2];
  if (distance < radiusOfSat) {
    boid.setVelocity(0, 0);
    boid.setLinear(0, 0);
  } 
  else if (distance > radiusDecel) {
    goalSpeed = boid.getMaxVel();
  } 
  else {
    goalSpeed = boid.getMaxVel() * distance / radiusDecel;
  }
  goalVelocity[0] = direction[0];
  goalVelocity[1] = direction[1];
  float goalVelocityLength = sqrt((goalVelocity[0]*goalVelocity[0]) + (goalVelocity[1]*goalVelocity[1]));
  if (goalVelocityLength != 0) {
    goalVelocity[0] = (goalVelocity[0]/goalVelocityLength)*goalSpeed;
    goalVelocity[1] = (goalVelocity[1]/goalVelocityLength)*goalSpeed;
  }
  boid.setLinear((goalVelocity[0] - boid.getVelocity()[0])/timeToTargetVelocity, 
  (goalVelocity[1] - boid.getVelocity()[1])/timeToTargetVelocity);
  if (boid.getLinearLength() > maxAccel) {
    boid.setLinear(normalizeVector(boid.getLinear())[0], normalizeVector(boid.getLinear())[1]);
    boid.setLinear(boid.getLinear()[0]*maxAccel, boid.getLinear()[1]*maxAccel);
  }
  boid.setAngular(0);
  boid.setVelocity(goalVelocity[0], goalVelocity[1]);
  if (boid.getVelocityLength() > boid.getMaxVel()) {
    boid.setVelocity(normalizeVector(boid.getVelocity())[0], normalizeVector(boid.getVelocity())[1]);
    ;
    boid.setVelocity(boid.getVelocity()[0]*boid.getMaxVel(), boid.getVelocity()[1]*boid.getMaxVel());
  }
}

KinMotionData seek(KinMotionData boid, float [] target, PShape object) {
  KinMotionData result = new KinMotionData();
  result.setMaxVel(boid.getMaxVel());
  result.setPosition(boid.getPosition()[0], boid.getPosition()[1]);
  result.setVelocity(target[0] - result.getPosition()[0], target[1] - result.getPosition()[1]);
  KinMotionData orient = orientPlayer(boid, object);
  result.setOrientation(orient.getOrientation());
  result.setVelocity(result.getVelocity()[0]+boid.getLinear()[0], 
  result.getVelocity()[1]+boid.getLinear()[1]);
  arrive(result, target);
  result.setPosition(result.getPosition()[0] + result.getVelocity()[0], 
  result.getPosition()[1] + result.getVelocity()[1]);
  return result;
}

KinMotionData wanderXeno(KinMotionData boid, PShape object) {
  KinMotionData result = new KinMotionData();
  result.setPosition(boid.getPosition()[0], boid.getPosition()[1]);
  KinMotionData finalTarget = new KinMotionData();
  if (boid.getPosition()[0]-wanderOffset < minX || boid.getPosition()[1]-wanderOffset < minY || boid.getPosition()[0]+wanderOffset > maxX || boid.getPosition()[1]+wanderOffset > maxY) {
    result.setOrientation(mapToRange(boid.getOrientation()-PI));
    object.rotate(PI);
    wanderOrientation += (randomBinomial()*wanderRate);
    finalTarget.setOrientation(wanderOrientation+result.getOrientation());
    finalTarget.setPosition(boid.getPosition()[0]+wanderOffset*asVector(boid.getOrientation())[0],
                            boid.getPosition()[1]+wanderOffset*asVector(boid.getOrientation())[1]);
    finalTarget.setPosition(finalTarget.getPosition()[0]+wanderRadius*asVector(finalTarget.getOrientation())[0],
                            finalTarget.getPosition()[1]+wanderRadius*asVector(finalTarget.getOrientation())[1]);
    //align(result, finalTarget);
    findTarget(finalTarget.getPosition()[0], finalTarget.getPosition()[1]);
  } else {
    wanderOrientation += randomBinomial()*wanderRate;
    finalTarget.setOrientation(wanderOrientation+boid.getOrientation());
    finalTarget.setPosition(boid.getPosition()[0]+wanderOffset*asVector(boid.getOrientation())[0],
                            boid.getPosition()[1]+wanderOffset*asVector(boid.getOrientation())[1]);
    finalTarget.setPosition(finalTarget.getPosition()[0]+wanderRadius*asVector(finalTarget.getOrientation())[0],
                            finalTarget.getPosition()[1]+wanderRadius*asVector(finalTarget.getOrientation())[1]);
    //align(result, finalTarget);
    findTarget(finalTarget.getPosition()[0], finalTarget.getPosition()[1]);
  }
  return result;
}

KinMotionData wanderPlayer(KinMotionData boid, PShape object) {
  KinMotionData finalTarget = new KinMotionData();
  if (boid.getPosition()[0]-wanderOffset < minX || boid.getPosition()[1]-wanderOffset < minY || boid.getPosition()[0]+wanderOffset > maxX || boid.getPosition()[1]+wanderOffset > maxY) {
    boid.setOrientation(mapToRange(boid.getOrientation()-PI));
    object.rotate(PI);
    wanderOrientation += (randomBinomial()*wanderRate);
    finalTarget.setOrientation(wanderOrientation+boid.getOrientation());
    finalTarget.setPosition(boid.getPosition()[0]+wanderOffset*asVector(boid.getOrientation())[0],
                            boid.getPosition()[1]+wanderOffset*asVector(boid.getOrientation())[1]);
    finalTarget.setPosition(finalTarget.getPosition()[0]+wanderRadius*asVector(finalTarget.getOrientation())[0],
                            finalTarget.getPosition()[1]+wanderRadius*asVector(finalTarget.getOrientation())[1]);
  } else {
    wanderOrientation += randomBinomial()*wanderRate;
    finalTarget.setOrientation(wanderOrientation+boid.getOrientation());
    finalTarget.setPosition(boid.getPosition()[0]+wanderOffset*asVector(boid.getOrientation())[0],
                            boid.getPosition()[1]+wanderOffset*asVector(boid.getOrientation())[1]);
    finalTarget.setPosition(finalTarget.getPosition()[0]+wanderRadius*asVector(finalTarget.getOrientation())[0],
                            finalTarget.getPosition()[1]+wanderRadius*asVector(finalTarget.getOrientation())[1]);
  }
  System.out.println(finalTarget.getPosition()[0] + " " + finalTarget.getPosition()[1]);
  System.out.println("Player: " + playerInfo.getPosition()[0] + "  " + playerInfo.getPosition()[1]);
  return finalTarget;
}

float randomBinomial() {
  Random r = new Random();
  return r.nextFloat()-r.nextFloat();
}

float [] asVector(float angle) {
   float vector[] = new float[2];
   vector[0] = cos(angle);
   vector[1] = sin(angle);
   return vector;
}

float [] normalizeVector(float[] vector) {
  float vectorLength = sqrt((vector[0]*vector[0]) + (vector[1]*vector[1]));
  vector[0] = vector[0]/vectorLength;
  vector[1] = vector[1]/vectorLength;
  return vector;
}

