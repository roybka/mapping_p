import processing.video.*;
float[][] matrix = new float[4][4];
PImage img;
int mi;
Capture video;
void setup() {
  fullScreen(P3D,2);
  
  loadMatrixFromFile("transformation_matrix.csv");
  background(0);
  img = loadImage("a.png");
  video = new Capture(this, width, height);
  video.start();  
}

void draw() {
  background(255);
  // Apply the loaded matrix
  //applyMatrix(matrix[0][0], matrix[0][1], matrix[0][3], matrix[0][2],
  //            matrix[1][0], matrix[1][1], matrix[1][3], matrix[1][2],
  //            matrix[2][0], matrix[2][1], matrix[2][3], matrix[2][2],
  //            matrix[3][0], matrix[3][1], matrix[3][3], matrix[3][2]);
  applyMatrix(matrix[0][0], matrix[0][1], 0, matrix[0][2],
                matrix[1][0],matrix[1][1], 0, matrix[1][2],
                0,          0,          1, 0,
                matrix[2][0], matrix[2][1], 0, matrix[2][2]);
  // Example drawing code
  background(0);
image(img, 0, 0, width, height);
}

// Function to load the matrix from a CSV file
void loadMatrixFromFile(String filename) {
  String[] rows = loadStrings(filename);
  for (int i = 0; i < rows.length; i++) {
    String[] cols = split(rows[i], ',');
    for (int j = 0; j < cols.length; j++) {
      matrix[i][j] = float(cols[j]);
      //println(i);
      //println(j);
      //println(matrix[i][j]);
    }
  }
}
