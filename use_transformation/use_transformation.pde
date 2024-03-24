float[][] matrix = new float[4][4];

void setup() {
  size(640, 480, P3D);
  loadMatrixFromFile("transformation_matrix.csv");
  noLoop();
}

void draw() {
  background(255);
  
  // Apply the loaded matrix
  applyMatrix(matrix[0][0], matrix[0][1], matrix[0][3], matrix[0][2],
              matrix[1][0], matrix[1][1], matrix[1][3], matrix[1][2],
              matrix[2][0], matrix[2][1], matrix[2][3], matrix[2][2],
              matrix[3][0], matrix[3][1], matrix[3][3], matrix[3][2]);
  
  // Example drawing code
  rect(0, 0, width, height);
}

// Function to load the matrix from a CSV file
void loadMatrixFromFile(String filename) {
  String[] rows = loadStrings(filename);
  for (int i = 0; i < rows.length; i++) {
    String[] cols = split(rows[i], ',');
    for (int j = 0; j < cols.length; j++) {
      matrix[i][j] = float(cols[j]);
    }
  }
}
