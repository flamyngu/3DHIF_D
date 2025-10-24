// src/Counter.tsx
import React, { useState } from "react"; // Import the useState hook
import "./Counter.css"; // Import the CSS file
function Counter() {
  // 1. Declare a state variable 'count' and its setter function 'setCount'.
  //TypeScript infers 'count' as a 'number' from the initial value 0.
  //We could also explicitly type it: useState<number>(0);
  const [count, setCount] = useState(0);
  // Event handler to increment the count
  const handleIncrement = () => {
    // IMPORTANT: Always use the setter function (setCount) to update state.
    // Using the functional update form (prevCount => ...) is best practice
    // when the new state depends on the previous state, ensuring atomicity.
    setCount((prevCount) => prevCount + 1);
  };
  // Event handler to decrement the count
  const handleDecrement = () => {
    setCount((prevCount) => prevCount - 1);
  };
  // Event handler to reset the count
  const handleReset = () => {
    setCount(0); // Set count back to initial value
  };
  return (
    <div className="counter">
      <h2>Simple Counter: {count}</h2>{" "}
      {/* Display the current value of 'count' */}
      <button onClick={handleIncrement} className="counter-btn increment">
        Increment
      </button>
      <button onClick={handleDecrement} className="counter-btn decrement">
        Decrement
      </button>
      <button onClick={handleReset} className="counter-btn reset">
        Reset
      </button>
      <p className="counter-note">
        This component manages its own internal 'count' state.
      </p>
    </div>
  );
}
export default Counter;
