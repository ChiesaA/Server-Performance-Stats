# Server Stats Script

Project URL: https://roadmap.sh/projects/github-actions-deployment-workflow

A simple Bash script to analyze basic Linux server performance statistics.

This script can be run on most Linux servers and prints useful system information such as CPU usage, memory usage, disk usage, top running processes, uptime, logged-in users, and failed login attempts.
## Features

- Total CPU usage
- Total memory usage
  - Used memory
  - Free memory
  - Usage percentage
- Total disk usage
  - Used disk
  - Free disk
  - Usage percentage
- Top 5 processes by CPU usage
- Top 5 processes by memory usage
- OS version
- System uptime
- Load average
- Logged-in users
- Failed login attempts

## Project Structure

```text
.
├── server-stats.sh
└── README.md
