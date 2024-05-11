import java.util.ArrayList;
import java.util.HashSet;

UserManager userManager;
ArrayList<User> users;

void setup() {
  size(800, 800);
  userManager = new UserManager();
  userManager.initializeUsers("normal", 5); // Initialize 5 normal users
  //userManager.initializeUsers("mouse", 1);  // Initialize 1 mouse-controlled user
}

void draw() {
  background(255);
  userManager.run();
  users = userManager.getUsers();
  for (User user : users) {
    user.show(); //Remove this to hide user dot.
    // ##### EXAMPLE CODE: divide the users to 2 random groups rect VS circle #####
    noStroke();
    int shapeSize = width/10;
    if (user.id % 2 == 0) { // if user id is even
      fill(255, 180, 180, 100);
      circle(user.position.x,user.position.y,shapeSize);
    } else { // if user id is odd
      rectMode(CENTER);
      fill(0, 180, 70, 100);
      rect(user.position.x,user.position.y,shapeSize,shapeSize);
    }
    // ##### END EXAMPLE #####
  }
}

void keyPressed() {
  switch(key) {
    case '+':
    case '=': // Handle both keys due to keyboard layout differences
      userManager.addNormalUser();
      break;
    case '-':
      userManager.removeNormalUser();
      break;
  }
}
