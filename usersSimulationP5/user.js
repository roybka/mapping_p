class UserManager {
  #users = [];
  #usedIds = new Set();

  constructor() {
    // Constructor stays clean
  }

  initializeUsers(type, count) {
    for (let i = 0; i < count; i++) {
      let id = this.#generateUniqueId();
      let color = this.#generateRandomColor(); // Safe to call here if within setup()
      let position = { x: random(width), y: random(height) };
      if (type === "normal") {
        this.#users.push(new NormalUser(id, position, color));
      } else if (type === "mouse") {
        this.#users.push(new MouseUser(id, color));
      }
    }
  }

  #generateUniqueId() {
    let id;
    do {
      id = floor(random(1000));
    } while (this.#usedIds.has(id));
    this.#usedIds.add(id);
    return id;
  }

  #generateRandomColor() {
    return color(random(255), random(255), random(255));
  }

  getUsers() {
    return this.#users.map(user => ({
      id: user.id,
      position: { ...user.position },
      color: user.color
    }));
  }

  run() {
    this.#users.forEach(user => {
      user.walk();
      user.draw(); // REMOVE THIS FOR NOT DRAWING USERS ON SCREEN
    });
  }
}



let NOISE_SCALE_MOVEMENT = 0.001;

// Base class
class User {
    constructor(id, position, color) {
      this.id = id;
      this.position = position;
      this.color = color;
    }
  
    walk() {
      // This method can be overridden by subclasses
    }
  
    draw() {
      fill(this.color);
      noStroke();
      ellipse(this.position.x, this.position.y, 10, 10);
    }
  }
  
  // Subclass for normal random walking users
  class NormalUser extends User {
    constructor(id, position, color) {
      super(id, position, color);
      this.xoff = random(1000);
      this.yoff = random(1000);
    }
  
    walk() {
      this.position.x = map(noise(this.xoff), 0, 1, 0, width);
      this.position.y = map(noise(this.yoff), 0, 1, 0, height);
      this.xoff += NOISE_SCALE_MOVEMENT;
      this.yoff += NOISE_SCALE_MOVEMENT;
    }
  }
  
  // Subclass for user controlled by mouse position
  class MouseUser extends User {
    constructor(id, color) {
      super(id, { x: mouseX, y: mouseY }, color);
    }
  
    walk() {
      this.position.x = mouseX;
      this.position.y = mouseY;
    }
  }
  