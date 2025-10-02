// src/index.ts
import express, { Request, Response } from 'express';
// Create the Express app
const app = express();
const PORT = 3000;
// This middleware is needed to parse JSON bodies from POST/PUT requests
app.use(express.json());
// --- In-Memory "Database" ---
// In a real app, you would use a database like PostgreSQL or MongoDB.
interface User {
 id: number;
 name: string;
 email: string;
}
let users: User[] = [
 { id: 1, name: 'Alice', email: 'alice@example.com' },
 { id: 2, name: 'Bob', email: 'bob@example.com' },
];
let nextUserId = 3;
// --- API Endpoints (Routes) ---
// GET /api/users - Get all users
app.get('/api/users', (req: Request, res: Response) => {
 res.json(users);
});
// GET /api/users/:id - Get a single user by ID
app.get('/api/users/:id', (req: Request, res: Response) => {
 const id = parseInt(req.params.id);
 const user = users.find(u => u.id === id);
 if (user) {
 res.json(user);
 } else {
 res.status(404).send('User not found');
 }
});
// POST /api/users - Create a new user
app.post('/api/users', (req: Request, res: Response) => {
 const { name, email } = req.body;
 if (!name || !email) {
 return res.status(400).send('Name and email are required');
 }
 const newUser: User = {
 id: nextUserId++,
 name,
 email,
 };
 users.push(newUser);
 res.status(201).json(newUser);
});
// PUT /api/users/:id - Update an existing user
app.put('/api/users/:id', (req: Request, res: Response) => {
 const id = parseInt(req.params.id);
 const userIndex = users.findIndex(u => u.id === id);
 if (userIndex !== -1) {
 const { name, email } = req.body;
 // Update user properties if they are provided in the request
 users[userIndex] = { ...users[userIndex], name: name ??
users[userIndex].name, email: email ?? users[userIndex].email };
 res.json(users[userIndex]);
 } else {
 res.status(404).send('User not found');
 }
});
// DELETE /api/users/:id - Delete a user
app.delete('/api/users/:id', (req: Request, res: Response) => {
 const id = parseInt(req.params.id);
 const initialLength = users.length;
 users = users.filter(u => u.id !== id);
 if (users.length < initialLength) {
 res.status(204).send(); // 204 No Content
 } else {
 res.status(404).send('User not found');
 }
});
// Start the server
app.listen(PORT, () => {
 console.log(`✅ Server is running at http://localhost:${PORT}`);
});