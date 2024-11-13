# EEE572 Project

## Installation

1.  Clone the repository: `git clone https://github.com/Larrydog3/EEE572_Project.git` | 
2. From the repository root directory, open the project `EEE572_Project.prj` in MATLAB by double-clicking it.

## Example Usage

```matlab
% MATLAB

% run analysis/runPLECS.m
runPLECS
```

### Testing

```matlab
% MATLAB
runtests('model/test')
```

## Directory Structure
```sh
├───analysis        # top-level analyses (.m or .mlx)
├───external        
│   └───plecs       # PLECS XML-RPC driver
└───model           # analytical models
    └───test        # tests for models
```
