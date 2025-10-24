// src/Greeting.tsx
import React from 'react';
import './Greeting.css'; // Import the CSS file

// 1. Define an interface for the props this component expects.
// 'name' is required (string), 'message' is optional (string).
interface GreetingProps {
  name: string;
  message?: string; // The '?' makes the prop optional
}

// 2. Define the functional component and apply the props interface.
// We're using object destructuring for cleaner access to props.
function Greeting({ name, message }: GreetingProps) {
  // Provide a default value for message if it's not provided by the parent
  const displayMessage = message || "Hello from React!";

  return (
    <div className="greeting">
      <h2>Hello, {name}!</h2>
      <p>{displayMessage}</p>
    </div>
  );
}

export default Greeting;
