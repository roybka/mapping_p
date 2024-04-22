import java.util.ArrayList;
import java.util.HashSet;

UserManager userManager;
ArrayList<User> users;

void setup() {
  size(400, 400);
  userManager = new UserManager();
  userManager.initializeUsers("normal", 5); // Initialize 5 normal users
  userManager.initializeUsers("mouse", 1);  // Initialize 1 mouse-controlled user
}

void draw() {
  background(220);
  userManager.run();
  users = userManager.getUsers();
  for (User user : users) {
    // PUT CODE
  }
}

class UserManager {
  ArrayList<User> users = new ArrayList<User>();
  HashSet<Integer> usedIds = new HashSet<Integer>();

  UserManager() {
    // Constructor stays clean
  }

  void initializeUsers(String type, int count) {
    for (int i = 0; i < count; i++) {
      int id = generateUniqueId();
      color col = generateRandomColor(); // Safe to call here if within setup()
      PVector position = new PVector(random(width), random(height));
      if (type.equals("normal")) {
        users.add(new NormalUser(id, position, col));
      } else if (type.equals("mouse")) {
        users.add(new MouseUser(id, col));
      }
    }
  }

  int generateUniqueId() {
    int id;
    do {
      id = floor(random(1000));
    } while (usedIds.contains(id));
    usedIds.add(id);
    return id;
  }

  color generateRandomColor() {
    return color(random(255), random(255), random(255));
  }

ArrayList<User> getUsers() {
  ArrayList<User> copy = new ArrayList<User>();
  for (User user : users) {
    copy.add(user.copy()); // Use the copy method
  }
  return copy;
}


  void run() {
    for (User user : users) {
      user.walk();
      user.draw(); // REMOVE THIS FOR NOT DRAWING USERS ON SCREEN
    }
  }
}

float NOISE_SCALE_MOVEMENT = 0.001;
abstract class User {
  int id;
  PVector position;
  color userColor; // Changed variable name from 'color' to 'userColor'

  User(int id, PVector position, color userColor) { // Adjust constructor
    this.id = id;
    this.position = position;
    this.userColor = userColor;
  }

  abstract User copy();

  void walk() {
    // This method can be overridden by subclasses
  }

  void draw() {
    fill(userColor); // Adjust usage to new variable name
    noStroke();
    ellipse(position.x, position.y, 10, 10);
  }
}

// Subclass for normal random walking users
class NormalUser extends User {
  float xoff, yoff;

  NormalUser(int id, PVector position, color userColor) { // Adjust constructor
    super(id, position, userColor);
    xoff = random(1000);
    yoff = random(1000);
  }

  @Override
  User copy() {
    NormalUser copy = new NormalUser(this.id, this.position.copy(), this.userColor);
    copy.xoff = this.xoff;
    copy.yoff = this.yoff;
    return copy;
  }

  void walk() {
    position.x = map(noise(xoff), 0, 1, 0, width);
    position.y = map(noise(yoff), 0, 1, 0, height);
    xoff += NOISE_SCALE_MOVEMENT;
    yoff += NOISE_SCALE_MOVEMENT;
  }
}

// Subclass for user controlled by mouse position
class MouseUser extends User {
  MouseUser(int id, color userColor) { // Adjust constructor
    super(id, new PVector(mouseX, mouseY), userColor);
  }

  @Override
  User copy() {
    return new MouseUser(this.id, this.userColor);
  }

  void walk() {
    position.x = mouseX;
    position.y = mouseY;
  }
}
