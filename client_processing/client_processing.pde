// not ready.
// todo: make objects persistent
// todo: support multiple objects
// todo: kalman filter?
// # make more efficient? (applymatrix calls)
import processing.net.*;
String data = "";
int st=0;
int port=12345;
String a = "Nothing";
PMatrix m;
float[][] matrix = new float[4][4];
float[][] matrix_cam = new float[4][4];
Client myClient;

void loadMatrixFromFile(String filename, float[][] mat) {
  String[] rows = loadStrings(filename);
  for (int i = 0; i < rows.length; i++) {
    String[] cols = split(rows[i], ',');
    for (int j = 0; j < cols.length; j++) {
      mat[i][j] = float(cols[j]);
    }
  }
}

void setup() {
  fullScreen(P3D, 1);
  background(255);

  // Connect to the server's IP and the port
  myClient = new Client(this, "127.0.0.1", port); // Use the correct IP and port
  loadMatrixFromFile("../resources/transformation_matrix.csv", matrix);
  loadMatrixFromFile("../resources/m_transformation_matrix.csv", matrix_cam);
  fill(0);
  applyMatrix(matrix[0][0], matrix[0][1], 0, matrix[0][2],
    matrix[1][0], matrix[1][1], 0, matrix[1][2],
    0, 0, 1, 0,
    matrix[2][0], matrix[2][1], 0, matrix[2][2]);
  //printMatrix();

}

void draw() {
  //println(millis()-st);
  //st=millis();
  background(255);
  applyMatrix(matrix[0][0], matrix[0][1], 0, matrix[0][2],
    matrix[1][0], matrix[1][1], 0, matrix[1][2],
    0, 0, 1, 0,
    matrix[2][0], matrix[2][1], 0, matrix[2][2]);
  //m = this.getMatrix();
  //printArray(m.get(new float[]{}));
  fill(44);
  rect(0, 0, width, height);
  applyMatrix(matrix_cam[0][0], matrix_cam[0][1], 0, matrix_cam[0][2],
    matrix_cam[1][0], matrix_cam[1][1], 0, matrix_cam[1][2],
    0, 0, 1, 0,
    matrix_cam[2][0], matrix_cam[2][1], 0, matrix_cam[2][2]);
  //printArray(m.get(new float[]{}));
  fill(144);
  if (myClient.available() > 0) {
    data = myClient.readString();
    println(data);
  if (data.equals(a)==false) {
      println("plotting");
      float[] list = float(split(data, ','));
      circle(int(list[0]), int(list[1]), 50);
    }
  }  
}
