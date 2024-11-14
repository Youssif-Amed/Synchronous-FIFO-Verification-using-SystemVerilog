# SystemVerilog-Based Verification of Synchronous FIFO Design

## Project Overview
This project verifies a **Synchronous FIFO Design** using **SystemVerilog**. The environment includes a testbench with constrained randomization, coverage metrics, and a scoreboard for checking the functionality and robustness of the FIFO design.

## Project Structure
- **Top Module**: Generates a clock signal, initializes an interface, and passes it to the DUT, testbench, and monitor modules.
- **Testbench**: Resets the DUT, applies random inputs, and monitors for the end of the test, asserting a `test_finished` signal.
- **Shared Package (`shared_pkg`)**: Contains shared variables (e.g., `error_count`, `correct_count`, `test_finished`) and the `FIFO_transaction` class for managing FIFO inputs and outputs.

## Modules and Classes

### 1. Top Module (`top.sv`)
   - Generates and passes the clock signal to the interface.
   - Instantiates the DUT, testbench, and monitor, sharing the interface instance among them.

### 2. Testbench (`tb.sv`)
   - Resets the DUT and applies randomized values to the inputs.
   - Asserts the `test_finished` signal when the test is complete.

### 3. Monitor Module (`monitor.sv`)
   - Creates objects for transaction, coverage, and scoreboard classes: `FIFO_transaction`, `FIFO_coverage`, and `FIFO_scoreboard`.
   - Continuously samples the interface data, stores it in the `FIFO_transaction` object, and forks two processes:
     - One process calls `sample_data` from the `FIFO_coverage` object to log coverage.
     - Another calls `check_data` from the `FIFO_scoreboard` to validate outputs.

### 4. Shared Package (`shared_pkg.sv`)
   - Contains:
     - **FIFO_transaction Class**: Stores FIFO inputs and outputs as variables and applies constraints on read and write enable signals.
     - **Counters**: Tracks `error_count` and `correct_count` for output validation.
     - **test_finished Signal**: Indicates simulation completion when asserted by the testbench.

### 5. Classes for Functional Coverage and Scoreboarding
   - **FIFO_coverage**: Collects functional coverage by cross-referencing write enable, read enable, and output control signals to ensure diverse FIFO states are tested.
   - **FIFO_scoreboard**: Compares actual outputs against reference values, logging mismatches and incrementing error counters.

## Functional Coverage
The coverage component verifies:
- **Cross Coverage**: Checks combinations of write and read enable signals alongside each output control signal (except `data_out`), ensuring the FIFO is tested in all operational states.
- **State Coverage**: Confirms transitions through key states like full, almost full, empty, and almost empty.

## Simulation Flow
1. **Clock Generation**: The top module generates the clock signal for the interface, shared across DUT, testbench, and monitor.
2. **Randomized Inputs**: The testbench applies constrained random values to inputs.
3. **Data Sampling and Validation**:
   - The monitor samples interface data and uses it for functional coverage and scoreboard checks.
   - Coverage tracks signal state combinations, while the scoreboard compares outputs against expected values.
4. **Simulation End Condition**: The testbench asserts `test_finished`, stopping the simulation and summarizing correct and error counts.

## Assertion-Based Verification
Assertions within the design file verify:
- **FIFO Status Flags**: Ensures output flags (full, empty) and internal counters maintain valid states.
- **Conditional Compilation**: Guards assertions using `ifdef` directives, enabling selective compilation for simulation.

## Running the Simulation
To run the simulation:
1. Compile the files with `+define+SIM` to enable assertions.
2. Run the simulation and check the output log for a summary of correct and error counts.

## Summary
This SystemVerilog verification environment verifies FIFO functionality and robustness through constrained random stimulus, coverage collection, and scoreboard checks, ensuring accurate data flow under various FIFO states.

---

## Acknowledgments
Special thanks to **Eng. Kareem Waseem** for guidance and support on this project.
