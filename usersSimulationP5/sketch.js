let userManager;
let users;

function setup() {
  createCanvas(400, 400);
  userManager = new UserManager();
  userManager.initializeUsers("normal", 5); // Initialize 5 normal users
  userManager.initializeUsers("mouse", 1);  // Initialize 1 mouse-controlled user
}

function draw() {
  background(220);
  userManager.run();
  users = userManager.getUsers();
  for (let user of users) {
    /// PUT CODE
  }
}

